package com.xperiment.runner.ComputeNextTrial
{
	import com.xperiment.events.GotoTrialEvent;
	import com.xperiment.runner.ComputeNextTrial.Progress.Progress;
	import com.xperiment.runner.ComputeNextTrial.Progress.ProgressFactory;
	import com.xperiment.trial.Trial;
	
	import flash.utils.Dictionary;


	public class NextTrialBoss
	{
		
		public var trialList:Vector.<Trial>;
		public var trialOrder:Array;
		public var currentTrial:int;
		private var progressDict:Dictionary;
		
		public function NextTrialBoss(script:XML,trialList:Vector.<Trial>,trialOrder)
		{

			this.trialList = trialList;
			this.trialOrder = trialOrder;
			currentTrial = 0;
			this.progressDict = ProgressFactory.make(script);
			
		}
		
		public function getTrial(nextCommand:String,prevTrial:Trial):Trial{

			//only bother with Progress when Progress exists and either forward or backward (latter info ignored anyway)
			var nextTrialNum:int=-1;
			if(progressDict && prevTrial.trialOrderScheme && progressDict.hasOwnProperty(prevTrial.trialOrderScheme) && [GotoTrialEvent.NEXT_TRIAL,GotoTrialEvent.PREV_TRIAL].indexOf(nextCommand)!=-1){
				var a:int = (progressDict[prevTrial.trialOrderScheme] as Progress).getNextTrial(prevTrial,currentTrial);
				currentTrial = a;
				return computeRunningTrial();	
			}
			
			else if(nextCommand==GotoTrialEvent.NEXT_TRIAL){
				currentTrial++;
				return computeRunningTrial();	
			}
			else if(nextCommand==GotoTrialEvent.MAKER_NEXT_TRIAL){
				if(currentTrial+1>=trialOrder.length){
					return computeRunningTrial();
				}
				currentTrial++;
				return computeRunningTrial();	
			}
			
			else if(nextCommand==GotoTrialEvent.PREV_TRIAL){
				currentTrial--;
				if(currentTrial<0)currentTrial=0;
				return computeRunningTrial();
			}
			else if(nextCommand==GotoTrialEvent.MAKER_PREV_TRIAL){
				if(currentTrial-1<0)return computeRunningTrial();
				currentTrial--;
				return computeRunningTrial();	
			}
			else if(nextCommand==GotoTrialEvent.FIRST_TRIAL){
				currentTrial=0;
				return computeRunningTrial();
			}
			else if(nextCommand==GotoTrialEvent.LAST_TRIAL){
				currentTrial=trialOrder.length-1;
				return computeRunningTrial();
			}
			
			else if(nextCommand==GotoTrialEvent.RERUN_TRIAL){
				return computeRunningTrial();
			}
				
			else if(!isNaN(Number(nextCommand))){
				currentTrial=int(nextCommand);
				return computeRunningTrial();	
			}
				
			else if(nextCommand!=""){	
				
				var trialLabel:String;
				for(var t:uint=0;t<trialList.length;t++){
					
					trialLabel=trialList[t].trialLabel
					if(trialLabel==nextCommand || trialLabel==nextCommand+"1"){
						currentTrial=findTrialNum(t);
						return trialList[t];
					}
				}	
			}

			return null;
		}
		
		
		
		public function firstTrial():Trial
		{	
		
			return trialList[trialOrder[0]];
		}
		
		public function findTrialNum(t:int):int{
			
			for(var i:int=0;i<trialOrder.length;i++){
				if(trialOrder[i]==t)	return i;
			}
			
			return 0;
		}
		
		public function computeRunningTrial():Trial{

			if((trialOrder.length<=currentTrial || currentTrial<0)){
				return null;
			}
			//trace(currentTrial,222,trialList,trialOrder,trialOrder[currentTrial],trialOrder.length)
			//trace(currentTrial,trialOrder[currentTrial],trialOrder)
			return trialList[trialOrder[currentTrial]]; 
		}
		
	}
}