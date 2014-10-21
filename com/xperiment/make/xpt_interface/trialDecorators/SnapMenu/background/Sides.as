package com.xperiment.make.xpt_interface.trialDecorators.SnapMenu.background
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Sides extends Sprite
	{
		private var theStage:Stage;
		
		private var left:Shape = new Shape;
		private var right:Shape = new Shape;
		private var top:Shape = new Shape;
		private var bottom:Shape = new Shape;
		
		private var sides:Vector.<Shape> = new <Shape>[left,right,top,bottom]
	
		private var unselectedColour:Number = 0x000000;
		private var selectedColour:Number   = 0xff0000;
		
		private var currentSide:Shape;
	
		
		public function kill():void
		{
			theStage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveL);
			for each(var side:Shape in sides){
				theStage.removeChild(side);
			}
			
			sides=null;
		}
		
		public function selectedSide():String{
			if(currentSide==left)return Background.LEFT;
			else if (currentSide==right)return Background.RIGHT;
			else if (currentSide==top)return Background.TOP;
			else if (currentSide==bottom)return Background.BOTTOM;
				
				
			throw new Error();
			return null;
		}
		
		public function Sides(theStage:Stage,currentSideStr:String)
		{
			this.theStage = theStage;
			
			definedCurrentSide(currentSideStr);
			
			for each(var side:Shape in sides){
				if(side==currentSide)basicSide(side,selectedColour);
				else basicSide(side,unselectedColour);
				
				theStage.addChild(side);
			}
						
			mouseMoveL(new MouseEvent(MouseEvent.MOUSE_MOVE)); //adds approp colour at the start
			theStage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveL);
		}
		
		private function definedCurrentSide(currentSideStr:String):void
		{
			switch(currentSideStr){
				case Background.BOTTOM:
					currentSide=bottom;
					break;
				case Background.TOP:
					currentSide=top;
					break;
				case Background.LEFT:
					currentSide=left;
					break;
				case Background.RIGHT:
					currentSide=right;
					break;
				default: throw new Error();
			}
			
		}		
		
		protected function mouseMoveL(e:MouseEvent):void
		{
			var min:Number=100000;
			var current:Number;
			var best:int;
			
			for(var i:int = sides.length-1; i>=0; i--){
				
				current=distanceSquared(sides[i].x+sides[i].width*.5,theStage.mouseX,sides[i].y+sides[i].height*.5,theStage.mouseY);
				if(current<min){
					//trace(i)
					min=current;
					best=i;
				}
			}
				
			if(sides[best]!=currentSide){
				if(currentSide)basicSide(currentSide,unselectedColour);
				currentSide=sides[best];
				basicSide(currentSide,selectedColour);
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function distanceSquared(x1:Number,x2:Number, y1:Number, y2:Number):Number
		{
			return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
		}
		
		private function basicSide(side:Shape,col:Number):void{	
			
			side.graphics.clear();
			side.graphics.beginFill(col,.8);
			
			
			switch(side){ 
				case left:
					side.graphics.drawRect(0,0,20,100);
					side.y=theStage.stageHeight*.5-side.height*.5;	
					side.x=0;
					break;
				case right:
					side.graphics.drawRect(0,0,20,100);
					side.y=theStage.stageHeight*.5-side.height*.5;	
					side.x=theStage.stageWidth-side.width;
					break;
				case top:
					side.graphics.drawRect(0,0,100,20);
					side.x=theStage.stageWidth*.5-side.width*.5;
					break;
				case bottom:
					side.graphics.drawRect(0,0,100,20);
					side.x=theStage.stageWidth*.5-side.width*.5;
					side.y=theStage.stageHeight-side.height;
					break;
				
				default: throw new Error();
			}

		}
		

	}
}