package com.xperiment.behaviour{
	import com.xperiment.events.GlobalFunctionsEvent;

	public class behavFinishStudy extends behav_baseClass{ //note without 'public' nothing happens!!
		
		override public function nextStep(id:String=""):void{
			theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.FINISH_STUDY));
		}
		
	}
}