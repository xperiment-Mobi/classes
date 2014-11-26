package com.xperiment.P2P.service.files
{
	import com.xperiment.P2P.service.P2PService_events;
	import flash.display.Sprite;
	import flash.utils.ByteArray;


	public class P2PService_file extends Sprite
	{
		public static var CHUNKSIZE:uint = 64 * 1024; // 64KBytes
		
		//public var chunks:int;
		public var data:Array = [];
		//public static var SEP:String = "<SEP>";
				
		public var meta:P2PService_file_meta;
		
		public function kill():void
		{
			while(data.length>0){
				data[0]=null;
				data.shift();
			}
			data = null;
			meta = null;
			
		}
		
		public function get count():int
		{
			return data.length;
		}

		public function add(file:ByteArray, name:String):void
		{
			meta = new P2PService_file_meta;
			meta.name = name;
			composeFile(file);	
		}
		
		
		public function setMeta(metaObj:Object):void
		{
			meta= new P2PService_file_meta;
			meta.name=metaObj.name;
			meta.chunks=metaObj.chunks;
			
			while(data.length<meta.chunks){
				data[data.length]=null;
			}
			
		}
		
		public function getChunk(index:int):*{
			return data[index];
		}
		
		public function write(index:int, obj:Object):void{
			data[index]=obj;

			if(data.length==meta.chunks+1){
				
				this.dispatchEvent(new P2PService_events(P2PService_events.FILE_LOADED,getFile(),true));
			}
			else{
				this.dispatchEvent(new P2PService_events(P2PService_events.FILE_LOADING,data.length/(meta.chunks+1),true));
			}
		}
		
		
		private function composeFile(file_byteArray:ByteArray):void
		{ 
			
			
			file_byteArray.position = 0;

			// split up the bytes into chunks and store them in a Vector
			meta.chunks = getChunks(file_byteArray);
			var i:int;
			var buf:ByteArray;
			
			data[i] = meta;
			
			for (i = 0; i < meta.chunks; i++)
			{
				buf = new ByteArray();
				if (i == meta.chunks-1)
				{
					file_byteArray.readBytes(buf, 0, file_byteArray.bytesAvailable);    
				}
				else
				{
					file_byteArray.readBytes(buf, 0, CHUNKSIZE);      
				}
				buf.position = 0;
				data[i+1] = buf;
			}
		}
		

		private function getChunks(data:ByteArray):uint
		{
			return Math.floor(data.length / CHUNKSIZE) + 1;
		}	

		
		public function getFile():ByteArray
		{
			var buffer:ByteArray;
			if (data)
			{
				
				buffer = new ByteArray();

				for (var i:int=1;i<data.length; i++)
				{
					buffer.writeBytes(data[i]);
				}
			}
			return buffer;
		}
		


	}
}