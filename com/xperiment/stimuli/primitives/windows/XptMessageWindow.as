package com.xperiment.stimuli.primitives.windows
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class XptMessageWindow extends Sprite
	{
		
		public var title:String = '';
		public var hasCloseButton:Boolean =true;
		public var closeButton:Sprite;
		
		public var buttonWidth:int=10;
		public var titleSize:int;
		public var messageSize:int;
		private var titleTF:TextField;

		public function kill():void{
			if(closeButton){
				closeButton.removeEventListener(MouseEvent.CLICK,closeMe);
				this.removeChild(closeButton);
				closeButton=null;
			}
		}
		
		protected function closeMe(event:MouseEvent):void
		{
			this.kill();
		}
		
		public function make():void{
			this.graphics.beginFill(0x000000,1);
			this.graphics.lineStyle(2,0x000000,1);
			
			this.graphics.drawRect(0,0,this.width,this.height);
			
			if(hasCloseButton)drawButton()
			drawTitle();
			
		}
		
		private function drawTitle():void
		{
			titleTF=new TextField;
			titleTF.multiline=true;
			titleTF.width=this.width;
			titleTF.text=title;
			
		}
		
		private function drawButton():void
		{
			closeButton = new Sprite;
			closeButton.graphics.beginFill(0x000000,1);
			closeButton.graphics.lineStyle(2,0x000000,1);
			
			closeButton.graphics.lineTo(buttonWidth,buttonWidth);
			closeButton.graphics.moveTo(0,buttonWidth);
			closeButton.graphics.lineTo(buttonWidth,0);
			closeButton.addEventListener(MouseEvent.CLICK,closeMe);
		}
	}
}