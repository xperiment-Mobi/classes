package com.xperiment.BehavLogicAction.Action
{
	import com.xperiment.BehavLogicAction.PropValDict;
	import com.xperiment.BehavLogicAction.Action.ActionTypes.ActionCommand;
	import com.xperiment.BehavLogicAction.Action.ActionTypes.ActionMaths;
	import com.xperiment.BehavLogicAction.Action.ActionTypes.ActionSimpleMaths;
	import com.xperiment.BehavLogicAction.common.SolveEquation;
	

	public class ActionFactory
	{
		
		public static var __encasingBrackets:RegExp = /\(.*\)/
		public static var __isCommand:RegExp = /\..*\(*\)/		
		
		
		public static function Action(action:String,propValDict:PropValDict):IAction
		{
								//includes the equals sign
	//trace(action)
		
			if(__isCommand.test(action) == true){
				var bracketContents:Array = __encasingBrackets.exec(action);
		
				//removed 25.10.2013 as it killed this if="this.doNow?this.text='('+VAR1+')'"
				//action=action.replace(bracketContents,"()");
			}

			if(action.indexOf("=")!=-1 == true){ //if has mathematical notation..
				//trace(action,11)
				var bothSides:Array=action.split("=");
				var lhs:String=bothSides[0];
				
				var rhs:String=replaceExptWideWithVals(bothSides[1],propValDict);

				action=lhs+"="+rhs;
				
				if(SolveEquation.test(action,[])==false) 	return new ActionSimpleMaths(action,propValDict.bind,propValDict.updateVal,propValDict.propVal);
				
				else 										return new ActionMaths(action,propValDict.bind,propValDict.updateVal,propValDict.propVal);	
				
			}
			
			else if(bracketContents){

				var contents:String = bracketContents[0];
				contents = contents.substr(1,contents.length-2);

				return new ActionCommand(action.replace(contents,''),propValDict.addCommand,propValDict.incrementPerTrial,contents.split(","));
			}
			
			
			else throw new Error("Wrongly formatted action:"+action);
			
			return null;
		}	
		

		private static function replaceExptWideWithVals(RHS:String,propValDict:PropValDict):String
		{
			var pos:int;
			var val:*;
			for (var prop:String in PropValDict.exptProps){
				
					if(prop!=''){
						val=PropValDict.exptProps[prop];
						RHS=RHS.split(prop).join(val);
					}
			}

			return RHS;
		}
	}
}