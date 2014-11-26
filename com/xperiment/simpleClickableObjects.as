package com.xperiment{

	import flash.display.*;
	import flash.events.*;

	class simpleClickableObjects extends Sprite {

		var myShape:Shape;

		function setupObject(width:uint,height:uint,colour:uint,lineThickness:uint,lineColour:Number,shape:String):Shape {

			myShape.graphics.beginFill(colour);
			myShape.graphics.lineStyle(lineThickness,lineColour);

			switch (shape) {
				case "rectangle" :
					myShape.graphics.drawRect(0,0,width,height);
					break;
				case "ellipse" :
					myShape.graphics.drawEllipse(0,0,width,height);
					break;
				case "circle" :
					myShape.graphics.drawCircle(0,0,width/2);
					break;
			}

			myShape.graphics.endFill();
			
			return myShape
		}
		

	}
}