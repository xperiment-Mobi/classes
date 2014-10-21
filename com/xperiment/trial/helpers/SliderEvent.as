package com.xperiment.trial.helpers
{
	import flash.events.Event;

	public class SliderEvent extends Event
	{
		public static var MOVED:String = "moved";
		
		public var pos:Number; //0-1;
		
		public function SliderEvent(pos:Number)
		{
			this.pos=pos;
			super(MOVED);
		}
	}
}