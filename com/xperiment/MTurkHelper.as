package com.xperiment
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	
	public class MTurkHelper extends Sprite
	{

		private const successMessage:String = "We have submitted your HIT to Mechanical Turk. You can verify this returning to your Hit window in MTurk and clicking 'check'. We appreciate your help in this study. Thankyou.";
		//private const failMessage:String = 'There has been a problem submitting your HIT to mechanical Turk. Please return to MTurk and follow our instructions. Apologies.';
		private static var instance:MTurkHelper;
		
		//private var success:Boolean;
		private var theStage:Stage;
		
		
		public function MTurkHelper(s:Stage)
		{
			theStage = s;
			theStage.addChild(this);
			//success = succ;
			
			var col:int;
			var txt:TextField = new TextField;
			txt.defaultTextFormat = new TextFormat(null, 15, 0x333333);
			txt.wordWrap = true;
			txt.width = theStage.stageWidth;
			txt.height=80;
			
			
			//if(success){
			col = 0x00ff00;
			txt.text = successMessage;
			//}
			/*else{
				col = 0xff0000;
				txt.htmlText = failMessage;
			}*/
			txt.htmlText+="\n<b>Click this bar to close this message.   Press Escape to return to your browser (if running the study fullscreen).</b>";
			
			
			this.graphics.beginFill(col,.9);
			this.graphics.drawRect(0,theStage.stageHeight,theStage.stageWidth,theStage.stageHeight+80);
			
			this.addChild(txt);
			//txt.x=this.width*.5-txt.width*.5;
			txt.y=this.height*.5-txt.height*.5;
			
			TweenLite.to(this,.5,{y:"-80"});
			
			listen();
		}
		
		private function listen():void
		{
			this.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
	
				e.currentTarget.removeEventListener(e.type, arguments.callee);
				TweenLite.to(e.currentTarget,.5,{y:"+80",onComplete:kill});
			});
		}
		
		private function kill():void{
			theStage.removeChild(this);
		}
		
		
		
		
		public static function DO(theStage:Stage):void
		{
			if(instance) throw new Error();	
			instance = new MTurkHelper(theStage);
			
		}
	}
}