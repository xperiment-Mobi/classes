package com.graphics.pattern{
	import flash.display.Shape;


	public class Target {
		//if fillColour not defined, transparent
		//if thickness = 0, no line
		static public function myTarget(obj:Object):Shape {
			var Sha:Shape = new Shape;
			var lineColourCross:uint;var lineColourCircle:uint;var fillColour:uint;var radius:uint;var lineCrossThickness:uint;var lineCircleThickness:uint;

			if(obj && obj.lineColourCross)lineColourCross=obj.lineColourCross; else lineColourCross=0x23c3f7;
			if(obj && obj.lineColourCircle)lineColourCircle=obj.lineColourCircle; else lineColourCircle=0x23c7f1;
			if(obj && obj.fillColour)fillColour=obj.fillColour;
			if(obj && obj.lineCrossThickness)lineCrossThickness=obj.lineCrossThickness; else lineCrossThickness=1;
			if(obj && obj.lineCircleThickness)lineCircleThickness=obj.lineCircleThickness; else lineCircleThickness=2;
			if(obj && obj.radius)radius=obj.radius; else radius=7;
			
			//circle
			Sha.graphics.lineStyle(lineCrossThickness,lineColourCircle);
			if(fillColour)Sha.graphics.beginFill(fillColour);
			Sha.graphics.drawCircle(0,0,radius);
			Sha.graphics.endFill();
			//cross
			Sha.graphics.lineStyle(1,lineColourCross);
			Sha.graphics.moveTo(-radius,-radius);
			Sha.graphics.lineTo(radius,radius);
			Sha.graphics.moveTo(-radius,radius);
			Sha.graphics.lineTo(radius,-radius);
			
			return Sha;
		}
	}
}