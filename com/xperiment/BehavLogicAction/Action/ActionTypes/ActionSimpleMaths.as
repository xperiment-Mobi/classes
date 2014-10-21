package com.xperiment.BehavLogicAction.Action.ActionTypes
{
	import com.xperiment.BehavLogicAction.Action.IAction;
	import com.xperiment.BehavLogicAction.common.OneValueEquation;
	import com.xperiment.BehavLogicAction.common.IReturnEquation;

	public class ActionSimpleMaths  implements IAction, IReturnEquation
	{
		public var LHS:OneValueEquation;
		public var RHS:OneValueEquation;
		private var _updateProperty:Function;
		private var action:String;
		private var propVal:Function;
		
		
		public function ActionSimpleMaths(action:String,bind:Function,updateProperty:Function,propVal:Function)
		{
			
			this.action=action;
			this.propVal=propVal;
			//HERE: Need to split the equation by =, store LHS and calc RHS (but using updateDicts also on the LHS)
			_updateProperty=updateProperty;
			var actArr:Array=action.split("=");
			if(actArr.length==2){
				
				LHS=new OneValueEquation;
				RHS=new OneValueEquation;

				LHS.equationOrigStr=actArr[0];
				RHS.equationOrigStr=actArr[1]; //rhs formula removed here
			
				LHS.requestUpdates(bind);
				RHS.requestUpdates(bind);
				actArr=null;
			}
			else throw Error("an ActionSimpleMaths was passed a (simple!) maths problem with more than one equals sign");
			
		}
		
		public function doAction():Function{
			//trace("do action",action,LHS.equationOrigStr,RHS.equationNow(false),RHS);
			return function():void{
				
				//below, huge hack, entered Jan 2014
				RHS.equation=propVal(RHS._equationOrigStr);
				///
				
				_updateProperty(LHS.equationOrigStr,RHS.equationNow(false))
			};
		}
		
		public function equationNow(orig:Boolean=true):*{
			//trace(55,LHS.equationNow(orig) + "="+ RHS.equationNow(orig))
			return LHS.equationNow(orig) + "="+ RHS.equationNow(orig);
		}	
		

	}
}