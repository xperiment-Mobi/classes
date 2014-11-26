package com.dropbox.FileLists
{
	import flash.filesystem.File;

	public class SyncPairUp
	{
		private var dropboxFiles:Vector.<File_Loc_Ver>;
		private var localFiles:Vector.<File_Loc_Ver>;
		private var file_loc_ver_pair:File_Loc_Ver_Pair;
		private var log:Function;
		public var pairs:Object = {};


		public function SyncPairUp(dropboxFiles:Vector.<File_Loc_Ver>, localFiles:Vector.<File_Loc_Ver>,log:Function)
		{
			
			this.dropboxFiles=	dropboxFiles;
			this.localFiles	= 	localFiles;
			this.file_loc_ver_pair = new File_Loc_Ver_Pair(log);
			this.log=log;
		
			pairupFiles();
		}		
		
		private function pairupFiles():void
		{
			var file_loc_ver_pair:File_Loc_Ver_Pair;
			var filename:String
			
			for each(var file:File_Loc_Ver in dropboxFiles){
				filename=locationName(file.location,file.name);

				if(pairs.hasOwnProperty(filename)) throw new Error("should never arise as dropbox files of the same name cannot exist in the same location");
				
				else{
					file_loc_ver_pair = new File_Loc_Ver_Pair(log);
					file_loc_ver_pair.dropBoxFile=file;
					pairs[filename] = file_loc_ver_pair; 
				}
			}
			
			for each(   file               in localFiles){
				filename=locationName(file.location,file.name);
				
				if(pairs.hasOwnProperty(filename)){
					
					file_loc_ver_pair = pairs[filename] as File_Loc_Ver_Pair;
					
					if(file_loc_ver_pair){
						if(file_loc_ver_pair.localFile != null)	throw new Error("should never arise as local files of the same name cannot exist in the same location");
						
						else{ 	//found a pair and adding local details to it
							file_loc_ver_pair.localFile=file;
							pairs[filename] = file_loc_ver_pair; 
						}
					}
					else{
						//the user has fiddled with the files on the phone!
					}
				}
						
				else{		//else must create pair.
			
					file_loc_ver_pair = new File_Loc_Ver_Pair(log);
					file_loc_ver_pair.localFile=file;
					pairs[filename] = file_loc_ver_pair; 
				}
			}
		}
		
		private function locationName(location:String, name:String):String
		{
			if(location!=""){	
				var combined:String = location+File.separator+name;
				if(File.separator!=String.fromCharCode(220)){
					return combined.split("\\").join("/");
				}
				else{
					return combined.split("/").join("\\");
				}
			}
			return name;
		}
	}
}
