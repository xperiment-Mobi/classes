package com.xperiment.BehavLogicAction.Action.ActionTypes
{
	import com.xperiment.BehavLogicAction.Action.IAction;

	public class ActionCommand implements IAction
	{
		public var action:String;
		private var incrementPerTrial:Function;
		private var contents:Array;
		
		public function kill():void{
			action=null;
			incrementPerTrial=null;
			contents=null;
		}
		
		
		public function ActionCommand(action:String,addCommand:Function,incrementPerTrial:Function,contents:Array)
		{
			this.action=action;
			this.incrementPerTrial=incrementPerTrial;
			this.contents=contents;
			addCommand(action);
			
		}
	
		
		public function doAction():Function{			
			return function():void{	
				//trace(contents,action,222)
				incrementPerTrial(action,contents)
			};
		}
		
	}
}