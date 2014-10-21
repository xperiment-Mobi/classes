package com.xperiment.behaviour{
	
	import com.xperiment.uberSprite;
	import com.xperiment.events.GotoTrialEvent;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.Dictionary;

	public class behavGotoTrial extends behav_baseClass {

		override public function setVariables(list:XMLList):void {
			setVar("String","goto","");
			super.setVariables(list);
			
		}
		
		
		override public function myUniqueActions(action:String):Function{
			if(!uniqueActions){
				uniqueActions=new Dictionary;
				uniqueActions['goto']=function():void{nextStep(getVar("goto"));};	
			}
			if(uniqueActions.hasOwnProperty(action)) return uniqueActions[action]
			
			return null;
		}


		override public function nextStep(id:String=""):void{
			if(id!="") parentPic.dispatchEvent(new GotoTrialEvent(GotoTrialEvent.TRIAL_PING_FROM_OBJECT,id));
			else parentPic.dispatchEvent(new GotoTrialEvent(GotoTrialEvent.TRIAL_PING_FROM_OBJECT,getVar("goto")));

			
		}
		
		
		override public function givenObjects(obj:uberSprite):void{	
			var str:String=(obj as object_baseClass).getVar(this.getVar("var"));
			if(str!="")setVar("String","goto",str);
			
			super.givenObjects(obj);
		}
		


		override public function kill():void {

			super.kill();
		}
	}
}