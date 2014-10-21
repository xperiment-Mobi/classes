package com.xperiment.BehavLogicAction
{
	import com.xperiment.BehavLogicAction.Action.Actions;
	import com.xperiment.BehavLogicAction.Logic.LogicEquation.TopLevelLogic;

	public class LogicAction
	{
		public var logic:TopLevelLogic;
		public var actions:Actions;
		public var elseActions:Actions;
		
		private var illegalBrackets:RegExp;

		
		//input: banana+123>3?doStuff:elseDoSuff
		
		public function LogicAction(logicAction:String,propValDict:PropValDict)
		{

			var actionsArr:Array;
			var logicActionArr:Array=logicAction.split("?");
			var logicToTest:String;

			if(logicActionArr.length>1){
				
				logicToTest=logicActionArr.shift();
				
				if(__legalBrackets(logicToTest)==false)throw new Error('You cannot use () in a logic statement ['+logicAction+"]. Events/Actions are just eg me.click [NOT me.click()]");
				
				logic=	new	 TopLevelLogic(logicToTest,logicOutcome,propValDict);
				
				actionsArr=logicActionArr.join().split(":");
				
				actions=	new	 Actions(actionsArr.shift(),propValDict);
				//trace("actions done...");
				
				if(actionsArr.length>0){
					
					elseActionsF(actionsArr[0],propValDict);
					//trace("else actions done...");
				}
									
			}
			else throw Error("improperly formatted behaviourLogic: "+logicAction);
		}
		
		private function elseActionsF(elifStr:String, propValDict:PropValDict):void
		{
			//trace(1111,elifStr)
			if(elifStr.indexOf("?")!=-1){
				//trace(123)
				throw new Error('not developed yet (having further if stagements)')
			}
			else elseActions=	new	 Actions(elifStr,propValDict);
		}		

		
		//unit testing here svp
/*		trace(__legalBrackets("")==true);
		trace(__legalBrackets("()")==false);
		trace(__legalBrackets("'()")==true);
		trace(__legalBrackets("'()'")==true);
		trace(__legalBrackets("'bla'()")==false);
		trace(__legalBrackets("'bla''()'gdfgdfgdgfgdg''gfgffg'()'")==true);
		trace(__legalBrackets("'bla''()'gdfgdfgdgfgdg''gfgffg'()'()")==false);*/
		
		public function __legalBrackets(str:String):Boolean{
			var arr:Array = str.split("'");
			if(arr.length==1){
				if(str.indexOf("()")!=-1)return false;
				else return true;
			}
			else{
				if(arr[0].indexOf("()")!=-1)return false;
				
				for(var i:int=1;i<arr.length;i++){
					if(i%2 ==0 && arr[i].indexOf("()")!=-1){
						return false;
					}
				}
			}	
			return true;
		}
		

		
		public function logicOutcome():void{			
			if(logic && logic.eval()){
				actions.run();
			}
			else if(elseActions){
				elseActions.run();
			}
		}
		
		public function kill():void{
			
			if(actions){
				for each(var a:Actions in actions){
					a.kill();
				}
			}
			actions=null;
			if(elseActions){
				for each(a in elseActions){
					a.kill();
				}
			}
			elseActions=null;
			
			logic.kill();
			
		}
	}
}