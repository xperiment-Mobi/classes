package com.xperiment.XMLstuff {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.errors.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	import flash.display.*;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.system.Capabilities;


	public class ImportExptScript extends Sprite {
		private var xmlLoader:URLLoader=new URLLoader  ;
		private var xmlData:XML;
		private var xmlListData:XMLList;
		public var percentLoaded:uint = 0;
		//var numberTrialsPerType:Array = new Array();



		public function run(name:String):void {
			
			var txt:String;
			var my_date:Date = new Date();
			txt="?CacheStop="+Math.random()+"?datestamp="+my_date.date+my_date.hours+my_date.minutes+my_date.seconds;
			if (Capabilities.playerType=='External') {
				txt="";
			}
			xmlLoader.addEventListener(Event.COMPLETE,LoadXML);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,ioError);
			//xmlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			xmlLoader.load(new URLRequest(name+txt));
			
		}

		public function giveMeData():XML {
			return xmlData;
		}

		private function LoadXML(e:Event):void {

			try {
				if(e.target.data=='') throw new Error('experiment file is empty');
				xmlData=new XML(e.target.data);
				dispatchEvent(new Event(Event.COMPLETE));
			} catch (e:Error) {
				dispatchEvent(new Event("dataNotLoaded"));
			}
			
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
		//	xmlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			xmlLoader=null;
			}
		}



	}
}