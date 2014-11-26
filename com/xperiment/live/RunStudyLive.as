package com.xperiment.live
{
	import com.xperiment.Results.Results;
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.preloader.IPreloadStimuli;
	import com.xperiment.preloader.Preloader_P2P;
	import com.xperiment.runner.runner;
	
	import flash.display.Stage;
	
	public class RunStudyLive
	{
		
		
		private var theStage:Stage;
		private var preload:IPreloadStimuli
		private var expt:runner;
		private var peerLive:PeerLive;
		public var exptResults:Results;
		private var study:String;
		private var studyId:String;
		
		public function RunStudyLive(theStage:Stage,script:XML, stimuli:Object, old_expt:runner, peerLive:PeerLive)
		{
			this.theStage=theStage;
			this.peerLive =peerLive;

			
			var myClass:Class = Object(old_expt).constructor;
			old_expt.kill();
			
			expt = new myClass(theStage);
			preload = new Preloader_P2P(stimuli,script.SETUP.computer.@stimuliFolder.toString());
			expt.preloader=preload;
			expt.giveScript(script);
			
			trialData_init();
		}
		
		private function trialData_init():void
		{
			exptResults = Results.getInstance();
			expt.P2PgiveF = trickleResults;
			trickleResults(new XML,0);
		}
		
		private function trickleResults(trialResults:XML,trialNum:int):void{
			var details:Object = peerLive.composeTrialResults(trialResults.toString(),trialNum+1);
			peerLive.sendTrialResults(details.combined);
			
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
			trace("run this trial...",trial);
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
