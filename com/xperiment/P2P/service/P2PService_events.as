package com.xperiment.P2P.service
{
	import flash.events.Event;
	
	public class P2PService_events extends Event
	{
		
		public static var GENERAL:String="general"; //ALL of these events are General
		
		public static var CONNECTED:String="connected";
		public static var FILE_LOADED:String="all_loaded";
		public static var LOADING:String="files_loading";
		public static var CLIENT_ADDED:String = "client_added";
		public static var FILELIST:String = "fileList";
		public static var PEER_ADDED:String = "PEER_ADDED"
		public static var EXPT_DATA:String = "expt data";
		public static  var PEER_REMOVED:String = "PEER_REMOVED";
		public static var MESSAGE:String	  = "message"
		public static var STUDY_META:String = "study meta info";	
		public static var FILE_LOADING:String = "file loading";
		//public static var BOSS_ADDED:String = "boss added";
		
		public var what:String;
		public var obj:Object;
		
		
		
		
		public function P2PService_events(what:String, obj:Object=null,bubbles:Boolean=false)
		{
			this.what=what;
			this.obj=obj;
			super(GENERAL,bubbles);
		}
	}
}