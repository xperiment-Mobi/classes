package com.mobile{
	import com.xperiment.AirRelated.Computer;
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.getQualifiedClassName;

	public class saveFilesInternally extends Sprite {
		private var folder:File;
		private var file:File;
		private var fileStream:FileStream;
		private var success:Function;

		public var storageLocation:String;
		public var succeeded:Boolean =true;
		private var myLog:String;
		
		
		public function getLog():String{
			return myLog;
		}
		
		
		private function log(str:String):void{
			trace(123,str)
			if(!myLog){
				myLog=str;
			}
			else{
				myLog+='\n'+str;
			}
		}

		public function saveFilesInternally(f:File=null):void {
			
			this.success=success;
			
			if(f)folder = f;
			else folder=Computer.storageFolder();
						
			storageLocation=folder.nativePath;
			/*	var message:TextField=new TextField;
			message.text=storageLocation;
			logger.sta.addChild(message);*/

			if (! folder.exists) {
				folder.createDirectory();
				log("folder '"+storageLocation+"' did not exist so created it");
			}
			else {
				log("'"+storageLocation+"' folder already exists so don't need to make it.");
			}

		}

		public function saveFile(fileName:String, dat:*, success:Function):void {
			log("attempting to save file on local device");
			try {
				
				file = folder.resolvePath(fileName);
				
				fileStream = new FileStream();
				fileStream.open(file, FileMode.UPDATE);
				var typ:String=getQualifiedClassName(dat);		
				if (typ.indexOf("ByteArray")!=-1)fileStream.writeBytes(dat,0,dat.length);
				else if(typ.indexOf("XML")!=-1 || typ.indexOf("String")!=-1 )fileStream.writeUTFBytes(dat);
				else {
					log
					log("tried to save data of unknown type: "+typ);
				}

				fileStream.close();
				log("saved this file: "+storageLocation+File.separator+fileName);
				success(true);


			} catch (e:Error) {
				log("PROBLEM: saving was not successful (error: '"+e.message+"'): "+fileName);
				success(false);
			}

		}
		
		
		public function deleteDirectory(dir:String):void {
			folder=File.applicationStorageDirectory.resolvePath(dir);
			if (! folder.exists) {
				log("cannot delete this folder as it does not exist!");
			}
			else {
				try {
					folder.deleteDirectory(true);
				} catch (error:Error) {
					log("PROBLEM: could not delete this directory for some reason: "+folder);
					log("here's the error message: "+error);
				}
				log("folder "+dir+" deleted");
			}
		}
	}
}