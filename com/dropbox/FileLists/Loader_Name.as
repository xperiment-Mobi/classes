package com.dropbox.FileLists
{
	import flash.net.URLLoader;

	public class Loader_Name
	{

		public var loader:URLLoader;
		public var file:File_Loc_Ver;

	
		public function Loader_Name(file:File_Loc_Ver, loader:URLLoader):void{
			
			this.file=file;
			this.loader=loader;
		}
	
		public function kill():void
		{
			loader.close();
			loader = null;
			file=null;
			
		}
	}
}