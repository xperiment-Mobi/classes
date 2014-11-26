package com.xperiment.make.xpt_interface.trialDecorators.SnapMenu.background
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class Background extends Sprite
	{
		private var theStage:Stage;
		
		public static var TOP:String = 'top';
		public static var BOTTOM:String = 'bottom';
		public static var LEFT:String = 'left';
		public static var RIGHT:String = 'right';
		public var snapSide:String = TOP;
		public var menuHeightPercent:int = 10;
		public var menuWidthPercent:int  = 10;
	
		private var backgroundColour:Number=0xffffff;
		private var sides:Sides;
		
		public function kill():void
		{
			theStage.removeChild(this);
			listeners(false);
		}
		
		public function Background(theStage:Stage)
		{
			this.theStage = theStage;
			this.mouseEnabled=true;
			this.buttonMode=true;
			theStage.addChild(this);
			createBackground();
			listeners(true);
		}
		
		private function listeners(on:Boolean):void{
			var f:Function;
			if(on)f=this.addEventListener;
			else  f=this.removeEventListener;
			
			f(MouseEvent.MOUSE_DOWN,mouseDownL);
		}
		
		private function mouseDownL(e:MouseEvent):void{
			sides = new Sides(theStage,snapSide);
			sides.addEventListener(Event.CHANGE,sideChangeL);
			
			
			theStage.addEventListener(MouseEvent.MOUSE_UP,mouseUpL);
			//this.startDrag(false,new Rectangle(0,0,theStage.stageWidth,theStage.stageHeight));
			
				
		}
		
		protected function sideChangeL(event:Event):void
		{
			snapSide=sides.selectedSide();
			createBackground();
			this.dispatchEvent(new Event(Event.CHANGE));
		}		
		
		
		protected function mouseUpL(e:MouseEvent):void
		{
			theStage.removeEventListener(e.type,arguments.callee);
			sides.removeEventListener(Event.CHANGE,sideChangeL);
			this.stopDrag();
			sides.kill();
		}		

		
		private function createBackground():void
		{
			this.graphics.clear();
			this.graphics.beginFill(backgroundColour,.5);
			
			if		(snapSide==TOP || snapSide==BOTTOM)	this.graphics.drawRect(0,0,theStage.stageWidth,theStage.stageHeight*menuHeightPercent*.01);
				
			else if	(snapSide==LEFT || snapSide==RIGHT)	this.graphics.drawRect(0,0,theStage.stageWidth*menuWidthPercent*.01,theStage.stageHeight);
				
			else throw new Error();
			
			
			switch(snapSide){
				case TOP:
				case LEFT:
					this.y=0;
					this.x=0;
					break;
				case BOTTOM:
					this.y=theStage.stageHeight-this.height;
					this.x=0;
					break;
				case RIGHT:
					this.y=0;
					this.x=theStage.stageWidth-this.width;
					break;
				default: throw new Error();
			}

			
		}
		

	}
}