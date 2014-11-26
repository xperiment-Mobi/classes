package com.xperiment.runner{

	import com.xperiment.Results.Results;
	import com.bit101.components.Style;
	import com.xperiment.trialOrder.trialOrderFunctions;
	import com.xperiment.trial.TrialANDROID;
	import com.xperiment.trial.overExperiment;
	
	import flash.desktop.NativeApplication;
	import flash.display.*;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;

	public class runnerAPPLE extends runnerANDROID {

		private var _dummyTrialAndroid:TrialANDROID;
		
		override public function initialise(sta:Stage) {
			super.theStage=sta;
			theStage.addEventListener("saveDataEndStudy",endProgram,true,0,true);
			Style.embedFonts=false;
			exptResults = Results.getInstance();
			super.logger.start(true,theStage)
			super.theStage.align=StageAlign.TOP_LEFT;
			super.theStage.scaleMode=StageScaleMode.NO_SCALE;
			super.nerdStuff="APPLE" + getAppInfo();
			//super.theStage.addEventListener(Event.FRAME_CONSTRUCTED, sortOutLocalDataBase);
			super.theStage.addEventListener(Event.FRAME_CONSTRUCTED, sortOutScreen);
			actionBar=0;
		}

		override public function closeProgram(e:Event) {
			dispatchEvent(new Event("endOfStudy"));
			trace("study finished.  Restarting...");
		}
		
		
		public function checkForLoadableObjects():void{
			if(trialProtocolList.SETUP.loadFilesInAdvance.@run.toString()=="false"){runningExptNow()}
			else{				
				preloader = new preloadFilesFromWeb(trialProtocolList,trialProtocolList.SETUP.fileInformation.@stimuliFolder+"\\");
				
				runningExptNow();
			}
			if("mTurk" in trialProtocolList.SETUP)mechTurk=new mTurk(theStage,logger);
		}
		
		

	}
}