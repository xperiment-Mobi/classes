package com.projectcocoon.p2p.vo
{
	
	/**
	 * Stores client information 
	 */
	public class ClientVO
	{
		
		/**
		 * Name of this client 
		 */		
		public var clientName:String;
		
		/**
		 * Clients peer ID
		 */  
		public var peerID:String;
		
		/**
		 * Clients group address
		 */  
		public var groupID:String;
		
		/**
		 * True if this <code>ClientVO</code> is the local client
		 */
		[Transient]
		public var isLocal:Boolean;
		
		/**
		 * Stores client information 
		 * @param clientName client name
		 * @param peerID client ID
		 * @param groupID client's group ID
		 * 
		 */		 
		public function ClientVO(clientName:String = null, peerID:String = null, groupID:String = null)
		{
			this.clientName = clientName;
			this.peerID = peerID;
			this.groupID = groupID;
		}
		
	}
}