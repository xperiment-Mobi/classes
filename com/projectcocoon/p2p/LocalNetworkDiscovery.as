/*
* Copyright 2011 (c) Peter Elst, project-cocoon.com.
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package com.projectcocoon.p2p
{
	
	import com.projectcocoon.p2p.command.CommandList;
	import com.projectcocoon.p2p.command.CommandType;
	import com.projectcocoon.p2p.events.AccelerationEvent;
	import com.projectcocoon.p2p.events.ClientEvent;
	import com.projectcocoon.p2p.events.GroupEvent;
	import com.projectcocoon.p2p.events.MessageEvent;
	import com.projectcocoon.p2p.events.ObjectEvent;
	import com.projectcocoon.p2p.managers.GroupManager;
	import com.projectcocoon.p2p.managers.ObjectManager;
	import com.projectcocoon.p2p.util.ClassRegistry;
	import com.projectcocoon.p2p.vo.AccelerationVO;
	import com.projectcocoon.p2p.vo.ClientVO;
	import com.projectcocoon.p2p.vo.MessageVO;
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.sensors.Accelerometer;
	import flash.utils.Timer;
	
	
	/**
	 *  Dispatched when the local client successfully joined the central <code>NetGroup</code>
	 *
	 *  @eventType com.projectcocoon.p2p.events.GroupEvent.GROUP_CONNECTED
	 *  
	 */
	[Event(name="groupConnected", type="com.projectcocoon.p2p.events.GroupEvent")]
	
	/**
	 *  Dispatched when the central <code>NetGroup</code> has been closed (i.e. local client is no longer connected to the <code>NetGroup</code>)
	 *
	 *  @eventType com.projectcocoon.p2p.events.GroupEvent.GROUP_CLOSED
	 *  
	 */
	[Event(name="groupClosed", type="com.projectcocoon.p2p.events.GroupEvent")]
	
	/**
	 *  Dispatched when a new client has joined the <code>NetGroup</code>. Use the <code>client</code> property to access the <code>ClientVO</code> object.
	 * <b>Note:</b> when a new client joins, his <code>clientName</code> will be <code>null</code>. Use the <code>clientUpdate</code> event
	 * to get notified when his real <code>clientName</code> has been received.
	 *
	 *  @eventType com.projectcocoon.p2p.events.ClientEvent.CLIENT_ADDED
	 *  
	 */
	[Event(name="clientAdded", type="com.projectcocoon.p2p.events.ClientEvent")]
	
	/**
	 *  Dispatched when a client updates (e.g. <code>clientName</code> has changed). Use the <code>client</code> property to access the <code>ClientVO</code> object.
	 *
	 *  @eventType com.projectcocoon.p2p.events.ClientEvent.CLIENT_UPDATE
	 *  
	 */
	[Event(name="clientUpdate", type="com.projectcocoon.p2p.events.ClientEvent")]
	
	/**
	 *  Dispatched after a client has left the <code>NetGroup</code>. Use the <code>client</code> property to access the <code>ClientVO</code> object.
	 *
	 *  @eventType com.projectcocoon.p2p.events.ClientEvent.CLIENT_REMOVED
	 *  
	 */
	[Event(name="clientRemoved", type="com.projectcocoon.p2p.events.ClientEvent")]
	
	
	/**
	 *  Dispatched after arbitrary data sent by another client has been received by this client. Use the <code>message</code> property to access the <code>MessageVO</code> object that holds the data.
	 *
	 *  @eventType com.projectcocoon.p2p.events.MessageEvent.DATA_RECEIVED
	 *  
	 */
	[Event(name="dataReceived", type="com.projectcocoon.p2p.events.MessageEvent")]
	
	/**
	 *  Dispatched after acceleration data sent by another client has been received by this client. Use the <code>acceleration</code> property to access the <code>AccelerationVO</code> object that holds the data.
	 *
	 *  @eventType com.projectcocoon.p2p.events.AccelerationEvent.ACCELEROMETER
	 *  
	 */
	[Event(name="accelerometerUpdate", type="com.projectcocoon.p2p.events.AccelerationEvent")]
	
	/**
	 *  Dispatched after an object replication announcement has been received by this client. Use the <code>metadata</code> property to access the <code>ObjectMetadataVO</code> object that holds the data.
	 * 	To request an object (i.e. start replicating the object on this client) call <code>requestObject(event.metadata)</code> 
	 *
	 *  @eventType com.projectcocoon.p2p.events.ObjectEvent.OBJECT_ANNOUNCED
	 *  
	 */
	[Event(name="objectAnnounced", type="com.projectcocoon.p2p.events.ObjectEvent")]
	
	/**
	 *  Dispatched after an object replication started and while replication takes place. Use the <code>metadata</code> property to access the <code>ObjectMetadataVO</code> object that holds the data.
	 *
	 *  @eventType com.projectcocoon.p2p.events.ObjectEvent.OBJECT_PROGRESS
	 *  
	 */
	[Event(name="objectProgress", type="com.projectcocoon.p2p.events.ObjectEvent")]
	
	/**
	 *  Dispatched after an object has been completely received by this client and the data is valid (local hash matches remote hash). Use the <code>metadata</code> property to access the <code>ObjectMetadataVO</code> object that holds the data. 
	 *
	 *  @eventType com.projectcocoon.p2p.events.ObjectEvent.OBJECT_COMPLETE
	 *  
	 */
	[Event(name="objectComplete", type="com.projectcocoon.p2p.events.ObjectEvent")]
	
	/**
	 * The LocalNetworkDiscovery is the base class in Cocoon P2P.
	 */
	public class LocalNetworkDiscovery extends EventDispatcher
	{
		/**
		 * URL for LAN connectivity
		 */
		private static const RTMFP_LOCAL:String = "rtmfp:";
		
		/**
		 * URL for peer discovery through Adobe's Cirrus service
		 * @see http://labs.adobe.com/technologies/cirrus/
		 */ 
		private static const RTMFP_CIRRUS:String = "rtmfp://p2p.rtmfp.net";
	
		private var _clientName:String;
		private var _groupName:String = "com.projectcocoon.p2p.default";
		private var _multicastAddress:String = "225.225.0.1:30303";
		private var _url:String = RTMFP_LOCAL;
		private var _useCirrus:Boolean;
		private var _key:String;
		private var _autoConnect:Boolean = true;
		private var _nc:NetConnection;
		private var _group:NetGroup;
		private var _groupManager:GroupManager;
		private var _objectManager:ObjectManager;
		private var _localClient:ClientVO;
		private var _receiveLocal:Boolean;
		private var _acc:Accelerometer;
		private var _accelerometerInterval:uint = 0;
		private var _timer:Timer;
		
		public var _clients:Vector.<ClientVO> = new Vector.<ClientVO>();
		private var _sharedObjects:Vector.<ObjectMetadataVO>;
		private var _receivedObjects:Vector.<ObjectMetadataVO>;
	
		
		
		// ========================== //
		
		/**
		 * Creates a new instance. If the <code>autoConnect</code> property is set to <code>true</code> it will automatically create a connection after creation.
		 */
		public function LocalNetworkDiscovery()
		{
			registerClasses();
			initTimer();
		}
		
		/**
		 * Connects to the p2p network 
		 */		
		public function connect():void
		{
			removeTimer();
			close();
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			if (_url == RTMFP_CIRRUS)
			{
				if (!key || key.length == 0)
					throw new Error("To use Cirrus, you have to set your developer key")
				_nc.connect(RTMFP_CIRRUS, key);
			}
			else
			{
				_nc.connect(_url);
			}
		}
		
		/**
		 * Closes the connection and cleans up everything.
		 */ 
		public function close():void
		{
			cleanup();
		}
		
		/**
		 * Sends an arbitrary message (object, primitive, etc.) to a specific peer in the p2p network 
		 * @param value the message to send. Can be any type.
		 * @param groupID the group address of the peer (usually <code>ClientVO.groupID</code>)
		 */		
		public function sendMessageToClient(value:Object, groupID:String):void
		{
			var msg:MessageVO = _groupManager.sendMessageToGroupAddress(value, _group, groupID);
			if(loopback) 
				dispatchEvent(new MessageEvent(MessageEvent.DATA_RECEIVED, msg));
		}
		
		/**
		 * Sends an arbitrary message (object, primitive, etc.) to all peers in the p2p network 
		 * @param value the message to send. Can be any type.
		 */
		public function sendMessageToAll(value:Object):void
		{
			var msg:MessageVO = _groupManager.sendMessageToAll(value, _group);
			if(loopback) 
				dispatchEvent(new MessageEvent(MessageEvent.DATA_RECEIVED, msg));
		}
		
		/**
		 * Shares an arbitrary object (any type: object, primitive, etc.) with a specific peer in the p2p network.
		 * The peer will receive an <code>ObjectEvent.OBJECT_ANNOUNCED</code> event. To request the annonced object,
		 * the peer has to call <code>requestObject(event.metadata)</code>
		 * @param value the object to share. Can be any type.
		 */
		public function shareWithClient(value:Object, groupID:String, metadata:Object = null):void
		{
			share(value, groupID, metadata);
		}
		
		/**
		 * Shares an arbitrary object (any type: object, primitive, etc.) with all peers in the p2p network.
		 * The peer will receive an <code>ObjectEvent.OBJECT_ANNOUNCED</code> event. To request the annonced object,
		 * the peer has to call <code>requestObject(event.metadata)</code>
		 * @param value the object to share. Can be any type.
		 */
		public function shareWithAll(value:Object, metadata:Object = null):void
		{
			share(value, null, metadata);
		}
		
		/**
		 * Requests a shared object. Once requested, the object will be replicated.
		 * During replication, <code>ObjectEvent.OBJECT_PROGRESS</code> events get dispatched.
		 * When the object replication is finished, an <code>ObjectEvent.OBJECT_COMPLETE</code> event gets dispatched
		 * @param metadata the metadata of the requested object
		 */	
		public function requestObject(metadata:ObjectMetadataVO):void
		{
			var msg:MessageVO = getObjectManager().request(metadata);


			if (msg)
				receivedObjects.push(msg.data);
			
		}
		
		// ========================== //
		
		/**
		 * The <code>NetConnection</code> used
		 */
		public function get connection():NetConnection
		{
			return _nc;
		}
		
		/**
		 * The string representation of the group specifier
		 */
		public function get spec():String
		{
			return _groupManager.getGroupSpec(_group);
		}
		
		/**
		 * The local <code>ClientVO</code> object
		 */
		public function get localClient():ClientVO
		{
			return _localClient;
		}
		
		/**
		 * Number of connected clients
		 */

		public function get clientsConnected():uint
		{
			if (_groupManager && _group)
				return _groupManager.getClients(_group).length;
			return 0;
		}
		
		
		/**
		 * <code>Vector</code> filled with <code>ClientVO</code> objects representing all clients
		 */
		public function get clients():Vector.<ClientVO>
		{
			return _clients;
		}
		
		/**
		 * <code>Vector</code> filled with <code>ObjectMetadataVO</code> objects representing all objects shared by the local client
		 */		
		public function get sharedObjects():Vector.<ObjectMetadataVO>
		{
			if (!_sharedObjects)
			{
				_sharedObjects = new Vector.<ObjectMetadataVO>();
				dispatchEvent(new Event("sharedObjectsChange"));
			}
			return _sharedObjects;
		}
		
		/**
		 * <code>Vector</code> filled with <code>ObjectMetadataVO</code> objects representing all objects received by this client
		 */		
		public function get receivedObjects():Vector.<ObjectMetadataVO>
		{
			if (!_receivedObjects)
			{
				_receivedObjects = new Vector.<ObjectMetadataVO>();
				dispatchEvent(new Event("receivedObjectsChange"));
			}
			return _receivedObjects;
		}
		
		
		/**
		 * When true, the connection will get created automatically after initialization<p/>
		 * @default true
		 */
		public function get autoConnect():Boolean
		{
			return _autoConnect;
		}
		public function set autoConnect(value:Boolean):void
		{
			_autoConnect = value;
		}
		
		/**
		 * The name of the local client as it will appear in the list of clients
		 */
		public function get clientName():String
		{
			return _clientName;
		}
		public function set clientName(val:String):void
		{
			_clientName = val;
			if(_localClient) 
			{
				_localClient.clientName = val;
				announceName();
			}
		}		
		
		/**
		 * Specifies the name of the NetGroup where other peers will join in. <p/>
		 * <b>Note:</b> to avoid clashes with other applications, this should be something "unique",
		 * e.g. you should prefix the name with a reverse DNS name or something like that<p/>
		 * @default com.projectcocoon.p2p.default
		 */
		public function get groupName():String
		{
			return _groupName;
		}
		public function set groupName(val:String):void
		{
			_groupName = val;
		}
		
		/**
		 * Specifies the local multicast address that will be used by all clients.<p/>
		 * @default 225.225.0.1:30303
		 */ 
		public function get multicastAddress():String
		{
			return _multicastAddress;
		}
		public function set multicastAddress(val:String):void
		{
			_multicastAddress = val;
		}
		
		/**
		 * When set to true, the local client will receive messages sent to other peers as well
		 * (helpful when building chat applications)<p/>
		 * @default false
		 */ 
		public function get loopback():Boolean
		{
			return _receiveLocal;
		}
		public function set loopback(bool:Boolean):void
		{
			_receiveLocal = bool;
		}
		
		/**
		 * Your Cirrus developer key, needed when using Cirrus
		 * @see http://labs.adobe.com/technologies/cirrus/
		 */ 
		public function get key():String
		{
			return _key;
		}
		public function set key(value:String):void
		{
			_key = value;
		}
		
		/**
		 * The RTMFP URL to connect to. 
		 * @default rtmfp:
		 */
		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			_url = value;
		}
		
		/**
		 * When set to true, the connection will be made against the Cirrus peer introduction service
		 * which allows to connect to peers on different networks instead of using local peer discovery<p/>
		 * @default false
		 */
		public function get useCirrus():Boolean
		{
			return _useCirrus;
		}
		public function set useCirrus(value:Boolean):void
		{
			_useCirrus = value;
			if (_useCirrus)
				_url = RTMFP_CIRRUS;
		}

		/**
		 * Sets the desired time interval (in milliseconds) to use for reading updates from the <code>Accelerometer</code>
		 */
		public function get accelerometerInterval():uint
		{
			return _accelerometerInterval;	
		}
		public function set accelerometerInterval(val:uint):void
		{
			if (!Accelerometer.isSupported)
				return;
			
			_accelerometerInterval = val;
			
			if (_acc)
				_acc.setRequestedUpdateInterval(_accelerometerInterval);
		}
		
		
		// ============= Private ============= //
		
		private function registerClasses():void
		{
			ClassRegistry.registerClasses();
		}
		
		private function initTimer():void
		{
			_timer = new Timer(500, 1);
			_timer.addEventListener(TimerEvent.TIMER, timerComplete);
			_timer.start();
		}
		
		private function removeTimer():void
		{
			if (_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, timerComplete);	
				_timer.stop();
				_timer = null;
			}
		}
		
		private function timerComplete(event:TimerEvent):void
		{
			removeTimer();
			if (autoConnect)
				connect();
		}
		
		
		private function cleanup():void
		{
			// do some cleanup
			if (_nc)
			{
				_nc.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				if (_nc.connected)
					_nc.close();
				_nc = null;
			}
			
			if (_groupManager)
			{
				_groupManager.removeEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
				_groupManager.removeEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);
				_groupManager.removeEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
				_groupManager.removeEventListener(ClientEvent.CLIENT_REMOVED, onClientRemoved);
				_groupManager.removeEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdate);
				_groupManager.removeEventListener(MessageEvent.DATA_RECEIVED, onDataReceived);
				_groupManager.removeEventListener(ObjectEvent.OBJECT_ANNOUNCED, onObjectAnnounced);
				_groupManager = null;
			}
			
			if (_objectManager)
			{
				_objectManager.removeEventListener(ObjectEvent.OBJECT_PROGRESS, onObjectProgress);
				_objectManager.removeEventListener(ObjectEvent.OBJECT_COMPLETE, onObjectComplete);
				_objectManager = null;
			}
			
			if (_acc)
			{
				_acc.removeEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
				_acc = null;
			}
			
			if (_group)
				_group = null;
			
			if (_localClient)
				_localClient = null;
			

			
			
			_clients = new Vector.<ClientVO>();				
			
			
			dispatchEvent(new Event("clientsChange"));		
		}
		
		private function setupGroup():void
		{
			
			// create and setup the GroupManager
			_groupManager = new GroupManager(_nc, multicastAddress);
			
			_groupManager.addEventListener(GroupEvent.GROUP_CONNECTED, onGroupConnected);
			_groupManager.addEventListener(GroupEvent.GROUP_CLOSED, onGroupClosed);
			_groupManager.addEventListener(ClientEvent.CLIENT_ADDED, onClientAdded);
			_groupManager.addEventListener(ClientEvent.CLIENT_REMOVED, onClientRemoved);
			_groupManager.addEventListener(ClientEvent.CLIENT_UPDATE, onClientUpdate);
			_groupManager.addEventListener(MessageEvent.DATA_RECEIVED, onDataReceived);
			_groupManager.addEventListener(ObjectEvent.OBJECT_ANNOUNCED, onObjectAnnounced);	
			
			// create the group
			_group = _groupManager.createNetGroup(groupName);
			
		}
		
		private function getObjectManager():ObjectManager
		{
			if (!_objectManager)
			{
				_objectManager = new ObjectManager(_groupManager, _group);
				_objectManager.addEventListener(ObjectEvent.OBJECT_PROGRESS, onObjectProgress);
				_objectManager.addEventListener(ObjectEvent.OBJECT_COMPLETE, onObjectComplete);
			}
			return _objectManager;
		}

		private function getClientName():String
		{
			if(!_clientName) 
				_clientName = "";
			return _clientName;
		}
		
		private function announceName():void
		{
			// announce ourself to the other peers
			_groupManager.announceToGroup(_group);
		}
		
		private function share(value:Object, groupID:String, metadata:Object):void
		{
			var msg:MessageVO = getObjectManager().share(value, groupID, metadata);
			
			sharedObjects.push(msg.data); // add the ObjectMetadataVO to the list of shared Objects
			
		}
		
		// ============= Event Handlers ============= //
		
		private function onNetStatus(evt:NetStatusEvent):void
		{
			switch (evt.info.code) 
			{
				case NetStatusCode.NETCONNECTION_CONNECT_SUCCESS:
					setupGroup();
					break;
				// TODO: add NetConnection disconnect handling and maybe reconnecting...
			}
		}
		
		private function onGroupConnected(event:GroupEvent):void
		{
			if (event.group == _group)
			{
				_localClient = _groupManager.getLocalClient(_group);
				_localClient.clientName = getClientName();
			}
			setupAccelerometer(); 
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function setupAccelerometer():void
		{
			shutdownAccelerometer();
			if (Accelerometer.isSupported && _accelerometerInterval > 0) 
			{
				_acc = new Accelerometer();
				_acc.setRequestedUpdateInterval(_accelerometerInterval);
				_acc.addEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
			}
		}
		
		private function shutdownAccelerometer():void
		{
			if (_acc) 
			{
				_acc.removeEventListener(AccelerometerEvent.UPDATE, onAccelerometer);
				_acc = null;
			}
		}
		
		private function onGroupClosed(event:GroupEvent):void
		{
			// shutdown Accelerometer
			shutdownAccelerometer();
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		
		private function onClientAdded(event:ClientEvent):void
		{
			if (event.group == _group)
			{
				
				_clients.push(event.client);	
				
				dispatchEvent(new Event("clientsConnectedChange"));
				if (event.client.isLocal)
					event.client.clientName = getClientName();
				announceName();
			}
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onClientRemoved(event:ClientEvent):void
		{
			if (event.group == _group)
			{
				
				_clients.splice(_clients.indexOf(event.client), 1);
				
				dispatchEvent(new Event("clientsConnectedChange"));
			}
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onClientUpdate(event:ClientEvent):void
		{
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onDataReceived(event:MessageEvent):void
		{
			if(event.group == _group && event.message.command == CommandList.ACCELEROMETER) 
			{
				var acc:AccelerationVO = event.message.data as AccelerationVO;
				dispatchEvent(new AccelerationEvent(AccelerationEvent.ACCELEROMETER, acc));
			}
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onAccelerometer(evt:AccelerometerEvent):void
		{
			var acc:AccelerationVO = new AccelerationVO(_localClient, evt.accelerationX, evt.accelerationY, evt.accelerationZ, evt.timestamp);
			var msg:MessageVO = _groupManager.sendMessageToAll(acc, _group, CommandType.SERVICE, CommandList.ACCELEROMETER);
			if(loopback) 
				onDataReceived(new MessageEvent(MessageEvent.DATA_RECEIVED, msg, _group));
		}

		private function onObjectAnnounced(event:ObjectEvent):void
		{
			// distribute the event
			dispatchEvent(event.clone());	
		}
		
		private function onObjectComplete(event:ObjectEvent):void
		{
			// distribute the event
			dispatchEvent(event.clone());
		}
		
		private function onObjectProgress(event:ObjectEvent):void
		{
			// distribute the event
			dispatchEvent(event.clone());
		}
		
	}
	
}