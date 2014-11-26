package com.xperiment.behaviour
{
	import com.xperiment.uberSprite;
	import com.xperiment.TrueTimer;
	
	import flash.events.Event;
	import flash.events.TimerEvent;

	public class behavTimer extends behav_baseClass
	{
		private var timer:TrueTimer;
		private var timeFromEnd:Number;
		private var repeatCount:int;
		
		override public function setVariables(list:XMLList):void {
			
			setVar("int","duration",1000);
			setVar("int","repeat",1);
			super.setVariables(list);
			repeatCount=getVar("repeat");
		}		
		
		
		override public function myUniqueActions(action:String):Function{
			
			switch(action){
				case "start": return function():void{startMe();};	break;
									
				case "pause": return function():void{timeFromEnd=timer.timeFromEnd();timer.stop();};	break;
				
				case "stop": return function():void{checkForEvent(new TimerEvent("dummy"));};			break;
				
				case "reset": return function():void{repeatCount=getVar("repeatCount") as int;};		break;
				
				case "resume": return function():void{if(timeFromEnd && repeatCount>0)timerStart(timeFromEnd,repeatCount);}; break;
				
				case "addRepeat": return function():void{timer.repeatCount++;};		break;
				
				case "removeRepeat": return function():void{timer.repeatCount--;}; break;
				
			}
		
			return null;
		}
		
		override public function nextStep(id:String=""):void{startMe();}
		
		private function startMe():void
		{
			timerStart(getVar("duration"),repeatCount);
		}
		
		private function timerStart(dur:int,rep:int):void{
			timer = new TrueTimer(dur,rep);
			timer.addEventListener(TimerEvent.TIMER,checkForEvent,false,0,true);
			timer.__start();
		}
		
		
		protected function checkForEvent(e:Event):void
		{
			repeatCount--;
			//AW JAN FIX
			pic.dispatchEvent(new Event("doAfter"));
			//manageBehaviours.behaviourFinished(this);
		}
		
		override public function kill():void{
			timer.removeEventListener(TimerEvent.TIMER,checkForEvent);
			super.kill();
		}
	}
}