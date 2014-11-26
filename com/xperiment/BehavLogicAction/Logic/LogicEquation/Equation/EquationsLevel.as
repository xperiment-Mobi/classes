package com.xperiment.BehavLogicAction.Logic.LogicEquation.Equation
{
	import com.xperiment.BehavLogicAction.PropValDict;
	import com.xperiment.BehavLogicAction.Logic.LogicOperator;
	
	//holds all logic at a given horizontal level (where bracketed bits of logic are sublevels which need to be evaluated first)
	/**
	 * @flowerModelElementId _9j-LkDfJEeKW7cM3ixcl0w
	 */
	public class EquationsLevel implements IEval
	{
		private const comparisions:Array=["==","!=",">","<",">=","<=","==="];
		private const operators:Array=["&&","||"];
		
		private var horizontalLogics:Array = [];
		private var logDict:PropValDict;
		
		
		//search through all of the logicExpressions and find variables. Update 2 Dictionaries:
			//always push an update function for the logicExpression into the updateFunctsDict dictionary, the key being the variable name.
			//check to see if the propDict has the variable already and if not, add. 
		//In this fashion, when the propDict is given a value for a give variable (propDict.variable="banana"), all of
		//the LogicExpressions that need updating with this value are done so by iterating through the array of function sat updateFunctsDict[variable]
		
		public function kill():void{
			
			for(var i:uint=0;i<horizontalLogics.length;i++){
				if(horizontalLogics[i].hasOwnProperty("kill")) horizontalLogics[i].kill();
				else horizontalLogics[i]=null;
			}
		}
			
		public function reconstruct(orig:Boolean):String{
			var logic:String = "";
			
			for(var i:uint=0;i<horizontalLogics.length;i++){
				if		(horizontalLogics[i] is Equation)			logic=logic+(horizontalLogics[i] as Equation).reconstruct(orig);
				else if	(horizontalLogics[i] is LogicOperator)		logic=logic+(horizontalLogics[i] as LogicOperator).operator;
				else if	(horizontalLogics[i] is EquationsLevel)		logic=logic+"("+(horizontalLogics[i] as EquationsLevel).reconstruct(orig)+")";
			}
			
			return logic;
		}
		
		public function eval():Boolean{
			var evalArr:Array=[];
			for(var i:uint=0;i<horizontalLogics.length;i++){
				if(horizontalLogics[i] is IEval)				evalArr.push((horizontalLogics[i] as IEval).eval());
				else if(horizontalLogics[i] is LogicOperator)	evalArr.push((horizontalLogics[i] as LogicOperator).operator);
			}


			return computeEvals(evalArr);
		}
		
		public function computeEvals(evalArr:Array):Boolean{
			var onGoingStat:Boolean=evalArr.shift() as Boolean;
			var nextStat:Boolean;
			var logic:String="";
			while(evalArr.length>0){
				if(evalArr[0] is String)logic=evalArr.shift() as String;
				else if(evalArr[0] is Boolean){
					nextStat=evalArr.shift() as Boolean;
					if(logic){
						if(logic=="&&"){
							onGoingStat=onGoingStat && nextStat; 
							logic="";
						}
						else if(logic=="||"){
							onGoingStat=onGoingStat || nextStat;
							logic="";
						}
					}
					else throw new Error("problem with logic statement")
				}
				
			}
			return onGoingStat;
		}

		
		private function passVarsToDictionary():void{
			var equation:Equation
			for(var i:uint=0;i<horizontalLogics.length;i++){
				
				if(horizontalLogics[i] is Equation){
					equation=horizontalLogics[i] as Equation;
					//uses UPDATE_DICTS function specified above
					equation.updateDicts(logDict.bind);
				}
			}
		}
		
		public function EquationsLevel(logic:String,myLogDict:PropValDict,logicOutcome:Function)
		{
			logDict=myLogDict;

			if(logic.split("(").length!=logic.split(")").length){
				throw Error("in logic ("+logic+") different number of left and- right brackets)");
			}
			
			
			var logicObj:Object;
			var logicStr:String;
			var currentEquation:Equation;
			var equationsLevel:EquationsLevel;
			var operator:String;
			
			var lowerLogicLevelPos:int;
			var lowerLogicLevel:String;
			
			var isMaths:Boolean=false;

			while(logic.length>0){
			
				if(logic.charAt(0)!="("){
					
					logicObj=findNextEquationStr(logic);
					if(!logicObj)break;

					logicStr=logic.substr(0,logicObj.position);

					operator=logicObj.operator
					
					//if on logic on same level
					//if(logicStr.indexOf("(")==-1){
						//parse the Equation String into a Equation and add to Array
						currentEquation=createLogicExpression(logicStr,logicOutcome);
						horizontalLogics.push(currentEquation);
						if(operator)horizontalLogics.push(new LogicOperator(operator));

						//problem if only single = (should be ==)
						logic=logic.substr(logicObj.position+2);

					/*}
					else if(true){
						trace("stuck here",logicStr);
					}
					else throw new Error("problem with this part of a logic statement: "+logicStr);*/
						
						
				}
				else  { //must be lower level as starts with ("(");
					lowerLogicLevelPos=extractLowerLevel(logic);
					equationsLevel = new EquationsLevel(logic.substr(1,lowerLogicLevelPos-1),logDict,logicOutcome);
					horizontalLogics.push(equationsLevel);
					logic=logic.substr(lowerLogicLevelPos+1);
				}
			}
			passVarsToDictionary();
		}	
		
	/*	Tests for extractLowerLevel
		
		var str:String="(((()))a)remainder";
		trace(test("(((()))a)remainder","(((()))a)","remainder"));
		try {extractLowerLevel("a(");}catch(e:Error){trace(true);}
		
		
		function test(str:String,result1:String,result2:String):Boolean{
			var res:Object=processLogic(str);
			return res.logicLevel==result1 && res.remainder==result2
		}
		
		function processLogic(logic:String):Object{
			var pos:int=extractLowerLevel(logic);
			return {logicLevel:str.substr(0,pos+1),remainder:str.substr(pos+1)};
		}*/
		
		//first character AWLAYS (
		private function extractLowerLevel(logicStr:String):int
		{
			var depth:int=1; //first character should always be (, thus start at +1;
			var char:String;
			
			char=logicStr.charAt(0);
			if(logicStr.charAt(0)!="("){
				throw new Error("Error in Logic: expecting ( but got another character("+char+", from this logic:"+logicStr+")");
			}
			
			
			for(var i:uint=1;i<logicStr.length;i++){
				char=logicStr.charAt(i);
				if		(char=="(")		depth++;
				else if	(char==")")		depth--;
				if(depth==0){break;} 
			}
			return i;
		}		
		
		//returns first logic chunk string
		private function findNextEquationStr(logic:String):Object{
			var pos:int=logic.length-1;
			var operat:String;
			
			//if finds an operator, return position and operator in an object
			for(var logic_i:int=0;logic_i<logic.length;logic_i++){
				for(var operat_i:int=0;operat_i<LogicOperator.operators.length;operat_i++){
					if(logic.charAt(logic_i)==LogicOperator.operators[operat_i].charAt(0)){
						return {position:logic_i,operator:LogicOperator.operators[operat_i]}
					}
				}
			}
			//else return null;
			return {position:logic_i,operator:LogicOperator.operators[operat_i]};
		}
		
		
		
		public function createLogicExpression(logic:String,logicOutcome:Function):Equation
		{

			var equation:Equation=new Equation(logicOutcome,logDict.propVal);
			var pos:int=logic.length-1;
			var tempPos:int;
			var comparison:String="";
			//search through comparisons Array (e.g. == < etc)
			//retrieves earliest position in string of comparator
			for(var i:uint=0;i<comparisions.length;i++){
				tempPos=logic.indexOf(comparisions[i]);
				if(tempPos<pos && tempPos!=-1){
					pos=tempPos;
					comparison=comparisions[i];
				}
			}
			if(comparison!="")	equation.passParameters(logic.substr(0,pos),comparison,logic.substr(pos+comparison.length));
			else{
								if(logic.split("=").length>1)throw new Error("error in your logic.  You can not use a single '=' in your logic.  You can only use: "+comparisions.join()+". In this logic: "+logic);
								equation.passParameters(logic,comparison,"");
			}
			
			return equation;
		}
	}
}