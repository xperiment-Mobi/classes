package com.Logger {
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Logger extends Sprite{
		
		private static var _instance:Logger;
		
		private var myLog:Array = new Array;
		private var traceStr:Boolean=false;
		public var sta:Stage; 
		private var streamData:Boolean = false;
		private var txt:TextField;
		
		public function log(str:String):void{
			myLog.push(str);
			//ChromeAddOn.info("-"+str);
			if (traceStr)trace("-"+str);
			if(streamData)this.dispatchEvent(new Event("logPing"));
			
			
			
		}
		
		
		public var hackCount:int=0;
		
		public function Logger(pvt:PrivateLogger){
			PrivateLogger.alert();
			
			
		}
		
		public static function getInstance():Logger
		{
			if(Logger._instance ==null){
				Logger._instance=new Logger(new PrivateLogger());
			}
			return Logger._instance;
		}	
		
		
		public function start(traceMe:Boolean,sta:Stage):void{
			myLog = new Array;
			this.sta=sta;
			traceStr=traceMe;
		}
		
		public function errorMessage(txt:String, message:String):void{
			
		}
		
		public function give(streamData:Boolean,fromBeginning:Boolean):String{
			this.streamData=streamData;
			if(fromBeginning)return myLog.join("\n");
			else return new String;
		}
		
		public function startStream():void{
			streamData=true;
		}
		
		public function stageErrorMessage(err:String):void{
			if(err!=""){
				var myTextFormat:TextFormat = new TextFormat;
				myTextFormat.size=20;
				this.txt=new TextField;
				txt.background=true;
				txt.wordWrap=true;
				txt.multiline=true;
				txt.backgroundColor=0xffffff
				txt.text=err;
				txt.width=sta.width;
				txt.height=sta.height;
				txt.setTextFormat(myTextFormat);
				txt.defaultTextFormat=myTextFormat;
				sta.addChild(txt);
				txt.wordWrap=true;
			}
			else{
				if(sta.contains(txt)){
					sta.removeChild(txt);
					txt=null;
				}
			}
			
			
		}
		
		public function stream():String{
			return myLog[myLog.length-1];
		}
		
		public function stopStream():void{
			streamData=false;
		}

	}
	
}
