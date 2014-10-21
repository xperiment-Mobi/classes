package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;

	public class addSave extends object_baseClass
	{
		override public function setVariables(list:XMLList):void {
			
			//or figure out codes by pressing from here http://www.kirupa.com/developer/as3/using_keyboard_as3.htm
			setVar("boolean","disableMouse",false);
			super.setVariables(list);
			

		}
		
		private function 
		
		override public function RunMe():uberSprite {
	
			theStage.addEventListener("dataSaved",saved);
			
			return (pic);
		}
	}
}