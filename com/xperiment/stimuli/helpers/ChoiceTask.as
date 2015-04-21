package com.xperiment.stimuli.helpers
{
	import com.xperiment.codeRecycleFunctions;

	public class ChoiceTask
	{
		public function ChoiceTask()
		{
		}
		
		public static function DO(prop:String, list:XMLList):void
		{
			//var commands:Object = codeRecycleFunctions.strToObj(str);
			//trace(JSON.stringify(commands),11,list.toXMLString());
			
			function err(str:String):void{
				throw new Error("Error in Choice_task: "+ str);
			}
			
			var howMany:int = 1;
			var numTrials:int = 1;
			var orig:String;
			
			if(list.hasOwnProperty('@howMany')) howMany = int( list.@howMany.toXMLString() );
			if(howMany<2) err("you must define 'howMany' and this has to be greater than 1");
			
			
			if(list.parent().hasOwnProperty('@trials')) numTrials = int( list.parent().@trials.toString() );
			if(howMany<2) err("you must define 'howMany' and this has to be greater than 1");
			
			if(list.hasOwnProperty('@'+prop)) orig = list.@[prop].toXMLString();
			
			
			var toChange:Array = orig.split(";").join("---").split("---");
			if(toChange.length<howMany) err("you must have equal or more parameters to change (in this case: "+prop+") as there are 'howMany' in a trial (else, impossible for their to be unique stimuli per trial)");
			if(toChange.length>howMany*numTrials)err("you have too few trials x stimPerTrial" )
			
			codeRecycleFunctions.arrayShuffle(toChange);

			var result:Array = computeBins_choiceTask(toChange, howMany, numTrials);
			
			for(var i:int=0;i<result.length;i++){
				result[i] = result[i].join("---");
			}
			
			list.@[prop] = result.join(";").toString();	

		}
		
	
		
		private static function computeBins_choiceTask(toChange:Array, howManyPerTrial:int, numTrials:int ):Array
		{
			
			var results:Array = [];
			
			var bin:Array = [];
			
			var attempts:int = 0;
			var maxAttempts:int = 10;
			
			var uniqueList:Array = [];
			
			var attempt:Array;
			
			function makeLabel(arr:Array):String{
				arr.sort();
				return arr.toString();
			}
			
			
			var label:String;
			
			while(results.length<numTrials){
			
				attempt = genRand(howManyPerTrial,toChange);	
				label = makeLabel(attempt.concat());

				if(uniqueList.indexOf(label)==-1 || attempts>=maxAttempts){
					uniqueList.push( label );
					results.push(attempt);
					attempts=0;
				}
				else{
					attempts++;
				}
				
			}

			return  results;
		}
		
		//generates unique rand
		private static function genRand(howManyPerTrial:int,toChange:Array):Array{
			var arr:Array = [];
			
			var item:String;
			while(arr.length<howManyPerTrial){
				item = toChange[int((toChange.length)*Math.random())];

				if(arr.indexOf(item)==-1){

					arr.push(item);
				}
			}

			return arr;
		}
		
	
		
	}
}