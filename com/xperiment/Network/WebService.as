package com.xperiment.Network
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class WebService extends Sprite
	{

		
		protected var success:Function;
		public var __myLog:String;
		private var xmlSendLoad:URLLoader
		public var succeeded:Boolean = true;
		//private var phpLoc:String;
		
		protected function log(str:String):void{
			if(!__myLog){
				__myLog=str;
			}
			else{
				__myLog+='\n'+str;
			}
		}
		
		public function WebService(phpLocation:String, success:Function,xmlURLReq:URLRequest) {

			this.success=success;
			
			
			xmlURLReq.method=URLRequestMethod.POST;
			xmlSendLoad=new URLLoader;
			listeners(true);
			
			try {
				xmlSendLoad.load(xmlURLReq);
			}catch (error:Error) {
				errorHappened('unknown error with webservice (perhaps htaccess is incorrect)')
			}
		}
		
		private function listeners(yes:Boolean):void{
			var f:Function;
			if(yes)	f=xmlSendLoad.addEventListener;
			else 	f=xmlSendLoad.removeEventListener;
			
			f(Event.COMPLETE, completeHandler);
			f(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			f(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		
		private function completeHandler(e:Event):void {
			listeners(false);
			checkResponse(e);
		}
		
		protected function checkResponse(e:Event):void
		{
			throw new Error("override me");
		}
		
		private function errorHappened(info:String):void{
			succeeded=false;
			log(info)
			listeners(false);
			if(success)success(false);
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void {
			errorHappened('security error with webservice: '+e)
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			errorHappened('ioerror with webservice: '+e)
		}
		
	}
}