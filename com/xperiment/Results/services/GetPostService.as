package com.xperiment.Results.services
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class GetPostService extends Sprite
	{
		public var myLog:String = '';
		private var success:Function;
		public var result:Object;
		private var killed:Boolean = false;
		public var succeeded:Boolean;
		
		public var url:String = MTURK_SUBMIT;
		
		public static var MTURK_SUBMIT:String='http://www.mturk.com/mturk/externalSubmit';
		public static var MTURK_SANDBOX_SUBMIT:String='http://workersandbox.mturk.com/externalSubmit';
		
		private var request:URLRequest;
		private var loader:URLLoader;
		
		public var service:String = "POST"
		
		public function kill():void{
			killed=true;
			loader.close();
			listeners(false);
		}
		
		public function send(data:Object,success:Function=null):void{
			
			var variables:URLVariables = new URLVariables;
			request = new URLRequest(url);

			for(var s:String in data){
				variables[s] = data[s];
			}
			
			request.data = variables;
			
			switch(service){
				case "POST":
					request.method = URLRequestMethod.POST;
					break;
				case "GET":
					request.method = URLRequestMethod.GET;
					break;
				default:
					throw new Error("devel error");	
			}
		
			
			
			loader = new URLLoader;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			listeners(true);
			
			try {
				loader.load(request);
			}
			catch (error:SecurityError)
			{
				onError("A SecurityError has occurred.");
			}
			
			trace("sent");
			
		}
		
		
		private function listeners(on:Boolean):void{
			var f:Function;
			if(on)	f=loader.addEventListener;
			else	f=loader.removeEventListener;

			f(Event.COMPLETE, completeHandler);
			f(SecurityErrorEvent.SECURITY_ERROR, errF);
			f(IOErrorEvent.IO_ERROR, errF);
			
		}
		
		private function completeHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			trace("completeHandler: " + loader.data);
			
			var vars:URLVariables = new URLVariables(loader.data);
			trace("The answer is " + vars.answer);
		}
		
		
		protected function errF(e:Event):void{
			onError(e.toString());
		}

		
		private function onResult(result:Object):void{
		
			log(result.toString());
			
			for(var str:String in result){
				for(var str2:String in result[str]){
					log((1,str,str2, result[str][str2])); 
				}
			}
			this.result = result;
			this.dispatchEvent(new Event(Event.COMPLETE));
			
			
	
		}
		
		private function log(str:String):void{
			myLog+='/n'+str;
		}
		
		private function errorDispatch():void{
			if(success)success(false);
			succeeded=false;
			this.dispatchEvent(new Event('error'));
		}
		

		private function onError(error:String):void{
			trace("errror",error)
			if(!killed){
				trace(123)
				log(error);
				errorDispatch();
			}
			
		}
	}
	
}