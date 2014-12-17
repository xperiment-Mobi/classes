
package com.xperiment.runner {

	import com.bit101.components.Style;
	import com.xperiment.MTurkHelper;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.BehavLogicAction.PropValDict;
	import com.xperiment.DeviceQuery.DeviceQuery;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs_WebParams;
	import com.xperiment.MockResults.MockResults;
	import com.xperiment.Results.Results;
	import com.xperiment.XMLstuff.ISaveResults;
	import com.xperiment.XMLstuff.ImportExptScript;
	import com.xperiment.XMLstuff.saveResults;
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.events.GotoTrialEvent;
	import com.xperiment.events.TrialEvent;
	import com.xperiment.make.comms.Communicator;
	import com.xperiment.messages.XperimentMessage;
	import com.xperiment.preloader.IPreloadStimuli;
	import com.xperiment.preloader.PreloadStimuli;
	import com.xperiment.preloader.Preloader_P2P;
	import com.xperiment.runner.ComputeNextTrial.NextTrialBoss;
	import com.xperiment.runner.utils.CheckTurk;
	import com.xperiment.runner.utils.ListTools;
	import com.xperiment.script.BetweenSJs;
	import com.xperiment.script.ProcessScript;
	import com.xperiment.trial.Trial;
	import com.xperiment.trialOrder.trialOrderFunctions;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	

	
	public class runner extends Sprite {
		
		//- PUBLIC & INTERNAL VARIABLES ---------------------------------------------------------------------------
		public var trialList:Vector.<Trial> = new Vector.<Trial>;;
		

		public var trialProtocolList:XML;
		public var theStage:Stage;
		public var exptResults:Results;
		//private var propValDict:PropValDict;
		public var dataSave:ISaveResults;
		public var myScript:ImportExptScript;
		public  var P2PgiveF:Function;
		public var preloader:IPreloadStimuli;
		
		public var runningTrial:Trial;
		
		public var isBuilder:Boolean = false;

		
		private var __needsDoing:Vector.<String>;
		//- CONSTRUCTOR -------------------------------------------------------------------------------------------
		private var startupTimer:Timer;
		private var killed:Boolean;
		public var __nextTrialBoss:NextTrialBoss;
		
/*		public function maker():void{
		
		}*/
		private var orig_script:XML;
		
		protected function initComms():void{
			Communicator.commandF = commandF;
			Communicator.setup();
		}
		
		protected function commandF(what:String, data:* =null):void{
			switch(what){
				default: 
					Communicator.pass('as3Error',{command: what,data: data, message: "unrecognised command from js"});
			}
		}
		
		
		public function startStudyQuery(done:String):void{
			if(!startupTimer) startupTimer = new Timer(10000,1);
			
			startupTimer.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
				//////////////////////////////////////
				e.target.removeEventListener(TimerEvent.TIMER,arguments.callee);

				//////////////////////////////////////Anonymous Function
				if(__needsDoing && __needsDoing.length!=0){
					if(!killed)	XperimentMessage.message(theStage, "Loading steps not completed within timeframe: "+__needsDoing.join(","));
				}
				//////////////////////////////////////
				//////////////////////////////////////
			});
			startupTimer.start();
			
			var pos:int = __needsDoing.indexOf(done);
			if(pos==-1)throw new Error();
			__needsDoing.splice(pos,1);
			
			if(__needsDoing.length==0){
				__needsDoing=null;
				runExpt();
			}	
		}
		
		public function runner(sta:Stage):void {
			theStage=sta;
			initComms();
			//if below needed for unitTests
			if(theStage) theStage.showDefaultContextMenu=false;
			DeviceQuery.init();
			
			killed=false;
			Style.embedFonts=false;
			Trial.theStage=theStage;
			setNeedsDoing();
			
		}	
		

		protected function setNeedsDoing():void
		{
			__needsDoing = new <String>['sortScreen','processScript','giveScript','loadableObjects'];
		}		
		
		
		protected function scaleMode():void{
			theStage.scaleMode=StageScaleMode.NO_SCALE;
		}
		
		public function initDeviceSpecificStuff():void{
			ExptWideSpecs_WebParams.SET();
			//below removed for runnBuilder
			scaleMode();
			if(!Trial.RETURN_STAGE_HEIGHT){//needed in case the experiment is restarted and is in fullscreen mode (else goes bananas);
				setDimensions();
			}
			
			startStudyQuery('sortScreen');
		}
		
		protected function setDimensions():void{
			
			Trial.RETURN_STAGE_HEIGHT=theStage.stageHeight;
			Trial.RETURN_STAGE_WIDTH=theStage.stageWidth;
			Trial.ACTUAL_STAGE_HEIGHT=theStage.stageHeight;
			Trial.ACTUAL_STAGE_WIDTH=theStage.stageWidth;	
		}
		
		protected function giveProcessScript():ProcessScript{
			return new ProcessScript();
		}
	
		public function giveScript(scr:XML,remote_url:String=null, params:Object = null):void {
			startStudyQuery('processScript');
			trialList = new Vector.<Trial>;
			orig_script = scr.copy();

			var processScript:ProcessScript = giveProcessScript();

			//Hack.DO();

			processScript.addEventListener(Event.COMPLETE, function(e:Event):void{
				e.target.removeEventListener(e.type,arguments.callee);
				//trace(123,processScript.script)
				trialProtocolList=processScript.script;
				//trace(trialProtocolList)

				processScript=null;
				ExptWideSpecs.setup(trialProtocolList);
trace(123344,params)
				if(params) ExptWideSpecs.URLVariables(params,'');
				else ExptWideSpecs.URLVariables(theStage.loaderInfo.parameters,theStage.loaderInfo.url);

				if(remote_url)ExptWideSpecs.remote_url(remote_url);
				if(ExptWideSpecs.IS("mock") == true)	MockResults.sortExptWideSpecs();

				exptResults = Results.getInstance();
				exptResults.setup();

				populatePropValDict();
				checkForLoadableObjects();

				setBackgroundColour();
				resizeListeners();
				startStudyQuery('giveScript');

				initDeviceSpecificStuff();
				
			},false,0,false); 
			
			processScript.process(scr);
			
			

		}
		
					
		public function runExpt():void{
		
			theStage.addEventListener(GotoTrialEvent.RUNNER_PING_FROM_TRIAL,nextTrial,false,0,false);
			theStage.addEventListener(GlobalFunctionsEvent.COMMAND,runCommand);
			theStage.addEventListener(TrialEvent.CHANGE, changeTrialInfo);
			
			
			if(!trialProtocolList){
				trialProtocolList=myScript.giveMeData();
			}
			runningExptNow();	
		}
		
		protected function changeTrialInfo(e:TrialEvent):void
		{
			var trials:Array = e.trials.splice(0);
			var tickList:Array = e.trials.splice(0);
			
			
			var command:String = e.action;
			
			if(command==TrialEvent.DISABLE || command == TrialEvent.ENABLE){
				var remove_index:int;
				var enable:Boolean = true;
				if(command==TrialEvent.DISABLE) enable = false;
				
				var trial:Trial;
				var trial_i:int;
				for(var t:uint=0;t<trialList.length;t++){
					trial_i=trials.indexOf(trialList[t].trialLabel)
					if(trial_i!=-1){
						//trace(11112)
		
						trialList[t].runTrial = enable;
						remove_index=tickList.indexOf(trialList[t].trialLabel);
						if(remove_index!=-1){
							tickList.splice(remove_index,1);
						}
					}	
				}	
				if(tickList.length>0)throw new Error("you have asked to '"+command+"' an unknown trial(s) with trialName(s): "+tickList.join(","));
			}
			
		}
		
		protected function populatePropValDict():void
		{
			//if(XptMemory.sessionAlreadyExisted==false){
				var attribs:XMLList = trialProtocolList.SETUP.variables.attributes();
				for (var i:int = 0; i < attribs.length(); i++){
					PropValDict.addExptProps(String(attribs[i].name()), attribs[i].toXMLString());
				}
				var urlVariables:Array = ExptWideSpecs.IS("urlParams");
				for(var variable:String in urlVariables){
					PropValDict.addExptProps(urlVariables[variable], variable);
				}
				
			/*}
			else{
					
				var props:Object = XptMemory.exptProps();
				for(var key:String in props){
					PropValDict.addExptProps(key, props[key]);
				}
			}*/
			
		}		

		
		public function runCommand(e:GlobalFunctionsEvent):void
		{

			switch(e.command){
				case GlobalFunctionsEvent.LANGUAGE:
					trialProtocolList=ProcessScript.replaceAllInstancesOfAttribWithSuffixedAttrib(e.values as String,trialProtocolList);
					break;
				case GlobalFunctionsEvent.SAVE_DATA:
					saveDataProcedure();
					break;
				
				case GlobalFunctionsEvent.RESTART_STUDY:
					theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.FINISH_STUDY,ExptWideSpecs.IS("restart")));
					break;
				case GlobalFunctionsEvent.GIVE_RUNNER:
					var p2pPeer_giveRunner:Function = e.values;
					p2pPeer_giveRunner(this);
					break;
				case GlobalFunctionsEvent.CHANGE_TRIALORDER:
					var list:Array = e.values;
					var nodeTree:Array
					for each(var change:Object in list){
						nodeTree = change.param.split(".");
						
						if(trialProtocolList.SETUP.hasOwnProperty(nodeTree[0]) && trialProtocolList.SETUP[nodeTree[0]].hasOwnProperty('@'+nodeTree[1])){
							trialProtocolList.SETUP[nodeTree[0]].@[nodeTree[1]] = change.val;
						}
						else throw new Error('ERR with input from behavTrialOrder');
						
						ExptWideSpecs.update(nodeTree,change.val);
					}
					genTrialOrder(false);
					break;
				case GlobalFunctionsEvent.P2P_GIVE_EXPT_STUFF:
					var p2pBoss_giveExptStuff:Function = e.values;
					p2pBoss_giveExptStuff(trialProtocolList, preloader);
					break;
				case GlobalFunctionsEvent.GOTO_TRIAL:
					runningTrial.compileOutputForTrial();
					runningTrial.generalCleanUp();
					var tempTrial:String = e.values;
					if(e.values == "") tempTrial = GotoTrialEvent.NEXT_TRIAL;
					nextTrial(new GotoTrialEvent(GotoTrialEvent.GOTO_TRIAL,tempTrial));
					break;
				/*case GlobalFunctionsEvent.MTURK_SUBMIT:
					submitMTurk();
					//throw new Error("legacy");
					break;*/
				case GlobalFunctionsEvent.QUIT:
				case GlobalFunctionsEvent.FINISH_STUDY:					
					askedToQuit();
					break;
				case GlobalFunctionsEvent.GOTO_COND:
					var newScript:XML = BetweenSJs.forceCond(orig_script,e.values);	
					loadDifferentScript(newScript);
					break;
				case GlobalFunctionsEvent.PROBLEM:
					kill();
					XperimentMessage.message(theStage,e.values.toString());
					break;
				default:
					throw new Error("unrecognised global command:"+e.command);
			}
		}
		
		public function loadDifferentScript(newScript:XML):void
		{
			runningTrial.compileOutputForTrial();
			runningTrial.generalCleanUp();
			
			extractTrialData(runningTrial);
			exptResults.preserveOverExpts(true);
			runningTrial = null;
			
			askedToRestart();
			
			ExptWideSpecs.kill();
			trialList = new Vector.<Trial>;
			preloader.kill(); preloader = null;
			setNeedsDoing();
			
			giveScript(newScript);
		}
		
