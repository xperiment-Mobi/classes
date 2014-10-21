package com.xperiment.runner {

	import com.xperiment.ExptWideSpecs.ExptWideSpecs_MobileParams;
	import com.xperiment.trial.Trial;
	import com.xperiment.trial.TrialANDROID;
	
	import flash.display.Stage;


	public class runnerANDROID extends runner_devices {

		public function runnerANDROID(sta:Stage):void {
			super(sta);
		}	
		
		override public function newTrial():Trial{
			return new TrialANDROID();
		}
		
		override public function ExptWideSpecs_deviceSpecific():void{
			ExptWideSpecs_MobileParams.SET();
		}
		
		
	}
}