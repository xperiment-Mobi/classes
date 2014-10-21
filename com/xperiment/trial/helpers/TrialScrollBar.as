package com.xperiment.trial.helpers
{

	import com.bit101.components.Style;
	import com.xperiment.trial.Trial;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class TrialScrollBar extends Sprite
	{
		private var maxHeight:int;
		private var myHeight:int;
		private var trialParent:DisplayObjectContainer;
		private var change:Number;
		
		public var range :Number;
		private var xPos:int;
		private var yPos:int;

		public function kill():void
		{
			// TODO Auto Generated method stub
			if(this.hasEventListener(MouseEvent.MOUSE_DOWN))this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownL);
			if(trialParent.hasEventListener(MouseEvent.MOUSE_UP))trialParent.removeEventListener(MouseEvent.MOUSE_UP,mouseUpL);
			if(trialParent.hasEventListener(MouseEvent.MOUSE_MOVE))trialParent.removeEventListener(MouseEvent.MOUSE_MOVE,moveL);
			trialParent.removeEventListener(MouseEvent.MOUSE_WHEEL,wheelL);
			trialParent.removeChild(this);

		}
		
		public function TrialScrollBar(pic:DisplayObjectContainer,myHeight:int, maxHeight:int)
		{
			this.myHeight=myHeight;
			this.maxHeight=maxHeight;
			this.trialParent=pic.parent;
			create();
			trialParent.addChild(this);
			
			
			
			xPos = Trial.ACTUAL_STAGE_WIDTH-this.width; 
			yPos = pic.parent.height-this.height

			this.x= xPos;
			this.y=0;
			
			trialParent.addEventListener(MouseEvent.MOUSE_WHEEL,wheelL);
		}
		
		protected function wheelL(e:MouseEvent):void
		{
			change=-e.delta*10;
			if(this.y+change<0)this.y=0;
			else if(this.y+change>range)this.y=range;
			else this.y+=change;
			
			this.dispatchEvent(new SliderEvent(this.y/range));
		}		
		
		
		private function create():void
		{
			this.graphics.beginFill(Style.BUTTON_FACE,1);
			this.graphics.drawRect(0,0,30,myHeight/maxHeight*myHeight);
			this.buttonMode=true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownL);
			this.range = myHeight-this.height;
		}
		
		protected function mouseDownL(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownL);
			trialParent.addEventListener(MouseEvent.MOUSE_UP,mouseUpL);
			trialParent.addEventListener(MouseEvent.MOUSE_MOVE,moveL);
			this.startDrag(false,new Rectangle(xPos,0,0,yPos));
			
		}
		
		protected function moveL(e:MouseEvent):void
		{
			this.dispatchEvent(new SliderEvent(this.y/range));
		}
		
		protected function mouseUpL(event:MouseEvent):void
		{
			this.stopDrag();
			trialParent.removeEventListener(MouseEvent.MOUSE_MOVE,moveL);
			this.removeEventListener(MouseEvent.MOUSE_UP,mouseUpL);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownL);
		}
	}
}