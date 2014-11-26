package com.Start.MobilePlayerStart.view
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;

	public class TileBackgroundFiller extends Sprite
	{
		private var loader:Sprite;
		private var _tileNo:uint = 0;
		private var _bgColor:uint = 0;
		private var _myBitmap:BitmapData;
		private var _mySprite:Sprite;
		private var _backgroundMc:MovieClip;
		private var _matrix:Matrix;
		public function TileBackgroundFiller(bgColor:uint=0x111111,tileNo:uint=0)
		{
			// constructor code
			_tileNo = tileNo;
			_bgColor = bgColor;
			loader = tile(_tileNo);
			_mySprite = new Sprite();

			_myBitmap = new BitmapData(loader.width,loader.height,true,0x0);

			_myBitmap.draw(loader, new Matrix());
			_backgroundMc = new MovieClip();
			_matrix = new Matrix();
			_matrix.rotate(Math.PI/4);

			this.addEventListener(Event.ADDED_TO_STAGE,  addedToStage);
		}
		
		private function addedToStage(evt:Event):void
		{
			drawImage();			
		}
		private function tile(tileNo:uint=0):Sprite
		{
			var sp:Sprite=new Sprite();

			
			sp.graphics.beginFill(0,0);
			sp.graphics.lineStyle(0,0,0);
			
			switch (tileNo)
			{
				case 0 :
					sp.graphics.drawRect(0,0,3,3);
					sp.graphics.beginFill(0xffffff,.05);
					sp.graphics.drawRoundRect(1,1,10,6,3);
					break;
				case 1 :
					sp.graphics.drawRect(0,0,3,3);
					sp.graphics.beginFill(0xffffff,.05);
					sp.graphics.drawCircle(22,22,20);
					break;
				case 2 :
					sp.graphics.drawRect(0,0,3,3);
					sp.graphics.beginFill(0xffffff,.05);
					sp.graphics.drawCircle(6,6,5);
					break;
				case 3 :
					sp.graphics.drawRect(0,0,0,0);
					sp.graphics.beginFill(0xffffff,.05);
					sp.graphics.drawRect(1,1,20,22);

					break;

			}
			sp.graphics.endFill();
			
			return sp;
		}

		public function drawImage():void
		{
			redrawBack();
			dispatchEvent(new Event("tileAdded"));
		}
		public function redrawBack():void
		{
			_mySprite.graphics.clear();
			_mySprite.graphics.beginBitmapFill(_myBitmap, _matrix, true, true);
			_mySprite.graphics.drawRect(0, 0, this.stage.fullScreenWidth, this.stage.fullScreenHeight);
			_mySprite.graphics.endFill();
			_backgroundMc.graphics.clear();
			_backgroundMc.graphics.beginFill(0x333333,1);

			var fillType:String = GradientType.RADIAL;
			var colors:Array = [_bgColor,0x111111];
			var alphas:Array = [1,1];
			var ratios:Array = [0x00,0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(stage.stageWidth,stage.stageHeight, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			var focalPointRatio:Number = 0;
			_backgroundMc.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod, "rgb", focalPointRatio);

			_backgroundMc.graphics.drawRect(0,0,stage.fullScreenWidth, stage.fullScreenHeight);
			_backgroundMc.graphics.endFill();
			addChild(_backgroundMc);
			addChild(_mySprite);


		}

	}

}