package com.xperiment.P2P.utils
{

	import flash.utils.ByteArray;

	public class Stimuli_ByteArray
	{
		private var toSend_imgLibrary:Object = {};
		private var bytes:ByteArray;
		public var toReceive_imgLibrary:Object;
		
		public function kill():void
		{
			toSend_imgLibrary=null;
			bytes=null;
			toReceive_imgLibrary=null;
			
		}
		
		public function saveXML(name:String, text:String):void
		{
			if (name == null || name == "")	throw new Error();
			if (text == null)				throw new Error();
			
			var data:ByteArray = new ByteArray();
			data.writeUTF(text);
			
			toSend_imgLibrary[name]={data:data,type:'xml'};
		}
		
		
		
		public function saveImage(name:String, byteArray:ByteArray):void
		{
			if (name == null || name == "")	throw new Error();
			if (byteArray == null)				throw new Error();
			
			// create a new data object
			var bmObj:Object = new Object();
			bmObj.data = byteArray;
			bmObj.type='bitmap'
			
			toSend_imgLibrary[name]=bmObj;
		}
		
		public function bytearray():ByteArray{
			if(bytes)return bytes;

			bytes = new ByteArray();
			bytes.writeObject(toSend_imgLibrary); // store width of image
			bytes.compress();
			
			return bytes;
		}
		
		
		public function bytearrayToStim(bytes:ByteArray):void
		{
		
			try{
				bytes.uncompress();
			}
			catch(e:Error){
				throw new Error("problem in uncompressing stimuli");
			}
			// bytes is now the uncompressed byte array
			// ... process bytes ...

			toReceive_imgLibrary = bytes.readObject();
			
			// imgLibrary is now initialized and contains data objects each representing a bitmap image
			

			for(var filename:String in toReceive_imgLibrary){
				
				var obj:* = toReceive_imgLibrary[filename];
				
				switch(obj.type){
					
					case 'bitmap':
						
	
						try
						{
							toSend_imgLibrary[filename] = obj;
							toReceive_imgLibrary[filename] =  obj;
						}
						catch(e:Error)
						{
							throw new Error("problem with recombining stimuli");
						}
					
						break;
					case 'xml':
						toReceive_imgLibrary[filename] = XML((obj.data as ByteArray).readUTF());
						break;
					
					default: throw new Error("unknown file transmission type");
					}
			}
		}
		

	}
}