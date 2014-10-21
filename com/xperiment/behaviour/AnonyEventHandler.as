package com.xperiment.behaviour
{
	public class AnonyEventHandler
	{
		public var anonyF:Function;
		public var killF:Function;
		
		public function kill():void
		{
			anonyF=null;
			killF =null;
		}
		
	}
}