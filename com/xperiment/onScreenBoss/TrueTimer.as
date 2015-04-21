//AW taken from http://blog.gritfish.net/?p=76%94

package com.xperiment.onScreenBoss{
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class TrueTimer extends Sprite {
		public var delay:Number;
		public var repeatCount:int = 2147483647;
		public var initTime:Date;
		public var currentTime:Date;
		private var pauseOffset:Number;
		public var currentMS:int=-1;
		public var __offset:int=0;
		public var running:Boolean=false;
		public var timeFromStart:int=0;
		public var timeShouldBe:int=0;
		private var now:Date;
		private var msDiff:Number;
		protected var callF:Function;
		
		
		
		
		public function TrueTimer(DELAY:int,callF:Function):void {
			delay=DELAY;
			this.callF=callF;
			init();
		}
		
		protected function init():void{
			initTime = new Date();
			currentTime=initTime;
		}
		
		
		public function evaluateTime(e:Event):void {
			
			if (running) {
				now = new Date();
				currentMS=now.valueOf()-initTime.valueOf();
				currentTime=now;
				callF();
			}
			
		}
		
		public function timeFromEnd():Number{
			return delay-timeFromStart;
		}
		
		
		public function start():void {
			initTime = new Date();
			currentTime=initTime;
			running=true;
			listen(true);
		}
		
		public function reStart():void {
			initTime = new Date();
			initTime=new Date(initTime.getTime()-pauseOffset);
			running=true;
			listen(true);
		}
		
		public function pause():void {
			pauseOffset=currentTime.valueOf()-initTime.valueOf();
			running=false;
			listen(false);
		}
		
		public function stop():void {
			running=false;
			listen(false);
		}
		
		public function reset():void {
			currentMS=0;
			__offset=0;
			running=false;
			listen(false);
			callF=null;
		}
		
		
		
		protected function listen(ON:Boolean):void{
			if(ON)	addEventListener(Event.ENTER_FRAME,evaluateTime);
			else	removeEventListener(Event.ENTER_FRAME,evaluateTime);
		}
		
		public function _goto(t:int):void
		{
			throw new Error('not implemented yet');
			
		}
	}
}