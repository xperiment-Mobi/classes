package com.projectcocoon.p2p.events
{
	import com.projectcocoon.p2p.vo.AccelerationVO;
	
	import flash.events.Event;
	
	/**
	 * Used to signal acceleration events 
	 */	
	public class AccelerationEvent extends Event
	{
		
		public static const ACCELEROMETER:String = "accelerometerUpdate";
		
		
		public var acceleration:AccelerationVO;
		
		public function AccelerationEvent(type:String, data:AccelerationVO=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			acceleration = data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new AccelerationEvent(type, acceleration, bubbles, cancelable);
		}
	}
}