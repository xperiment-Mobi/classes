package unitTests
{
	import com.xperiment.BehavLogicAction.LogicActions;
	import com.xperiment.BehavLogicAction.PropValDict;
	import org.flexunit.Assert;
	
	
	
	public class test_logicActions
	{
	
		
		[Test( description="tests logicActions: core stuff" )]
		public function test1() : void
		{
			var test:Function = function():Boolean{
				var propValDict:PropValDict = new PropValDict();
				
				var testL:LogicActions = new LogicActions(propValDict);
				testL.passLogicAction(["A.onCli?B.start()","C.onCli?E.start()"]);
				
				
				var valueUpdates:Object = new Object;
				var noProb:Boolean=false;
				
				var events:Array=["A.onCli","C.onCli"];
				
				for(var i:int=0;i<events.length;i++){
					if(valueUpdates[events[i]]==undefined)valueUpdates[events[i]]=1;
					else valueUpdates[events[i]] = valueUpdates[events[i]]+1;
					
					//tests that the action auto increments each time it is called
					propValDict.incrementPerTrial(events[i],null);
					if(valueUpdates[events[i]]==valueUpdates[events[i]]) noProb=true;
					else return false;
				}	
				
				
				//tests that prev undefined event error erises with undefined event
				try{
					propValDict.incrementPerTrial("prev undefined event",null);
				}
				catch(e:Error){
					if(e.toString()!="Error: An action occured that was not specified in your script: prev undefined event")return false;
				}
				
				//tests that prev undefined action cannot be allowed to be assigned to nothing!
				try{
					propValDict.__bindAction("prev undefined event",function():void{});
				}
				catch(e:Error){
					if(e.toString()!="Error: A response action has been provided for an action that has been specified no where (must be a bug)")return false;
				}
				
				testL.kill();
				testL=null;
				propValDict.kill();
				
				return noProb;
			}
			
			Assert.assertTrue(test())
		}
		
			[Test( description="tests logicActions:Actions" )]
			public function test2() : void
			{
			
			var test2:Function = function(logics:Array,events:Array, actions:Array,listOfUpdates:Array,actCount:int):Boolean{
				
				var i:int;
				var propValDict:PropValDict = new PropValDict();
				
				var testL:LogicActions = new LogicActions(propValDict);
				testL.passLogicAction(logics);
				
				for(i=0;i<listOfUpdates.length;i++){
					propValDict.updateVal(listOfUpdates[i].what,listOfUpdates[i].to,null);
				}
				
				for(i=0;i<actions.length;i++){
					linkResultantActions(actions[i],propValDict.bind);
				}
				
				var actionCount:int=0;
				function linkResultantActions(action:String, bindProperty:Function):void
				{
					bindProperty(action,function():void{
						actionCount++
						//trace("running action   [", action, "]",actionCount);
					});
				}
				
	
				for(i=0;i<events.length;i++){

					propValDict.incrementPerTrial(events[i],null);
				}
				
				testL.kill();
				
				propValDict.kill();
				


				if(actionCount!=actCount){
					return false;
				}
				return true;
			}
			
	
			Assert.assertTrue(test2(["A.onCli?B.start()"],["A.onCli"],["B.start()"],[{}],1));			
			Assert.assertTrue(test2(["A.onCli?B.start()","C.onCli?E.start()","E.onCli?A.doNothing()"],["A.onCli","E.onCli"],["B.start()","E.start()"],[{}],1));
			
			
			Assert.assertTrue(test2(["A.onCli?B.start(),C.start()"],["A.onCli"],["B.start()","C.start()"],[{}],2)); //testing multple actions
			Assert.assertTrue(test2(["124==124&&A.onCli?B.start()"],["A.onCli"],["B.start()"],[{what:"a",to:124}],1)); //testing action + logic
			Assert.assertTrue(test2(["125==124&&A.onCli?B.start()"],["A.onCli"],["B.start()"],[],0)); //testing action + logic
			Assert.assertTrue(test2(["banana==124&&A.onCli?B.start()"],["A.onCli"],["B.start()"],[{what:"banana",to:"124"}],1)); //testing action + logic
			
			Assert.assertTrue(test2(["A.onCli==1?B.start()"],["A.onCli","A.onCli"],["B.start()"],[{}],1));
			Assert.assertTrue(test2(["A.onCli==2?B.start()"],["A.onCli","A.onCli"],["B.start()"],[{}],1));
			Assert.assertTrue(test2(["A.onCli==3?B.start()"],["A.onCli","A.onCli"],["B.start()"],[{}],1)==false);
			Assert.assertTrue(test2(["A.onCli==0?B.start()"],["A.onCli","A.onCli"],["B.start()"],[{}],1)==false);
			
			//passing objects
			Assert.assertTrue(test2(["A.onCli==0?B.start(A)"],["A.onCli","A.onCli"],["B.start()"],[{}],1)==false);
			
			
			}
			
			[Test( description="tests logicActions:Maths" )]
			public function test3() : void
			{
				
			var test3:Function = function(logics:Array,events:Array, actions:Array,listOfUpdates:Array,logicUpdates:Array):Boolean{
				var i:int;
				var propValDict:PropValDict = new PropValDict();
				
				var testL:LogicActions = new LogicActions(propValDict);
				testL.passLogicAction(logics);
				
				for(i=0;i<listOfUpdates.length;i++){
					propValDict.updateVal(listOfUpdates[i].what,listOfUpdates[i].to,null);
				}
				
				for(i=0;i<actions.length;i++){
					linkResultantActions(actions[i],propValDict.bind);
				}
				
				function linkResultantActions(action:String, bindProperty:Function):void
				{
					bindProperty(action,function():void{
						
						//trace("running action   [", action, "]");
					});
				}
				
				for(i=0;i<events.length;i++){
					propValDict.incrementPerTrial(events[i],null);
				}
				
				for(i=0;i<logicUpdates.length;i++){
					//trace(123,propValDict.propDict[logicUpdates[i].what],logicUpdates[i].to);
					if(propValDict.propDict[logicUpdates[i].what]!=logicUpdates[i].to) return false;
				}
				
				testL.kill();
				testL=null;
				propValDict.kill();
				
				return true;
			}
			
			Assert.assertTrue(test3(["A.onCli?B='banana'"],["A.onCli"],[],[{}],[{what:"B",to:"'banana'"}]));
			Assert.assertTrue(test3(["A.onCli?B=2+1"],["A.onCli"],[],[{}],[{what:"B",to:"3"}]));	
			Assert.assertTrue(test3(["A.onCli?B=2+1"],["A.onCli"],[],[{}],[{what:"B",to:"4"}])==false);
			Assert.assertTrue(test3(["A.onCli?B=2+1","A.onCli?C=2+sqrt(9)"],["A.onCli"],[],[{}],[{what:"B",to:"3"},{what:"C",to:"5"}]));

			Assert.assertTrue(test3(["A.onCli?B=2+1","A.onCli?B=B+2"],["A.onCli"],[],[{}],[{what:"B",to:"5"}]));	
			
		}
		
			[Test( description="tests logicActions:Maths" )]
			public function test4() : void
			{
				
				var test3:Function = function(logics:Array,events:Array, actions:Array,listOfUpdates:Array,logicUpdates:Array):Boolean{
					var i:int;
					var propValDict:PropValDict = new PropValDict();
					
					var testL:LogicActions = new LogicActions(propValDict);
					testL.passLogicAction(logics);
					
					for(i=0;i<listOfUpdates.length;i++){
						propValDict.updateVal(listOfUpdates[i].what,listOfUpdates[i].to,null);
					}
					
					for(i=0;i<actions.length;i++){
						linkResultantActions(actions[i],propValDict.bind);
					}
					
					function linkResultantActions(action:String, bindProperty:Function):void
					{
						bindProperty(action,function():void{
							
							//trace("running action   [", action, "]");
						});
					}
					
					for(i=0;i<events.length;i++){
						propValDict.incrementPerTrial(events[i],null);
					}
					
					for(i=0;i<logicUpdates.length;i++){
						if(propValDict.propDict[logicUpdates[i].what]!=logicUpdates[i].to) return false;
					}
					
					testL.kill();
					testL=null;
					propValDict.kill();
					return true;
				}
			
				Assert.assertTrue(test3(["A.onCli?B=2+1","A.onCli?B=B+2"],["A.onCli"],[],[{}],[{what:"B",to:"5"}]));	

			}
			
			[Test( description="tests logicActions:Actions, else" )]
			public function test5() : void
			{
				
				var test2:Function = function(logics:Array,events:Array, actions:Array,elseActions:Array, listOfUpdates:Array,actCount:int):Boolean{
					
					var i:int;
					var propValDict:PropValDict = new PropValDict();
					
					var testL:LogicActions = new LogicActions(propValDict);
					testL.passLogicAction(logics);
					
					for(i=0;i<listOfUpdates.length;i++){
						propValDict.updateVal(listOfUpdates[i].what,listOfUpdates[i].to,null);
					}
					
					for(i=0;i<actions.length;i++){
						linkResultantActions(actions[i],propValDict.bind);
					}
					
					for(i=0;i<elseActions.length;i++){
						linkResultantActions(elseActions[i],propValDict.bind);
					}
					
					
					var actionCount:int=0;
					function linkResultantActions(action:String, bindProperty:Function):void
					{
						bindProperty(action,function():void{
							actionCount++;
							elseActions.splice(actions.indexOf(action),1);
							//trace("running action   [", action, "]",actionCount);
						});
					}
					
					for(i=0;i<events.length;i++){
						
						propValDict.incrementPerTrial(events[i],null);
					}
					
					testL.kill();
					
					propValDict.kill();
					
					
					if(actionCount!=actCount)return false;
					if(elseActions.length!=0)return false;
					
					return true;
				}

				Assert.assertTrue(test2(["A.onCli==99?B.start():Else.start()"],["A.onCli"],["B.start()"],["Else.start()"],[{}],1));			
			}

	}
}