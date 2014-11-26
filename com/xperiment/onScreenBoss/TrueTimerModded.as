//AW taken from http://blog.gritfish.net/?p=76%94

package com.xperiment.onScreenBoss{

	
	import flash.display.Sprite;
	import flash.events.Event;

	
	public class TrueTimer extends Sprite implements iTrueTimer{
		public var updateEvery:int;
		public var initTime:int;
		public var currentTime:int;

		public var trialTime:int=0;

		public var running:Boolean=false;
		
		private var callF:Function;
		private var nextPing:Number;
		
		private var tickCount:int = 0;

		
		
		
		public function TrueTimer(DELAY:int,callF:Function):void {
			updateEvery=DELAY;
			this.callF=callF;
			nextPing = updateEvery;
		}


		private function evaluateTime(e:Event):void {
			if (running) {
				currentTime = new Date().valueOf();
				if (currentTime >= nextPing) {	
					tickCount++;
					trialTime= currentTime-initTime;
					nextPing = initTime + tickCount * updateEvery;
					callF(trialTime);	
				}
			}
		}

		

		public function start():void {
			initTime = new Date().valueOf();
			running=true;
			listen(true);
		}
		
		public function reStart():void {
			if(running==false){
				running=true;
				listen(true);
			}
			
			
			_goto(trialTime);
			
		}
		
		public function pause():void {
			running=false;
			listen(false);
		}
		
		public function stop():void {
			pause();
			
		}
		
		public function reset():void {
			_goto(0);
		}
		
		public function _goto(t:int):void{

			initTime =new Date().valueOf()-t;

			trialTime=t;
			tickCount= t / updateEvery;
			nextPing = 0;
			
			if(running) evaluateTime(null);
			else		callF(trialTime);
			
			
		}
		

		private function listen(ON:Boolean):void{
			if(ON)	addEventListener(Event.ENTER_FRAME,evaluateTime);
			else	removeEventListener(Event.ENTER_FRAME,evaluateTime);
		}

	}
}