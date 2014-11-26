package com.dropbox.SQLliteDB.Events
{
	import flash.events.Event;
	import com.dropbox.FileLists.File_Loc_Ver;
	
	public class DropboxsyncDB_Event extends Event
	{
		static public const DROPBOX_FILE:String = "dropboxFile";
		
		public var file:File_Loc_Ver;
		
		public function DropboxsyncDB_Event(type:String,file)
		{
			this.file=file;
			
			super(type);
		}
	}
}