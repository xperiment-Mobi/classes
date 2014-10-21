package com.xperiment.Results.services
{	
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	
	public class SoapService extends Sprite
	{
		private var _connection:NetConnection;
		private var _responder:Responder;
		public static var GET_SJS:String = "myservice.getSJs";
		public static var CONDS_PER_STEP__GIVEN_COND:String = "myservice.condsPerStep_GiveCond";
		public static var SAVE_RESULTS:String = "myservice.saveResults";
		public static var DRIBBLE_RESULTS:String = SAVE_RESULTS;//;"myservice.dribbleResults";
		public static var UUID_ALREADY_SAVED_TO_CLOUD:String = 'myservice.UUIDPreSave_saveFinal';
		public static var GET_STUDIES:String = 'myservice.expts';
		private var service:String;
		public var myLog:String = '';
		private var success:Function;
		public var result:Object;
		private var killed:Boolean = false;
		public var succeeded:Boolean = true;

		public function kill():void{
			killed=true;
			if(_connection){
				_connection.close();
				listeners(false);
			}
		}
		
		public function send(data:Object,service:String,success:Function=null,force_gateway=null):void{
						
			this.service = service;
			this.success = success;
			if(!_connection)	setupConnection(force_gateway);
			
			/*for(var s:String in data.info){
				trace(s,data.info[s]);
			}*/
			
			_connection.call(service,_responder,data);
		}
		
		private function setupConnection(force_gateway:String):void{
	
			_connection = new NetConnection;
			//_connection.objectEncoding = 3; defaults to 3 so no need to set
			//_connection.proxyType="best";
			var g:String = ExptWideSpecs.IS("cloudURL");
			if(force_gateway)g=force_gateway;

			listeners(true);
	
			_connection.connect(g);
			_responder = new Responder(onResult, onError);
		}
		
		private function listeners(on:Boolean):void{
			var f:Function;
			if(on)	f=_connection.addEventListener;
			else	f=_connection.removeEventListener;
			
			f(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			f(NetStatusEvent.NET_STATUS,netStatusF);
			f(AsyncErrorEvent.ASYNC_ERROR,asyncErrorF);
			f(IOErrorEvent.IO_ERROR, ioErrorF);

		}
		
		protected function ioErrorF(e:IOErrorEvent):void{
			log(e.toString());
			errorDispatch();
		}
		
		
		protected function asyncErrorF(e:AsyncErrorEvent):void{
			log(e.toString());
			errorDispatch();
		}
		
		protected function netStatusF(e:NetStatusEvent):void
		{
			for(var str:String in e.info){
				log(str+' '+ e.info[str]); 
				
				//replace this if(str.indexOf('error')!=-1){ with below Jan 2014
				if(e.info[str].indexOf('error')!=-1){
					errorDispatch();
				}
			}				
		}
		
		public function close():void{
			_connection.close();
		}
		
		private function onResult(result:Object):void{
			if(result != null){
				log(result.toString());
				
				for(var str:String in result){
					for(var str2:String in result[str]){
						log((1,str,str2, result[str][str2])); 
					}
				}
				this.result = result;
				this.dispatchEvent(new Event(Event.COMPLETE));

				if(success){
					if(result.toString()=="experiment answer data saved" || GET_STUDIES==service){
						succeeded=true;
						success(true);
					}
					else{
						succeeded=false;
						success(false);
						
					}
				}
			}
			else{
			log("no feedback from the cloud but the cloud URL does seem correct. Is this experiment's id registered online?");
				errorDispatch();
			}
		}
		
		private function log(str:String):void{
			trace("log:",str);
			myLog+='/n'+str;
		}
		
		private function errorDispatch():void{
			succeeded=false;

			if(success)success(false);
			this.dispatchEvent(new Event('error'));
		}
		
		private function securityErrorHandler(e:SecurityErrorEvent):void {
			log(e.toString());
			errorDispatch();

		}
		private function onError(error:Object):void{

			if(!killed){
				log(error.description);
				errorDispatch();
			}
		}
	}
}