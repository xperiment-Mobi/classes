package com.xperiment.behaviour
{

	public class BehaviorBossHelper
	{
		//nb: updateDicts(rawProp:String,funct:Function)
		static public function link(perTrialProps:Vector.<String>,updateDicts:Function,stimArr:Array):void
		{
			
			//trace("herere");
			for each(var prop:String in perTrialProps){
				
				//trace(111,prop)
			}	
		}
		
		static public function fixBehavCommaIssue(behav:String,splitter:String):Array{
			
			
			if(behav.indexOf(splitter)==-1)throw Error("problem with this action as you've given it nothing to do:"+behav);
			else{
				var behavArr:Array=behav.split(splitter);
				var eventStr:String;
				for(var event_i:int=1;event_i<behavArr.length-1;event_i++){
					eventStr=behavArr[event_i];
					for(var action_i:int=eventStr.length-1;action_i>=0;action_i--){
						if(eventStr.charAt(action_i)=="," ){
							behavArr[event_i-1]+=splitter+eventStr.substr(0,action_i)
							behavArr[event_i]=eventStr.substr(action_i+1);
							break;
						}
						else if(action_i==0){
							behavArr[event_i-1]+=splitter+eventStr;
							behavArr[event_i]="";
						}
					}
				}
			}
			
			behavArr[behavArr.length-2]+=splitter+behavArr[behavArr.length-1];
			behavArr[behavArr.length-1]="";
			
			for(event_i=behavArr.length;event_i>=0;event_i--){
				if(behavArr[event_i]=="") behavArr.splice(event_i,1);
			}
			
			return behavArr
		}		
		
	}
}