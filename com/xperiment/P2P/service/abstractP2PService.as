package com.xperiment.P2P.service
{
	import com.xperiment.P2P.service.files.P2PService_file;
	
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetGroupReplicationStrategy;
	import flash.utils.ByteArray;


	public class abstractP2PService extends Sprite
	{
				
		private const SERVER:String   = "rtmfp://stratus.adobe.com/";
		private const DEVKEY:String   = "8eb8deed424176bf57f3645e-1823ee5b6114";
		private const GROUP:String	  = "xperiment/mobi";
		
		private const SEND_ID:String = "<ID>";
		
		private var connected:Boolean = false;
		private var netConnection:NetConnection;
		private var netGroup:NetGroup;
		private var files:P2PService_file = new P2PService_file;
		private var numChunks:int = 0;
		private var groupAddress:String;
		
		public var study:String = '';
		public var peers:Peers = new Peers;
		public var local:Boolean = false;
		
		public var listenersList:Array = [
			{e:NetStatusEvent.NET_STATUS,f:netStatus},
			{e:IOErrorEvent.IO_ERROR,f:errorL},
			{e:AsyncErrorEvent.ASYNC_ERROR, f:errorL},
			{e:SecurityErrorEvent.SECURITY_ERROR,f:errorL}
			];
		
		
		
		public function kill():void{
			netGroup.close();
			netConnection.close();
			this.removeChild(files);
			files.kill();
			if(netConnection)listeners(netConnection,false);
			if(netGroup)listeners(netGroup,false);
		}
		
		public function abstractP2PService(name:String,study:String, local:Boolean)
		{
			this.name=name;
			this.study=study;
			//trace(local,11)
			this.local=local;
			this.addChild(files);
			connect();
		}
		
		private function connect():void
		{
			netConnection = new NetConnection();
			
			listeners(netConnection,true);

			if(local)	netConnection.connect("rtmfp:");
			else		netConnection.connect(SERVER+DEVKEY);
		}	
		
		private function listeners(what:*,on:Boolean):void{
			var f:Function;
			if(on)f=what.addEventListener;
			else  f=what.removeEventListener;
			
			for each(var listenObj:Object in listenersList){
				f(listenObj.e,listenObj.f);
			}
		}
		
		protected function errorL(e:Event):void
		{
			trace('errorL',e);
			
		}
		

		
		public function netStatus(e:NetStatusEvent):void{
			
		
			switch(e.info.code){
				case "NetConnection.Connect.Success":
					//trace(e.info.code);
					setupGroup();
					break;
				
				case "NetGroup.Connect.Success":
					
					this.dispatchEvent(new P2PService_events(P2PService_events.CONNECTED));
					connected = true;
					netGroup.replicationStrategy = NetGroupReplicationStrategy.LOWEST_FIRST;
					this.groupAddress = netGroup.convertPeerIDToGroupAddress(getPeerId());
					//sends own credentials back to boss
					if(this is P2PService_peer)sendMessage(SEND_ID+netConnection.nearID);
						
					
					break;
				
				case "NetGroup.SendTo.Notify":

					//bit of a bodge as for some reason e.info.fromLocal does not work when sending data to P2P_Expt
					if(this is P2PService_expt && e.info.message.hasOwnProperty("data"))
						this.dispatchEvent(new P2PService_events(P2PService_events.EXPT_DATA,e.info.message));

					
					//final destination reached
					else if (e.info.fromLocal==true)
						this.dispatchEvent(new P2PService_events(P2PService_events.STUDY_META,e.info.message));
					
					
					//not destination so re-send
					else 
						netGroup.sendToNearest(e.info.message, e.info.message.destination);
					
					break;
				
				case "NetGroup.Posting.Notify":			
					receiveMessage(e.info.message, e.info.message.sender);
					break;
				
				
				case "NetGroup.Connect.Closed":
					trace("NetGroup.Connect.Closed");
					break;
				
				case "NetGroup.Neighbor.Disconnect":
					
					peers.remove(e.info.peerID);
					this.dispatchEvent(new P2PService_events(P2PService_events.PEER_REMOVED,e.info.peerID));
					break;
				
				case "NetGroup.Neighbor.Connect":
					//emit id here
					break;

				
				case "NetGroup.Replication.Fetch.SendNotify":
					//trace("send notify");
					//files.write(e.info.index, e.info.object);
					break;
				
				case "NetGroup.Replication.Failed":
					trace("fail");
					break;
				
				// This code is called on a Provider
				case "NetGroup.Replication.Request":
					// calling this causes "NetGroup.Replication.Fetch.Result" invocation on a Receiver
					netGroup.writeRequestedObject(e.info.requestID,files.getChunk(e.info.index))
					
					break;
				
				// This code is called on a Receiver
				case "NetGroup.Replication.Fetch.Result":
					// received chunks can be already provided to others
					//netGroup.addHaveObjects(e.info.index,e.info.index);
					
					if(e.info.index == 0){
						// First chunk (0) holds the number of chunks
						files.setMeta(e.info.object);
						netGroup.addWantObjects(1,e.info.object.chunks);
					}
					
					// write a chunk into an object/array
					files.write(e.info.index,e.info.object);
					netGroup.addHaveObjects(e.info.index,e.info.index);
							
					break;
			
				case "NetConnection.Connect.Closed":
					//do nothing
					break;
				
				default:
					trace("unknown message from netconnection:",e.info.code);
			}
		}
		
		public function getPeers():Peers{
			return peers;
		}
		
		private function setupGroup():void{

			if(study.length!=0 && study.charAt(0)!="/")study="/"+study;
			
			var groupspec:GroupSpecifier = new GroupSpecifier(GROUP+study);
			groupspec.multicastEnabled = true;
			groupspec.objectReplicationEnabled = true;
			groupspec.routingEnabled=true;
			groupspec.serverChannelEnabled = true;
			groupspec.postingEnabled = true;
			if(local){
				groupspec.ipMulticastMemberUpdatesEnabled = true;
				groupspec.addIPMulticastAddress("230.0.0.1:3000");
			}
			
			netGroup = new NetGroup(netConnection,groupspec.groupspecWithAuthorizations());
			
			netGroup.replicationStrategy = NetGroupReplicationStrategy.LOWEST_FIRST;
				
			listeners(netGroup,true);
			
			name ||= netConnection.nearID;
		}
		
		
		public function shareFile(file:ByteArray, name:String):void{
			files.add(file,name);
			netGroup.addHaveObjects(0,files.count);
		}
		
		public function requestExptFile():void{
			netGroup.addWantObjects(0,0);
		}
	

		public function sendMessage(txt:String, peerId:String=null,what:String=null):void{

			var message:Object = constructMessage(peerId);
			message.text = txt;
			if(what)message.data=what;
			
			if(peerId==null)	
				netGroup.post(message);
			else 
				netGroup.sendToNearest(message,message.destination);
			
		}
		
		public function sendData(info:Object, peerId:String):void{
			
			var message:Object = constructMessage(peerId);
			message.info = info;
			message.name = netConnection.nearID;
			message.data = true;
			//trace(netGroup.neighborCount,1234,peerId,message.destination)
			
			if("sent" != netGroup.sendToNearest(message,peerId))throw new Error("devel error: could not send experiment data to Experimenter");	
		}
		
		private function constructMessage(peerId:String=null):Object{
			var message:Object = {};
			message.sender = getPeerId();
			message.user = name;
			message.uuid = Math.random()*100000;
			if(peerId!=null){
				message.destination = netGroup.convertPeerIDToGroupAddress(peerId);
			}
		
			return message;
		}
		
		public function getPeerId():String{ 
			return netGroup.convertPeerIDToGroupAddress(netConnection.nearID);
		}
		
		private function receiveMessage(messageObj:Object, sender:String):void{
			//trace("receive message",this,messageObj);

			if(this is P2PService_peer == false && messageObj.text.indexOf(SEND_ID)!=-1){
				//id has been received
				
				var peer:String = messageObj.text.split(SEND_ID).join('');

				if(peers.add(peer))this.dispatchEvent(new P2PService_events(P2PService_events.PEER_ADDED,peer));
				
			}

			else {

				this.dispatchEvent(new P2PService_events(messageObj.text,{sender:sender,data:messageObj.data}));
			}
			
		}
	}
}