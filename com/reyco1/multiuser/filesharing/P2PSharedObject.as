package com.reyco1.multiuser.filesharing
{
	import flash.utils.ByteArray;

	public class P2PSharedObject
	{
		
		public var size:Number 				= 0;
		public var packetLenght:uint 		= 0;
		public var actualFetchIndex:Number 	= 0;
		public var data:ByteArray			= null;
		public var chunks:Object 			= new Object();
		
		public function P2PSharedObject()
		{
		}
		
		
		static public function generate(ba:ByteArray):P2PSharedObject{
		
			var shObj:P2PSharedObject = new P2PSharedObject();
			
			ba.position=0;
			
			shObj.size 			= ba.length;
			shObj.packetLenght 	= Math.floor(ba.length / 64000) + 1;
			shObj.data 			= ba;
			
			shObj.chunks 			= new Object();
			shObj.chunks[0] 		= shObj.packetLenght + 1;
			
			for(var i:int = 1; i < shObj.packetLenght; i++)
			{
				shObj.chunks[i] = new ByteArray();
				shObj.data.readBytes(shObj.chunks[i], 0, 64000);				
			}
			
			shObj.chunks[shObj.packetLenght] = new ByteArray();
			shObj.data.readBytes(shObj.chunks[i], 0, shObj.data.bytesAvailable);
			
			shObj.packetLenght += 1;
			
	
			
			return shObj;
		}
	}
}