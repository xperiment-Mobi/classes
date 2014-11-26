package com.xperiment.stimuli.primitives.windows
{
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;

	public class WindowPrimitive_fullscreen extends WindowPrimitive
	{
		
		private var callBackF:Function;
		
		public function WindowPrimitive_fullscreen(obj:Object,callBackF)
		{
			this.callBackF = callBackF;
			super(obj);
		}
		
		
		override protected function setupButtons():void
		{
			
			super.setupButtons();
			params.pushButtonText = params.goFullScreen;
			
			params.pushButtonListener = callBackF;


			button2 = new PushButton(myWindow,0,0,params.pushButtonText);
			button2.addEventListener(MouseEvent.CLICK,params.pushButtonListener,false,0,true);
			button2.width=200;
			button2.height=200;
			button2.y=30;
	
			var moveX:int=myWindow.width-closeButton.x-button2.width;
			moveX*=.5;

			button2.x+=	moveX;
			closeButton.x+=	moveX;
			
		}
		

	}
}