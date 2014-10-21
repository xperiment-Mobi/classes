package com.projectcocoon.p2p.events
{
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.events.Event;
	
	/**
	 * Used to signal object events 
	 */	
	public class ObjectEvent extends Event
	{
		
		public static const OBJECT_ANNOUNCED:String = "objectAnnounced";
		public static const OBJECT_REQUEST:String = "objectRequest";
		public static const OBJECT_PROGRESS:String = "objectProgress";
		public static const OBJECT_COMPLETE:String = "objectComplete";
		
		public var metadata:ObjectMetadataVO;
		
		public function ObjectEvent(type:String, metadata:ObjectMetadataVO)
		{
			super(type);
			this.metadata = metadata;
		}
		
		public override function clone():Event
		{
			return new ObjectEvent(type, metadata);
		}

	}
}