package com.xperiment.behaviour
{

	public class BehaviourBossHelper
	{
		
		static public function fixBehavCommaIssue(behav:String,splitBy:String="?"):Array{
			
			
			if(behav.indexOf(splitBy)==-1)throw Error("problem with this action as you've given it nothing to do:"+behav);
			else{
				var behavArr:Array=behav.split(splitBy);
				var eventStr:String;
				for(var event_i:int=1;event_i<behavArr.length-1;event_i++){
					eventStr=behavArr[event_i];
					for(var action_i:int=eventStr.length-1;action_i>=0;action_i--){
						if(eventStr.charAt(action_i)=="," ){
							behavArr[event_i-1]+=splitBy+eventStr.substr(0,action_i)
							behavArr[event_i]=eventStr.substr(action_i+1);
							break;
						}
						else if(action_i==0){
							behavArr[event_i-1]+=splitBy+eventStr;
							behavArr[event_i]="";
						}
					}
				}
			}
			
			behavArr[behavArr.length-2]+=splitBy+behavArr[behavArr.length-1];
			behavArr[behavArr.length-1]="";
			
			for(event_i=behavArr.length;event_i>=0;event_i--){
				if(behavArr[event_i]=="") behavArr.splice(event_i,1);
			}
				
			return behavArr
		}		
	
	}
}