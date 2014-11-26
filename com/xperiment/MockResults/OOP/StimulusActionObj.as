package com.xperiment.MockResults.OOP
{
	import com.xperiment.stimuli.addButton;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class StimulusActionObj
	{

		public var stimulus:object_baseClass;

		public var nextTrial:Boolean = false;
		
		private var timer:Timer;
		
		public function kill():void{
			if(timer){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,timerF);
			}
			stimulus = null;
		}
		
		public function computeActions():void
		{
			stimulus['mock']();
		}
		
		public function startNextTrialStimuli():void{
			timer = new Timer(50+100*Math.random(),1);
			timer.addEventListener(TimerEvent.TIMER,timerF);
			timer.start();
		}
		
		private function timerF(e:TimerEvent):void{
			timer.stop();
			if(stimulus is addButton)(stimulus as addButton).MouseDown(new MouseEvent(MouseEvent.MOUSE_DOWN));

			
		}
	}
}