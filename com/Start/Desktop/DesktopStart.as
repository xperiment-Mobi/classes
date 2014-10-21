package com.Start.Desktop
{
	import com.Start.WebStart.WebStart;
	import com.xperiment.runner.runner;
	import com.xperiment.runner.runnerLab;
	
	import flash.display.Stage;

	
	public class DesktopStart extends WebStart
	{
		
		static private var scriptName:String;
		
		public function DesktopStart(theStage:Stage,url:String=''){
			if(url!='')scriptName=url;
			super(theStage,scriptName);
		}
			
		override public function exptPlatform():runner{
			return new runnerLab(theStage);
		}
		
		override public function restart():Function{
			
			return function():void{
				
				if(expt)expt.kill();
				scriptLoad(scriptName);
			}
		}
		
	}
}