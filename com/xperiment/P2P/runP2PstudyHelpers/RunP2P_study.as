package com.xperiment.P2P.runP2PstudyHelpers
{
	import com.xperiment.P2P.service.P2PService_peer;
	import com.xperiment.Results.Results;
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.preloader.IPreloadStimuli;
	import com.xperiment.preloader.Preloader_P2P;
	import com.xperiment.runner.runner;
	
	import flash.display.Stage;

	public class RunP2P_study
	{
		
		
		private var theStage:Stage;
		private var preload:IPreloadStimuli
		private var expt:runner;
		private var service:P2PService_peer;
		public var exptResults:Results;
		private var study:String;
		private var studyId:String;
		
		public function RunP2P_study(theStage:Stage,script:XML, stimuli:Object, old_expt:runner, service:P2PService_peer, study:String, study_id:String)
		{
			this.theStage=theStage;
			this.service =service;
			this.study   =study;
			this.studyId =study_id;

			var myClass:Class = Object(old_expt).constructor;
			old_expt.kill();
			
			expt = new myClass(theStage);
			preload = new Preloader_P2P(stimuli,script.SETUP.computer.@stimuliFolder.toString());
			//expt.givePreloader(preload);
			expt.giveScript(script);

			trialData_init();
		}
		
		private function trialData_init():void
		{
			exptResults = Results.getInstance();
			expt.P2PgiveF = trickleResults;
			trickleResults(new XML,-1);
		}
		
		private function trickleResults(trialResults:XML,trialNum:int):void{
			service.sendData({trialNum:trialNum,trialResults:trialResults},studyId);

		}
		
		
		/*private function listeners(on:Boolean):void
		{
			var f:Function;
			if(on)f=theStage.addEventListener;
			else  f=theStage.removeEventListener;
			
			f(P2P_Event.SAVE_RESULTS,saveResultsL);
		}*/
		
		/*private function saveResultsL(e:P2P_Event):void{
			
		}*/

		public function nextTrial(trial:String):void
		{
			trace("run this trial",trial);
			dispatch(GlobalFunctionsEvent.GOTO_TRIAL,trial);
		}
		

		
		public function endStudy():void
		{
			dispatch(GlobalFunctionsEvent.FINISH_STUDY);
			
		}
		
		private function dispatch(what:String,data:String=null):void{			
			theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,what,data));
		}
	}
}