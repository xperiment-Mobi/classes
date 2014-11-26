package com.xperiment.BehavLogicAction.Logic.LogicEquation.Equation
{
	import com.xperiment.BehavLogicAction.common.SolveEquation;
	
	public class Equation implements IEval
	{
		public var left:IEquationSide;
		public var comparison:String;
		public var right:IEquationSide;
		private var logicOutcome:Function;
		private var getPropVal:Function;
		
		public function kill():void{
			left.kill();
			left=null;
			if(right){
				right.kill();
				right=null;
			}
			//logicOutcome=null;
			//getPropVal=null;
		}
		
		
		public function Equation(logicOutcome:Function,getPropVal:Function){
			this.logicOutcome=logicOutcome;
			this.getPropVal=getPropVal;
		}
	
		public function update(what:String, toWhat:*):void{
			left.update(what,toWhat);
			if(right)right.update(what,toWhat);//potentially both could be the same...
		}
		
		public function reconstruct(orig:Boolean=true):String{			
			return left.equationNow(orig)+comparison+right.equationNow(orig);
		}

		
		public function eval():Boolean{

			/////////////////////////////
			//note that the below AND update is called upon start.  
			//Duplication of effort, but propably worth not fixing due to extra baggage of logic needed to fix this.
			left.updateNow();
			if(right)right.updateNow();
			
			/////////////////////////////
			
			var lhs:*= left.equation;
			if(right)var rhs:*= right.equation;
			else{
				if(left.equationNegated)return !Boolean(lhs);
				else 					return  Boolean(lhs)
			}
			
			//trace(lhs,23232,rhs);
			//trace(111,left.equation, right.equation,lhs, comparison, rhs, typeof(lhs),typeof(rhs),lhs>rhs,getQualifiedClassName(lhs), getQualifiedClassName(rhs));
			//trace(left.equationNegated,right.equationNegated,333)
			if(left.equationNegated)lhs=!lhs; //only used to see if object exists / or object is boolean
			if(right.equationNegated)rhs=!rhs; 
			
			
			if(left.equation !=undefined  && right.equation !=undefined ){
				
				//trace(33,left.equationOrigStr,left.equation  && right.equation);
				
			//test for sameness in Types
				if(typeof(lhs) != typeof(rhs)){
					
					if(checkSpecial(lhs,rhs)){

						//trace(2222222,typeof(lhs),left.equationOrigStr,lhs, right.equationOrigStr,rhs,comparison)
					}
					//trace("you are comparing "+getQualifiedClassName(lhs)+"("+lhs+") with "+getQualifiedClassName(rhs)+"("+rhs+") which is not recommended, and indeed forced to return FALSE." )
					else return false;
				}
				//trace(12345,comparison);
				//trace(123,lhs,rhs)
			
				//trace("eval:",lhs ,comparison, rhs,lhs	!= 	rhs);
				if		(comparison=="==")		return 	lhs ==	rhs;
				else if	(comparison=="!=")		return 	lhs	!= 	rhs;
				else if	(comparison==">")		return 	lhs	>	rhs;
				else if	(comparison=="<")		return  lhs <	rhs;
				else if	(comparison==">=")		return  lhs >=	rhs;
				else if	(comparison=="<=")		return  lhs <=	rhs;
				else if	(comparison=="===")	return  lhs ===	rhs;
			}
			
			else if(left.equation && !right.equationOrigStr){
				return lhs;
			}
			
			else if(left.equationOrigStr && right.equation==null){
				if(left.equationNegated)return true;
				else 					return false;
			}	

			return false;
		}
		
		private function checkSpecial(lhs:*, rhs:*):Boolean
		{
			var obj:Object = {};
			obj[typeof(lhs)]=lhs;
			obj[typeof(rhs)]=rhs;
			if(obj.hasOwnProperty('string') && (obj.hasOwnProperty('number') || obj.hasOwnProperty('int') || obj.hasOwnProperty('uint'))){
				if(obj.string=="''") return true;
			}
			return false;
		}
		
		//untested!
		private function specialNumVsBlankCheck(lhs:*, rhs:*):int
		{
			var obj:Object = {};
			obj[typeof(lhs)]=lhs;
			obj[typeof(rhs)]=rhs;
			
			if(obj.hasOwnProperty('number') && obj.hasOwnProperty('string')){
				if(obj.string=="''")return 1;
			}
			return 0;
		}		
		
		public function updateDicts(updateDi:Function):void
		{
			for each(var side:String in ["left","right"]){
				if(this[side]!=null)this[side].requestUpdates(updateDi);
			}
		}
		
		//tests to see if the string is surrounded by single quotation marks
		private function isLogicStr(str:String):Boolean{
			
			return ("'" == str.charAt(0) && "'" == str.charAt(str.length-1));
		}

		
		public function passParameters(lhsStr:String, comparison:String, rhsStr:String):void
		{
			this.comparison=comparison;
			if(isLogicStr(lhsStr)==false && SolveEquation.test(lhsStr,null)) left = new ManyVarSide(logicOutcome,getPropVal);
			else left=new OneVarSide(logicOutcome,getPropVal);
			left.equationOrigStr=lhsStr;
			
			if(rhsStr!=""){
				if(isLogicStr(rhsStr)==false && SolveEquation.test(rhsStr,null)) right = new ManyVarSide(logicOutcome,getPropVal);
				else right=new OneVarSide(logicOutcome,getPropVal);
				right.equationOrigStr=rhsStr;
			}
		}
		
		//used only for testing purposes
		public function setupSides():void{
			left= new OneVarSide(logicOutcome,getPropVal);
			right=new OneVarSide(logicOutcome,getPropVal);
		}
	}
}