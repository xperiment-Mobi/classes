package com.xperiment.behaviour.interfaces
{

	public interface IbehavGetVariable
	{

		function getStoredVariable(nam:String):String;
		
		
/*
		import com.xperiment.Results.Results;
		public var exptResults:Results;
		

		public function getStoredVariable(nam:String):String{
			if(!exptResults)exptResults = Results.getInstance();
			return exptResults.getStoredVariable(nam);
				
		}
		
		
		//use the below to replace variables with their value in strings (where variable is suffixed with $);
		if(question.indexOf("$")!=-1){
		if(!exptResults){
		exptResults = Results.getInstance();
		exptResults.replaceWithVariables(question);
		}
		}*/
		
		
	}
}