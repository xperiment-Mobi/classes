package com.xperiment.events
{
	import flash.events.Event;
	
	public class StimulusEvent extends Event
	{
		
		public static const DO_NOW:String 		= 'doNow';
		public static const DO_BEFORE:String 	= 'doBefore';
		public static const DO_AFTER_APPEARED:String 	= 'doAfter';
		public static const ON_FINISH:String 	= 'onFinish';
		public static const list:Vector.<String> = new <String>[DO_NOW,DO_BEFORE,DO_AFTER_APPEARED,ON_FINISH];


		
		public function StimulusEvent(type:String)
		{
			super(type, bubbles, cancelable);
		}
	}
}