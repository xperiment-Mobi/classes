package com.xperiment.behaviour
{

	import com.xperiment.events.TrialEvent;
	
	public class behavTrial extends behav_baseClass
	{
		override public function setVariables(list:XMLList):void {
			setVar("string","disable",'','comma seperated trial names');
			setVar("string","enable",'','comma seperated trial names');
			super.setVariables(list);
		}
		

		
		override public function nextStep(id:String=""):void{	
			
			
			
			dispatch(getVar('enable'), TrialEvent.ENABLE);
			dispatch(getVar('disable'), TrialEvent.DISABLE);

		}
		
		private function dispatch(trialsStr:String,command:String):void{
			var e:TrialEvent 
			if(trialsStr.length > 0){
				
				e = new TrialEvent(TrialEvent.CHANGE, command); 
				e.trials=trialsStr.split(",");
				theStage.dispatchEvent(e);
			}
		}
		
		
	}
}