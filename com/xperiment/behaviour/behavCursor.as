package com.xperiment.behaviour{
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	
	public class behavCursor extends behav_baseClass {
		
	/*	private var _currentCursor:CustomCursor; 
		private var _rotationCursor:CustomCursor;
		private var _moveCursor:CustomCursor;*/
		
		override public function kill():void{
			Mouse.cursor=MouseCursor.AUTO;
			
			super.kill();
		}
		
		override public function setVariables(list:XMLList):void {
			
			setVar("string","shape",MouseCursor.HAND,"values include: "+MouseCursor.ARROW+" "+MouseCursor.BUTTON+" "+MouseCursor.HAND+" "+MouseCursor.IBEAM+" "+MouseCursor.AUTO +"(default value)");
			super.setVariables(list);
			
			if([MouseCursor.ARROW,MouseCursor.BUTTON,MouseCursor.HAND,MouseCursor.IBEAM].indexOf(getVar("shape"))==-1)throw new Error()
			
		}	
		
		override public function nextStep(id:String=""):void{
			
			changeCursor();
			
		}
		
		private function changeCursor():void
		{
			Mouse.cursor=getVar("shape");
			
		}
		
	}
}

/*import flash.display.Shape;

internal class CustomCursor {
	public var shape:Shape;
	public var hideMouse:Boolean;
	public var xOffset:Number;
	public var yOffset:Number;
	public var autoRotate:Boolean;
	
	public function CustomCursor(shape:Shape, hideMouse:Boolean, xOffset:Number, yOffset:Number, autoRotate:Boolean) {
		this.shape = shape;
		this.hideMouse = hideMouse;
		this.xOffset = xOffset;
		this.yOffset = yOffset;
		this.autoRotate = autoRotate;
	}
	
}*/
