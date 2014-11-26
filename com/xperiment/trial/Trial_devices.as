package com.xperiment.trial {

	import com.xperiment.behaviour.behavPastResults;
	import com.xperiment.behaviour.behavQuit;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.stimuli.IStimulus;
	import com.xperiment.stimuli.StimulusFactory;
	import com.xperiment.stimuli.addButtonToCloseProgram;
	import com.xperiment.stimuli.addTouch;
	import com.xperiment.trial.Scroll.IScroll;
	import com.xperiment.trial.Scroll.ScrollTrial_Mobile;
	
	
	public class Trial_devices extends Trial {
		public var _dummyaddButtonToCloseProgram:addButtonToCloseProgram;
		public var _dummyaddTouch:addTouch;
		public var _dummybehavQuit:behavQuit;

		
		public function deviceSpecific_StimFactory(stimName):IStimulus{
			throw new Error();
		}
		
		
		
		override public function stimulusFactory(stimName:String):IStimulus{
			var processedName:String = StimulusFactory.processStimName(stimName)
			
			switch(processedName){
				case "quit": 				return new behavQuit;
				case "pastresults":			return new behavPastResults;
			}
			
			var deviceSpecific:IStimulus = deviceSpecific_StimFactory(processedName);
			if(deviceSpecific) return deviceSpecific;
			
			return StimulusFactory.Stimulus(stimName);
		}
		
		override public function getOnScreenBoss():OnScreenBoss{
			return new OnScreenBoss;
		}
		
		override public function giveScrollTrial():IScroll
		{
			return new ScrollTrial_Mobile();
		}
		
	}
}