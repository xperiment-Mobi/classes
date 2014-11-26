package com.xperiment.BehavLogicAction.common
{
	import com.xperiment.parsers.CompiledObject;
	import com.xperiment.parsers.MathParser;
	

	public class SolveEquation implements IReturnEquation
	{
		///////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////	Static stuff
		public static var mathsCommands:Array = ["*","/","-","+","^","(",")"];
		
		static public function test(what:String,extra:Array):Boolean{
			for(var i:uint=0;i<mathsCommands.length;i++){
				if(what.indexOf(mathsCommands[i])!=-1) return true;
			}
			
			//note that a=2 fails as the simple version of this test does not detect for it. Hence, it is possible to pass
			//additional characters to test for
			if(extra){
				for(i=0;i<extra.length;i++){
					if(what.indexOf(extra[i])!=-1) return true;
				}
			}
			return false;
		}
		///////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		
		public function kill():void{
			var i:int;
			for(i=0;i<_equation.length;i++){
				_equation[i]=null;
				_equationOrigArr=null;
			}
			
			//if the below allowed, leads to erros in test_logic
			//_equation=null;
			//_equationOrigArr=null;
			
			for(var v:String in MathsVars){
				MathsVars[v]=null;
			}
			MathsVars=null;
			
			for(i=0;i<requestUpdatesArr.length;i++){
				requestUpdatesArr[i]=null;
			}
			requestUpdatesArr=null;
		}
		
		
		public var _equation:Array;
		private var _equationOrigArr:Array;
		private var MathsVars:Vector.<String>;
		public var requestUpdatesArr:Array = [];
		
		//private var _equationOrigStr:String;// not used.  

		
		public function get equation():*{
			
			var equation:String=_equation.join("");

			var eqTxtArr:Array= equation.split("'");
			
			if(eqTxtArr.length==1) return doMaths(equation);
			
			else if(eqTxtArr.length%2!=1) throw new Error("Combined Maths and Text statement broken: "+equation+" (uneven number of ' - should be formatted like this: 1+2' hello ' 4+5).");
			else{	
				
				equation=equation.split("+'").join("<-split->").split("'+").join("<-split->").split("'").join("");
				
				var arr:Array=equation.split("<-split->");
				var res:String="";
				for(var i:int=0;i<arr.length;i++){
					res+=String(doMaths(arr[i]));
				}
				return "'"+res+"'";	
			}
			return "";
		}
		
		private function doMaths(equation:String):*
		{
			
			var mpVal:MathParser = new MathParser([]);
			var compobjVal:CompiledObject =  mpVal.doCompile(equation);
			
			if (compobjVal.errorStatus == 1 || equation.indexOf(" ")!=-1){
				return equation;
			}

			
			var res:* = mpVal.doEval(compobjVal.PolishArray, []);

			mpVal=null;
			
			if(res.toString()=='NaN')	return equation;
			
			return 	res	
		}
		
		public function set equation(value:*):void{_equation = value;}
		
		public function get equationOrigStr():String{
			return _equationOrigArr.join("");
		}
		
		public function set equationOrigStr(what:String):void{
			if(what.indexOf("'")==-1 && what.indexOf("!")!=-1){	
				throw new Error("Not allowed '!' statements in purely mathematical equations. Here is the offending equation: "+what);
			}
			createEquaArr(what);
		}
		
		// below equationNegated included only for compatibility with IEquationSide
		// Note this class always returns false 
		public function get equationNegated():Boolean{return false;}
		public function set equationNegated(value:Boolean):void{}
		//
		
		
		public function update(what:String, toWhat:*):void{
			trace("need to set 'update' function in manyVarSide Class")
			//_equation[i]=to;
		}
		
		public function equationNow(orig:Boolean=true):*{
			//trace(1111,_equation);
			if(orig) 	return _equationOrigArr.join("");
			else 		return _equation.join("");
			
		}
		
		
		public function requestUpdates(updateDicts:Function):void{
			for each(var obj:Object in requestUpdatesArr){
				//trace(obj.what,34343);
				//AW STRANGE ISSUE
				updateDicts(obj.what,obj.funct as Function);
			}
		}
		
		public function createRequestUpdatesArr(prop:String,pos:uint):void{
			requestUpdatesArr.push({what:prop,funct:function(what:String, to:*):void{
				//trace(1112,what,to);
				_equation[pos]=to;
			} as Function})
		}
		
		//Must only be run once.
		private function createEquaArr(equat:String):void{	
			if(_equationOrigArr) throw new Error("Function createEquaArr(str) in ManyVarSide Class run more than once")
			_equationOrigArr=[];
			_equation=[];
			/*var mathTextArr:Array
			
			if(equat.indexOf("'")!=-1){
				equat=equat.replace("+'","<-split->").replace("'+","<-split->");
				var arr:Array=equat.split("<-split->")
				if(arr.length%2!=1)throw new Error ("Combined Maths and Text statement broken: "+equat+" (uneven number of ' - should be formatted like this: 1+2' hello ' 4+5).");
				mathTextArr=[];
				equat="";
				for(var i:int=0;i<arr.length;i++){
					if(i%2=0)equat+=arr[i];
					else{
						equat+="REPLACE"+String(i);
						mathTextArr["REPLACE"+String(i)]=arr[i];
					}			
				}	
			}*/
			
			var tempEqArr:Array=equat.split("");
			//var isLetter:RegExp = /[a-zA-Z']/
			var isLetter:RegExp = /[a-zA-Z]/  //note, removed single quotation mark March 2013
			
			var rollingStr:String=equat.charAt(0); 
			equat=equat.substr(1);
			var isMathCommand:Boolean;
			var prevIsMathCommand:Boolean=mathsCommands.indexOf(tempEqArr.shift())==-1;
			var pos:int=0;
			var inQuots:Boolean=false;
						
			while(tempEqArr.length>0){
				isMathCommand=mathsCommands.indexOf(tempEqArr[0])==-1;
				
				if(prevIsMathCommand!=isMathCommand){
					_equationOrigArr.push(rollingStr)
					_equation.push(rollingStr)
						

						
					if(prevIsMathCommand && rollingStr.length>0 && isLetter.test(rollingStr.charAt(0))){
						//trace(33434,rollingStr);
						createRequestUpdatesArr(rollingStr,_equation.length-1);
					}	
					rollingStr="";	
				}
				rollingStr+=tempEqArr.shift();
				prevIsMathCommand=isMathCommand;
			}
																
																
			if(rollingStr!=""){
				_equationOrigArr.push(rollingStr);
				_equation.push(rollingStr)
					//below makes sure that non numbers that are a text string do not request an update function
					//nb that only variables can request updates
				if(isMathCommand && !(rollingStr.substr(0,1)=="'" && rollingStr.substr(rollingStr.length-1)=="'")){

					createRequestUpdatesArr(rollingStr,_equation.length-1);
				}
			}
		}
		
		
		
	}
}