package com.xperiment.live
{
	import flash.events.Event;
	
	public class EventLive extends Event
	{
		public var data:Object;
		
		public function EventLive(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}