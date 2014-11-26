package com.xperiment.make.xpt_interface.Bind
{
	import com.xperiment.stimuli.object_baseClass;

	public class MultiTrialCorrection
	{
		public static var overStims:Boolean  = false;
		public static var overTrials:Boolean = true;
		

		
		public static function compute(stim:object_baseClass):Object{
			
			
			var obj:Object = {trialNum:stim.duplicateTrialNumber, itemNum:stim.iteration,numTrials:stim.numTrials};
			obj.numItems = int( stim.getVar("howMany") );
			
			return obj;
		}
	/*	
		private static function computeHowMany(howManyStr:String, params:Object):int
		{
			var trials:Array = howManyStr.split(";");
			for(var i:int=0;i<trials.length;i++){
				trials[i] = trials[i].split("---");
			}
			
			trace("--------------------");
			trace(trials[int(params.trialNum)][int(params.itemNum)],JSON.stringify(params),howManyStr);
			trace("----sssss----------------");
			
			return int( trials[int(params.trialNum)][int(params.itemNum)] );
		}*/
		
		private static function processHowMany(val:String, oldVal:String, multiSpecs:Object):String{
			var arr:Array= oldVal.split(";");
			__duplicateUp(arr, multiSpecs.numTrials,multiSpecs.defaults.numTrials);
			arr[multiSpecs.trialNum] = val;
			CrunchUp.DO(arr);
			return arr.join(";");
		}
		
		
		public static function sortMultiSpecs(val:String, oldVal:String, multiSpecs:Object,attrib:String=''):String
		{

		    if(val==oldVal)	return val;
			if(!multiSpecs) return val;
			if(overTrials && overStims) return val;

			if(attrib=="howMany"){
				return processHowMany(val, oldVal, multiSpecs);
			}

			//-split up
			var trialSplit:Array = oldVal.split(";");
			var defaultStr:String;
			
			
			for(var i:int=trialSplit.length-1; i>=0; i--){
				trialSplit[i] = trialSplit[i].split("---");
			}

			
		
			if(trialSplit.length<multiSpecs.numTrials){
				defaultStr = getDefault(attrib,multiSpecs);
				__duplicateUp(trialSplit, multiSpecs.numTrials,defaultStr);
			}
			
			if(overTrials){
				for(i = trialSplit.length-1;i>=0;i--){
					sortTrialChange(trialSplit, i, multiSpecs, val, defaultStr, attrib);
				}
			}

			else sortTrialChange(trialSplit, multiSpecs.trialNum, multiSpecs, val, defaultStr, attrib);
		
			
			for(i=trialSplit.length-1; i>=0; i--){
				if(trialSplit[i] is Array){
					trialSplit[i] = CrunchUp.DO(trialSplit[i]);
					
					trialSplit[i] = trialSplit[i].join("---");
				}
				else CrunchUp.DO([trialSplit[i]]);
			
			}

			trialSplit = CrunchUp.DO(trialSplit);
			
			val = trialSplit.join(";");
//trace(2,val)
			return val;
		}
		
		private static function sortTrialChange(trialSplit:Array, trialNum:int, multiSpecs:Object, val:String, defaultStr:String, attrib:String):void
		{
			if(overStims){
				trialSplit[trialNum] = val;
				return;
			}
			
			var isolatedTrial:Array;
			var addBack:Boolean = false;
			
			
			if(trialSplit[trialNum] is Array){
				if(val) isolatedTrial= trialSplit[trialNum];
					
				else{
					isolatedTrial=[];
					for(var i:int=0;i<trialSplit[trialNum].length;i++){
						isolatedTrial.push(trialSplit[trialNum][i]);
					}
					addBack=true;
				}
				
			}
			else {
				
				isolatedTrial = [trialSplit[trialNum]];
				addBack = true;
			}
			

			if(isolatedTrial.length<multiSpecs.numItems){
			
				defaultStr ||= getDefault(attrib,multiSpecs);
				
				__duplicateUp(isolatedTrial, multiSpecs.numItems,defaultStr);
			}

			if(val)	isolatedTrial[multiSpecs.itemNum] = val;
			else{
				isolatedTrial.splice(multiSpecs.itemNum,1);
				
			}

			CrunchUp.DO(isolatedTrial);

			if(addBack) trialSplit[trialNum] = isolatedTrial;
		}
		


		
		private static function getDefault(attrib:String, multiSpecs:Object):String
		{
			if(multiSpecs.hasOwnProperty('defaults')==false) throw new Error("defaults must be defined for multispecs");
			if(multiSpecs.defaults[attrib])return multiSpecs.defaults[attrib];	
			return '';
		}		
		
		
		
		public static function __duplicateUp(isolatedTrial:Array, numItems:int,defaultVal:String):Array{

			var duplic:Array = [];
			for(var i:int=0;i<isolatedTrial.length;i++){
				if(isolatedTrial[i]=="")isolatedTrial[i]=defaultVal;
				duplic.push(isolatedTrial[i]);
			}
			
			for(i=0;i<numItems;i++){
				if(isolatedTrial.length<=i){
					if(isolatedTrial[i]=="")isolatedTrial[i]=defaultVal;
					isolatedTrial.push(duplic[i%duplic.length]);
				}
			}

			return isolatedTrial;
		}
		
		public static function setMode(data:Object):void
		{
			if('overStims'==data.button){
				overStims=data.state;
			}
			else if('overTrials'==data.button){
				overTrials= data.state;
			}
			else{
				throw new Error();
			}
		}
	}
}