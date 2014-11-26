package com.xperiment.messages
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class XperimentBounceMessage extends Sprite
	{
		
		public static function bounceMessage(theStage:Stage, str:String):void{
			var message:TextField = new TextField;
			message.background=true;
			message.backgroundColor=0;
			message.textColor=0xffffff;
			message.text=str;
			var format:TextFormat = new TextFormat();
			format.size = 27;
			message.setTextFormat(format);
			message.autoSize=TextFieldAutoSize.CENTER;
			message.alpha=0;
			message.multiline=true;
			message.x=-message.width;
			message.y=theStage.stage.nativeWindow.height*.5-message.height*.5;
			theStage.addChild(message);
			TweenMax.to(message, .8, {alpha:1,x:theStage.stage.nativeWindow.width-message.width*1.1, ease:Bounce.easeOut});
			TweenMax.to(message, 1.5, {delay:4, alpha:0,y:-4*message.height,ease:Bounce.easeIn, onComplete:
				function():void{
					///anon function
					theStage.removeChild(message);
					message=null;
					format=null;
					///
				}});
			
		}
	}
}