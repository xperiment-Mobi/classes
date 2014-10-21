package com.projectcocoon.p2p.events
{
	import com.projectcocoon.p2p.vo.ClientVO;
	
	import flash.events.Event;
	import flash.net.NetGroup;
	
	/**
	 * Used to signal group events 
	 */	
	public class GroupEvent extends Event
	{
		
		public static const GROUP_CONNECTED:String = "groupConnected";
		public static const GROUP_CLOSED:String = "groupClosed";
		
		public var group:NetGroup;
		
		public function GroupEvent(type:String, group:NetGroup)
		{
			super(type);
			this.group = group;
		}
		
		public override function clone():Event
		{
			return new GroupEvent(type, group);
		}

	}
}