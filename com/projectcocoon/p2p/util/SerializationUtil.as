package com.projectcocoon.p2p.util
{
	import flash.utils.ByteArray;

	/**
	 * Used internally by the <code>ObjectManager</code>
	 */	
	public class SerializationUtil
	{
		/**
		 * Takes an object, writes it to a ByteArray in AMF format and compresses it 
		 * @param object to be serialized
		 * @return compressed ByteArray
		 * 
		 */		
		public function serialize(object:Object):ByteArray
		{
			try
			{
				var byteArray:ByteArray = new ByteArray();
				byteArray.writeObject(object);
				byteArray.position = 0;
				byteArray.compress();
				return byteArray;
			}
			catch (e:Error)
			{
			}
			return null;
		}
		
		/**
		 * Takes a compressed ByteArray, decompresses it and reads an AMF encoded object from it. 
		 * @param bytes compressed ByteArray
		 * @return deserialized object
		 * 
		 */		
		public function deserialize(bytes:ByteArray):Object
		{
			try
			{
				bytes.uncompress();
				bytes.position = 0;
				return bytes.readObject();
			}
			catch (e:Error)
			{
			}
			return null;
		}
	}
}