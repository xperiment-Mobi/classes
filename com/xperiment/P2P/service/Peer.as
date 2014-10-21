package com.xperiment.P2P.service
{
	public class Peer
	{
		public var name:String;
		public var message:String = '(downloading stimuli)';
		
		public function Peer(name:String)
		{
			this.name=name;
		}
		
		public function summary():String
		{
			return message;
		}
	}
}