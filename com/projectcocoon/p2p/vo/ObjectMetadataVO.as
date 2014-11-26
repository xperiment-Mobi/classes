package com.projectcocoon.p2p.vo
{
	/**
	 * Stores object replication information 
	 */
	public class ObjectMetadataVO
	{
		/**
		 * unique identifier for this object replication 
		 */		
		public var identifier:String;
		
		/**
		 * size (in bytes) for this object replication
		 */
		public var size:uint;
		
		/**
		 * amount of chunks for this object
		 */
		public var chunks:uint;
		
		/**
		 * used internally 
		 */
		public var info:Object;
		
		/**
		 * amount of chunks already received 
		 */
		[Transient]
		public var chunksReceived:int;
		
		/**
		 * the object itself (or null if it's not yet fully replicated) 
		 */
		[Transient]
		public var object:Object;
		
		public function ObjectMetadataVO()
		{
			chunksReceived = 0;
		}
		
		/**
		 * Progress percentage 
		 * @return percentag
		 */		
		public function get progress():Number
		{
			if (chunks > 0)
				return chunksReceived / chunks;
			return 0;
		}
		
		/**
		 * Is this object complete?
		 * @return true if the object has been fully replicated
		 */		
		public function get isComplete():Boolean
		{
			return progress == 1;
		}
	}
}