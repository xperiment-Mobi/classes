package com.xperiment.BehavLogicAction
{
	import flash.utils.Dictionary;
	
	public final class ActionDict
	{
		
		public var actionFuncts:Dictionary;	
		private static var _instance:ActionDict;
		
		public function ActionDict(pvt:PrivateSingletonDict){
			PrivateSingletonDict.alert();
		}
		
		public static function getInstance():ActionDict
		{
			if(ActionDict._instance ==null){
				ActionDict._instance=new ActionDict(new PrivateSingletonDict());
				ActionDict._instance.setup();
			}
			if(ActionDict._instance.actionFuncts==null)ActionDict._instance.setup();
			return ActionDict._instance;
		}
		
		public function giveActionF(action:String):Function{
			if(actionFuncts[action] is Function) return actionFuncts[action];
			if(actionFuncts[action] == null) throw Error("requested to run an action ("+action+") but no function has been assigned to it.");
			//if(actionFuncts[action] is undefined) throw Error("requested to run an action ("+action+") but no such action defined.");
			else throw Error("requested to run an action ("+action+") but no such action defined.");
			return null;
		}
		
		public function runActionF(action:String, removeAfter:Boolean=false):void{
			if(actionFuncts[action] is Function) if(actionFuncts[action]()==false || removeAfter) removeExptAction(action);
			if(actionFuncts[action] == null) throw Error("requested to run an action ("+action+") but no function has been assigned to it.");
			//if(actionFuncts[action] is undefined) throw Error("requested to run an action ("+action+") but no such action defined.");
			else throw Error("requested to run an action ("+action+") but no such action defined.");
		}
		
		
		////////////////////////////////////////
		////////////////////////////////////////
		//Per Trial Functions
		private var perTrialActions:Vector.<String>;
		
		public function killPerTrialActions():void{
			var action:String;
			while(perTrialActions.length>0){
				removeExptAction(perTrialActions.shift());
			}
			perTrialActions = null;
		}
				
		//only called by Action
		public function specifyRequirTrialAction(action:String):void{
			if(actionFuncts[action] == undefined){
				if(!perTrialActions)perTrialActions=new Vector.<String>;
				perTrialActions.push(action);
				actionFuncts[action] = null;
			}
		}
		//
		////////////////////////////////////////
		////////////////////////////////////////
		
		public function removeExptAction(action:String):void
		{
			if(actionFuncts[action] == null || actionFuncts[action] is Function) delete actionFuncts[action];
			else throw Error("Tried to delete a trial specific action but it was not in the ActionFunction pool!")
		}
		
		public function assignFunctToAction(rawProp:String,funct:Function):Boolean{
			if(actionFuncts[rawProp] == null){
				actionFuncts[rawProp]=funct;
				return true;
			}
			else if(actionFuncts[rawProp] == undefined)throw Error("asked to give a Trial Only Action a function ("+rawProp+") but that Action has not been previously specified.")
			else if(actionFuncts[rawProp] == Function) throw Error("asked to give a Trial Only Action a function ("+rawProp+") but that Action already has a function (from a past trial?? If so, bad)");
			else throw Error("unknown problem when trying to specify an Action ("+rawProp+").");
		}
		
		public function setup():void{
			actionFuncts=	new Dictionary(true);
		}

		//only used by Action class
		//a filter which only lets one instance of an action to be required.
		public function specifyRequirExptAction(action:String):void{
			if(actionFuncts[action] == undefined){
				actionFuncts[action] = null;
			}
		}
		
		public function kill():void{
			for (var val:String in actionFuncts){
				actionFuncts[actionFuncts]=null;
			}	
			actionFuncts=null;
			for ( val in perTrialActions){
				perTrialActions[val]=null;
			}
			perTrialActions=null;
		}
	}
}