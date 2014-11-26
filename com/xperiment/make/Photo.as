package com.xperiment.make
{

	
	import com.adobe.images.JPGEncoder;
	import com.hurlant.util.Base64;
	
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.utils.ByteArray;

	public class Photo
	{
		public function Photo()
		{
		}
		
		public static function take(theStage:Stage, givePhoto:Function):void
		{
			var bmData:BitmapData = new BitmapData(theStage.width,theStage.height, true);
			bmData.draw(theStage);
			
			var ba:ByteArray = (new JPGEncoder).encode(bmData);
			
			givePhoto("photo",Base64.encodeByteArray(ba));
		}
	}
}