package com.xperiment.behaviour{
	import com.xperiment.StringStuff.StringLogic;

	import com.xperiment.Results.Results;
	import com.xperiment.behaviour.interfaces.IbehavGetVariable;
	

	import flash.events.Event;


	public class behavLogic extends behavIf implements IbehavGetVariable {
		private var exptResults:Results;
		private var logicArray:Array;
	
		override public function setVariables(list:XMLList):void {
			//action1
			//action2
			//...
			//logic1
			//logic2
			//...
			super.setVariables(list);
			sortoutLogicSteps();
		}
		
		private function sortoutLogicSteps():void
		{
			var doContinue:Boolean=true;
			var i:uint=1;
			var currentLog:String;
			var currentaction:String;
			var obj:Object;
			
			while(doContinue){
				currentLog=getVar("logic"+String(i));
				currentaction=getVar("action"+String(i));
				if(currentLog=="" && currentaction==""){doContinue=false;break;}
				obj=new Object;
				if(i==1){
					logicArray=new Array;
					obj.logic=currentLog;
					obj.action=currentaction;
				}
				if(currentLog=="")obj.logic=logicArray[logicArray.length-1].logic; //if does not exist here, use the one that existed previously
				else obj.logic=currentLog
				if(currentaction=="")obj.action=logicArray[logicArray.length-1].action;
				else obj.action=currentaction;
				logicArray.push(obj);
				i++;
			}
			
		}		
		
		
		override public function nextStep(id:String=""):void{

			//AW JAN FIX
			pic.dispatchEvent(new Event("doBefore"));
			//if(logicArray.length==0 && getVar("behaviours").length!=0)manageBehaviours.doEvents(this,(getVar("behaviours") as String).split("=")[1],getVar("behaviours"));
			
			for (var i:uint=0;i<logicArray.length;i++){
				
				var question:String=logicArray[i].logic;
				var behaviour:String=logicArray[i].behaviours;
				var r:RegExp=/([A-Z]\s?)+/
		//trace("L1");
				if(r.test(question)){// check to see if there is a stored variable (which is all caps)
					//trace("L2");
					if(!exptResults)exptResults = Results.getInstance();
					
					exptResults.storeVariable({name:"dat",data:"a"});

					question=exptResults.replaceWithVariables(question);
					//trace(question,22);
					if(question.indexOf("!!!")!=-1){
						//trace("L3");
						if(logger){
							logger.stageErrorMessage("!!Could not evaluate behavLogic as not all the variables requested are available:"+question);
							logger.log("!!Could not evaluate behavLogic as not all the variables requested are available:"+question);}
					}
					else if(StringLogic.myStringLogic(exptResults.convertStringValsToNums(question))){ //converts the question into numbers first as stringLogic cannot deal with words
						//trace("L4");
						if(logger)logger.log(getVar("logic")+" evaluated true so behaviour ran ("+question+")");
						//trace("L5");
						
						//AW JAN FIX
						pic.dispatchEvent(new Event("doAfter"));
						//manageBehaviours.doEvents(this, logicArray[i].action as String,"onFinish");
						break;
					}
					else if(logger)logger.log(getVar("logic")+" evaluated false so behaviour not run ("+question+")");	
				}
			}
		}
	}
}