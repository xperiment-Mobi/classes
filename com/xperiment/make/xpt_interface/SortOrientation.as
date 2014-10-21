package com.xperiment.make.xpt_interface
{
	public class SortOrientation
	{

		public static function DO(orientation:String, trialProtocolList:XML):String
		{
			
			var xml:XML = trialProtocolList..*.screen[0];
			
			xml.@orientation = orientation;
			
			
			
			
			return '';
		}
	}
}