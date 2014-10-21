package com.xperiment.events
{
	import flash.events.Event;
	
	public class GotoTrialEvent extends Event
	{
		
		public var action:String; // nextTrial, prevTrial reserved, else use trialname
		
		public static const TRIAL_PING_FROM_OBJECT:String="trialPingFromObject";
		public static const RUNNER_PING_FROM_TRIAL:String="runnerPingFromTrial";
		
		public static const NEXT_TRIAL:String = 'nextTrial';
		public static const MAKER_NEXT_TRIAL:String = 'maker next Trial';
		public static const MAKER_PREV_TRIAL:String = 'maker prev Trial';
		public static const PREV_TRIAL:String = 'prevTrial';
		public static const GOTO_TRIAL:String = 'prevTrial';
		public static const FIRST_TRIAL:String ='fistTrial';
		public static const LAST_TRIAL:String = 'lastTrial';
		public static const RERUN_TRIAL:String= 'rerun last trial';
		
		
		public function GotoTrialEvent(type:String, action:String)
		{
			this.action=action;

			super(type);
		}
		
	}
}

