package unitTests
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.flexunit.runner.FlexUnitCore;

	
	public class xperimentTestSuite extends Sprite
	{
		private var core:FlexUnitCore;
		
		public function xperimentTestSuite(){
			
			core = new FlexUnitCore();
			
			var fin:FinishedListener = new FinishedListener;
			fin.passF(finished);
			core.addListener(fin);
			
			//core.run(test_EventPassPegToAction);
			//core.run(test_logic)
			//core.run(test_logicActions)
			//core.run(test_exptWideVars)
			//core.run(test_ActionMaths)
			//core.run(test_accessStimProps);
			//core.run(test_giveTrialPeg);
		
			//core.run(test_trialOrderFunctions);
			//test_FlattenXML
			
			core.run(test_ActionFactory,test_giveTrialPeg,test_accessStimProps,test_logic,test_trialOrderFunctions,test_behavBoss,test_ActionDict,test_BehavBossHelper,
				test_ActionMaths,test_logicActions,test_exptWideVars,test_exptWideSpecs,test_RandCond,test_CodeRecycleFunctions,test_RequiredActions,
				test_Communicator,test_cloudLocationUpdater,test_Trial_cleanTitle, test_TrialHelper,test_ProcessScript,
				test_ShuffleFs,test_GetData,test_ObjectBaseClass,test_trialOrder,test_xptMemory, 
				test_trialOrderChange, test_MultiSpecsCorrection,test_timeline, test_BindScript_addTrial_and_delTrial);//,test_SaveResults,test_OnScreenBoss,test_loader,test_integrationOfLogicActions);
			//test_ProgressROWPVT
			
			//need to re add this test_abstractTrial_sortoutTimingF
			//test_StimEvents not used
			core = null;
			super();

		}
		
		public function finished():void{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}