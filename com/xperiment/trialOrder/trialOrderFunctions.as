package com.xperiment.trialOrder{
	import com.xperiment.trialOrder.components.BlockOrder.OrderBlocksBoss;
	import com.xperiment.trialOrder.components.BlockOrder.TrialBlock;
	
	public class trialOrderFunctions {
		
		
		//static var blockSize:uint;
		//static var numBlocks:uint;
		private static var randFirstOrder:String;
		private static var randSecondOrder:String;		
		
		
		public static function computeOrder(trialProtocolList:XML,composeTrial:Function):Array{
			sortOutShuffles(trialProtocolList)
			
			var orderBlocksBoss:OrderBlocksBoss = new OrderBlocksBoss();
			
			
			var counter:int=0;
			var trialBlock:TrialBlock;
			var trials:Array;
			
			for (var i:uint=0; i<trialProtocolList.TRIAL.length(); i++) { //for each block of trials
				trialBlock=new TrialBlock;
				
				trialBlock.setup(trialProtocolList.TRIAL[i],counter,i,composeTrial)
			
				if(trialBlock.numTrials>0){	//ignore trials that say zero trials
					orderBlocksBoss.giveBlock(trialBlock); 
					counter=trialBlock.getMaxTrial()+1;
				}	
			}
			
			var trialOrder:Array = orderBlocksBoss.compose();
	
			orderBlocksBoss.kill();

			return trialOrder;
		}
				
		
		
		private static function sortOutShuffles(trialProtocolList:XML):void
		{
			var list:XMLList = trialProtocolList.TRIAL.(hasOwnProperty("@shuffle_block"));
			var blockList:Array=[];
			
			for each(var trial:XML in list){
				blockList.push(trial.@block.toString());
			}
			
			var randArr:Array = randomizeArray(blockList)
			
			for each(trial in list){
				trial.@block=String(randArr.shift());
			}
		}
		
		private static function randomizeArray(array:Array):Array {
			var newArray:Array = new Array();
			while(array.length > 0){
				var obj:Array = array.splice(Math.floor(Math.random()*array.length), 1);
				newArray.push(obj[0]);
			}
			return newArray;
		}
		
		

		private static function shuffleArray(a:Array):Array {
			var a2:Array=[];
			while (a.length>0) {
				a2.push(a.splice(Math.round(Math.random()*a.length-1),1)[0]);
			}
			return a2;
		}
		
		
		
		private static function genRepetition(num:uint):Array {
			var repArray:Array=new Array  ;
			for (var i:uint=0; i<num; i++) {
				repArray.push(i+1);
			}
			return repArray;
		}
	}
}