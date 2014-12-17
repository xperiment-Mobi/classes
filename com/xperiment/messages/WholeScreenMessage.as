package com.xperiment.messages
{
	import com.greensock.TweenLite;	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com.greensock.TimelineLite;


	public class WholeScreenMessage
	{
		static public function DO(stage:Stage, message:String, fontSize:int=40, timeout:int=5):void
		{
			var cover:Sprite = new Sprite;
			cover.graphics.beginFill(0xff0000,1);
			cover.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
			
			var txt:TextField = new TextField;
			txt.defaultTextFormat = new TextFormat(null,fontSize);
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.text=message;
			
			cover.addChild(txt);
			txt.x=cover.width*.5-txt.width*.5;
			txt.y=cover.height*.5-txt.height*.5;
			
			
			stage.addChild(cover);
			

			var tl:TimelineLite = new TimelineLite;
			tl.add( TweenLite.to(cover, 0, {alpha:0}) );
			tl.add( TweenLite.to(cover, .3, {alpha:.9}) );
			tl.add( TweenLite.to(cover, 1, {}) );
			tl.add( TweenLite.to(cover, .3, {alpha:0, onComplete:kill}) );
			tl.play();
			
			function kill():void{
				tl.clear();
				stage.removeChild(cover);
				txt=null;
				cover=null;
			}
		}
	}
}