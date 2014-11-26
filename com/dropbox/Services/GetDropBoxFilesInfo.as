package com.dropbox.Services
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.hamster.dropbox.DropboxClient;
	import org.hamster.dropbox.DropboxEvent;
	import org.hamster.dropbox.models.DropboxFile;
	import com.dropbox.FileLists.File_Loc_Ver;

	public class GetDropBoxFilesInfo extends Sprite
	{
		private var dropAPI:DropboxClient;
		private var folder:String;
		
		public  var file_loc_vers:Vector.<File_Loc_Ver> = new Vector.<File_Loc_Ver>;
		private var getFilesRequests:Array;
		
		private var log:Function;
		public var completed:Boolean = false;
		
		public function kill():void
		{
			dropAPI.removeEventListener(DropboxEvent.METADATA_FAULT, listener);
			dropAPI.removeEventListener(DropboxEvent.METADATA_RESULT, listener);
			getFilesRequests=null;
		}

		public function GetDropBoxFilesInfo(folder:String, dropAPI:DropboxClient, log:Function)
		{	
			/*
			all .sav are uploaded, moved to local\backup.
			all .xml are downloaded and overwrite existing xml.	
			*/
			this.folder=folder;
			this.dropAPI=dropAPI;
			this.log=log;
			
			dropAPI.addEventListener(DropboxEvent.METADATA_FAULT, listener);
			dropAPI.addEventListener(DropboxEvent.METADATA_RESULT, listener);
			
		}
		
		public function getFiles(temp_folder:String=null):void{
			
			if(temp_folder==null)temp_folder=folder;
			
			if(!getFilesRequests)getFilesRequests=[];
			getFilesRequests.push(temp_folder);
		
			dropAPI.metadata(temp_folder, 1000, "", true);

		}
		
		private function listener(e:DropboxEvent):void{
			if(e.resultObject.hasOwnProperty('path') == false || e.resultObject.toString().indexOf('not found')!=-1 ){
				createDirectory(folder);
				log("folder '"+folder+"' has never existed in your dropbox folder so is being created.");
			}
			else if(e.resultObject.isDeleted){
				createDirectory(folder);
				trace(111);
				log("folder '"+folder+"' has been deleted in your dropbox folder by other software so recreating it.");
			}
			
			else{

			var pos:int=getFilesRequests.indexOf(e.resultObject.path.substr(1));
	
				if(pos != -1){
					getFilesRequests.splice(pos,1);
				}
				else throw new Error("should not be possible");
				
	
				switch(e.type){
					case DropboxEvent.METADATA_RESULT:
						processContents(e.resultObject);
						break;
					case DropboxEvent.METADATA_FAULT:
						if(e.resultObject){
							var errArr:Array=e.resultObject.split("'");
							if(errArr.length==3 && (errArr[1] as String).substr(1)==folder){
								log(folder+" does not exist so creating it at dropbox remote");
								createDirectory(folder);
								completedSearch();
								
							}
						}
						else{
							trace(e.resultObject);
							throw new Error();
						}
						break;
						//break; left out on purpose so above flows into this error
					default: throw new Error("unknown problem in DropBox class - report to developers please: "+e.resultObject);
				}
			}
		}
		

		 private function processContents(resultObject:Object):void{
			

			if(resultObject.isDeleted){
				//here be dragons
				//pimpContent({revision:resultObject.revision,resultObject:resultObject.isDir,isDeleted:resultObject.isDeleted,path:resultObject.path,date:content.modified});
			}
			else{
				for each(var content:DropboxFile in resultObject.contents){
					pimpContent({revision:content.revision,isDir:content.isDir,isDeleted:content.isDeleted,path:content.path,date:content.modified});	
				}
			}
			
			if(getFilesRequests.length==0)	completedSearch();

		}	
		 
		 private function pimpContent(content:Object):void
		 {
			var name:String;
			var location:String='';
			var pos:int;
			 
			name=content.path.substr(folder.length+2);
			
			if(name.indexOf('/')!=-1){
				pos = name.length-name.split('').reverse().indexOf('/');
				location = name.substr(0,pos-1);
				name = name.substr(pos);
			}
			
			location = location.split("/").join("\\");
			
			//note that content.date is verified good
			
			if(!content.isDir){
				file_loc_vers[file_loc_vers.length] = (		new File_Loc_Ver(	content.path,name,location,content.revision, content.date , content.isDir, content.isDeleted, content.date,null	));
				this.dispatchEvent(new Event(Event.ADDED));
			}
			
			else getFiles(content.path.substr(1)); 
		 }		 
		 
		 private function completedSearch():void
		 {
			 completed=true;
			 this.dispatchEvent(new Event(Event.COMPLETE));
		 }
		 
		private function createDirectory(folder:String):void
		{
			
			var listener:Function = function(e:DropboxEvent):void{
				dropAPI.removeEventListener(DropboxEvent.FILE_CREATE_FOLDER_FAULT, listener);
				dropAPI.removeEventListener(DropboxEvent.FILE_CREATE_FOLDER_RESULT, listener);
				switch(e.type){
					case DropboxEvent.FILE_CREATE_FOLDER_FAULT:
						log("could not create folder!");
						createDirectory(folder);
						break;
					case DropboxEvent.FILE_CREATE_FOLDER_RESULT:
						log('created folder');
						break;
					default: throw new Error("problem");	
				}
			}
			
			dropAPI.addEventListener(DropboxEvent.FILE_CREATE_FOLDER_FAULT, listener);
			dropAPI.addEventListener(DropboxEvent.FILE_CREATE_FOLDER_RESULT, listener);
			
			dropAPI.fileCreateFolder(folder);
		}
	}
	
}