/*		protected function submitMTurk():void
		{
			Communicator.pass("submit_mturk_external_question",null);
		}*/		
		
			
		
/*		public function givePreloader():void{
			preloader = new preloadFilesFromWeb(trialProtocolList,theStage);
		}*/
		

		private function checkForLoadableObjects():void{
			startStudyQuery('loadableObjects');
			if(ExptWideSpecs.IS("preloadStimuli") && ExptWideSpecs.IS("mock")==false){
				generatePreloader();
				Trial.preloader=preloader;
			}

			
		}
		
		public function generatePreloader():void
		{
			if(!preloader)	preloader = new PreloadStimuli(trialProtocolList,theStage,kill);
			else if(preloader is Preloader_P2P == false){
				(preloader as PreloadStimuli).seekLoadable(trialProtocolList);
			}
		}		

		
		public function runningExptNow():void{	
			ListTools.extract(trialProtocolList,exptResults);
			myScript=null;
			
			genTrialOrder(true);
			
			runningTrial=firstTrial();

			runningExptNow_II();
		}
		
		protected function firstTrial():Trial{
			return __nextTrialBoss.firstTrial();
		}
		
		private function genTrialOrder(genTrials:Boolean):void
		{	
			var trialOrder:Array = trialOrderFunctions.computeOrder(trialProtocolList,__composeTrial);
			
			if(genTrials)	__nextTrialBoss = new NextTrialBoss(trialProtocolList,trialList,trialOrder);
			else			__nextTrialBoss.trialOrder = trialOrder;	
		}
		
		
		public function __composeTrial(info:Object):void {	
			var tempTrial:Trial=newTrial();
			tempTrial.setup(info);
			trialList.push(tempTrial);
		}
		 
		//nb restart other stuff used for Maker
		public function runningExptNow_II():void{
			if(CheckTurk.DO(trialProtocolList,theStage))commenceWithTrial();//starts the trial sequence 
		}
		
		public function newTrial():Trial{
			return new Trial();
		}
		
		
		protected function resizeListeners():void{
			theStage.addEventListener(Event.RESIZE,stageResized,false,0,true);
		}
		
		protected function stageResized(e:Event):void{
			setBackgroundColour();
		}
		
		
		public function commenceWithTrial(params:Object=null):void {
			//setBackgroundColour(trialProtocolList.TRIAL[runningTrial.TRIAL_ID].@backgroundColour.toString());
			if(!runningTrial){
				XperimentMessage.message(theStage,"!End of the study. You should provide an 'end of study' screen and not rely on this message!");
				var t:Timer= new Timer(1500,1);
				t.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
					//////////////////////////////////////
					e.target.removeEventListener(TimerEvent.TIMER,arguments.callee);
					//////////////////////////////////////Anonymous Function
					t.stop();
					endProgram();
					//////////////////////////////////////
					//////////////////////////////////////
				});
				t.start();	
			}
			else{	

				runningTrial.prepare(__nextTrialBoss.currentTrial,trialProtocolList.TRIAL[runningTrial.TRIAL_ID],params);	
				//trace(11,__nextTrialBoss.currentTrial)
			}
		}

		private function extractTrialData(t:Trial):void{
			var trialData:XML;
			//no point saving data if the trial has not been run
			if(runningTrial.runTrial == true && isBuilder==false){
				trialData=runningTrial.giveTrialData();	
				//XptMemory.updateExptProps(PropValDict.exptProps);
				if(exptResults && trialData)exptResults.give(trialData);	
			}
			
			if(P2PgiveF)	P2PgiveF(trialData,__nextTrialBoss.currentTrial);
		}
		
		public function nextTrial(e:GotoTrialEvent):void {
			
			extractTrialData(runningTrial);
			
			runningTrial=__nextTrialBoss.getTrial(e.action,runningTrial);

			if(runningTrial){
				
				if(runningTrial.runTrial == true){
					commenceWithTrial();
				}
				else{
					e.action = GotoTrialEvent.NEXT_TRIAL
					nextTrial(e);				
				}
			}
			else problemWithNextTrial(e.action);
		}
		
		protected function problemWithNextTrial(action:String):void
		{

			var message:String;
			if(action==GotoTrialEvent.NEXT_TRIAL){
				
				message="You have reached the end of the study. The Experimenter really should have made a nice 'thankyou' screen here!";
				
			}
			else if(action=="quit"){
				askedToQuit();
				return;
			}
			else message ="You asked to goto an unknown trial called '"+action+"'.";
			
			
			XperimentMessage.message(theStage, message);
			theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.RESTART_STUDY));	
		}
		
		public function askedToQuit():void
		{
			kill();
		}
		
		public function askedToRestart():void //for mobile version
		{
			askedToQuit(); 
		}

		
		public function saveDataProcedure():void{

			var mturkId:String = ExptWideSpecs.IS("assignment_id");
			if(mturkId!=null && mturkId!='')	MTurkHelper.DO(theStage,mturkId);
			
			if(P2PgiveF)P2PgiveF(exptResults.composeXMLInfo(),null);
			
			dataSave ||= new saveResults(theStage);
			dataSave.save();
		}
		

		
		public function destroy():void{
			runningTrial.generalCleanUp();
			runningTrial=null;
			
		}
		
		public function endProgram():void {
			//override this for platform specific actions
			kill();
		}
		
		public function kill():void
		{
			preloader.kill();
			trialList = null;
			if(runningTrial)destroy();
			//if(trialDataBar && theStage.contains(trialDataBar))theStage.removeChild(trialDataBar);
			if(exptResults)exptResults.kill();
			//ExptWideSpecs.kill();
			codeRecycleFunctions.kill();
			exptResults=null;
			theStage.removeEventListener(GotoTrialEvent.RUNNER_PING_FROM_TRIAL,nextTrial);
			theStage.removeEventListener(GlobalFunctionsEvent.COMMAND,runCommand);
			theStage.removeEventListener(TrialEvent.CHANGE, changeTrialInfo);
			this.killed=true;
			//if(theStage.contains(acrossExperimentTrial))theStage.removeChild(acrossExperimentTrial);
		}
		
		/*public function extractStudyData():void {
			//if(acrossExperimentTrial && acrossExperimentTrial.hideResults==false)exptResults.give(acrossExperimentTrial.trialData);		
		}	
		*/
		
		
	
		
		public function setBackgroundColour(colour:String=''):void {	
			if(colour=='')	colour = ExptWideSpecs.IS("BGcolour");
			theStage.color = codeRecycleFunctions.getColour(colour);
			setWebSiteColour(colour);
		}
		
		protected function setWebSiteColour(colour:String):void{
			colour = colour.split("0x").join("#");
			Communicator.pass('bgCol',colour);
		}
		

	}
}

