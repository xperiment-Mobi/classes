package com.xperiment.behaviour
{
	import com.xperiment.events.GlobalFunctionsEvent;

	public class behavTrialOrder extends behav_baseClass
	{
		override public function setVariables(list:XMLList):void {
			setVar("string","blockDepthOrder",'',"sets variable with the same name in SETUP, under Trials. You can also specify trial orderings as a node value");
			setVar("string","which","0","the default trial ordering to use (specified as a node value only, seperated by new lines) ")
			super.setVariables(list);
		}
		
		override public function nextStep(id:String=""):void{
			var lines:Array = xmlVal.split("/n");

			var which:int = int(getVar("which"));

			if(lines.length<which){
				var message:String = 'Problem with the trialOrder you asked to change. There are '+lines.length+' different order(s) specified but you asked for order '+which+' which is not present';
				theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.PROBLEM,message));
			}
			theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.CHANGE_TRIALORDER,[{param:'trials.blockDepthOrder',val:lines[which]}]));
		}
	}
}