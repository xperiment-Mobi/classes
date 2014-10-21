package com.xperiment.make.OnScreenBoss
{
	import com.xperiment.onScreenBoss.TrueTimer;
	import com.xperiment.onScreenBoss.iTrueTimer;

	public class TrueTimerMaker extends TrueTimer implements iTrueTimer
	{

		private var callBackF:Function;
		private var currentTime:int;

	
		public function TrueTimerMaker(DELAY:int,callF:Function):void{
			super(DELAY,callF);
		}
		
	
		
		override public function start():void{
		}
		
		override public function reStart():void{
		} 
		
		override public function pause():void{
		}
		
		override public function stop():void{
		}
	}
}