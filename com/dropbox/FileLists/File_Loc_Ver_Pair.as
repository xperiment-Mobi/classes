package com.dropbox.FileLists
{
	import com.dropbox.DropboxConnection;

	public class File_Loc_Ver_Pair
	{
		public var dropBoxFile:File_Loc_Ver;
		public var localFile:File_Loc_Ver;
		public var action:String;
		
		private var log:Function;
		
		public static const UPDATE_LOCAL:String = 'updateLocal';
		public static const UPDATE_DROPBOX:String = 'updateDropbox';
		public static const DELETE_LOCAL:String = 'deleteLocal'; 
		public static const DELETE_DROPBOX:String = 'deleteDropBox'; 
		public static const NOTHING:String = 'nothing'; 
		
		private const deleteIfLocalFileType:Array = ['xml'];
		private const deleteIfLocalFileTypeKeepBackup:Array = ['xml'];
		
		public function File_Loc_Ver_Pair(log:Function){
			this.log=log;
		}		
		
		public function setLocalRevision(revision:String):void{
			localFile.revision=revision;
		}
		
		public function computeAction():void
		{						
/*			trace("---");
			var nam:String;
			if(localFile)nam=localFile.name;
			if(dropBoxFile)nam=dropBoxFile.name;
			if(localFile)trace(localFile.loc_name)
			if(dropBoxFile)trace(dropBoxFile.loc_name);
			trace("-",nam,localFile,dropBoxFile)
			trace(DropboxConnection.dropBoxOverrides(nam));
			trace(DropboxConnection.localOverrides(nam))*/;
			
			var filename:String;
			if(localFile)	filename=localFile.name;
			else			filename=dropBoxFile.name;
			
			var localBoss:Boolean = DropboxConnection.localOverrides(filename);
			var dropbBoss:Boolean = DropboxConnection.dropBoxOverrides(filename);
			
			if(localBoss && dropbBoss) throw new Error("a file type cannot 'be boss' at both local and dropbox locations! Check settings in DropboxConnection.as");
			
			if	(!dropBoxFile && localFile){
				if(dropbBoss && !DropboxConnection.localDontDelete(filename))	action= DELETE_LOCAL;
				else if(localBoss )												action= UPDATE_DROPBOX;
				else															action= NOTHING;
			}
			
			else if	(dropBoxFile && !localFile){
				if(dropbBoss)														action= UPDATE_LOCAL;
				else if(localBoss && !DropboxConnection.dropBoxDontDelete(filename))action= DELETE_DROPBOX;
				else																action= NOTHING;
			}
				
			else if	(dropBoxFile && localFile){
		
				if(localFile.revision!=''){
					action= NOTHING;
					
					if		(int(dropBoxFile.revision) > int(localFile.revision)){
						if(dropbBoss) 												action= UPDATE_LOCAL;	//when dropbox is more recent				
					}
					else if	(localFile.date > localFile.lastRevisionDate){
						if(localBoss)												action= UPDATE_DROPBOX;	//when local is more recent
					}
				}
				
				
				else {	
					//future programmer: I guess we could use dates to figure out which is more recent. Decided not to as this situation should
					//really never arise.  It WOULD arise if someone copy and paste the same folder to the remote and locally, but I doubt
					//this will happen.
					//Note that the local version of this file gets added to the database at the end of syncing. I wont ponder the consequences of this now
					//, as again, this situation should not arise in normal usage
					
					if(dropbBoss){
						//log('Issue: a file exists locally and in dropbox ('+dropBoxFile.loc_name+') but this file has not been encountered before locally (did you copy it to your device?). Dropbox permissions for file type > local permissions: local will be updated.');
																					action= NOTHING;
					}
					else if(localBoss){
						//log('Issue: a file exists locally and in dropbox ('+dropBoxFile.loc_name+') but this file has not been encountered before locally (did you copy it to your device?). Dropbox permissions for file type < local permissions: dropbox will be updated.');
																					action= NOTHING;
					}
					else															action= NOTHING;
				}

				}		
			else throw new Error("should not be possible");
			
		}
		
	}
}