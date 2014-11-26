package com.xperiment.live
{
	import flash.events.Event;
	
	public class UIEventLive extends Event
	{
		public static var BUTTON_PRESSED:String = "button pressed";
		
		public var data:Object;
		
		public function UIEventLive(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}