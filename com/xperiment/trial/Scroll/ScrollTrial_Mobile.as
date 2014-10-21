package com.xperiment.trial.Scroll
{
	import com.Start.MobileStart.MobileScreen;

	
	import flash.display.Sprite;
	import flash.events.MouseEvent;



	public class ScrollTrial_Mobile extends ScrollTrial
	{
		private var range:Number;
		private var mouseDownPos:int;
		
		override public function kill():void{
			pic.stage.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownL);
			upDownL(false);
			super.kill();
		}
		
		public function ScrollTrial_Mobile()
		{
			super(false);
		}
		
		
		
		override public function init(pic:Sprite, maxHeight:int):void{
			super.init(pic,maxHeight);
			this.range=MobileScreen.VIRTUAL_Height;
				
		
			pic.stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownL);
		}
		
		private function upDownL(ON:Boolean):void{
			if(pic){
				if(ON){
					pic.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveL);
					pic.stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpL);
				}
				else{
					pic.stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveL);
					pic.stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpL);
				}
			}
		}
		
		protected function mouseDownL(e:MouseEvent):void
		{
			if(blitMask){
				blitMask.dispose();
				blitMask=null;
			}
			mouseDownPos=e.stageY-pic.y;
			upDownL(true);
		}
		
		protected function mouseUpL(event:MouseEvent):void
		{
			upDownL(false);
		}
		
		protected function mouseMoveL(e:MouseEvent):void
		{
			
			pic.y=e.stageY-mouseDownPos;
			
			if(pic.height+pic.y<range){
				pic.y=range-pic.height;
			}
			else if(pic.y>0)pic.y=0;
			
			

			
		}
	}
}