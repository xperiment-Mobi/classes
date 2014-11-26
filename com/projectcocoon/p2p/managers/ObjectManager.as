package com.projectcocoon.p2p.managers
{
	import com.projectcocoon.p2p.NetStatusCode;
	import com.projectcocoon.p2p.command.CommandList;
	import com.projectcocoon.p2p.command.CommandType;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.events.ObjectEvent;
	import com.projectcocoon.p2p.util.SerializationUtil;
	import com.projectcocoon.p2p.vo.MessageVO;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetGroup;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	[Event(name="objectAnnounced", type="com.projectcocoon.p2p.events.ObjectEvent")]
	[Event(name="objectRequest", type="com.projectcocoon.p2p.events.ObjectEvent")]
	[Event(name="objectProgress", type="com.projectcocoon.p2p.events.ObjectEvent")]
	[Event(name="objectComplete", type="com.projectcocoon.p2p.events.ObjectEvent")]
	public class ObjectManager extends EventDispatcher
	{
		
		public static var CHUNKSIZE:uint = 64 * 1024; // 64KBytes
		
		private var groupManager:GroupManager;
		private var dataDictionary:Dictionary;		// key = String 	value = Vector.<ByteArray>
		private var senderDictionary:Dictionary; 	// key = NetGroup 	value = ObjectMetadataVO
		private var receiverDictionary:Dictionary;	// key = NetGroup 	value = ObjectMetadataVO
		private var announcementGroup:NetGroup;
		
		public function ObjectManager(groupManager:GroupManager, announcementGroup:NetGroup)
		{
			if (!groupManager || !announcementGroup)
				throw new Error("GroupManager and/or NetGroup is null");
			
			this.groupManager = groupManager;
			this.announcementGroup = announcementGroup;
			
			groupManager.addEventListener(MessageEvent.DATA_RECEIVED, onDataReceived);
			groupManager.addEventListener(ObjectEvent.OBJECT_ANNOUNCED, onObjectAnnounced);
			groupManager.addEventListener(ObjectEvent.OBJECT_REQUEST, onObjectRequest);
			groupManager.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
			groupManager.addEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);
			
			dataDictionary = new Dictionary();
			senderDictionary = new Dictionary();
			receiverDictionary = new Dictionary();
		}

		/**
		 * Start sharing an object
		 * @param value the Object to share (can be anything except null)
		 * @param groupID the Group Address of the peer with whom this Object should be shared (if null, all peers will get the object announcement)
		 * @param info an Object with arbitary data to be send along (e.g. filename, extra information etc.)
		 * @return the message
		 */
		public function share(value:Object, groupID:String = null, info:Object = null):MessageVO
		{
			if (!value)
				throw new ArgumentError("value must not be null");
			
			// serialize the data to a ByteArray
			var data:ByteArray = new SerializationUtil().serialize(value);
			var metadata:ObjectMetadataVO = getMetaData(data, info);
			
			data.position = 0;
			
			// split up the bytes into chunks and store them in a Vector
			var chunks:uint = metadata.chunks;
			var dataVector:Vector.<ByteArray> = initializeDataVector(chunks);
			var i:int;
			var buf:ByteArray;
			for (i = 0; i < chunks; i++)
			{
				buf = new ByteArray();
				if (i == chunks-1)
				{
					data.readBytes(buf, 0, data.bytesAvailable);	
				}
				else
				{
					data.readBytes(buf, 0, CHUNKSIZE);	
				}
				buf.position = 0;
				dataVector[i] = buf;
			}
			
			// store information 
			dataDictionary[metadata.identifier] = new ObjectData(metadata, dataVector);
			
			// announce
			var msg:MessageVO;
			if (groupID)
				msg = groupManager.sendMessageToGroupAddress(metadata, announcementGroup, groupID, CommandType.SERVICE, CommandList.ANNOUNCE_SHARING);
			else
				msg = groupManager.sendMessageToAll(metadata, announcementGroup, CommandType.SERVICE, CommandList.ANNOUNCE_SHARING);
			
			return msg;
		}
		
		/**
		 * Requests a shared object. Once requested, the object will be replicated.
		 * During replication, <code>ObjectEvent.OBJECT_PROGRESS</code> events get dispatched.
		 * When the object replication is finished, an <code>ObjectEvent.OBJECT_COMPLETE</code> event gets dispatched
		 * @param metadata the metadata of the requested object
		 */		
		public function request(metadata:ObjectMetadataVO):MessageVO
		{
			// already requested?
			if (dataDictionary[metadata.identifier] is ObjectData)
				return null;
			
			// inform the sharer that we want the object
			var msg:MessageVO = groupManager.sendMessageToAll(metadata, announcementGroup, CommandType.SERVICE, CommandList.REQUEST_OBJECT);
			
			// join the group where the object will be shared
			var group:NetGroup = groupManager.createNetGroup(metadata.identifier);
			
			// store data 
			var dataVector:Vector.<ByteArray> = initializeDataVector(metadata.chunks);
			dataDictionary[metadata.identifier] = new ObjectData(metadata, dataVector);
			receiverDictionary[group] = metadata;
			
			return msg;
		}
		
		// ============= Private ============= //
		
		private function getMetaData(data:ByteArray, info:Object):ObjectMetadataVO
		{
			var metadata:ObjectMetadataVO = new ObjectMetadataVO();
			metadata.identifier = getIdentifier(data);
			metadata.size = data.length;
			metadata.chunks = getChunks(data);
			metadata.info = info;
			return metadata;
		}
		
		private function getIdentifier(data:ByteArray):String
		{
			return getOneAtATimeHash(data) + "=" + new Date().time.toString(16);
		}
		
		private function getChunks(data:ByteArray):uint
		{
			return Math.floor(data.length / CHUNKSIZE) + 1;
		}
		
		private function initializeDataVector(chunks:uint):Vector.<ByteArray>
		{
			var dataVector:Vector.<ByteArray> = new Vector.<ByteArray>(chunks, true);
			var i:uint;
			for (i = 0; i < chunks; i++)
				dataVector[i] = null;
			return dataVector;
		}
		
		private function startSeeding(netGroup:NetGroup):void
		{
			var metadata:ObjectMetadataVO = senderDictionary[netGroup];
			if (metadata)
			{
				netGroup.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				var data:ObjectData = dataDictionary[metadata.identifier];
				if (data)
				{
					trace("start seeding " + metadata.identifier);
					netGroup.addHaveObjects(0, data.dataVector.length-1);
				}
				else
				{
					trace("ERROR: no data found for " + metadata.identifier);
				}
			}
		}

		private function startLeeching(netGroup:NetGroup):void
		{
			var metadata:ObjectMetadataVO = receiverDictionary[netGroup];
			if (metadata)
			{
				netGroup.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				var data:ObjectData = dataDictionary[metadata.identifier];
				if (data)
				{
					trace("start leeching " + metadata.identifier);
					netGroup.addWantObjects(0, data.dataVector.length-1);
				}
				else
				{
					trace("ERROR: no data found for " + metadata.identifier);
				}
			}
		}
		
		private function handleRequest(event:NetStatusEvent):void
		{
			var netGroup:NetGroup = event.target as NetGroup;
			var metadata:ObjectMetadataVO = senderDictionary[netGroup];
			if (metadata)
			{
				var data:ObjectData = dataDictionary[metadata.identifier];
				if (data)
				{
					trace("serving index " + event.info.index);
					netGroup.writeRequestedObject(event.info.requestID, data.dataVector[event.info.index]);
				}
			}
		}
		
		private function handleResult(event:NetStatusEvent):void
		{
			var netGroup:NetGroup = event.target as NetGroup;
			var metadata:ObjectMetadataVO = receiverDictionary[netGroup];
			if (metadata)
			{
				var data:ObjectData = dataDictionary[metadata.identifier];
				if (data)
				{
					metadata.chunksReceived++;
					var idx:uint = event.info.index;
					data.dataVector[idx] = event.info.object;
					
					trace("received chunk " + (idx+1) + "/" + metadata.chunks + " of " + metadata.identifier);
					dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_PROGRESS, metadata));
					
					if (!senderDictionary[netGroup])
					{
						// start seeding 
						senderDictionary[netGroup] = metadata;
					}
					netGroup.addHaveObjects(idx, idx);
					
					if (metadata.chunksReceived == metadata.chunks)
					{
						trace("object " + metadata.identifier + " completed!");
						reassembleObject(metadata);
					}
				}
				else
				{
					trace("ERROR: no data found for " + metadata.identifier);
				}
			}
		}
		
		private function reassembleObject(metadata:ObjectMetadataVO):void
		{
			var data:ObjectData = dataDictionary[metadata.identifier];
			if (data)
			{
				var i:int;
				var buffer:ByteArray = new ByteArray();
				for (i = 0; i < data.dataVector.length; i++)
				{
					buffer.writeBytes(data.dataVector[i]);
				}
				if (buffer.length == metadata.size)
				{
					if (checkHash(buffer, metadata.identifier))
					{
						var object:Object = new SerializationUtil().deserialize(buffer);
						if (object)
						{
							// all ok 
							metadata.object = object;
							dispatchEvent(new ObjectEvent(ObjectEvent.OBJECT_COMPLETE, metadata));
						}
						else
						{
							// object could not get reassembled...
							throw new Error("Deserialization Error: error reassembling object");
						}
					}
					else
					{
						throw new Error("Deserialization Error: Hash mismatch");
					}
				}
				else
				{
					// length does not match...
					throw new Error("Deserialization Error: received bytes != shared bytes");
				}
			}
		}
		
		private function checkHash(buffer:ByteArray, identifier:String):Boolean
		{
			try
			{
				return identifier.split("=")[0] == getOneAtATimeHash(buffer);	
			}
			catch (e:Error)
			{
			}
			return false;
		}
		
		private function handleNotify(event:NetStatusEvent):void
		{
			// TODO Auto Generated method stub
			trace("replication notify")
		}
		
		private function handleFault(event:NetStatusEvent):void
		{
			// TODO Auto Generated method stub
			trace("replication fault")
		}
		
		/**
		 * @private
		 * Use Jenkins One-at-a-Time-Hash on a ByteArray
		 * Adopted from http://en.wikibooks.org/wiki/Algorithm_Implementation/Hashing
		 */ 
		private function getOneAtATimeHash(key:ByteArray):String
		{
			var hash:int = 0;
			var b:int;
			key.position = 0;
			while (key.bytesAvailable > 0) 
			{
				b = key.readByte()
				hash += (b & 0xFF);
				hash += (hash << 10);
				hash ^= (hash >>> 6);
			}
			key.position = 0;
			hash += (hash << 3);
			hash ^= (hash >>> 11);
			hash += (hash << 15);
			return hash.toString(16);
		}
		
		// ============= Event Handlers ============= //
		
		private function onGroupClosed(event:GroupEvent):void
		{
			var group:NetGroup = event.group;
			var metadata:ObjectMetadataVO = senderDictionary[group];
			if (!metadata)
				metadata = receiverDictionary[group];
			if (metadata)
			{
				delete dataDictionary[metadata.identifier];
			}
			delete senderDictionary[group];
			delete receiverDictionary[group];
		}
		
		private function onGroupConnected(event:GroupEvent):void
		{
			var group:NetGroup = event.group;
			if (senderDictionary[group])
			{
				startSeeding(group);
			}
			else if (receiverDictionary[group])
			{
				startLeeching(group);
			}
		}
		
		private function onDataReceived(event:Event):void
		{
		}
		
		private function onObjectAnnounced(event:ObjectEvent):void
		{
		}
		
		private function onObjectRequest(event:ObjectEvent):void
		{
			var metadata:ObjectMetadataVO = event.metadata;

			if (dataDictionary[metadata.identifier])
			{
				
				// join the group where the object will be shared
				var group:NetGroup = groupManager.createNetGroup(metadata.identifier);
				senderDictionary[group] = metadata;
			}
			
		}
		
		private function onNetStatus(event:NetStatusEvent):void
		{
			// Important: this event handler only works on the NetGroups where
			// the objects get shared, *not* on the main NetGroup where the
			// announcements get made!
			switch (event.info.code) 
			{
				case NetStatusCode.NETGROUP_REPLICATION_REQUEST:
					handleRequest(event);
					break;
				case NetStatusCode.NETGROUP_REPLICATION_FETCH_RESULT:
					handleResult(event);
					break;
				case NetStatusCode.NETGROUP_REPLICATION_FETCH_FAILED:
					handleFault(event);
					break;
				case NetStatusCode.NETGROUP_REPLICATION_FETCH_SENDNOTIFY:
					handleNotify(event);
					break;
				case NetStatusCode.NETGROUP_CONNECT_CLOSED:
				case NetStatusCode.NETGROUP_CONNECT_FAILED:
				case NetStatusCode.NETGROUP_CONNECT_REJECTED:
					// todo: cleanup things
					break;
			}
		}
		
		
	}
}
import com.projectcocoon.p2p.vo.ObjectMetadataVO;

import flash.utils.ByteArray;

class ObjectData
{
	public var metadata:ObjectMetadataVO;
	public var dataVector:Vector.<ByteArray>;

	public function ObjectData(metadata:ObjectMetadataVO, dataVector:Vector.<ByteArray>)
	{
		this.metadata = metadata;
		this.dataVector = dataVector;
	}
}