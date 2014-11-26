package com.xperiment.runner.ComputeNextTrial.Progress
{
	public class Progress_Staircase extends Progress
	{
		
		static public var UP:String   = "up";
		static public var DOWN:String = "down";
		
		public var direction:String = UP;
		
		public function Progress_Staircase(xml:XML)
		{
			super(xml);
		}
	}
}