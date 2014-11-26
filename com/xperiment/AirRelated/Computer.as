package com.xperiment.AirRelated
{
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	import flash.filesystem.File;

	public class Computer
	{
		static public function storageFolder():File{
			
			var folder:File;
			var masterLoc:String=ExptWideSpecs.IS('dataFolderLocation');
			var locat:String=ExptWideSpecs.IS('saveLocallySubFolder')+"results"+File.separator;
			locat = locat.split("app-storage:"+File.separator).join("");
	
			//likely will need IOS specific mod for locat
			
			if(masterLoc==""){

				folder=File.applicationStorageDirectory.resolvePath(locat);
			}
			else{
				switch(masterLoc.toLowerCase()){
					case "desktop":
						folder=File.desktopDirectory.resolvePath(locat);
						break;
					case "my documents":
					case "mydocuments":
						folder=File.documentsDirectory.resolvePath(locat);
						break;
				}
			}
			return folder;
		}
	}
}