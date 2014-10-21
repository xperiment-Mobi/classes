package com.xperiment.behaviour.interfaces
{

	public interface IbehavSaveVariable
	{
		
		function addSetVars():void;
		function storeVariable(dat:String):void;
		
		
		/*	
		import com.xperiment.Results.Results;
		public var exptResults:Results;
		
		public function addSetVars():void{
			//	setVar("boolean","saveVariables",false); //add these to setVariables at top
			//	setVar("string","saveVariableID","");
			if(getVar("saveVariables") && getVar("saveVariableID")==""){
			if(getVar("startID")!="") setVar("string","saveVariableID",getVar("startID"));		
			else setVar("boolean","saveVariables",false);
			}
		}

		public function getStoredVariable(nam:String):String{
			if(!exptResults)exptResults = Results.getInstance();
			return exptResults.getStoredVariable(nam);
				
		}
		
		public function storeVariable(obj:Object):void{
			if(!exptResults)exptResults = Results.getInstance();
			exptResults.storeVariable(obj);
		}
		
		//add below add appropriate location
		storeVariable({name:getVar("saveVariableID"),data:ran});
		
		
		//use the below to replace variables with their value in strings (where variable is suffixed with $);
		if(question.indexOf("$")!=-1){
		if(!exptResults){
		exptResults = Results.getInstance();
		exptResults.replaceWithVariables(question);
		}
		}
		
		*/
	}
}