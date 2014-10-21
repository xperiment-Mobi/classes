package com.xperiment.runner {
	
	import com.Start.MobileStart.MobileScreen;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.XMLstuff.saveResultsAndroid;
	import com.xperiment.runner.runner;
	import com.xperiment.trial.Trial;	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class runner_devices extends runner {
		
		public var actionBar:uint=48;
		
		public function runner_devices(theStage:Stage){
			super(theStage);
		}
		
		override public function newTrial():Trial{
			throw new Error();
			return new Trial();
		}
		
		
		public function ExptWideSpecs_deviceSpecific():void{
			throw new Error();
		}
		
		protected function getMobileScreen():MobileScreen{
			return new MobileScreen(theStage,ExptWideSpecs.IS('orientation').toLowerCase(),ExptWideSpecs.IS('width'),ExptWideSpecs.IS('height'),ExptWideSpecs.IS('aspectRatio'));
		}
		
		override public function initDeviceSpecificStuff():void{
			
			ExptWideSpecs_deviceSpecific();
			
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE,deactivateL);
			
			
			var mobileScreen:MobileScreen = getMobileScreen();

			mobileScreen.addEventListener(Event.COMPLETE,function(e:Event):void{
				e.target.removeEventListener(e.type, arguments.callee);
				///////////////////
				///anonymous function
				Trial.RETURN_STAGE_HEIGHT=MobileScreen.VIRTUAL_Height;
				Trial.RETURN_STAGE_WIDTH =MobileScreen.VIRTUAL_Width;
				Trial.ZOOM_X			     =MobileScreen.ZOOM_X;
				Trial.ZOOM_Y			     =MobileScreen.ZOOM_Y;
				Trial.VERTICAL_ADJUST    =MobileScreen.VERTICAL_ADJUST;
				Trial.HORIZONTAL_ADJUST  = MobileScreen.HORIZONTAL_ADJUST;
				Trial.ACTUAL_STAGE_WIDTH= MobileScreen.ACTUAL_WIDTH;
				Trial.ACTUAL_STAGE_HEIGHT= MobileScreen.ACTUAL_HEIGHT;
				
				mobileScreen.kill();
				startStudyQuery('sortScreen');
				///anonymous function
				///////////////////			
			});
			
			mobileScreen.init();
		}
		
		protected function deactivateL(e:Event):void
		{
			if(!NativeApplication.nativeApplication.hasEventListener(Event.ACTIVATE)){
				pause(true);
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE,function(e:Event):void{
					e.currentTarget.removeEventListener(e.type,arguments.callee);
					pause(false);	
				});
			}
			
		}
		
		
		override public function askedToQuit():void
		{
			
			NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE,deactivateL);
			NativeApplication.nativeApplication.exit();
		}
		
		override public function endProgram():void {
			
			if(trialList){
				for(var i:int; i<trialList.length;i++){
					if((trialList[i] as Trial).trialInfo!=null)(trialList[i] as Trial).generalCleanUp();
				}
			}
			
			this.kill();
			
			if(ExptWideSpecs.IS("autoClose") as Boolean  == true){
				var endTimer:Timer = new Timer(ExptWideSpecs.IS("autoCloseTimer") as Number,1);
				
				endTimer.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
					endTimer.removeEventListener(e.type,arguments.callee);
					NativeApplication.nativeApplication.exit();
				});
				
				endTimer.start();
			}
			else{
				theStage.dispatchEvent(new Event("endOfStudy"));
			}
		}
		
		override public function saveDataProcedure():void{
			//extractStudyData();
			var dataSave:saveResultsAndroid = new saveResultsAndroid(theStage);
			dataSave.save();
		}
		
		
		public function pause(ON:Boolean):void
		{
			if(runningTrial){
				runningTrial.pause(ON);
			}
			
		}
	}
}