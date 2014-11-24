package com.xperiment.make.xpt_interface
{
	import com.xperiment.make.comms.Communicator;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.trialDecorators.Timeline.Timeline;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class UpdateHelper
	{
		private var timer:Timer  //used for less frequently updating codemirror script
		private var updateFrom:Array = [];
		private var runner:runnerBuilder;
		private var requirements:Array = [];
		private var elements:Object = {};
		
		public function UpdateHelper(r:runnerBuilder)
		{
			runner = r;
			initRequirements();
			initElements();
			timer = new Timer(50,1);
			timer.addEventListener(TimerEvent.TIMER,_scriptUpdatedL);
		}
		
		private function initElements():void
		{
			elements['PropertyInspector.edit'] 			= ['setScriptEditor','restartTrial'];
			elements['PropertyInspector.addRemove'] 	= ['setScriptEditor','resetPropertyApp','restartTrial'];
			elements['BindScript.addStimulus'] 			= ['setScriptEditor','restartTrial'];
			elements['BindScript.deleteTrial']	 		= ['setScriptEditor'];
			elements['BindScript.deleteTrials'] 		= ['setScriptEditor'];
			elements['BindScript.depthOrderChanged'] 	= ['setScriptEditor'];
			elements['Bind_processChanges']				= ['setScriptEditor','resetPropertyApp'];
			elements['Bind_addTrial.__addNew'] 			= ['setScriptEditor'];
			elements['Bind_delTrial.delCards'] 			= ['setScriptEditor'];
			elements['Cards.freshCardsApp'] 			= [];
			elements['Timeline.__processMultiStim'] 	= [];
			elements['Bind_processChanges.timingChanged']=['setScriptEditor','resetPropertyApp'];
			elements['Bind_delStim.deletePartMultiStim']= ['restartTrial','setScriptEditor','resetPropertyApp','setTimeline__Trial'];
			elements['Bind_delStim.deleteStim']			= ['restartTrial','setScriptEditor','resetPropertyApp','setTimeline__Trial'];
			elements['Trial_Goto'] 						= ['setTimeline__Trial','pos_scale_editor__Trial','resetPropertyApp'];
			
		}
		
		private function initRequirements():void
		{
			//requirements.push( {'syncRunnerScript_BindScript': 	function():void{runner.syncRunnerScript_BindScript();}} );
			requirements.push( {'setScriptEditor': 		function():void{Communicator.pass('setScript',BindScript.cleanScript())}} );
			requirements.push( {'restartTrial': 		function():void{runner.restartTrial(false,true)}} );
			requirements.push( {'resetPropertyApp': 	function():void{PropertyInspector.newTrial(runner.runningTrial as TrialBuilder);}} );
			requirements.push( {'setTimeline__Trial': 	function():void{Timeline.update(runner.runningTrial);}} );
			requirements.push( {'pos_scale_editor__Trial': 	function():void{runner.posScaleChanger();}} );
			
		}
		
		public function updateStuff(u:Array):void{
			for(var i:int=0;i<u.length;i++){
				if(updateFrom.indexOf(u[i])==-1)updateFrom.push(u[i]);
			}
			timer.reset();
			timer.start();
		}
		
		private function _scriptUpdatedL(e:TimerEvent):void{
			var requiredToRun:Array = generateNeeded();	
			var requirement:String;
			for(var i:int=0;i<requirements.length;i++){
				requirement=getName(requirements[i]);
				if(requiredToRun.indexOf(requirement)!=-1){
					requirements[i][requirement]();
				}
			}
		}
		
		private function getName(obj:Object):String{
			var nam:String;
			for(nam in obj){
				return nam;
			}
			
			return '';
		}
		
		private function generateNeeded():Array
		{
			var arr:Array = [];
			var list:Array;	
			
			for(var i:int=0;i<updateFrom.length;i++){	
				list = elements[updateFrom[i]];
				for each(var requir:String in list){
					if(arr.indexOf(requir)==-1)arr.push(requir);
				}
			}
				
			updateFrom = [];
			return arr;
		}

		
		public function kill():void
		{
			timer.removeEventListener(TimerEvent.TIMER,_scriptUpdatedL);
		}
	}
}