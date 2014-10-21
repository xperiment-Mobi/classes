package com.mobile
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class getFilesInternally extends Sprite
	{

		private var fileLdr:URLLoader;
		private var myData:*;
		private var filename:String;
		
		
		public function kill():void{
			myData = null;
			fileLdr = null;
		}

		//where f=folder to look in
		public function getFilesInternally(myData:*, filename:String, f:String=""):void
		{

			this.myData = myData;

			if (f!="") filename = f + "/" + filename;
						
			this.filename=filename;
			
			var folder:File=File.applicationStorageDirectory.resolvePath(f);
			var storageLocation:String = folder.nativePath;

			if (f!="")
			{
				storageLocation = "file://" + storageLocation;
			}
			
			//trace(storageLocation,this.filename,22);
			fileLdr = new URLLoader;
			fileLdr.addEventListener(Event.COMPLETE,LoadFile,false,0,true);
			fileLdr.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,Err,false,0,true);
			fileLdr.addEventListener(IOErrorEvent.IO_ERROR,ioErr,false,0,true);
			fileLdr.load(new URLRequest(storageLocation+"/"+this.filename));
			//trace("ddddd:"+storageLocation+"/"+filename);
		}

		public function giveFile():*
		{
			
			return myData;
		}

		private function LoadFile(e:Event):void
		{
			removeListeners();
			try
			{
				myData = fileLdr.data;
				//trace("ffffffs:"+ fileLdr.data);
			}
			catch (e:Error)
			{
				myData = "";
				return;
			}
			this.dispatchEvent(new Event("filePing",true));
		}

		private function Err(e:UncaughtErrorEvent):void
		{
			removeListeners();
			myData = "";
			this.dispatchEvent(new Event("filePing",true));
		}
		
		private function ioErr(e:IOErrorEvent):void
		{
			trace("file does not exist");
			removeListeners();
			myData = "";
			this.dispatchEvent(new Event("filePing",true));
		}

		private function removeListeners():void
		{
			fileLdr.removeEventListener(Event.COMPLETE,LoadFile);
			fileLdr.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,Err);
			fileLdr.removeEventListener(IOErrorEvent.IO_ERROR,ioErr);
		}
	
	}
}