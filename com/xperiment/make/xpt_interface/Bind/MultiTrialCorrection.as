package com.xperiment.make.xpt_interface.Bind
{
	import com.xperiment.stimuli.object_baseClass;

	public class MultiTrialCorrection
	{
		

		
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
			

			if(attrib=="howMany"){
				return processHowMany(val, oldVal, multiSpecs);
			}

			//-split up
			var trialSplit:Array = oldVal.split(";");
			var defaultStr:String;
			var addBack:Boolean = false;
			
			for(var i:int=trialSplit.length-1; i>=0; i--){
				trialSplit[i] = trialSplit[i].split("---");
			}

			//trace(123,trialSplit.length,multiSpecs.numTrials)
			//---core
			if(trialSplit.length<multiSpecs.numTrials){
				defaultStr = getDefault(attrib,multiSpecs);
				__duplicateUp(trialSplit, multiSpecs.numTrials,defaultStr);
			}
			
			
			var isolatedTrial:Array;
			if(trialSplit[multiSpecs.trialNum] is Array){
				if(val) isolatedTrial= trialSplit[multiSpecs.trialNum];
				
				else{
					isolatedTrial=[];
					for(i=0;i<trialSplit[multiSpecs.trialNum].length;i++){
						isolatedTrial.push(trialSplit[multiSpecs.trialNum][i]);
					}
					addBack=true;
				}

			}
			else {
				
				isolatedTrial = [trialSplit[multiSpecs.trialNum]];
				addBack = true;
			}
			
			//trace(3333,trialSplit)
			
			//if(Number(val.substr(0,val.length-1))>50)trace(13,val,isolatedTrial)
			//trace(isolatedTrial.length,multiSpecs.itemNum+1)
			//trace(2292,isolatedTrial.length,multiSpecs.itemNum+1)
			if(isolatedTrial.length<multiSpecs.numItems){
				//trace(444,getDefault(attrib,multiSpecs))	
				defaultStr ||= getDefault(attrib,multiSpecs);

				__duplicateUp(isolatedTrial, multiSpecs.numItems,defaultStr);
			}
			//trace(trialSplit,33333)
			if(val)	isolatedTrial[multiSpecs.itemNum] = val;
			else{
				isolatedTrial.splice(multiSpecs.itemNum,1);

			}
			//trace(trialSplit,33333)
			CrunchUp.DO(isolatedTrial);

			//trace(trialSplit,33333)
			if(addBack) trialSplit[multiSpecs.trialNum] = isolatedTrial;
			//trace(trialSplit,444)
			//---recombine
			for(i=trialSplit.length-1; i>=0; i--){
				if(trialSplit[i] is Array){
					trialSplit[i] = CrunchUp.DO(trialSplit[i]);
					
					trialSplit[i] = trialSplit[i].join("---");
				}
				else CrunchUp.DO([trialSplit[i]]);
				
				//trace(1111,trialSplit[i]);
//				/trialSplit[i] = trialSplit[i].join("---");
			}

			trialSplit = CrunchUp.DO(trialSplit);
			
			val = trialSplit.join(";");
//trace(2,val)
			return val;
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
		
	}
}