
package  com.xperiment.stimuli{

	import flash.events.Event;



	public class addNextTrial extends object_baseClass {


		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList):void {
			super.setVariables(list);
			pic.addEventListener(Event.ADDED_TO_STAGE,added);

		}


		public function added(e:Event):void{
			e.target.removeEventListener(Event.ADDED_TO_STAGE,added);
			dispatchEvent(new Event("nextTrial",true));
		}


	}
}