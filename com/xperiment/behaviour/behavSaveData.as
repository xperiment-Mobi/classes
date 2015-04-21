package com.xperiment.behaviour
{

	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.events.GlobalFunctionsEvent;

	public class behavSaveData extends behav_baseClass
	{
		
		override public function setVariables(list:XMLList):void {
			setVar("boolean","checkDataExists",true);
			setVar("string","closeMessage","");
			setVar("string","successMessage","");
			setVar("string","errMessage","");
			super.setVariables(list);
			
			
			var str:String = getVar("closeMessage")
			if(str.length>0) ExptWideSpecs.changeCloseMessage(str);
			
			str = getVar("successMessage");
			if(str.length>0) ExptWideSpecs.changeCloseMessage(str);
			
			str = getVar("errMessage");
			if(str.length>0) ExptWideSpecs.changeErreMessage(str);
	
		}	

		
		override public function nextStep(id:String=""):void
		{
			theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.SAVE_DATA));
			
			
			
			super.nextStep();
		}
	}
}