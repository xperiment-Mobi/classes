package com.xperiment.behaviour
{
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.stimuli.primitives.windows.ModalWindow_fullscreen;
	import com.xperiment.trial.Trial;
	
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.FullScreenEvent;
	
	public class behavFullScreenDummy extends behav_baseClass
	{
		private static var modalWindow:ModalWindow_fullscreen;
		private static var staticStage:Stage;
		private static var header:String;
		private static var close:String;
		private static var queryIfChange:Boolean;
		private static var wasSet:Boolean;
		private static var staticScaleMode:String;
		private static var staticCallWhenFinished:Function;
		private static var header2:String;
		private static var goFullScreen:String;
		private static var goSmallScreen:String;
		
		
		override public function setVariables(list:XMLList):void {
			setVar("string","header","Click ‘go full screen’ (recommended) or click ‘close when ready’ to begin the experiment.");
			setVar("string","header2","Click ‘close when ready’ to begin the experiment.");
			setVar("string","goFullScreen","go fullscreen");
			setVar("string","goSmallScreen","go smallscreen");
			setVar("string","action","on","either 'on' or 'off'");
			setVar("boolean","queryIfChange",true);
			setVar("string","closeMessage","close when ready");
			setVar("string","scaleMode","sameSize","stretch,sameSize,aspectRatio");
			super.setVariables(list);
			
			staticStage = theStage;
			header = getVar("header");
			header2 = getVar("header2");
			close = getVar("closeMessage");
			goFullScreen = getVar("goFullScreen");
			goSmallScreen=getVar("goSmallScreen");
			queryIfChange = getVar("queryIfChange");
		}
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		override public function storedData():Array {
			
			var stim:object_baseClass;
			var sav:String = getVar("save");
			
			objectData.push({event:"ran_fullscreen",data:wasSet});
			
			
			return super.objectData;
		}
		
		override public function nextStep(id:String=""):void{
			
			var contin:Boolean = true;
			
			//if(ExptWideSpecs.IS("browser").toLowerCase().indexOf("chrome")==-1 && ExptWideSpecs.IS("mock")==false){
			if(ExptWideSpecs.IS("mock")==false){
				
				
				staticScaleMode=getVar("scaleMode");
				staticCallWhenFinished = callWhenFinished;
				scaleModeSort();
				
				
				listener(false);
				if(getVar("action").toLowerCase()=="on"){
					initStaticListener(null);
				}
				else if(modalWindow)modalWindow.stop();
			}
			else{
				callWhenFinished();
			}
		}
		
		private function callWhenFinished():void{
			behaviourFinished();
		}
		
		private static function scaleModeSort():void
		{	
			staticStage.scaleMode = StageScaleMode.NO_SCALE;
			staticStage.align="yx";	
		}
		
		private static function completeCallback():void{
			wasSet = modalWindow.bigScreen;
			if(staticCallWhenFinished)staticCallWhenFinished();
			if(queryIfChange==true && staticStage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE ){
				modalWindow=null;
				listener(true);
			}
			
		}
		
		private static function listener(ON:Boolean):void{
			
			if(ON){
				if(staticStage.hasEventListener(FullScreenEvent.FULL_SCREEN)==false)staticStage.addEventListener(FullScreenEvent.FULL_SCREEN, initStaticListener);
			}
			else{
				if(staticStage.hasEventListener(FullScreenEvent.FULL_SCREEN)==true)staticStage.removeEventListener(FullScreenEvent.FULL_SCREEN, initStaticListener);
			}
		}
		
		protected static function initStaticListener(e:FullScreenEvent):void
		{
			if(staticStage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE){
				var params:Object = {goFullScreen:goFullScreen, goSmallScreen:goSmallScreen, header2:header2, closButtonText:close, headerSize:40,width:Trial.ACTUAL_STAGE_WIDTH*.9,height:Trial.ACTUAL_STAGE_HEIGHT*.7, sendButtonsVisible:false,textAreaVisible:false};
				listener(false);
				scaleModeSort();
				modalWindow = new ModalWindow_fullscreen(staticStage, params, header, '',completeCallback);
			}
		}
		
	}
}


