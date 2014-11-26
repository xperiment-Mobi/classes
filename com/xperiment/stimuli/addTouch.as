package  com.xperiment.stimuli{

	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.text.TextFormat;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addButton;

	public class addTouch extends addButton {

		override public function setVariables(list:XMLList):void {
			setVar("boolean","emphasized",true);
			setVar("boolean","showWhere",true);
			super.setVariables(list);
		}
		
		override public function RunMe():uberSprite {
			super.pic.addEventListener(MouseEvent.CLICK,MouseDown);
			
			if (getVar("showWhere")){
				var myShape:Shape = new Shape;
				myShape.graphics.beginFill(0x0000FF);
				myShape.graphics.drawRect(0,0,getVar("width"),getVar("height"));
				myShape.alpha=.5;
				pic.addChild(myShape);
				};
			
			super.setUniversalVariables();
			return (pic);
		}
		
		override public function kill():void{
			super.pic.removeEventListener(MouseEvent.CLICK,MouseDown);
			//logger.log("addTouch.kill(): dead"); 
			super.kill();
		}
	}
}