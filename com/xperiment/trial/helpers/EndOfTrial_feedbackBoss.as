package com.xperiment.trial.helpers
{
	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class EndOfTrial_feedbackBoss
	{
		public function EndOfTrial_feedbackBoss()
		{
		}
		
		public static function DO(endOfTrialStim:Vector.<uberSprite>, currentDisplay:OnScreenBoss, nextEvent:Function):void
		{

			for each(var stim:object_baseClass in endOfTrialStim){

				var duration:String = stim.getVar('duration');
				if(duration=='') duration = stim.getVar("timeEnd");
				if(duration=='') duration = '500';
				
				stim.addEventListener(StimulusEvent.ON_FINISH,function(e:Event):void{
					stim.removeEventListener(e.type, arguments.callee);
					var pos:int = endOfTrialStim.indexOf(e.currentTarget as uberSprite);
					endOfTrialStim.splice(pos,1);
					if(endOfTrialStim.length==0){
						
						var endDelay:String = stim.getVar("timeStart");
						if(endDelay.length==3){
							endOfTrialStim=null;
							nextEvent();
						}
						else{
							endDelay=endDelay.substr(4);
							var t:Timer= new Timer(int(endDelay));
							t.addEventListener(TimerEvent.TIMER,function(e:Event):void{
								t.stop();
								t.removeEventListener(TimerEvent.TIMER,arguments.callee);
								endOfTrialStim=null;
								nextEvent();
							});
							t.start();
						}
					}
				
				});
				
				currentDisplay.runDrivenEvent(stim.peg,stim.getVar("delay"),duration);
			}
			
			//stim.dispatchEvent(new StimulusEvent(StimulusEvent.ON_FINISH));trace(110)
			
		}
		

	}
}