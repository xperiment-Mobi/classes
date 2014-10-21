package com.xperiment.BehavLogicAction.Logic.LogicEquation.Equation
{
	import com.xperiment.BehavLogicAction.common.OneValueEquation;

	internal class OneVarSide extends OneValueEquation implements IEquationSide
	{
		private var logicOutcome:Function = function():void{};
		private var getPropVal:Function;
		
		
		public function OneVarSide(logicOutcome:Function,getPropVal:Function){
			
			
			this.logicOutcome=logicOutcome;
			this.getPropVal=getPropVal;
		}
		
		
		///PROB, being called Multiple times, once for 123 which should not happen
		//NOT a problem actually as this function is called when the equationOrigStr is set.
		override public function update(what:String, toWhat:*):void{
			//trace(34,what,toWhat)
			super.update(what,toWhat);
			if(what!=toWhat)logicOutcome();
			
		}
		
		
		public function updateNow():void{

			if(getPropVal && updateable){
				super.update(_equationOrigStr,getPropVal(_equationOrigStr));
			}
		}
	}
}