package com.xperiment.P2P.service
{
	public class Peers
	{

		private var myPeersObj:Object = {};

		
		public function add(peer:String):Boolean
		{
			trace(99,peer)
			if(myPeersObj.hasOwnProperty(peer))return false;
			myPeersObj[peer]=new Peer(peer);
			return true;
		}
		
		public function addMessage(peer:String,message:String):void{
			if(myPeersObj.hasOwnProperty(peer))myPeersObj[peer].message = message;
			else throw new Error();
		}
		
		public function remove(name:String):void
		{
			myPeersObj[name] = null;
			delete myPeersObj[name];
			trace("peer removed22",name);
		}
		
		public function getPeerSummaries():Array{
			var all:Array = [];
			var count:int=0;
			
			for each(var peer:Peer in myPeersObj){
				trace(232323232322,peer.name);
				all.push("SJ "+(count++)+" "+peer.summary());
			}
						
			return all;
		}
		
		private function getPeer(peer:String):Peer{
			
			if(myPeersObj.hasOwnProperty(peer))return myPeersObj[peer];
			
			return null;
		}
		
		public function count():int{
			var count:int=0;
			for each(var peer:Peer in myPeersObj){
				count++;
			}
			return count;
		}
		
		public function trialChange(sj:String, trial:String):void
		{
			var peer:Peer = getPeer(sj)
			if(peer)	peer.message="("+trial+")";
			
		}
	}
}