package com.xperiment.Logic.components
{
	import flash.utils.getQualifiedClassName;
	import com.xperiment.Logic.components.IEval;
	
	public class LogicExpression implements IEval
	{
		private var _leftHandSide:*;
		private var _leftHandSideStr:String;
		private var _leftHandSideNegated:Boolean;
		private var _comparison:String;
		private var _rightHandSide:*;
		private var _rightHandSideStr:String;
		private var _rightHandSideNegated:Boolean;
		
		public function set rightHandSideNegated(value:Boolean):void{_rightHandSideNegated = value;}
		public function set leftHandSideNegated(value:Boolean):void{_leftHandSideNegated = value;}
		public function get leftHandSide():*{return _leftHandSide;}
		public function set leftHandSide(value:*):void{_leftHandSide = value;}
		public function get leftHandSideStr():String{return _leftHandSideStr;}
		public function set leftHandSideStr(value:String):void{
			
			if(value){
				if(value.charAt(0)=="!"){	
					_leftHandSideNegated=true;
					value=value.substr(1);
				}
				if(value!=null){
					_leftHandSideStr = value;
					_leftHandSide=setProperty(_leftHandSideStr);
				}
			}
		}
		
		public function leftHandSideNow(orig:Boolean=true):String{
			if(orig)return _leftHandSideStr;
			if(_leftHandSide)return _leftHandSide;
			else return 			_leftHandSideStr;
		}
		
		public function rightHandSideNow(orig:Boolean):String{
			if(orig)return _rightHandSideStr;
			if(_rightHandSide)return _rightHandSide;
			else return 			_rightHandSideStr;
		}
		
		public function get comparison():String{return _comparison;}
		public function set comparison(value:String):void{
			_comparison = value;
		}
		
		public function get rightHandSide():*{return _rightHandSide;}
		public function set rightHandSide(value:*):void{_rightHandSide = value;}
		
		public function get rightHandSideStr():String{return _rightHandSideStr;}
		public function set rightHandSideStr(value:String):void{
			if(value){
				if(value.charAt(0)=="!"){
					_rightHandSideNegated=true;
					value=value.substr(1);
				}
				if(value!="null"){
					_rightHandSideStr = value;
					_rightHandSide=setProperty(_rightHandSideStr);
				}
				
			}
		}
		
		public function update(what:String, to:*):void{
			if	(_leftHandSideStr==what)	_leftHandSide=to;
			if	(_rightHandSideStr==what)	_rightHandSide=to;//potentially both could be the same...
		}
		
		public function reconstruct(orig:Boolean=true):String{
			var leftNeg:String	= ""; if(_leftHandSideNegated)	leftNeg="!";
			var rightNeg:String	= ""; if(_rightHandSideNegated)	rightNeg="!";
			
			return leftNeg+leftHandSideNow(orig)+comparison+rightNeg+rightHandSideNow(orig);
		}
		
		private function setProperty(rawProp:String):*
		{
			if		(!isNaN(Number(rawProp)))				return Number(rawProp);
			else if	(rawProp.split("'").length==3)			return rawProp; //remove the single quotation marks
			else if (rawProp.toLowerCase() == "true")		return true;
			else if (rawProp.toLowerCase() == "false")		return false;
			//else if(rawProp is String)	return rawProp;  //cannot do this as this variable == null is used elsewhere
			else return null;
			//nb Prop not set if rawProp is a variable name. This fact is used to identify variables later on.
		}
		
		public function eval():Boolean{
			//trace(222,_leftHandSideStr,_rightHandSideStr)
			
			var lhs:*= _leftHandSide;
			var rhs:*= _rightHandSide;
			if(_leftHandSideNegated)lhs=!lhs; //only used to see if object exists / or object is boolean
			
			if( _rightHandSideNegated)rhs=!rhs; 
			
			if(_leftHandSide  && _rightHandSide){
				
			//test for sameness in Types
				if(getQualifiedClassName(lhs) != getQualifiedClassName(rhs)){
					//trace("you are comparing "+getQualifiedClassName(_leftHandSide)+"("+_leftHandSide+") with "+getQualifiedClassName(_rightHandSide)+"("+_rightHandSide+") which is not recommended, and indeed forced to return FALSE." )
					return false;
				}
			
				//trace("eval:",_leftHandSide || _rightHandSide);
				if		(_comparison=="==")		return 	lhs ==	rhs;
				else if	(_comparison=="!=")		return 	lhs	!= 	rhs;
				else if	(_comparison==">") 		return 	lhs	>	rhs;
				else if	(_comparison=="<")		return  lhs <	rhs;
				else if	(_comparison==">=")		return  lhs >=	rhs;
				else if	(_comparison=="<=")		return  lhs <=	rhs;
				else if	(_comparison=="===")	return  lhs ===	rhs;
			}

			
			else if(_leftHandSide && !_rightHandSideStr){
				
				return lhs;
			}
			
			else if(_leftHandSideStr && !_leftHandSide){
				if(_leftHandSideNegated)return true;
				else 					return false;
			}
						
			return false;
		}
		
	}
}