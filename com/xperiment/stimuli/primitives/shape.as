package com.xperiment.stimuli.primitives {
	
	import flash.display.Shape;
	
	public class shape {

		static public  function makeShape(type:String, lineThickness:int, lineColour:Number, transparency:Number, colour:Number, width:int,height:int):Shape {
			var sha:Shape=new Shape  ;
			sha.graphics.lineStyle(lineThickness,lineColour,transparency);
			sha.graphics.moveTo(0,0);
			switch(type.toLowerCase()){
				case "circle":
					if(colour>0)sha.graphics.beginFill(colour,1);
					sha.graphics.drawEllipse(0, 0,width,height);
					break;
				case "triangle":
					if(colour>0)sha.graphics.beginFill(colour,1);
					sha.graphics.lineTo(width,0);
					sha.graphics.lineTo(Math.round(width)*.5,height);
					sha.graphics.lineTo(0,0);
					break;
				case "square":
					if(colour>0)sha.graphics.beginFill(colour,1);
					sha.graphics.lineTo(width,0);
					sha.graphics.lineTo(width,height);
					sha.graphics.lineTo(0,height);
					sha.graphics.lineTo(0,0);
					break;
				case "tick":
					sha.graphics.moveTo(0, height*.25);
					sha.graphics.lineTo(width*.25, 0);
					sha.graphics.curveTo(width/2, height/2,width, height);
					sha.y=-height*.8;
					sha.x=width*.2
					break;
					
				case "smile":
				    sha.graphics.moveTo(width*.2, height*.75);
					sha.graphics.drawCircle(width*.2, height*.5, height*.2);
					sha.graphics.drawCircle(width*.6, height*.5, height*.2);
					sha.graphics.moveTo(0, 0);
					   sha.graphics.curveTo(width/2.3, -height/2,width*.75, 0);
					sha.graphics.drawCircle(width*.2, height*.5, .1);
					sha.graphics.drawCircle(width*.6, height*.5, .1);
					sha.height*=.9;
					sha.y-=height/1.5;
					sha.x+=width/20;
					break;
				case "sad":
				
					break;
			}
			if(colour>0)sha.graphics.endFill();
			return sha;
		}

	}
	
}
