package com.xperiment.make.xpt_interface.Bind
{

	public class Bind_MultiStim_change
	{

		public static const TRIAL_PARAMS:String = ",";
		public static const STIMULI_PARAMS:String=";";
		
		public static function DO(bind_id:String, new_trialOrder:Array, oldScript:XML):void
		{
			var multiTrial:XML = BindScript.getStimScript(bind_id);
			if(!multiTrial) throw new Error();
			else{
				updateStimuli(multiTrial,new_trialOrder,oldScript, bind_id);
			}	
		}
		
		private static function currentTrialOrder():Array
		{
			var arr:Array = [];
			return arr;
		}
		
		private static function updateStimuli(multiTrial:XML, new_trialOrder:Array, oldScript:XML, bind_id:String):void
		{

			var numTrials:String = multiTrial.@trials.toString();;
			
			if(numTrials.length==0)	return;
			var numTrialsInt:int = int(numTrials);
			
			if(numTrialsInt<1)		return;

			var lookup:XML = generateLookup(oldScript, bind_id);
			
			var prop:String = BindScript.bindLabel;
			
			
			
			var xml:XML = oldScript..*.(hasOwnProperty('@'+prop) && attribute(prop)==bind_id)[0];	
			

			__updateTrialNames(
				bind_id, 
				multiTrial,
				new_trialOrder,
				numTrialsInt,
				TRIAL_PARAMS
			);
			
			var stimBind:String;
			var stim:XML;
			for(var i:int=0;i<multiTrial.children().length();i++){
				stim = multiTrial.children()[i];
				stimBind = stim.@[BindScript.bindLabel].toXMLString();
				__updateStimulus(
					stimBind, 
					stim,
					new_trialOrder,
					getStimFromTrial(lookup, stimBind),
					numTrialsInt,
					STIMULI_PARAMS
				);
			}
			
		}
		
		private static function __updateTrialNames(bind_id:String, stim:XML, new_trialOrder:Array,numTrials:int,params_type:String):void
		{
			
			var propVal:String=stim.@trialName.toXMLString();
			if(propVal.length<=0)					return;
			if(propVal.indexOf(params_type)==-1)	return;
			
	
			var oldVal:String = stim.attribute('trialName').toXMLString();
			
			var newVal:String = shuffleMultiSpecs(oldVal, new_trialOrder,numTrials,params_type);
			
			if(oldVal==newVal)						return;
			
			BindScript.StimulusUpdate(bind_id, {'trialName':newVal});
			
		}		

		
		public static function __updateStimulus(bind_id:String, stim:XML, new_trialOrder:Array, origStim:XML,numTrials:int,params_type:String):void
		{
			var propStr:String;
			var propVal:String;
			var oldVal:String;
			var newVal:String;
			
			var updates:Object = {};
			var change:Boolean = false;
			for each(var prop:XML in stim.@*) 
			{
				propStr=prop.name();
				propVal=prop.toXMLString();
		
				if(propVal.indexOf(params_type)!=-1){
					
					change=true;
					oldVal = origStim.attribute(propStr).toXMLString();
					newVal = shuffleMultiSpecs(oldVal, new_trialOrder,numTrials,params_type);
					updates[propStr] = newVal;
				}
			}
			if(change){
				
				BindScript.StimulusUpdate(bind_id, updates);
			}
		}
		
		private static function getStimFromTrial(trial:XML, bindLabel:String):XML{
			return generateLookup(trial, bindLabel);
		}

		
		private static function generateLookup(orig_script, bind_id:String):XML{
			var prop:String = BindScript.bindLabel;
			var xml:XML = orig_script..*.(hasOwnProperty('@'+prop) && attribute(prop)==bind_id)[0];	
			return xml;
		}
		
		private static function getStimAttribs(stim:XML):Object
		{
			var obj:Object = {};
			for each(var xml:XML in stim.@*){
				obj[xml.name().toString()] = xml.toXMLString();
			}
			
			return obj;
		}		
		

		
	
		
		public static function shuffleMultiSpecs(value:String, new_trialOrder:Array,howMany:int, params_type:String):String
		{
			var stimSplit:Array = value.split(params_type);
			
			if(stimSplit.length<howMany)	MultiTrialCorrection.__duplicateUp(stimSplit, howMany,'');
			
			var newVal:Array = [];
			
			for(var i:int=0;i<new_trialOrder.length;i++){
				newVal.push(stimSplit[new_trialOrder[i]]);
			}
			
			newVal = CrunchUp.DO(newVal);
			
			//var newValue:String = newVal.join("---");
			//trace(newValue,"    ",value);
			return newVal.join(params_type);
		}
		
	}
}