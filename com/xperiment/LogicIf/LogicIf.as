package com.xperiment.LogicIf
{
	import com.xperiment.Logic.components.ILogicDictionaries;
	import com.xperiment.LogicIf.components.LogicAction;
	import com.xperiment.Logic.Logic;
	import flash.utils.Dictionary;
	
	public class LogicIf 
	{
		private var logDict:VariableDictionaries;
		private var ActionsDictofLogics:Dictionary;
		//stores arrays of Logic.  Each array consists of Logics with the same resulting action.
		//Thus, when an action is piped in here, can iterively go through all the Logics associated with it.
		
		public function LogicIf(logicsActionsStr:String,logDict:VariableDictionaries = null)
		{
			logDict==null	?	this.logDict= new VariableDictionaries		:	 this.logDict=logDict; //if not passed logDict, make one
			
			ActionsDictofLogics = processLogicAction(logicsActionsStr)
		}
		
		public function eval(action:String, peg:String,whatHappened:String):Boolean
		{
			//if not done so already adds myPeg.event to dictionary (temporary variable deleted at the end of the trial)
			//increments myPeg.event by one
			//used to keep a tally on the number of times the event occured
			logDict.incrementPerTrialProp(peg+"."+whatHappened);
			
			//assuming that the action is an index in ActionsDictofLogics, iterate through all the LogicActions in the Array at that index
			//if one returns true, return true (and stopping the iteration automatically).
			if(ActionsDictofLogics[action]){
				for(var i:uint=0;i<ActionsDictofLogics[action].length;i++){	
					if((ActionsDictofLogics[action][i] as LogicAction).logic.eval())return true;
				}		
			}
			return false;
		}
		
		

		
		//note that multiple logicsActions can be passed to here such as A1&&B1&&C1:hide,!A1&&B1&&C1:show
		private function processLogicAction(logicsActionsStr:String):Dictionary
		{
			var logicsActionsStrArr:Array=logicsActionsStr.split(",");
			var ActionsDictofLogics:Dictionary = new Dictionary;
			
			var logicAction:LogicAction;
			
			for (var i:int=0;i<logicsActionsStrArr.length;i++){
				logicAction = LogicAction.build(logicsActionsStrArr[i]); 	//If logic not correctly formatted (with a : seperating logic:action), throws error and returns null
																			//Letting it return null to let xperiment run despite errors during expt development stage
				if(logicAction){ //check to see if logic is valid (not null)
					logicAction.passDictionary(logDict);
					
					if(ActionsDictofLogics[logicAction.actionStr]==undefined)ActionsDictofLogics[logicAction.actionStr]=new Array;
					ActionsDictofLogics[logicAction.actionStr].push(logicAction);
				}
			}
			return ActionsDictofLogics;
		}
		

	}
}