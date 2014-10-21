package com.xperiment.trialOrder.components.BlockOrder
{
	import com.xperiment.parsers.CompiledObject;
	import com.xperiment.parsers.MathParser;
	
	public class SlotInForcePositions
	{
		
		
		public static function DO(trials:Array,forcePositions:Array):Array
		{
			var forcePosition:Object;
			var position:int;
			for(var i:int=0;i<forcePositions.length;i++){
				forcePosition=forcePositions[i];	
				position=getPosition(forcePosition.forcePosition,trials.length);
				forcePositions[i].position = position;
			}

			forcePositions.sortOn('position',Array.NUMERIC);

			for(i=forcePositions.length-1;i>=0;i--){
				__addTrials(trials,forcePositions[i].position,forcePositions[i].trials);
			}
			
			return trials;
		}
		
		public static function __addTrials(trials:Array, position:int,addTrials:Array):Array{

			addTrials.reverse();
			for(var i:int=0;i<addTrials.length;i++){
				
				
				trials.splice(position,0,addTrials[i]);
			}

			return trials;
		}
		
		public static function getPosition(forcePosition:String,length:int):int
		{
			if(!isNaN(Number(forcePosition))){
				return int(forcePosition);
			}
			
			switch(forcePosition.toUpperCase()){
				case 'FIRST':
					return 0;
					break;
				case 'SECOND':
					return 1;
					break;
				case 'THIRD':
					return 2;
					break;
				case 'LAST':
					return length;
					break;
				case 'MIDDLE':
				 case 'CENTER':
				case 'CENTRE':
					return int(length/2); // as position is int, rounds down
					break;
				case 'MIDDLE+1':
				case 'CENTER+1':
				case 'CENTRE+1':
					return int(length/2)+1; // as position is int, rounds down
					break;
				
			}
			
			var mpVal:MathParser = new MathParser([]);
			
			var compobjVal:CompiledObject =  mpVal.doCompile(forcePosition.split('length').join(String(length)));
			

			if (compobjVal.errorStatus != 1){
				var pos:Number=mpVal.doEval(compobjVal.PolishArray, []);
				mpVal=null;
				return 	Math.round(pos*length);	
			}
			
			
			throw new Error('You have asked to force the position of some trials but I do not understand where to slot them in (e.g. first, last, middle, middle+1 [to help with rounding up where the centre is; nb centre+2 is not valid] 1/2, 1/3, more complex math (use the word length to specify the length of the current block): '+forcePosition);
			
			return null;
		}
	}
}