package com.xperiment.behaviour{
	import com.xperiment.events.GotoTrialEvent;
	import com.xperiment.stimuli.Imockable;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class behavNextTrial extends behav_baseClass implements Imockable {

		
		override public function nextStep(id:String=""):void {
			if(parentPic){
				parentPic.dispatchEvent(new GotoTrialEvent(GotoTrialEvent.TRIAL_PING_FROM_OBJECT,GotoTrialEvent.NEXT_TRIAL));
				//trace("behavNextTrial ping sent to trial");
			}
			
		}
		
		
		public function mock():void{
		var t:Timer = new Timer(200,1);
		t .addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
			//////////////////////////////////////
			e.target.removeEventListener(e.type,arguments.callee);
			//////////////////////////////////////Anonymous Function
			t.stop();
			nextStep();
			//////////////////////////////////////
			//////////////////////////////////////
		});
		t.start();
				
		}
		
	}

}