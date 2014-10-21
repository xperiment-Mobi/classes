package com.xperiment.BehavLogicAction.Action.ActionTypes
{
	import com.xperiment.BehavLogicAction.Action.IAction;
	import com.xperiment.BehavLogicAction.common.IReturnEquation;
	import com.xperiment.BehavLogicAction.common.OneValueEquation;
	import com.xperiment.BehavLogicAction.common.SolveEquation;
	
	public class ActionMaths implements IAction, IReturnEquation
	{
		public var LHS:OneValueEquation;
		public var RHS:SolveEquation
		private var _updateProperty:Function;
		private var action:String;
		
		public function ActionMaths(action:String,bindProperty:Function,updateProperty:Function,propVal:Function)
		{

			this.action=action;
			_updateProperty=updateProperty;
			
			var actArr:Array=action.split("=");
			if(actArr.length==2){
				LHS=new OneValueEquation;
				RHS=new SolveEquation;
				LHS.equationOrigStr=actArr[0];
				RHS.equationOrigStr=actArr[1]; 
				LHS.requestUpdates(bindProperty);
				RHS.requestUpdates(bindProperty);
				actArr=null;
			}
			else throw Error("an ActionMaths was passed a maths problem with more than one equals sign.");
		}
				
		public function doAction():Function{
			return function():void{
				_updateProperty(LHS.equationOrigStr,RHS.equation);
			};
		}
		
		public function equationNow(orig:Boolean=true):*{
			return LHS.equationNow(orig) + "="+ RHS.equationNow(orig);
		}	
	}
}


//after evaluated, pass evaluation to propValDict.updatePropEveryWhere(what,evaluatedTo)