package com.xperiment {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLDocument;
	import flash.errors.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	import flash.display.*;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.system.Capabilities;



	public class importExptScript extends Sprite {
		private var xmlLoader:URLLoader=new URLLoader  ;
		private var xmlData:XML;
		private var xmlListData:XMLList;
		public var percentLoaded:uint = 0;
		



		public function importExptScript(name:String) {
			var txt:String;
			var my_date:Date = new Date();
			txt="?CacheStop="+Math.random()+"?datestamp="+my_date.date+my_date.hours+my_date.minutes+my_date.seconds;
			if (Capabilities.playerType=='External') {
				txt="";
			}
			xmlLoader.addEventListener(Event.COMPLETE,LoadXML);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			xmlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			xmlLoader.load(new URLRequest(name+txt));
		}

		public function giveMeData():XML {
			return xmlData;
		}
		
		

		private function progressHandler(event:ProgressEvent):void {
			dispatchEvent(new Event("dataLoading"));
			percentLoaded=Math.round(event.bytesLoaded/event.bytesTotal * 100);
			
		}


		private function LoadXML(e:Event):void {


			try {
				xmlData=new XML(xmlLoader.data);
				dispatchEvent(new Event("dataStartLoading"));
				//trace(xmlData);
			} catch (e:Error) {
				trace("Error: "+e);
				return;
			}
			xmlData=new XML(e.target.data);
			dispatchEvent(new Event("dataLoaded"));
		}

		private function ioError(e:IOErrorEvent):void {
			xmlData=new XML(<data>Problem loading data</data>);
			trace("problem loading data");
			dispatchEvent(new Event("dataNotLoaded"));
		}

		public function kill():void {
			if (xmlLoader){
			xmlLoader.close();
			xmlLoader.removeEventListener(Event.COMPLETE,LoadXML);
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioError);
			xmlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			xmlLoader=null;
			}
		}









	}
}