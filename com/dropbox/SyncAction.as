package com.dropbox
{

	
	import com.dropbox.FileLists.File_Loc_Ver;
	import com.dropbox.FileLists.File_Loc_Ver_Pair;
	import com.dropbox.FileLists.Loader_Name;
	import com.dropbox.SQLliteDB.DropboxSyncTable;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.hamster.dropbox.DropboxClient;
	import org.hamster.dropbox.DropboxEvent;

	
	public class SyncAction extends Sprite
	{
		public function kill():void{
			listeners(false);
			this.dropAPI=	null;
			this.folder=	null;
			this.pairs=  	null;
			this.mobileDB=	null;
			
			if(localLastEdits)localLastEdits=null;
		}
		
		private var dropAPI:DropboxClient;
		private var pairs:Object;
		private var folder:String;
		private var loaders:Vector.<Loader_Name> = new Vector.<Loader_Name>;
		private var mobileDB:DropboxSyncTable;
		private var localLastEdits:Array;
		private var log:Function;
		
		public function SyncAction(dropAPI:DropboxClient, folder:String, pairs:Object, mobileDB:DropboxSyncTable, log:Function)
		{
			this.dropAPI=	dropAPI;
			this.folder=	folder;
			this.pairs=  	pairs;
			this.mobileDB=	mobileDB;
			this.log=		log;
			
			listeners(true);
			
			for each(var pair:File_Loc_Ver_Pair in pairs){
				pair.computeAction();
			}
		}
		
		private function listeners(yes:Boolean):void{
			var f:Function;
			if(yes)f=dropAPI.addEventListener;
			else   f=dropAPI.removeEventListener;
			
			f(DropboxEvent.GET_FILE_RESULT, gotFileSuccess);
			f(DropboxEvent.GET_FILE_FAULT, 	gotFileFail);
			f(DropboxEvent.PUT_FILE_RESULT, uploadFileSuccess);
			f(DropboxEvent.PUT_FILE_FAULT, 	uploadFileFail);
		}
				
		public function doActions():void
		{
			var action:String;
			for each(var pair:File_Loc_Ver_Pair in pairs){
				action=pair.action;
				//bit annoying. There's a bug when creating IOS app with 'deeply nested' switch statements
				//http://bugs.adobe.com/jira/browse/FB-33461 .Would have preferred a switch as cleaner.
				
				
				if(action == File_Loc_Ver_Pair.NOTHING){ 
					if(pair.localFile && pair.localFile.revision=='' && pair.dropBoxFile){
						mobileDB.updateRevision(pair.localFile.location, pair.localFile.name, pair.dropBoxFile.revision);
					}
				}
				
				
				//each of the below are catalogued in terms of whether action completed
				
				else if(action == File_Loc_Ver_Pair.UPDATE_DROPBOX){ 
					updateDropBox(pair);
					log('update dropbox file: '+pair.localFile.location+'    '+pair.localFile.name);
				}	
				
				else if(action == File_Loc_Ver_Pair.UPDATE_LOCAL){
					loaders[loaders.length]=new Loader_Name(pair.dropBoxFile,dropAPI.getFile(pair.dropBoxFile.loc_name));
					log('update local file: '+pair.dropBoxFile.location+'    '+pair.dropBoxFile.name);
				}	
				
				else if(action == File_Loc_Ver_Pair.DELETE_DROPBOX){
					log('delete dropbox file: '+pair.dropBoxFile.location+'    '+pair.dropBoxFile.name);
					dropAPI.fileDelete(pair.dropBoxFile.loc_name);
				}
				
				else if(action == File_Loc_Ver_Pair.DELETE_LOCAL){
					log('delete local file: '+pair.localFile.location+'    '+pair.localFile.name);
					var file:File=File.applicationStorageDirectory.resolvePath(pair.localFile.loc_name);
					if(!file.exists)throw new Error('File does not exist apparently ('+pair.localFile.loc_name+').  Should not arise.');
					file.deleteFileAsync();
					mobileDB.del_LocNam(pair.localFile.loc_name);
				}
				
				else {
					throw new Error('devel error');
				}
			}
		}
		
		

		
		
		
		protected function gotFileFail(e:DropboxEvent):void
		{
			log("failed retrieving file from dropbox");	
		}
		
		protected function gotFileSuccess(e:DropboxEvent):void
		{
			var content:ByteArray = ByteArray(e.resultObject);
			
			for (var i:int; i<loaders.length; i++){
				
				if(loaders[i].loader && loaders[i].loader.data == content){
					saveLocally(content,loaders[i].file);
					loaders[i].kill();
					loaders.splice(i,1);
					break;
				}	
			}
		}
		
		private var retry:Object;
		
		private function saveLocally(content:ByteArray, loc_file:File_Loc_Ver):void
		{
			var fileType:String = "";
			var fileTypeArr:Array = loc_file.name.split(".");
			if (fileTypeArr.length>1) {
				fileType=fileTypeArr[fileTypeArr.length-1];
				fileType=fileType.toLowerCase();
			}

			if(DropboxConnection.PERMITTED_FILETYPES.indexOf('*')!=-1 || 
				DropboxConnection.PERMITTED_FILETYPES.indexOf(fileType.toLowerCase())==-1) {
				log('not doing anything with this file as it is an unknown type (dont know how to save it; permitted types currently are txt, xml, jpg, png): '+ loc_file.loc_name);
			}
			
			else{
				
				var writeFile:Function;
				
				var folder:File=File.applicationStorageDirectory.resolvePath(DropboxConnection.LOCAL_DIR+File.separator+toLocalSeps(loc_file.location));
				if(!folder.exists) folder.createDirectory();

				var file:File = folder.resolvePath(loc_file.name);
				//trace("deleting file",file.name,file.exists);
				if(file.exists){
					
					file.deleteFile();
				}
				
				if	   (['txt','xml'].indexOf(fileType)!=-1){				
					writeFile = function():void{
						fileStream.writeUTFBytes(String(content))
					};
				}
				else if(['jpg','png','swf','mp3','flv','ttf'].indexOf(fileType)!=-1){	
					writeFile = function():void{
						fileStream.writeBytes(content);
					};
				}	
				else{ 
					if(DropboxConnection.PERMITTED_FILETYPES.indexOf('*')==-1)throw Error('I do not know how to save files of this type: '+fileType);
					else writeFile = function():void{
						fileStream.writeBytes(content);
					};
				}
				
				
				////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////////////////////////
				//encapsulating all code regarding writing file and saving to database in the below block
				
				var fileListener:Function = function(e:Event):void{
					fileStreamListeners(false);
					fileStream.close();
					if(e.type=='ioError'){
						
						retry ||= {};
						if(retry.hasOwnProperty(loc_file.loc_name)){
							retry[loc_file.loc_name].count++;
							if(retry>10){
								throw new Error("have tried saving this file 10 times " + loc_file.loc_name + " and have given up");
							}
						}
						retry[loc_file.loc_name] = {count:1}
						saveLocally(content,loc_file);
						trace("cannot save the file " + loc_file.loc_name + " for some reason so trying again X" + retry[loc_file.loc_name].count);
					}
									
					else{ //success						
						//note that for some reason file.modificationDate is 4ms off what is reported for the same file in the future if there is no pause...
						//ABOVE, turns out that fileStream.close() must be run first.

						if(retry && retry.hasOwnProperty(loc_file.loc_name))retry[loc_file.loc_name]=null;
						
						mobileDB.addFile(file.nativePath, toWinSeps(loc_file.location), loc_file.name, loc_file.revision, file.modificationDate);
					}		
				}
					
				var fileStreamListeners:Function = function(active:Boolean):void{
					if(active){
						fileStream.addEventListener(Event.COMPLETE,fileListener);
						fileStream.addEventListener(IOErrorEvent.IO_ERROR,fileListener);
					}
					else{
						fileStream.removeEventListener(Event.COMPLETE,fileListener);
						fileStream.removeEventListener(IOErrorEvent.IO_ERROR,fileListener);	
					}
				}
				
				var fileStream:FileStream = new FileStream();
				
				fileStreamListeners(true);
				fileStream.openAsync(file, FileMode.UPDATE);
				writeFile();
				
				
			}	
		}	
		
		private function toWinSeps(str:String):String{
			return str.split(File.separator).join("\\");
		}
		
		
		private function toLocalSeps(str:String):String{
			return str.split("\\").join(File.separator);
		}

		
		
		private function updateDropBox(pair:File_Loc_Ver_Pair):void
		{

			var file:File_Loc_Ver = pair.localFile;
			var localFile:File=File.applicationStorageDirectory.resolvePath(pair.localFile.loc_name);
			
			//////////////////
			//////////////////anonymous function
			localFile.addEventListener(Event.COMPLETE,function(e:Event):void{
					e.target.removeEventListener(e.type,arguments.callee);
					
					var loc:String = file.location.replace( /\\/g, '/');
				
					var extrapFolder:String=folder.split(String.fromCharCode(220)).join("/")+"/";
			
					extrapFolder+=loc;
					
					if(!pair.dropBoxFile)	dropAPI.putFile(extrapFolder,file.name,localFile.data,'dropbox',false)	
					else 					dropAPI.putFile(extrapFolder,file.name,localFile.data,'',true);
					
					
					if(!localLastEdits)		localLastEdits = [];
					localLastEdits.push({folder:extrapFolder,name:file.name,localLastEdit:pair.localFile.date});
			},false,0,true);
			//////////////////anonymous function
			//////////////////
			
		if(!localFile.exists){
			throw new Error('should be impossible that file does not exist');
		}
		else localFile.load();
		}		
		
		
		
		protected function uploadFileFail(e:DropboxEvent):void
		{
			var message:String = e.resultObject;
			
			throw new Error("not all files uploaded: "+message);
		}
		
		protected function uploadFileSuccess(e:DropboxEvent):void
		{		
			var revision:String = 	e.resultObject.revision;
			
			var name:String=		e.resultObject.path;
			var location:String = 	''	//note below where the location is properly set
			name = 					name.substr(folder.length+2)+'/';
			
			//below is a hack to get around IOS using different slashes from everyone else
			name = name.split(String.fromCharCode(92)).join('/');
			
			
			var d:String;
			for(var i:int=0;i<localLastEdits.length;i++){
				if(localLastEdits[i].name==name && localLastEdits[i].folder == folder){
					if(localLastEdits[i].localLastEdit){
						var date:Date=localLastEdits[i].localLastEdit;
						d=String(date)+','+String(date.milliseconds);
					}
					localLastEdits.splice(i,1);
					break;
				}
			}
			removeCompletedActions(File_Loc_Ver_Pair.UPDATE_DROPBOX,location,name);
			mobileDB.updateRevisionAndDate(location,name,revision,d);
		}	
		
		
		private function removeCompletedActions(action:String, location:String, name:String):void
		{
			if(action==File_Loc_Ver_Pair.UPDATE_DROPBOX){
				for(var i:int = 0; i<pairs.length; i++){
					if(pairs[i].localFile.name==name && pairs[i].localFile.location==location){
						pairs.splice(i,1);
					}
					break;
				}
			}
			
		}
	}
}