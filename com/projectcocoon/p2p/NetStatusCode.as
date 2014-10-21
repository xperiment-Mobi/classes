package com.projectcocoon.p2p
{
	/**
	 * Helper class containing the NetConnection codes 
	 */	
	public class NetStatusCode
	{

		// NetConnection connectivity related
		public static const NETCONNECTION_CONNECT_SUCCESS:String = "NetConnection.Connect.Success";
		public static const NETCONNECTION_CONNECT_CLOSED:String = "NetConnection.Connect.Closed";
		public static const NETCONNECTION_CONNECT_FAILED:String = "NetConnection.Connect.Failed";
		
		// NetGroup connectivity related
		public static const NETGROUP_CONNECT_SUCCESS:String = "NetGroup.Connect.Success";
		public static const NETGROUP_CONNECT_CLOSED:String = "NetGroup.Connect.Closed";
		public static const NETGROUP_CONNECT_FAILED:String = "NetGroup.Connect.Failed";
		public static const NETGROUP_CONNECT_REJECTED:String = "NetGroup.Connect.Rejected";
		
		// neighbour related
		public static const NETGROUP_NEIGHBOUR_CONNECT:String = "NetGroup.Neighbor.Connect";
		public static const NETGROUP_NEIGHBOUR_DISCONNECT:String = "NetGroup.Neighbor.Disconnect"; 
		
		// posting / routing related
		public static const NETGROUP_POSTING_NOTIFY:String = "NetGroup.Posting.Notify";
		public static const NETGROUP_SENDTO_NOTIFY:String = "NetGroup.SendTo.Notify";
		
		// object replication related
		public static const NETGROUP_REPLICATION_REQUEST:String = "NetGroup.Replication.Request";
		public static const NETGROUP_REPLICATION_FETCH_RESULT : String = "NetGroup.Replication.Fetch.Result";
		public static const NETGROUP_REPLICATION_FETCH_FAILED : String = "NetGroup.Replication.Fetch.Failed";
		public static const NETGROUP_REPLICATION_FETCH_SENDNOTIFY:String = "NetGroup.Replication.Fetch.SendNotify";
		
		
	}
}