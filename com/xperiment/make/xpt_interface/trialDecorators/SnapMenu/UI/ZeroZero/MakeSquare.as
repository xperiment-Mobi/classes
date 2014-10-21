package com.xperiment.make.xpt_interface.trialDecorators.SnapMenu.UI.ZeroZero
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class MakeSquare extends Sprite
	{
		public static var unselectedColour:Number=0xffffff;
		public static var selectedColour:Number=0x000000;
		public static var circleSizePer:Number = 10;
		
		public var selected:Boolean = false;
		
		private var circle:Shape = new Shape;
		private var myX:int;
		private var myY:int;
		private var dimension:int;
		
		public function kill():void
		{
			listeners(false);
			this.removeChild(circle);
			
		}
		
		public function MakeSquare(x:int,y:int,dimension:int)
		{
			this.addChild(circle);
			this.myX=x;
			this.myY=y;
			this.dimension= dimension;
			generate();
			listeners(true);
			this.mouseChildren=false;
			
		}
		
		private function listeners(on:Boolean):void{
			var f:Function;
			if(on)	f=this.addEventListener;
			else	f=this.removeEventListener;
			f(MouseEvent.MOUSE_OVER,mouseOverL);
			f(MouseEvent.MOUSE_OUT,mouseOutL);
		}
		
		protected function mouseOverL(event:MouseEvent):void
		{
			generate(0x00ffff);
		}
		
		protected function mouseOutL(event:MouseEvent):void
		{
			generate();
		}
		
		private function generate(forceCol:Number=-1):void
		{
			this.graphics.clear();
			
			var squareCol:Number;
			var circleCol:Number;
			if(selected){
				squareCol=selectedColour;
				circleCol=unselectedColour;
			}
			else{
				squareCol=unselectedColour;
				circleCol=selectedColour;
			}
			
			if(forceCol!=-1)squareCol=forceCol
			
			this.graphics.beginFill(squareCol,.6);
			this.graphics.drawRect(0,0,dimension,dimension);
			
			circle.graphics.clear();
			circle.graphics.beginFill(circleCol,.95);
			circle.graphics.drawCircle(0,0,Number(dimension)*circleSizePer*.01);

			circle.x=Number(dimension)*(myX+1)/5;
			circle.y=Number(dimension)*(myY+1)/5;
			
			if(myX==0){
				circle.x-=circle.width*.2;
			}
			else if(myX==1){
				circle.x+=circle.width*.5;
			}
			else if(myX==2){
				circle.x+=circle.width*1.2;
			}
			
			if(myY==0){
				circle.y-=circle.height*.2;
			}
			else if(myY==1){
				circle.y+=circle.height*.5;
			}
			else if(myY==2){
				circle.y+=circle.height*1.2;
			}
			
			
		}
		

	}
}