package com.xperiment.make.xpt_interface
{
	import com.xperiment.make.xpt_interface.Cards.CardLevel;
	import com.xperiment.trial.Trial;

	public class TrialHelpers
	{
		
		private static function run(r:runnerBuilder,i:int):void{
			r.runningTrial.generalCleanUp();
			r.runningTrial=r.trialList[i];
			r.runTrial();
		}
		
		public static function goto_TrialNumber(data:*,r:runnerBuilder):void
		{
			if(isNaN(Number(data)))r.log("got_trialNumber, number not given: "+data);
			if(Number(data)>r.trialList.length)r.log("got_trialNumber, number higher than the number of trials: "+data);
			run(r,int(data));
		}
		
		
		
		public static function goto_TrialName(data:*, r:runnerBuilder):void
		{
			var success:Boolean=false;
			for(var t:uint=0;t<r.trialList.length;t++){
				if((r.trialList[t] as TrialBuilder).trialLabel==data){
					run(r,t);
				}
			}
			if(success == false) r.log("could not find a trial with this name: "+data);
	
			
		}
		
		
		public static function goto_TrialCardID(data:*, r:runnerBuilder):void
		{
			var cardID:String = data;
			var multiIndex:int = 0;
			
			//check to see if part of a pack
			var split:Array = cardID.split(CardLevel.TRIAL_SPLIT);
			if(split.length>1){
				multiIndex	= int(split[1]);
				cardID		= split[0];
			}

			var index:int = __searchTrials(cardID,multiIndex,r.trialList);
			if(index!=-1){
				run(r,index);
			}
		}
		
		private static function __searchTrials(bind_id:String, multiIndex:int, trialList:Vector.<Trial>):int
		{
			var trialBuilder:TrialBuilder;
			
			for(var t:uint=0;t<trialList.length;t++){
				trialBuilder = trialList[t] as TrialBuilder;
				trace(1,trialBuilder.bind_id)
				if(trialBuilder.bind_id==bind_id && trialBuilder.trialBlockPositionStart == multiIndex){
					return t;
				}
			}

			return -1;
		}		

	}
}