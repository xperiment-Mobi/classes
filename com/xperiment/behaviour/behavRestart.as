package com.xperiment.behaviour
{

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.xperiment.events.GlobalFunctionsEvent;

	public class behavRestart extends behav_baseClass
	{
		override public function setVariables(list:XMLList):void {
			setVar("number","timeToRestart",1000);
			super.setVariables(list);
			
		}
		
		override public function nextStep(id:String=""):void {
			//theStage.dispatchEvent(new Event("endOfStudy",true));
			var timer:Timer = new Timer(getVar("timeToRestart"),1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void{
				e.currentTarget.removeEventListener(e.type,arguments.callee);
				theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.RESTART_STUDY));
			});
			trace(12323)
			timer.start();
		}
	}
}