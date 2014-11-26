package com.mobile
{

	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.display.Sprite;
	import flash.events.Event;

	public class deleteFilesInternally extends Sprite
	{


		//where f=folder to look in
		public static function deleteFile(filename:String,f:String=""):String
		{

			var ret:String;
			if (f!="")
			{
				filename = f + "/" + filename;
			}
			var folder:File = File.applicationStorageDirectory.resolvePath(filename);
			if (folder.exists)
			{
				folder.deleteFile();
				ret = "deleted file";
			}
			else
			{
				ret = "file does not exist so cannot delete it";
			}
			return ret;
		}



	}
};