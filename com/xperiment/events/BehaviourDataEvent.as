package com.xperiment.events
{
	import flash.events.Event;
	
	public class BehaviourDataEvent extends Event
	{
		
		public static const PASSDATA:String = "passData";
		
		public var calleeBehavID:String;
		public var calledBehavID:String;
		public var data:*;
		
		public function BehaviourDataEvent(type:String, calleeBehavID:String, calledBehavID:String, data:*)
		{
			this.calleeBehavID=calleeBehavID;
			this.calledBehavID=calledBehavID;
			this.data=data;
			super(type);
		}
	}
}