package com.xperiment.behaviour
{
	import flash.events.Event;
	
	public class HackEvent extends Event
		
	{
		
		public var RT:Number;
		
		public function HackEvent(type:String, RT:Number)
		{
			this.RT=RT;
			
			super(type, false, false);
		}
	}
}