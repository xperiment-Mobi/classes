package com.Start.WebStart
{
	import com.Start.CanRestart;
	
	import flash.display.Stage;
	import com.xperiment.runner.runnerJS;
	import com.xperiment.runner.runner;

	//import flash.system.Capabilities;

	public class WebStartJS extends WebStart implements CanRestart
	{
		

		
		override public function kill():void
		{
			super.kill();
		}

		override public function exptPlatform():runner{
			return new runnerJS(theStage);
		}

		
		public function WebStartJS(theStage:Stage, scriptName:String='')
		{
			super(theStage,scriptName);

		}
		


		
		
	}
}