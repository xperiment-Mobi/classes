package com.virtualMouse{

	import com.virtualMouse.VirtualMouse;
	import com.virtualMouse.VirtualMouseEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	
	public class Mouses extends Sprite {
		
		//private var tail:Shape = new Shape;
		private var theStage:Stage;
		public var vMouse:VirtualMouse
		
		public function Mouses(theStage:Stage):void{
			this.graphics.beginFill(0xFFFF00);
			this.graphics.drawCircle(0,0,8);
			vMouse = new VirtualMouse(theStage,400,400);
			vMouse.ignore(this);
			
			//drawTail(0,0);
			//	this.addChild(tail);
		}
		
		public function stopClick():void{
			vMouse.disableEvent("MouseEvent.CLICK");
		}
		
		public function startClick():void{
			vMouse.enableEvent("MouseEvent.CLICK");
		}
		
		
		
		public function updatePos(xPos:int,yPos:int,zPos:int,zBodyPos:int):void{
			vMouse.setLocation(x,y);
			this.x=xPos;
			this.y=yPos;
			if(zBodyPos-zPos>500)somethingClicked();
			
		}
		
		public function pressButton():void{
			vMouse.click();
		}
		
		private function somethingClicked():void{
			pressButton();
			this.dispatchEvent(new Event("clicked"));
		}
		
		public function updateTail(xPos:int,yPos:int):void{
			//	tail.graphics.clear();
			//	tail.graphics.lineStyle(5,0xFFFF00);
			//	tail.graphics.moveTo(0,0);
			//	tail.graphics.lineTo(xPos,yPos);
			//	tail.graphics.endFill();
		}
	}

}