package com.Start.MobileStart
{

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	public class MobileScreen extends Sprite
	{
		
		public static var stageWidth:int;
		public static var stageHeight:int;
		
		public static const HORIZONTAL:String = 'horizontal';
		public static const VERTICAL:String = 'vertical';
		
		public static var VIRTUAL_Width:int;
		public static var VIRTUAL_Height:int;
		public static var ZOOM_X:Number;
		public static var ZOOM_Y:Number;
		public static var VERTICAL_ADJUST:int = 0;
		public static var HORIZONTAL_ADJUST:int = 0;
		public static var ACTUAL_HEIGHT:int;
		public static var ACTUAL_WIDTH:int;
		private var _frameCnt:int=0;
		private var theStage:Stage;
		private var orientation:String;
		private var aspectRatio:String;
	

		
		
		public function MobileScreen(theStage:Stage,orientation:String, askedForWidthStr:String, askedForHeightStr:String, aspectRatio:String)
		{
			
			this.orientation = orientation.toLowerCase();
			this.aspectRatio = aspectRatio.toLowerCase();
			this.theStage = theStage;
			//theStage.align="yx";
			theStage.autoOrients=false;

			if(askedForWidthStr.toLowerCase()=="max")askedForWidthStr="0";
			if(askedForHeightStr.toLowerCase()=="max")askedForHeightStr="0";

			
			VIRTUAL_Width = int(askedForWidthStr);
			VIRTUAL_Height = int(askedForHeightStr);
		}
		
		public function init():void{	
			theStage.scaleMode=StageScaleMode.NO_SCALE;
			theStage.addEventListener(Event.ENTER_FRAME, screenListener);	
		}
		
		
		public function screenListener(e:Event):void {
			_frameCnt++;
			if (_frameCnt > 5) {
				theStage.removeEventListener(Event.ENTER_FRAME,screenListener);
				
				calcOrientationAndSizes();
				calcZoom();
				
				VERTICAL_ADJUST = (stageHeight - ZOOM_Y*VIRTUAL_Height)*.5
				HORIZONTAL_ADJUST = (stageWidth - ZOOM_X*VIRTUAL_Width)*.5
				
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function calcOrientationAndSizes():void
		{
			var max:int = Capabilities.screenResolutionX;
			var less:int= Capabilities.screenResolutionY;
			
			
			
			if(flash.system.Capabilities.os.indexOf('Windows')!=-1){

				max = theStage.fullScreenWidth;
				less = theStage.fullScreenHeight;
			}
			
			var defaultVertical:Boolean = true;
			
			if(theStage.stageWidth>theStage.stageHeight){
				if(theStage.orientation == StageOrientation.DEFAULT)defaultVertical=false;
			}
			else{
				if(theStage.orientation != StageOrientation.DEFAULT)defaultVertical=false;
			}
			
			if(max<less){
				var temp:int = max;
				max=less;
				less=temp;
			}
			

			if (orientation == HORIZONTAL ){
				stageWidth = max;
				stageHeight= less
			}
			else{
				stageWidth= less;
				stageHeight= max;
			}
			
	
			ACTUAL_HEIGHT	= stageHeight;
			ACTUAL_WIDTH	= stageWidth;
			

			
			if(VIRTUAL_Width==0)	VIRTUAL_Width = ACTUAL_WIDTH;
			if(VIRTUAL_Height==0)	VIRTUAL_Height = ACTUAL_HEIGHT;
			
			
			var curr_orient:String = theStage.orientation;
			
			function logic1():void{
				if(curr_orient==StageOrientation.ROTATED_RIGHT || curr_orient==StageOrientation.ROTATED_LEFT)theStage.setOrientation(curr_orient);
				else theStage.setOrientation(StageOrientation.ROTATED_RIGHT);
				
				
			}
			
			function logic2():void{
				theStage.setOrientation(StageOrientation.DEFAULT);
			}
			
			
			if(defaultVertical){
				if (orientation == HORIZONTAL){
					logic1();
				}
				else{
					logic2();
				}
			}
			else{
				if (orientation == HORIZONTAL){
					logic2();
					
				}
				else{
					logic1()
				}
				
			}
		}		


		
		private function calcZoom():void
		{
			
			
			switch(aspectRatio){
				case "stretch":
					ZOOM_X=Number(stageWidth)/Number(VIRTUAL_Width);
					ZOOM_Y=Number(stageHeight)/Number(VIRTUAL_Height);
					break;
				
				default:
					var minZoom1:Number;
					var minZoom2:Number;
					
					minZoom1 = Number(stageWidth)/Number(VIRTUAL_Width);
					minZoom2 = Number(stageHeight)/Number(VIRTUAL_Height);
					
					if(minZoom1<minZoom2) 	ZOOM_X = minZoom1;
					else					ZOOM_X = minZoom2;
					
					ZOOM_Y=ZOOM_X;
					break;
			}
		
		}		



		public function kill():void
		{
		
		}
	}
}