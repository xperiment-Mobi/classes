package com.xperiment.make.xpt_interface.trialDecorators.Helpers
{

	import flash.events.Event;

	public class NeedsUpdating extends Event
	{
		public static var NEEDS_UPDATE:String = 'needs update';
		
		public var stimuli:Array;
		public var changed:Object = {};
		public var reset:Boolean;
		public var x:Number;
		public var y:Number;
		
		public function NeedsUpdating(stimuli:Array,changed:Object, reset:Boolean=false)
		{
			this.stimuli=stimuli;
			this.changed=changed;
			this.reset=reset;
			super(NEEDS_UPDATE);
		}
	}
}