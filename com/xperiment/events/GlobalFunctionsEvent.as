package com.xperiment.events
{
	import flash.events.Event;
	
	public class GlobalFunctionsEvent extends Event
	{
		
		public var command:String;
		public var values: *;
		
		public static var COMMAND:String="command";
		public static var GOTO_TRIAL:String = "next trial";
		public static var QUIT:String = "quit";
		public static var FINISH_STUDY:String = "finish study";
		public static var FINISH_STUDY_MENU:String = "saveDataEndStudyMenu";
		public static var LANGUAGE:String = "language";
		public static var SAVE_DATA:String = "save data";
		public static var RESTART_STUDY:String = "restart";
		public static var P2P_GIVE_EXPT_STUFF:String = "p2p give expt stuff";
		public static var GIVE_RUNNER:String = "give runner";
		public static var STIM_SELECTED:String = "stimulus selected";
		public static var START_TRIAL:String = "start trial";
		public static var END_TRIAL:String = "end trial";
		public static var MOBILE_QUIT:String ="mobile quit";
		public static var PROBLEM:String = "problem";
		public static var CHANGE_TRIALORDER:String = "change trial order";
		public static var MTURK_SUBMIT:String = "submit mechanical turk";
		
		
		public function GlobalFunctionsEvent(type:String, command:String,values:* = "")
		{
			this.command=command;
			this.values=values;
			super(type);
		}
	}
}