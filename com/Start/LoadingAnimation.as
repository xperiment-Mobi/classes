package com.Start
{

	import com.greensock.TweenLite;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.xperiment.codeRecycleFunctions;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	
	public class LoadingAnimation
	{
		private static var shape:Sprite
		private static var txt:TextField;
		private static var str:String='loading';
		
		static public function init(theStage:Stage):void
		{

			
			shape = new Sprite;
			shape.graphics.beginFill(0x4f4f4f);
			shape.graphics.drawRect(0,0,100,100);
			theStage.addChild(shape);
			shape.x=theStage.stageWidth*.5-shape.width*.5;
			shape.y=theStage.stageHeight*.5-shape.height*.5;
			
			txt = new TextField;
			var format:TextFormat = new TextFormat;
			format.size = 40;
			txt.setTextFormat(format);
			txt.defaultTextFormat=format;
			
			txt.text=str;
			txt.textColor=0x4f4f4f;
			txt.autoSize = TextFieldAutoSize.CENTER;
			theStage.addChild(txt);
			txt.y=theStage.stageHeight*.8-txt.height*.5;
			txt.x=theStage.stageWidth*.5-txt.width*.5;
			
			txt.visible=false;
			shape.visible=false;
			var t:Timer = new Timer(200);
			t.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
				t.removeEventListener(e.type,arguments.callee);
				t.stop();
				if(txt){
					txt.visible=true;
					shape.visible=true;
					TweenPlugin.activate([TransformAroundCenterPlugin])
					TweenLite.to(shape,.8,{repeat:-1,repeatDelay:.5,transformAroundCenter:{rotation:360}}); 
				}
				
			});
			t.start();	
		}
		
		private static function message(param0:String):String
		{
			// TODO Auto Generated method stub
			return str + " " + param0+'%';
		}
		
		public static function progress(progress:Number):void
		{
			txt.text=message(codeRecycleFunctions.roundToPrecision(progress,0).toString());
		}
		
		public static function kill():void
		{
			TweenLite.killTweensOf(shape);
			if(shape && shape.stage){
				shape.stage.removeChild(shape);
				if(txt && txt.stage)txt.stage.removeChild(txt);
			}
			shape=null;
			txt=null;
			
			
		}
		
	}
}