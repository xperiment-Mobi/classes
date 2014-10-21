package com.xperiment.BehavLogicAction.Action
{
	import com.xperiment.BehavLogicAction.Action.ActionTypes.ActionCommand;
	import com.xperiment.BehavLogicAction.PropValDict;

	public class Actions
	{
		private var actionsArr:Array;
		public var ActionsVect:Vector.<IAction> = new Vector.<IAction>;
		public var actionsToRunFs:Array =[];
		private var propValDict:PropValDict;
		private var commasOutSideBrackets:RegExp = /(?![^(]*\)),/g


		public function kill():void{
			for (var A:String in ActionsVect){
				delete ActionsVect[A];
			}
			ActionsVect=null;
			for(var i:uint=0;i<actionsArr.length;i++){
				actionsToRunFs[i]=null;
			}
			actionsToRunFs=null;
		}
		
		public function Actions(actions:String,propValDict:PropValDict)
		{

			actionsArr = actions.split(commasOutSideBrackets);

			this.propValDict=propValDict;

			for(var i:int=0;i<actionsArr.length;i++){
		
				ActionsVect.push(ActionFactory.Action(actionsArr[i],propValDict));
			}
			
			for(i=ActionsVect.length-1;i>=0;i--){
				
				actionsToRunFs.unshift(ActionsVect[i].doAction());
				if(ActionsVect[i] is ActionCommand){
					ActionsVect[i]=null
					ActionsVect.splice(i,1);
				}

			}
		}
	
		
		public function run():void
		{
			for(var i:uint=0;i<actionsToRunFs.length;i++){
				actionsToRunFs[i]();
				//trace(111,actionsToRunFs[i])
			}
			
		}
	}
}