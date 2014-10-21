package unitTests
{
	import com.xperiment.BehavLogicAction.PropValDict;
	import com.xperiment.BehavLogicAction.Action.ActionFactory;
	import com.xperiment.BehavLogicAction.Action.IAction;
	import com.xperiment.BehavLogicAction.Action.ActionTypes.ActionMaths;
	import com.xperiment.BehavLogicAction.Action.ActionTypes.ActionSimpleMaths;
	
	import flexunit.framework.Assert;
	
	
	public class test_ActionMaths
	{
	
		
		[Test( description="tests ActionMaths" )]
		public function test3() : void
		{
			function test_actionMaths(action:String,propsToUpdate:Array,lhsExpected:*,expected:String,extra:Function=null):Boolean{
				var test:Boolean=true;
				var propVal:PropValDict = new PropValDict();
				var actionSimpleMaths:IAction = ActionFactory.Action(action, propVal);
				var updateProp:Object;
				for(var i:uint=0;i<propsToUpdate.length;i++){
					updateProp=propsToUpdate[i] as Object;
					propVal.updateVal(updateProp.what, updateProp.to,null);
				}
				if(actionSimpleMaths is ActionSimpleMaths){
					test = test && (actionSimpleMaths as ActionSimpleMaths).LHS.equationNow(false)==null;
					var f:Function=actionSimpleMaths.doAction();
					//trace(test,222)
					f();
					test = test && (actionSimpleMaths as ActionSimpleMaths).LHS.equationNow(false)== lhsExpected;
					test = test && (actionSimpleMaths as ActionSimpleMaths).equationNow(false)==expected;
					if(extra != null)test=test && extra(propVal,actionSimpleMaths);
				}
				else{
					test = test && (actionSimpleMaths as ActionMaths).LHS.equationNow(false)==null;
					f=actionSimpleMaths.doAction();
					f();
					test = test && (actionSimpleMaths as ActionMaths).LHS.equationNow(false)== lhsExpected;
					test = test && (actionSimpleMaths as ActionMaths).equationNow(false)==expected;
				
					
					if(extra != null)test=test && extra(propVal,actionSimpleMaths);
					
				}
				
				propVal.kill();
				return test;
			}
			
			var f:Function = function(propVal:PropValDict,actionSimpleMaths:ActionSimpleMaths):Boolean{
				propVal.updateVal("b","'banana'",null);
				if(actionSimpleMaths.equationNow(false)=="'banana'=2") return true;
				else return false;
			}
			

			Assert.assertTrue(test_actionMaths("b=2",[],2,"2=2",f));
			/*Assert.assertTrue(test_actionMaths("b=2+3",[],5,"5=2+3"));
			Assert.assertTrue(test_actionMaths("b=2+val",[{what:"val",to:3}],5,"5=2+3"));
			Assert.assertTrue(test_actionMaths("b=2+'val'",[{what:"val",to:3}],"'2val'","'2val'=2+'val'"));//note output here is v odd.  Making sure here that text in quotes can be incorporated.
			Assert.assertTrue(test_actionMaths("b='a '+2+'val '",[{what:"val",to:3}],"'a 2val '","'a 2val '='a '+2+'val '"));//testing multiple concatenations
			Assert.assertTrue(test_actionMaths("b=' b'+'a '+2+'val '",[{what:"val",to:3}],"' ba 2val '","' ba 2val '=' b'+'a '+2+'val '"));//testing multiple concatenations
	*/
		}
	
	

	}
}