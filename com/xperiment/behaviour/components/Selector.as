package com.xperiment.behaviour.components
{
	import com.dgrigg.minimalcomps.graphics.Shape;
	
	import flash.display.Sprite;

	public class Selector extends Sprite
	{
		
		private var center:Shape;
		
		private const centerWidth:int = 8;
		private const thisWidth:int = 10;
		
		public function kill():void
		{
			this.removeChild(center);
			center=null;
			
		}
		
		public function Selector()
		{
			init();
			
		}
		
		private function init():void
		{
			graphics.lineStyle(1);
			graphics.lineTo(thisWidth,thisWidth);
			graphics.moveTo(thisWidth,0);
			graphics.lineTo(0,thisWidth);
			
			center = new Shape;
			center.graphics.lineStyle(1);
			colour(0x000000);
			this.addChild(center);
			center.y = center.x = thisWidth*.5 - centerWidth*.5;
			
		
		}	
		
		public function colour(col:int):void{
			center.graphics.clear();
			center.graphics.beginFill(col,1);
			center.graphics.drawRect(0,0,centerWidth,centerWidth);
		}

	}
}