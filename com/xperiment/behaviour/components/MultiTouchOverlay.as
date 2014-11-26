package com.xperiment.behaviour.components
{
	import flash.display.Stage;
	import flash.events.TransformGestureEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class MultiTouchOverlay
	{
		private var multiTouch:__AS3__.vec.Vector.<String>;
		private var theStage:Stage;
		
		
		//if returns not null, must provide Object of TouchEvents with 
		public static function check(theStage:Stage):MultiTouchOverlay{
			
			var mt:__AS3__.vec.Vector.<String> = Multitouch.supportedGestures;
			if(mt)	return new MultiTouchOverlay(theStage, mt);
			else return null;
		}
		
		//DO NOT INSTANTIATE ELSEWHERE BESIDES VIA CHECK
		public function MultiTouchOverlay(theStage:Stage,multiTouch:__AS3__.vec.Vector.<String>)
		{
			this.theStage=theStage;
			this.multiTouch=multiTouch

			
			if(multiTouch){
				
				for (var i:int = multiTouch.length-1; i>=0 ;i--)
					if([TransformGestureEvent.GESTURE_ZOOM,	TransformGestureEvent.GESTURE_ROTATE].indexOf(multiTouch[i])==-1){
						multiTouch.splice(i,1);
					}
				
				touchListenersInitKill(true);
				Multitouch.inputMode=MultitouchInputMode.GESTURE;
			}
		}
		
		private function touchListenersInitKill(on:Boolean):void{
			var f:Function;
			if(on)	f=theStage.addEventListener;
			else	f=theStage.removeEventListener;
			
			for each(var listener:String in multiTouch){
				f(listener,touchL);
			}
		}
		
		protected function touchL(e:TransformGestureEvent):void
		{
			
			/*switch(e.type){
				case TransformGestureEvent.GESTURE_ROTATE:
					manager.rotateSelection(e.rotation * Math.PI / 180);
					break;
				case TransformGestureEvent.GESTURE_ZOOM:
					manager.scaleSelection(e.scaleX,e.scaleY);
					break;
				
			}*/
			
		}
	}
}