package com.xperiment.make.xpt_interface
{
	import com.xperiment.trial.Trial;	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class MessageMaker
	{
		private static var overlay:Sprite
		private static var callBackF:Function;
		private static var txt:TextField;
		
		public static function refresh(theStage:Stage,_callBackF:Function):void
		{
			if(!overlay){
				make(theStage, _callBackF, "click to refresh");
			}
		}
		
		public static function scriptProb(theStage:Stage,_callBackF:Function):void{
			if(overlay)kill();
			make(theStage, _callBackF,"problem with script. Click to try again");
		}
		

		
		private static function make(theStage:Stage,_callBackF:Function, text:String):void{
			overlay = new Sprite;
			callBackF=_callBackF;
			var mat:Matrix = new Matrix();
			var colors:Array=[0xFFFFFF,0xFFFFFF];
			var alphas:Array=[.5,1];
			var ratios:Array=[0,255];
			
			var width:int = Trial.RETURN_STAGE_WIDTH;
			var height:int = Trial.RETURN_STAGE_WIDTH;
			
			
			//Without the translation parameters, -circRad+25, -circRad-25, the center
			//of the gradient will fall at the point x=circRad, y=circRad relative to
			//the center of the circle. So the center of the gradient will fall in the
			//lower right portion of the perimeter of the circle. -circRad, -circRad
			//move the center of the gradient to the center of the circle; the +25
			//and -25 parts move it a bit up and to the right.
			mat.createGradientBox(width,height,0,width*.25,height*.25);
			overlay.graphics.lineStyle();
			overlay.graphics.beginGradientFill(GradientType.RADIAL,colors,alphas,ratios,mat);
			overlay.graphics.drawRect(0,0,width, height);
			overlay.graphics.endFill();
			theStage.addChild(overlay);
			
			txt = new TextField;
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.multiline=true;
			txt.text=text;
			txt.scaleX=width/txt.width*.25;
			txt.scaleY=height/txt.height*.25;
			
			overlay.addChild(txt);
			txt.x=width*.5-txt.width*.5;
			txt.y=height*.5-txt.height*.5;
			txt.selectable=false;
			overlay.mouseEnabled=true;
			overlay.buttonMode=true;
			overlay.addEventListener(MouseEvent.CLICK,listener);
		}
		
		protected static function listener(event:MouseEvent):void
		{
			kill();
			callBackF();
		}		
		
		private static function kill():void
		{
			if(overlay){
				if(overlay.hasEventListener(MouseEvent.CLICK))overlay.removeEventListener(MouseEvent.CLICK,listener);
				overlay.parent.removeChild(overlay);
				txt.parent.removeChild(txt);
				txt=null;
				overlay=null;
			}
		}
	}
}