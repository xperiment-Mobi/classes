package com.xperiment.behaviour{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.events.GotoTrialEvent;
	import com.xperiment.stimuli.Imockable;

	public class behavNextTrial extends behav_baseClass implements Imockable {

		override public function setVariables(list:XMLList):void {
			//setVar("int","lineThickness",2); cannot have this as it kills other behaviours as it extends the size of the sprite (see behavdragtoshiftingarea);
			setVar("int","delay",50,'','millisecond delay before moving onto the next trial. Be aware that having no delay may lead to any data being collected on the point of moving to the next trial not being recorded.');
			
			super.setVariables(list);
		}
		
		override public function nextStep(id:String=""):void {
			if(parentPic){
				parentPic.dispatchEvent(new GotoTrialEvent(GotoTrialEvent.TRIAL_PING_FROM_OBJECT,GotoTrialEvent.NEXT_TRIAL));
			}	
		}
			
		public function mock():void{	
			codeRecycleFunctions.delay(nextStep,200);	
		}
		
	}

}