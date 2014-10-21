package com.xperiment.behaviour
{
	import com.xperiment.behaviour.components.Drawing;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class behavDraw extends behav_stim_hybrid
	{
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		
		private var mouseChildrenInitialVal:Boolean;
		private var drawing:Drawing;
	
		
		override public function kill():void{
			listener(theStage, Event.ENTER_FRAME,addDotL,false);
			listener(theStage, MouseEvent.MOUSE_DOWN,mouseDownL,false);
			listener(theStage, MouseEvent.MOUSE_UP,mouseDownL,false);
		}
		
		override public function setVariables(list:XMLList):void {
			setVar("string","colour",0x0000FF);
			

			super.setVariables(list);
		}
		
		
		override public function nextStep(id:String=""):void{

			if(behavObjects.length>1)throw new Error("Error in behavDraw. Only allowed to draw on one other object but you gave more: "+getVar("usePegs")+".");
			
			drawing = new Drawing(pic);
			
			listener(theStage, MouseEvent.MOUSE_DOWN,mouseDownL,true);
			
			mouseChildrenInitialVal=behavObjects[0].mouseChildren;
			behavObjects[0].mouseChildren=false;;
			
		}
		
		private function listener(what:DisplayObject,listen:String, funct:Function,ON:Boolean):void{
			var has:Boolean = what.hasEventListener(listen);
			if(ON)what.addEventListener(listen,funct);
			if(!ON && has)what.removeEventListener(listen,funct);
		}
		
	

	
		private function mouseDownL(e:MouseEvent):void{
			behavObjects[0].mouseChildren=false;
			listener(theStage, MouseEvent.MOUSE_DOWN,mouseDownL,false);
			listener(theStage, MouseEvent.MOUSE_UP,mouseUpL,true);
			listener(theStage, Event.ENTER_FRAME,addDotL,true);
				
		}
		
		private function mouseUpL(e:MouseEvent):void{
			behavObjects[0].mouseChildren=mouseChildrenInitialVal;
			listener(theStage, MouseEvent.MOUSE_DOWN,mouseDownL,true);
			listener(theStage, MouseEvent.MOUSE_UP,mouseUpL,false);
			listener(theStage, Event.ENTER_FRAME,addDotL,false);
			
			drawing.stop();
		}
		
		protected function addDotL(e:Event):void
		{
			drawing.addDot(new Point(mouseX,mouseY));

		}
		
		
	}
}