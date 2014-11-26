package com.graphics.pattern{
	import flash.display.Shape;


	public class Box {
		//if fillColour not defined, transparent
		//if thickness = 0, no line
		static public function myBox(obj:Object):Shape {
			var Sha:Shape = new Shape;
			var lineColour:uint;var fillColour:uint;var size:uint;var w:uint;var h:uint;var thickness:uint; var alpha:Number;
			
			if(obj && obj.lineColour)lineColour=obj.lineColour; 
			if(obj && obj.fillColour)fillColour=obj.fillColour;
			if(obj && obj.lineThickness)thickness=obj.lineThickness;
			if(obj && obj.width)w=obj.width; else w=10;
			if(obj && obj.height)h=obj.height; else h=10;
			if(obj && obj.alpha)alpha=obj.alpha; else h=1;
			
			if(thickness!=0)Sha.graphics.lineStyle(thickness, lineColour,alpha);
			if(fillColour)Sha.graphics.beginFill(fillColour);
			Sha.graphics.drawRect(0,0,w,h);
			if(fillColour)Sha.graphics.endFill();

			return Sha;
		}
	}
}