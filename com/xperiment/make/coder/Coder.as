package com.xperiment.make.coder
{

	import com.xperiment.make.xpt_interface.runnerBuilder;
	import com.xperiment.trial.Trial;

	public class Coder
	{		
		private static var runner:runnerBuilder;
		private static var overlay:CodeOverlay;
		
		
		public static function start():void
		{
			overlay ||= new CodeOverlay(runner.theStage);
		}
		
		public static function setup(r:runnerBuilder):void
		{
			runner = r;
			start(); //remove eventually
			
		}
		
		public static function update(runningTrial:Trial):void
		{
			// TODO Auto Generated method stub
			if(overlay)overlay.update(runningTrial);
			
		}
	}
}
