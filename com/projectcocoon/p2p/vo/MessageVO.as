package com.projectcocoon.p2p.vo
{
	
	/**
	 * Stores message information 
	 */
	public class MessageVO
	{

		private static var SEQ:uint = 0;
		
		public var client:ClientVO;
		public var data:Object;
		public var destination:String;
		public var type:String;
		public var command:String;
		public var sequenceId:uint;
		public var timestamp:Date;
		
		/**
		 * Stores messages. To maintain type-safety when sending custom data types across the network make sure to use <code>registerClassAlias()</code> on your custom types. 
		 * @param client the client who sent this message
		 * @param data the user data of this message
		 * @param destination the group address to send this message to 
		 * @param type used internally
		 * @param command used internally
		 * 
		 */		
		public function MessageVO(client:ClientVO=null, data:Object=null, destination:String="", type:String="", command:String="")
		{
			this.client = client;
			this.data = data;
			this.destination = destination;
			this.type = type;
			this.command = command;
			timestamp = new Date();
			sequenceId = ++SEQ;
		}
		
		/**
		 * Is this a direct message?
		 * @return true if this is a direct (private) message
		 * 
		 */		
		public function get isDirectMessage():Boolean
		{
			return (destination && destination != "") 
		}
		
		public function toString():String
		{
			return "MessageVO{client: " + client + ", data: " + data + ", destination: \"" + destination + "\", type: \"" + type + "\", command: \"" + command + "\", sequenceId: " + sequenceId + ", timestamp: " + timestamp + "}";
		}

	}
	
}