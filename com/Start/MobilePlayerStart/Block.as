package com.Start.MobilePlayerStart
{
	import flash.display.Shape;


	public class Block extends Shape
	{
		
		public var vitality:int;
		
		public static var myWidth:Number;
		public static var myHeight:Number;
		
		public function Block() 
		{
			randomVitality()
			colour();
		}
		
		private function colour():void
		{
			this.graphics.beginFill(0x444444,vitality/10);
			this.graphics.drawRect(0,0,myWidth,myHeight);
		}
		
		public function randomVitality():void{
			vitality = Math.random()*10*.5;
		}
	}
}