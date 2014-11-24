//AW taken from http://blog.gritfish.net/?p=76%94

package com.xperiment.onScreenBoss{

	import flash.events.Event;
	
	public class TrueTimerBuilder extends TrueTimer{
		public var updateEvery:int = 50;
		public var initTimeBuilder:int;
		public var currentTimeBuilder:Number;
		public var trialTime:int=0;
		private var nextPing:Number;
		
		private var tickCount:int = 0;

		
		override public function TrueTimerBuilder(DELAY:int,callF:Function):void {
			super(DELAY,callF);
		}
		
		override protected function init():void{
			initTime = new Date();
			currentTime=initTime;
		}


		private function evaluateTime(e:Event):void {

			if (running) {
				currentTimeBuilder = new Date().valueOf();

				if (currentTimeBuilder >= nextPing) {	
					tickCount++;
					trialTime= currentTimeBuilder-initTimeBuilder;
					calcNextPing();
					callF(trialTime);	
			
				}
			}
		}
		
		private function calcNextPing():void{
			nextPing = initTimeBuilder + tickCount * updateEvery;
		}


		override public function start():void {
			initTimeBuilder = new Date().valueOf();
			running=true;
			calcNextPing()
			listen(true);
		}
		
		override public function reStart():void {
			if(running==false){
				running=true;
				listen(true);
			}
			
			
			_goto(trialTime);
			
		}
		
		override public function pause():void {
			running=false;
			listen(false);
		}
		
		override public function stop():void {
			pause();
			
		}
		
		override public function reset():void {
			_goto(0);
		}
		
		override public function _goto(t:int):void{

			initTimeBuilder =new Date().valueOf()-t;

			trialTime=t;
			tickCount= t / updateEvery;
			nextPing = 0;
			
			if(running) evaluateTime(null);
			else		callF(trialTime);
			
			
		}
		
		override protected function listen(ON:Boolean):void{
			if(ON)	addEventListener(Event.ENTER_FRAME,evaluateTime);
			else	removeEventListener(Event.ENTER_FRAME,evaluateTime);
		}
		

	}
}