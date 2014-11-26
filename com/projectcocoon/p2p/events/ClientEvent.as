package com.projectcocoon.p2p.events
{
	import com.projectcocoon.p2p.vo.ClientVO;
	
	import flash.events.Event;
	import flash.net.NetGroup;
	
	/**
	 * Used to signal client events 
	 */	
	public class ClientEvent extends Event
	{
		
		public static const CLIENT_ADDED:String = "clientAdded";
		public static const CLIENT_UPDATE:String = "clientUpdate";
		public static const CLIENT_REMOVED:String = "clientRemoved";
		

		public var client:ClientVO;
		public var group:NetGroup;
		
		public function ClientEvent(type:String, client:ClientVO=null, group:NetGroup=null)
		{
			super(type);
			this.client = client;
			this.group = group;
		}
		
		override public function clone():Event
		{
			return new ClientEvent(type, client, group);
		}		
		
	}
}