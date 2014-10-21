package com.xperiment.BehavLogicAction.Logic.LogicEquation
{
	import com.xperiment.BehavLogicAction.Logic.LogicEquation.Equation.EquationsLevel;
	import com.xperiment.BehavLogicAction.PropValDict;

	public class TopLevelLogic
	{
		
		private var logDict:PropValDict;
		private var equationLevel:EquationsLevel;		

		public function kill():void{
			equationLevel.kill();
			//logDict.kill();
			//logDict=null;

		}
		
		public function TopLevelLogic(logic:String,logicOutcome:Function,propValDict:PropValDict=null)
		{
			//go through whole logics hierachy and get update functions
			logDict= propValDict;
			equationLevel= new EquationsLevel(logic,logDict,logicOutcome);
		}
		
		//only used for testing purposes
		public function assignProp(prop:String, val:*):void{
			logDict.updateVal(prop,val,null);
		}
		
		public function eval():Boolean{
			return equationLevel.eval();
		}
		
		//where set bool to true if you want the original
		public function reconstruct(orig:Boolean=true):String{
			return equationLevel.reconstruct(orig);
		}
		
		
		

	}
}