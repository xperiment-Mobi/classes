package com.xperiment.Results.services{
	import flash.events.*;
	import flash.net.*;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;


	/*
	works like this:
	
	var myEmailAddress:String = "123@123.com";
	var toWhomAddress:String = "andytwoods@gmail.com";
	var subject:String = "123";
	var dummy:emailResults = new emailResults(myData, myEmailAddress, toWhomAddress, subject);
	
	ps myData is XML
	*/


	public class emailResults {

		public var loader:URLLoader;
		private var emailSuccessful:Boolean=false;
		private var success:Function;
		private var myLog:String;
		
		//public function err:Error(e:Event);
		public var succeeded:Boolean =true;
		
		public function getLog():String{
			return myLog;
		}
		
		private function log(str:String):void{
			if(!myLog){
				myLog=str;
			}
			else{
				myLog+='\n'+str;
			}
		}
		
		public function emailResults(myResults:String, success:Function) {

			this.success=success;
			var variables:URLVariables=new URLVariables();


			variables.from=ExptWideSpecs.IS("myAddress");
			variables.email=ExptWideSpecs.IS("toWhom");
			variables.message=ExptWideSpecs.IS("message");
			variables.filename=ExptWideSpecs.IS("filename");
			variables.subject =ExptWideSpecs.IS("subject");
			variables.data=myResults;
			

			var request:URLRequest=new URLRequest(); 
			//request.requestHeaders.push(new URLRequestHeader('Content-type', 'multipart/form-data'));
			request.url=ExptWideSpecs.IS("phpAddress"); 
			request.method=URLRequestMethod.POST;
			request.data=variables;
			
			
			
			loader=new URLLoader();
			listeners(true);
		
			//loader.dataFormat=URLLoaderDataFormat.TEXT;
			loader.dataFormat=URLLoaderDataFormat.VARIABLES;
			

			
			try{
				loader.load(request);
				
			}
			catch(e:Error){
				this.succeeded=false;
				variables=null;
				//trace("Unable to send email as the reciprocating php file does not exist","Error message: "+e);
				log("Unable to send email as the reciprocating php file does not exist");
				log("Error message: "+e);
				success(false);
				
				
			}
			log("-----------------------------------------------");
			log("attempting to send you your data via email:");
			log("toWhom:"+variables.email);
			log("subject:"+variables.subject);
			log("from:"+variables.from);

		}
		
		private function listeners(on:Boolean):void
		{
			if(on){
				loader.addEventListener(Event.COMPLETE,messageSent);
				loader.addEventListener(IOErrorEvent.IO_ERROR, catchIOError);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				loader.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,uncaughtError);
			}
			else{
				loader.removeEventListener(Event.COMPLETE,messageSent);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, catchIOError);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				loader.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,uncaughtError);
			}
		}
		
		protected function uncaughtError(e:Event):void
		{
			this.succeeded=false;
			log('unknown error!');
			success(false);
		
		}		

		
		protected function httpStatus(e:HTTPStatusEvent):void
		{
			switch(String(e.status).substr(0,1)){ //for status codes see http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
				
				// 1xx Informational Request received, continuing proces
				case "2": // 2xx Success
					//all is good :)
					break;
				default:
					//trace(e.status);
					break;
				//3xx Redirection
				//4xx Client Error
				//5xx Server Error
				
				
			}
		}		
		

		private function catchIOError(event:IOErrorEvent):void {

			this.succeeded=false;
			log("Unable to send email as there is no net connection");
			log("Error message: "+event.type);
			success(false);
			
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			this.succeeded=false;
			listeners(false);
			log("Unable to send email as you have not specified a good URL address");
			log("Error message: "+event.type);
			success(false);
			
		}
		private function messageSent(e:Event):void {
			listeners(false);
			var loader:URLLoader=URLLoader(e.target);
			var vars:URLVariables=new URLVariables(loader.data);
			var str:String=unescape(vars.toString())
			
			if(str.indexOf("Mailer Error")==-1){
				this.succeeded=true;
				log("-----------------------------------------------");
				log("message from email server: "+vars.answer);
				log("-----------------------------------------------");
//				/trace("sent email. response from server:",str);
				success(true);
				
			}
			else {
				this.succeeded=false;
				trace("attempted to send email but failed at server.  Here's the message:",str);
				success(false);
				
			}
			
		}
	}
}