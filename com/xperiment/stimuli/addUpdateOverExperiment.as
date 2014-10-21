package  com.xperiment.stimuli{

	import flash.display.*;
	import com.xperiment.uberSprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;



	public class addUpdateOverExperiment extends object_baseClass {

		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList) {
			setVar("string","update","");
			super.setVariables(list);

		}


		override public function RunMe():uberSprite {
			super.pic.addEventListener(Event.ADDED_TO_STAGE, blankAddedToStage);
			return (pic);
		}

		private function blankAddedToStage(event) {
			super.overEntireExperiment.updateSomethingNOW(getVar("update"));
			super.pic.removeEventListener(Event.REMOVED_FROM_STAGE, blankAddedToStage);
		}

	}
}