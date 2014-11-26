package com.xperiment.RequiredActions
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class RequiredAction extends Sprite
	{
		private var timeoutTimer:Timer;
		private var runFs:Function;
		
		public var actionF:Function;
		public var successArr:Array;
		public var failArr:Array;
		public var wait:Boolean = false;
		public var retries:int = 0;
		public var resetTimeronRetry:Boolean = true;
		public var myName:String;
		public var finished:Boolean = false;
		public var success:Boolean;
		
		
		public function kill():void{
			timeoutTimer.removeEventListener(TimerEvent.TIMER,timedOutF);
			timeoutTimer.stop();
			successArr = null;
			failArr = null;
			actionF = null;
			finished = true;
		}
		
		public function start():void{
			timeoutTimer.start();
			if(actionF){
				if(actionF.length==1)actionF(successFail);
				else actionF();
			}
		}
		
		public function RequiredAction(runFs:Function, timeout:int)
		{
			this.runFs = runFs;
			timeoutTimer = new Timer(timeout,1);
			timeoutTimer.addEventListener(TimerEvent.TIMER,timedOutF);
			
		}
		
		private function timedOutF(event:TimerEvent):void
		{
			successFail(false);
		}	
		
		public function successFail(success:Boolean):void
		{
			if(success)	{
				this.success=true;
				runFs(successArr,this,true);
				kill();
			}
			else{
				if(retries>0){
					retries--;
					if(resetTimeronRetry){
						timeoutTimer.stop();
						timeoutTimer.reset();
					}
					start();
				}
				else {
					this.success=false;
					runFs(failArr,this,false);
					kill();
				}
			}
			
		}
		
	}
}