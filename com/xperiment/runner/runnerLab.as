package com.xperiment.runner {
	import com.Start.MobileStart.MobileScreen;
	import com.Start.MobileStart.MobileScreenLab;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs_LabParams;
	import com.xperiment.trial.Trial;
	import com.xperiment.trial.TrialLab;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;


	public class runnerLab extends runner_devices {
		
		override public function kill():void{
			theStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressL)
			super.kill();
		}
		
		public function runnerLab(sta:Stage):void {
			sta.addEventListener(KeyboardEvent.KEY_DOWN, keyPressL);
			super(sta);
		}	
		
		protected function keyPressL(e:KeyboardEvent):void
		{
			if( e.keyCode == Keyboard.ESCAPE )
			{
				if(CountEscapes.escape())askedToQuit();
				e.preventDefault();
			}
			
		}
		
		override public function ExptWideSpecs_deviceSpecific():void{
			ExptWideSpecs_LabParams.SET();
		}
		
		
		
		override public function newTrial():Trial{
			return new TrialLab();
		}
		
		override public function initDeviceSpecificStuff():void{
			theStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; 
			super.initDeviceSpecificStuff();
		}
		
		override protected function getMobileScreen():MobileScreen{
			return new MobileScreenLab(theStage,ExptWideSpecs.IS('orientation').toLowerCase(),ExptWideSpecs.IS('width'),ExptWideSpecs.IS('height'),ExptWideSpecs.IS('aspectRatio'));
		}
		
		override protected function stageResized(e:Event):void{
			theStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; 
			super.stageResized(e);
		}
		
	}
}

import flash.utils.getTimer;

class CountEscapes {
	private static var prevPressTime:int= -1000;
	private static var count:int=0;
	
	public static function escape():Boolean
	{
		var t:int = getTimer();
		if(t-prevPressTime>500){
			count=1;
		}
		else count++;
		if(count>5) return true;
		prevPressTime = t;

		return false;	
	}

}