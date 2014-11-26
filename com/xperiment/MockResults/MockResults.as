package com.xperiment.MockResults
{
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.MockResults.OOP.StimulusActionObj;
	import com.xperiment.stimuli.Imockable;
	import com.xperiment.stimuli.addButton;
	import com.xperiment.stimuli.object_baseClass;

	public class MockResults
	{
		static private var stimuli:Vector.<StimulusActionObj> 		= new Vector.<StimulusActionObj>;
		static private var nextTrialStimuli:Vector.<StimulusActionObj> = new Vector.<StimulusActionObj>;

		
		public static function sortExptWideSpecs():void
		{
			ExptWideSpecs.MockSort();
			
		}
		
		public static function giveStimuli(trial_stimuli:Vector.<object_baseClass>):void
		{
			var doLast:Boolean;
			var s:StimulusActionObj
			var stimObj:StimulusActionObj;
			
			for each(var stimulus:object_baseClass in trial_stimuli){
				
				
				if(stimulus is addButton && (stimulus.getVar("goto")!="" || stimulus.getVar("mock.goto")!="")){
					stimObj= newStimObj(stimulus);
					stimObj.nextTrial = true;
				}

				else if(stimulus is Imockable){
					stimObj= newStimObj(stimulus);
					stimObj.computeActions();
				}
			}
		}
		
		public static function start():void{
			var stimulus:StimulusActionObj

			
			for each(stimulus in stimuli){
				if(stimulus.nextTrial){
					stimulus.startNextTrialStimuli();
				}
			}
		}
		
		private static function newStimObj(stimulus:object_baseClass):StimulusActionObj{
			stimulus.ran=true;
			var stimObj:StimulusActionObj = new StimulusActionObj;
			stimObj.stimulus = stimulus;
			stimuli[stimuli.length] = stimObj;
			return stimObj;
		}


		
		public static function kill():void{
			for each(var stimulus:StimulusActionObj in stimuli){
				stimulus.kill();
			}
			for each(stimulus in nextTrialStimuli){
				stimulus.kill();
				
				stimuli = null;
				nextTrialStimuli = null;
			}
		}
	
	}
}