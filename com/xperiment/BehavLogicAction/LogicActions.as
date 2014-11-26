package com.xperiment.BehavLogicAction
{

	public class LogicActions
	{

		public var logicActionsVect:Vector.<LogicAction> = new Vector.<LogicAction>; 
		private var propValDict:PropValDict;


		public function LogicActions(propValDict:PropValDict)
		{	
			this.propValDict=propValDict;
		}
		
		public function passLogicAction(logicActionArr:Array):void{
			
			
			for each(var logicAction:String in logicActionArr){
				logicActionsVect.push(new LogicAction(logicAction,propValDict));
			}

			
		}
		public function kill():void{
			for each(var v:LogicAction in logicActionsVect){
				v.kill();
			}
			logicActionsVect=null;
		}	
		
	}
}