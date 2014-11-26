package com.xperiment.BehavLogicAction.Logic.LogicEquation.Equation
{
	import com.xperiment.BehavLogicAction.common.SolveEquation;


	/**
	 * @flowerModelElementId _9kOqQDfJEeKW7cM3ixcl0w
	 */
	public class ManyVarSide extends SolveEquation implements IEquationSide
	{		
		private var logicOutcome:Function = function():void{};
		private var getPropVal:Function;
		
		public function ManyVarSide(bubble:Function,getPropVal:Function){
			this.logicOutcome=logicOutcome;
			this.getPropVal=getPropVal;
		}
		
		override public function createRequestUpdatesArr(prop:String,pos:uint):void{
			requestUpdatesArr.push({what:prop,funct:function(what:String, to:*):void{
				_equation[pos]=to;
				if(logicOutcome!=null && what != to) logicOutcome();
			} as Function})
		}
		
		public function updateNow():void{
			if(getPropVal){
				for each(var obj:Object in requestUpdatesArr){
					obj.funct(obj.what, getPropVal(obj.what))
				}
			}
			//throw new Error("ability to update 'on the fly' not implemented yet");
		}
		
	}
}