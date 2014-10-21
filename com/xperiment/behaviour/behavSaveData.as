package com.xperiment.behaviour
{

	import com.xperiment.events.GlobalFunctionsEvent;

	public class behavSaveData extends behav_baseClass
	{
		
		override public function setVariables(list:XMLList):void {
			setVar("boolean","checkDataExists",true)
			super.setVariables(list);
		}	

		
		override public function nextStep(id:String=""):void
		{
			theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.SAVE_DATA));
			super.nextStep();
		}
	}
}