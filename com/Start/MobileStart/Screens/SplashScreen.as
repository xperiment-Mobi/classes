package com.Start.MobileStart.Screens
{
	import com.greensock.TweenLite;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	
	public class SplashScreen extends Sprite
	{
		
		public var bitmap:Bitmap;
		
		private var splash:ImageLoader; 
		private var theStage:Stage;
		
		
		public function kill():void{
			
			theStage.removeChild(bitmap);
			splash.removeEventListener(LoaderEvent.COMPLETE,onImageLoad);
			splash.removeEventListener(LoaderEvent.FAIL,onImageFail);
			splash=null;
			
			
		}
		
		public function SplashScreen(theStage:Stage){
			this.theStage=theStage;
		}
		
		public function start():void
		{
			splash = new ImageLoader('assets/splash.png');
			splash.addEventListener(LoaderEvent.COMPLETE,onImageLoad);
			splash.addEventListener(LoaderEvent.FAIL,onImageFail);
			splash.load();
		}
		
		protected function onImageFail(e:LoaderEvent):void
		{
			next();
		}
		
		//when the image loads, fade it in from alpha:0 using TweenLite
		private function onImageLoad(event:LoaderEvent):void {
			bitmap=splash.rawContent;
			
			var scale:Number = theStage.stageWidth/bitmap.width;
			if(scale>theStage.stageHeight/bitmap.height)scale=theStage.stageHeight/bitmap.height;
			
			bitmap.width*=scale;
			bitmap.height*=scale;
			
			bitmap.x=theStage.stageWidth*.5-bitmap.width*.5;
			bitmap.y=theStage.stageHeight*.5-bitmap.height*.5;
			
			theStage.addChild(bitmap);
			TweenLite.from(bitmap, 1, {alpha:0, onComplete:next});
		}
		
		
		private function next():void{	
			kill();
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}