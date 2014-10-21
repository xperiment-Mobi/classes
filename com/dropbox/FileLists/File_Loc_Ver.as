package com.dropbox.FileLists
{
	public class File_Loc_Ver
	{
		public static const FILE:String = 	'file';
		public static const DIR:String = 	'dir';
		
		public var location:String;
		public var name:String;
		public var revision:String;
		public var what:String;
		public var deleted:Boolean;
		public var date:Date;
		public var loc_name:String;
		public var lastRevisionDate:Date;
	
		public function File_Loc_Ver(loc_name:String, name:String, location:String, revision:String, lastEdit:String, isDir:Boolean, deleted:Boolean, date:Date, lastRevisionDate:Date){
			//trace("-------------",namLocation, revision)
			
			this.loc_name=loc_name;
			this.name=name;
			this.location=location;
			this.revision=revision;
			this.deleted=deleted;
			this.date=date;
			this.lastRevisionDate = lastRevisionDate;
			
			if(isDir)this.what=DIR;
			else this.what=FILE;
			
			
			
			//trace("------------------------------",location,name,revision,what,deleted, date);
		}
	}
}