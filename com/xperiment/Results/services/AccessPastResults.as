package com.xperiment.Results.services
{

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	

	public class AccessPastResults extends Sprite
	{
		private var _soapService:SoapService;
		private var t:Timer;
		
		public var replyF:Function;
		public var timeOut:int = 10000;
		
		public function kill():void{
			t.stop();
			_soapService.kill();
			t.removeEventListener(TimerEvent.TIMER,timeOutF);
		}
		
		private function listeners(on:Boolean):void{
			if(on){
				_soapService.addEventListener('error',eventF);
				_soapService.addEventListener(Event.COMPLETE,eventF);
			}
			else{
				
				_soapService.removeEventListener('error',eventF);
				_soapService.removeEventListener(Event.COMPLETE,eventF);
			}
		}
		
		public function init(info:Object,gateway:String,SJsPerCondPerStep:Array,conditions:Array,cutOffTime:String, replyF:Function):void
		{
			this.replyF=replyF;
			__init(gateway)	
			var param:Object = {};
			
			param.info ={}
				
			for(var key:String in info){
				param.info[key]=info[key]
			}
			
			param.SJsPerCondPerStep = SJsPerCondPerStep;
			param.cutOffTime = cutOffTime;
			param.conditions = conditions;
			param.results = {};
			
			__send(param, SoapService.CONDS_PER_STEP__GIVEN_COND);
			
		}
		
		public function __send(param:Object, service:String):void
		{
			_soapService.send(param,service);
		}
		
		public function __init(gateway:String):void
		{
			t = new Timer(timeOut,1);
			t.addEventListener(TimerEvent.TIMER,timeOutF);
			t.start();
			
			_soapService ||= new SoapService;	
			
			listeners(true);
		}
		
		protected function timeOutF(event:TimerEvent):void
		{
			listeners(false);
			onFail();		
		}
		
		protected function eventF(e:Event):void
		{
			
			listeners(false);
			if(e.type=='error'){
				trace("error accessing past results",_soapService.result);
				onFail();
			}
			else{
				var tempResult:Object = _soapService.result;
				onSuccess(tempResult);	
			}
		}
		
		public function onFail():void
		{
			replyF('');
		}
		
		public function onSuccess(tempResult:Object):void
		{
			replyF(tempResult);
		}
	}
}