package com.xperiment.behaviour
{
	import com.xperiment.Results.Results;
	
	
	public class behavNote extends behav_baseClass {
		
	
		private var exptResults:Results;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","note","");
			super.setVariables(list);
		}
		
		override public function nextStep(id:String=""):void {
			//add below add appropriate location
			var note:String=getVar("note");

			for each(var subNote:String in note.split(",")){
				if((subNote.split("=") as Array).length==2)storeVariable({name:subNote.split("=")[0],data:subNote.split("=")[1]});
			}
		}		

		
		public function storeVariable(obj:Object):void{
			if(!exptResults)exptResults = Results.getInstance();
			exptResults.storeVariable(obj);
			
		}
		
	}
}
	
