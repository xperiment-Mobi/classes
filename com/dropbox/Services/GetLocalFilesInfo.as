package com.dropbox.Services
{
	
	import com.dropbox.DropboxConnection;
	import com.dropbox.FileLists.File_Loc_Ver;
	import com.dropbox.SQLliteDB.DropboxSyncTable;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	public class GetLocalFilesInfo extends Sprite
	{
		private var folder:String;

		
		public  var file_loc_vers:Vector.<File_Loc_Ver> = new Vector.<File_Loc_Ver>;
		private var nativePath:String;
		public  var completed:Boolean = false;
		private var mobileDB:DropboxSyncTable;
		private var regenRevisionList:Vector.<Object> = new Vector.<Object>;
		private var filesMissingFromDB:Vector.<File_Loc_Ver> = new Vector.<File_Loc_Ver>;
		private var log:Function;
		private var emptyDirs:Vector.<File>;
		
		public function kill():void
		{
			regenRevisionList=null;
			mobileDB=null;
			file_loc_vers=null;
			emptyDirs=null;
		}
		
		
		public function GetLocalFilesInfo(mobileDB:DropboxSyncTable,log:Function){
			
			this.mobileDB = mobileDB;
			this.log=log;
		}
		
		

		public function getFiles():void{
			var dir:File = File.applicationStorageDirectory.resolvePath(DropboxConnection.LOCAL_DIR);
			nativePath = dir.nativePath;
			trace('local folder: '+nativePath)
			if(dir.exists)pimpFiles(dir);
			else{
				dir.createDirectory();
			}
			
			deleteStrayFilesFromDB();
			deleteEmptyDirs();
			
			addFilesToDBifAbsent();
			
			completedSearch();
		}	
		
		private function pimpFiles(directory:File):void{
			
			if (directory.isDirectory){
				var location:String;
				var localFiles:Array = directory.getDirectoryListing();
				
				if(localFiles.length==0){
					emptyDirs ||= new Vector.<File>; //if empty dir does not exist, make it so
					emptyDirs.push(directory);
				}
				
				var revision:Object 
				var lastRevisionDate:Date;
				var file_loc_ver:File_Loc_Ver;
				var unknownFile:Boolean;
				for each (var file:File in localFiles){
					
					if (!file.isDirectory){
						unknownFile=false;
						location=file.nativePath.substr(nativePath.length+1);
						location=location.substr(0,location.length-file.name.length);
						
						if(location.length>0)location=location.substr(0,location.length-1);

						revision = mobileDB.getRevision(toWinSeps(location), file.name);
											
						if(revision.revision==DropboxSyncTable.NO_SUCH_FILE){
							unknownFile=true;
							revision.revision=''
						}
						else{ 
							var dateArr:Array = revision.locaLastEdit.split(',');
									//the below works! http://responsivedesignstudio.com/blog/2008/09/09/as3-undocumented-method-datestring/
							lastRevisionDate=new Date(dateArr[0]);
							lastRevisionDate.setMilliseconds(Number(dateArr[1]));
						}

						regenRevisionList[regenRevisionList.length]=revision; //used later to remove stray files
						
						file_loc_ver = new File_Loc_Ver(	file.nativePath,file.name,location,revision.revision, revision.localLastEdit, file.isDirectory, false, file.modificationDate,lastRevisionDate	)
						file_loc_vers[file_loc_vers.length] = file_loc_ver;
						
						if(unknownFile)filesMissingFromDB[filesMissingFromDB.length]=file_loc_ver;
		
					}
					else{
						
						pimpFiles( file )
					}
					
				}
			}
		}

		
		private function completedSearch():void
		{
			completed = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function toWinSeps(str:String):String{
			return str.split(File.separator).join("\\");
		}
		
		
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//database cleanup functions
		
		private function deleteStrayFilesFromDB():void
		{
			
			var dbLocationList:Vector.<String> = mobileDB.get_Loc_names();
			
			var listLocalFiles:Array=[];
			for each(var f:File_Loc_Ver in file_loc_vers){
				listLocalFiles.push(f.loc_name);
			}
		
			for each(var location:String in dbLocationList){
				if(listLocalFiles.indexOf(location as String)==-1){
					mobileDB.del_LocNam(location);
				}
			}

			dbLocationList = null;
			regenRevisionList = null;
			
		}
		
		private function deleteEmptyDirs():void
		{
			var emptyDir:File;
			if(emptyDirs){
				while(emptyDirs.length>0){
					emptyDir=emptyDirs.shift();
					log('deleting this empty directory: '+emptyDir.url);
					emptyDir.deleteDirectory();
				}
			}
		}	
		
		private function addFilesToDBifAbsent():void
		{
			for each(var file_loc_var:File_Loc_Ver in filesMissingFromDB){
				
				mobileDB.addFile(file_loc_var.loc_name,file_loc_var.location,file_loc_var.name,'',file_loc_var.date);
			}
		}
		
	}
	
}