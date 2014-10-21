package com.xperiment.BehavLogicAction.common
{
	public class OneValueEquation implements IReturnEquation
	{
		public var _equation:*;
		public var _equationOrigStr:String;
		private var _equationNegated:Boolean;
		public var updateable:Boolean = false;
		
		public function get equation():*{

			return _equation;}
		
		public function set equation(value:*):void{_equation = value;}
		
		public function get equationNegated():Boolean{return _equationNegated;}
		public function set equationNegated(value:Boolean):void{_equationNegated = value;}
		
		public function get equationOrigStr():String{return _equationOrigStr;}
		public function set equationOrigStr(what:String):void{
			update(what,what);
			
			if(!((what.charAt(0)=="'" && what.charAt(what.length-1)=="'") || !isNaN(Number(what)))){ //only updateable if NOT a text string or a number
				updateable=true;	
			}
	
		}
		
		
		public function kill():void{
			_equation=null;
		}
		
		
		///PROB, being called Multiple times, once for 123 which should not happen
		//NOT a problem actually as this function is called when the equationOrigStr is set.
		public function update(what:String, toWhat:*):void{
			
			//trace("requested to update",what,"to",toWhat);
			
			
			if(what.charAt(0)=="!"){	
				_equationNegated=true;
				what=what.substr(1);
			}
			_equationOrigStr = what;
			
			
			if(_equationOrigStr.charAt(0)=="!"){
				_equationNegated=true;
				_equationOrigStr=_equationOrigStr.substr(1);
			}
			if(_equationOrigStr!="null" && toWhat!=undefined){
				//trace(23232,toWhat,what,23)
				//_equationOrigStr = what;	
				//trace(_equationOrigStr,what,toWhat,"should fire twice-----------")
				if		(!isNaN(Number(toWhat)))			_equation= Number(toWhat);
				else if	(toWhat.charAt(0)=="'" && toWhat.charAt(toWhat.length-1)=="'")		_equation= toWhat; //remove the single quotation marks
				else if (toWhat.toLowerCase() == "true")	_equation= true;
				else if (toWhat.toLowerCase() == "false")	_equation= false;
					//else if(rawProp is String)	return rawProp;  //cannot do this as this variable == null is used elsewhere
				else _equation=null;
				//nb equationSide not set if value is a variable name. This fact is used to identify variables later on.
			}
		}
		
		

		
		public function requestUpdates(bind:Function):void{
			//if(equation == null) {
				
				bind(_equationOrigStr,update);
			//}
		}
		
		public function equationNow(orig:Boolean=true):*{
			if(orig){
				if(_equationNegated)return !_equationOrigStr;
				else 				return _equationOrigStr;
			}
			else{
				
				
				
				//trace(1212112112,_equationOrigStr,_equation);
				if(_equationNegated)return	!_equation;
				else				return 	 _equation;
				
				
			}
		}	
		
	}
}