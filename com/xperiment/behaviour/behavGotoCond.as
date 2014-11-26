package com.xperiment.behaviour{
	
	import com.xperiment.uberSprite;
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.stimuli.object_baseClass;


	public class behavGotoCond extends behav_baseClass {

		override public function setVariables(list:XMLList):void {
			setVar("String","goto","");
			super.setVariables(list);
			
		}
		
	

		override public function nextStep(id:String=""):void{

			if(theStage){
				theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.GOTO_COND,getVar("goto")));
			}
			
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