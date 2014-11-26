package com.xperiment.trial {
	import com.xperiment.stimuli.IStimulus;
	import com.xperiment.stimuli.addText;



	public class TrialLab extends Trial_devices {
		
		
		
		override public function deviceSpecific_StimFactory(stimName):IStimulus{
			switch(stimName){
					case "mechanicalurk": 		return new addText;
					//case "adminsetvariable": 	return new adminSetVariable;
					//case "adminconsole": 		return new adminConsole;
			}
			return null;
		}	
	}
}