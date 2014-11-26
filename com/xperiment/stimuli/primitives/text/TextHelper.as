package com.xperiment.stimuli.primitives.text
{

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;

	public class TextHelper
	{
		
/*		public static function autosize(pic:Sprite,myText:TextField):void{
			//myText.width=pic.width;
			//myText.height=pic.height;
			myText.background=true;
			myText.backgroundColor=0;
			trace(myText.width,myText.height);
			myText.autoSize=TextFieldAutoSize.CENTER;
			trace(myText.width,myText.height);
		}*/
		
		public static function align(align:String,myTextFormat:TextFormat):void
		{
	
			switch(align.toLowerCase()){
				case "left":
					myTextFormat.align=TextFormatAlign.LEFT;
					
					break;
				case "right":
					myTextFormat.align=TextFormatAlign.RIGHT;
					break;
				case "center":
				case "centre":
				case "middle":
					//trace("here");
					myTextFormat.align=TextFormatAlign.CENTER;
					break;
			}
		}
		
/*		private static function sizer(justify:String, myText:TextField):void{
			
			var f:TextFormat=myText.getTextFormat();
			switch(justify){
				case "autoleft":
					f.align = "left";
					break;
				case "autoright":
					f.align = "right";
					break;
				case "autocentre":
				case "autocenter":
				default:
					f.align = "center";
			}
			
			var rect:Rectangle=new Rectangle(0,0,int(myText.textWidth),myText.textHeight);
			var doContinue:Boolean=true;
			f.size=1;
			//var startTime:Date = new Date();
			var counter:uint=0; //there's an issue in Chrome's pepperflash with autosize.  This should stop xperiment crashing.
			
			//logger.log("a2"); //*******************need better algorithm.  Keeps crashing in Chrome.
			while (doContinue && counter<10) {
				//logger.log("a3 "+counter+String(doContinue));
				counter++;
				f.size=int(f.size)+5;
				myText.setTextFormat(f);
				rect=getSize(myText);
				doContinue=rect.width < myText.width-3 && rect.height < myText.height-3;
				
			}
			counter=0;
			while (myText.textWidth > myText.width-3 || myText.textHeight > myText.height-3 || counter<2) {
				counter++
					f.size=int(f.size)-1;
				myText.setTextFormat(f);
				rect=getSize(myText);
			}
			f.size=int(f.size)-1;
			myText.setTextFormat(f);
			
			
		}*/
		
		private static function getSize(txtf:TextField):Rectangle{
			var rect:Rectangle = new Rectangle(0,0,0,0);
			var metrics:TextLineMetrics;
			for(var i:uint=0;i<txtf.numLines;i++){
				metrics=txtf.getLineMetrics(i);
				if(metrics.width>rect.width)rect.width=metrics.width;
				rect.height+=metrics.height;
			}
			return rect;
		}
		
		public static function exactSpacing(pic:Sprite, myText:TextField, myTextFormat:TextFormat, fontSize:int, exactSpacing:Number):void
		{
			throw new Error("don't know if exactSpacing still works");
			var txt:String=myText.text
			var spr:Sprite=new Sprite;
			var subSpr:Sprite;
			var t:TextField;
			for (var i:uint=0;i<txt.length;i++){
				subSpr=new Sprite;
				t = new TextField();
				t.text=txt.charAt(i);
				myTextFormat.size=fontSize;
				t.setTextFormat(myTextFormat);
				t.defaultTextFormat=myTextFormat;
				t.autoSize=TextFieldAutoSize.CENTER;
				subSpr.addChild(t);
				/*subSpr.graphics.beginFill(0x000fff,1);
				subSpr.graphics.drawRect(t.x,0,2,2);*/
				subSpr.x=exactSpacing*i;
				spr.addChild(subSpr);
				//myText=null;
				
			}		
			
		}
		
		public static function sortBorderBackground(pic:Sprite, myText:TextField, border:Number,borderColour:Number,alpha:Number,background:Number):void
		{
			
			var myBorder:Shape = new Shape;
			if(border!=0)myBorder.graphics.lineStyle(border, borderColour,alpha);
			if(background!=-1)myBorder.graphics.beginFill(background);
			if(border!=0 || background!=-1){
				myBorder.graphics.drawRect(myText.x,myText.y,myText.width-1,myText.height-1);
				myBorder.graphics.endFill();
				pic.addChildAt(myBorder,0);
			}
		}
	}
}