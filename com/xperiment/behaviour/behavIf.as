package com.xperiment.behaviour{
	import com.xperiment.StringStuff.StringLogic;
	import com.xperiment.uberSprite;
	import com.xperiment.Results.Results;
	import com.xperiment.behaviour.interfaces.IbehavGetVariable;
	import com.xperiment.behaviour.interfaces.IbehavSaveVariable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class behavIf extends behav_baseClass implements IbehavSaveVariable, IbehavGetVariable {
		private var exptResults:Results;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","what","");
			setVar("boolean","saveVariables",true);
			setVar("string","saveVariableID","");
			super.setVariables(list);
			
			addSetVars();
			
		}
		
		public function addSetVars():void{
			//	setVar("boolean","saveVariables",false); //add these to setVariables at top
			//	setVar("string","saveVariableID","");
			if(getVar("saveVariables") && getVar("saveVariableID")==""){
				if(getVar("peg")!="") setVar("string","saveVariableID",getVar("peg"));		
				else setVar("boolean","saveVariables",false);
			}
		}

		public function getStoredVariable(nam:String):String{
			if(!exptResults)exptResults = Results.getInstance();
			return exptResults.getStoredVariable(nam);
		}
		
		public function storeVariable(dat:String):void{

			if(!exptResults)exptResults = Results.getInstance();
			if(getVar("saveVariables")){
				var savNam:String="";
				if(getVar("saveVariableID")!="")savNam=getVar("saveVariableID");
				else if(getVar("peg")!="")savNam=getVar("peg");
				
				
				if(savNam!="")exptResults.storeVariable({name:savNam,data:dat});
				else logger.log("!Could not save outcome of decision in BehavIf as you have not provided a saveVariableID and there is no peg to use.  BTW data="+dat);
			}
		}
		
		override public function nextStep(id:String=""):void{
			var question:String=getVar("what");
			
			if(question.indexOf("$")!=-1){// replace variables with their values
			if(!exptResults)exptResults = Results.getInstance();	
		
			question=exptResults.replaceWithVariables(question);
			if(StringLogic.myStringLogic(question)){ 
				if(logger)logger.log(getVar("logic")+" evaluated true so behaviour ran ("+question+")");
				nextStep();
			}
			else if(logger)logger.log(getVar("logic")+" evaluated false so behaviour not run ("+question+")");				
			}
					
			for each(var what:String in question.split(",")){
				if (id==what){
					if(getVar("result")!=""){
						sortResults();
						//AW JAN FIX
						pic.dispatchEvent(new Event("doAfter"));
						//manageBehaviours.doEvents(this,(getVar("behaviours") as String).split("=")[1],"onFinished");
					}
				}
			}		
		}
		
		public function sortResults():void
		{
			var tempData:Array = new Array;
			var result:String=getVar("result");
			if(result.indexOf(":")!=-1){
				tempData.event=result.split(":")[0];
				tempData.data=result.split(":")[1];		
			}
			else {
				tempData.event="result";
				tempData.data=result;
			}						
			storeVariable(tempData.data);
			objectData.push(tempData);
		}
		
		override public function returnsDataQuery():Boolean {
			var res:Boolean=super.returnsDataQuery();
			if(getVar("result")) return true;
			else if(res) return true;
			else return false;
		}
	}
}