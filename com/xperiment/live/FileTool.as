package com.xperiment.live
{
	import flash.utils.ByteArray;

	public class FileTool
	{
		static public function encode(obj:Object):ByteArray
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(obj);
			return bytes;
		}
		
		static public function decode(bytes:ByteArray):Object{
			bytes.position = 0; // back to where we wrote the object
			return bytes.readObject();
		}
	}
}