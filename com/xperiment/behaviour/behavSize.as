package com.xperiment.behaviour{
	import com.xperiment.uberSprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;

	public class behavSize extends behav_baseClass {
		private var steps:Array;
		private var prevWidth:uint;
		private var prevHeight:uint;
		private var scale:Number;
		private var myTimer:Timer;
		private var timerCounter:uint=0;

		override public function setVariables(list:XMLList):void {
			setVar("number","finalSize",4);
			super.setVariables(list);
		}

		override public function givenObjects(obj:uberSprite):void {
			super.givenObjects(obj);
		}
		
		override public function nextStep(id:String=""):void{
			super.nextStep();
			for(var i:uint=0;i<behavObjects.length;i++){
				size(behavObjects[i]);
			}
		}

		private function size(obj:uberSprite):void {
			var origWidth:uint=obj.width;
			var origHeight:uint=obj.height;
			obj.scaleX=getVar("finalSize");
			obj.scaleY=getVar("finalSize");
			
			obj.x-=(obj.width-origWidth)/2
			obj.y-=(obj.height-origHeight)/2;
		}
	}
}