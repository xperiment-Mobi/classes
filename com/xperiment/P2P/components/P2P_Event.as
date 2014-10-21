package com.xperiment.P2P.components
{
	import flash.events.Event;
	
	public class P2P_Event extends Event
	{
		public var data:Object;
		public var data2:Object;
		
		public static var START_STUDY:String="start study";
		public static var NEXT_TRIAL:String="next trial";
		public static var FINISH_STUDY:String="finish study";
		
		public static var BUTTON_PRESSED:String = "button pressed";
		public static var __CONNECTED_TO_EXPT:String = "connected to experiment & started to receive data files";
		public static var __FILE_LOADED:String = "All experiment files loaded. Waiting for Experimenter to start the experiment...";
		//public static var __ALL_EXPT_FILES_LOADED:String = "All experiment files loaded. Waiting for Experimenter to start the experiment...";
		public static var PEER_MESSAGE:String = "peer message";
		public static var TRIAL_CHANGE:String = "trial change";
		public static var LOADED_STIM:String = "loaded the stimuli in P2P_expt";
		
		
		
		
		public function P2P_Event(type:String,data:Object,data2:Object=null)
		{
			this.data=data;
			this.data2=data2;
			super(type,true);
		}
	}
}