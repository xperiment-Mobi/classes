package com.xperiment.events
{
	import flash.events.Event;
	
	public class TrialEvent extends Event
	{
		
		public var action:String; // nextTrial, prevTrial reserved, else use trialname
		public var trials:Array;

		public static const CHANGE:String = "changeTrialInfo";
		public static const STARTED:String = "trial started";
		public static const FINISHED:String = "trial started";
		public static const DISABLE:String = "disableTrial";
		public static const ENABLE:String  = "enableTrial";
		
		
		
		public function TrialEvent(type:String, action:String)
		{
			this.action=action;

			super(type);
		}
		
	}
}

