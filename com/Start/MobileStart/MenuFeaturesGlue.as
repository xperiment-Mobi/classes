package com.Start.MobileStart
{
	import com.Start.MobileStart.ListExperiments.ExptInfo;
	import com.Start.MobileStart.ListExperiments.ListExperiments;
	import com.Start.MobileStart.Screens.view.Ui_View_madComp;
	import com.Start.MobileStart.Screens.view.iUi;
	import com.dropbox.DropboxConnection;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.Timer;
	
	
	public class MenuFeaturesGlue extends Sprite
	{
		
		
		private var exptList:Vector.<ExptInfo>;
		
		private var theStage:Stage;
		private var expts:ListExperiments
		private var dropbox:DropboxConnection
		
		private var ui:iUi;
		private var timer:Timer;
		
		
		public function kill():void{
			uiListeners(false);
			ui.kill();
			ui=null;
			expts=null;
			
			for each(var expt:ExptInfo in exptList){expt.kill();}
			
			expt = null;
			exptList = null;
			theStage.removeChild(this);
			System.gc();
		}

		
		public function getExpt():XML{
			var exptToRun:String = ui.experimentToRun;
			
			for each(var exptInfo:ExptInfo in exptList){				
				if(exptInfo.exptName==exptToRun){
					trace(exptInfo,222,exptToRun,ui.condition)
					return exptInfo.forceCondition_updateFolder(ui.condition);
				}
			}
			
			throw new Error('devel error: unknown study selected from ui menu');
			return null;
		}
		
		
		
		public function MenuFeaturesGlue(theStage:Stage):void
		{
			this.theStage = theStage;
			theStage.addChild(this);
			getExperiments();
		}
		
		private function getExperiments():void
		{
			function callBackF():void{
				exptList=expts.getList();
				expts=null;
				if(!ui)setupScreen();
				ui.expts=composeExptsObj();
				ui.disable(false);
				
			}
			
			expts = new ListExperiments(callBackF);
			expts.process();
			
		}
		
		private function setupScreen():void{
			this.ui= new Ui_View_madComp();
			this.addChild(ui as Sprite);
			
			uiListeners(true);
			
			ui.create();
		}
		
		private function composeExptsObj():Object
		{
			var obj:Object = {};
			var conditions:Array;
			var i:int;

			
			for each(var expt:ExptInfo in exptList){
				conditions=[];
				
				//converting String Vector to Array
				if(expt.conditions){		for(i=0;i<expt.conditions.length;i++)	{conditions.push(expt.conditions[i]);}		}

				obj[expt.exptName] = conditions;
			}
			
			return obj;
		}
		
		private function uiListeners(ON:Boolean):void
		{
			var f:Function;
			if(ON)	f=(ui as Sprite).addEventListener;				
			else	f=(ui as Sprite).removeEventListener;
			
			f("refresh",refreshL);
			f("quit",quitL);
			f("dropboxSync",dropboxSyncL);
			f("cloudSync",cloudSyncL);
			f("runStudy",runStudyL);	
			f("killDropboxCreds",killDropboxCredsL);			
			f("killCLoudCreds",killCloudCredsL);
			f("killExpts",killExptsL);
			
		}	
		
		private function refreshL(e:Event):void{
			getExperiments();
		}
		
		private function quitL(e:Event):void{
			NativeApplication.nativeApplication.exit();
		}
		
		private function killCloudCredsL(e:Event):void{
			ui.popup('not implemented yet');
		}
		
		private function killExptsL(e:Event):void{
			ui.popup('not implemented yet');
		}
		
		
		private function runStudyL(e:Event):void{
			
			if(ui.experimentToRun !=''){
				ui.setForFutureExptToRun(ui.experimentToRun);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		
		
		private function cloudSyncL(e:Event):void
		{
			ui.popup('not implemented yet');
			trace("not implemented yet, cloudSync");
		}	
		
		private function dropboxSyncL(e:Event):void
		{
			ui.wipeFeedback();
			ui.disable(true);
			setupDropBox();
			
			dropbox.appKey="1r9mdwov0wpwmow";
			dropbox.appSecret="rzr3icjfbj2s12o"
			dropbox.folderToSync = 'xperiment';
			dropbox.pipeLog=ui.pipeLog;		
			dropbox.addEventListener(Event.COMPLETE,function(e:Event):void{
				//nested F
				e.target.removeEventListener(e.type, arguments.callee);
				ui.disable(false);
				getExperiments();
				/////////
			},false,0,false)
			
			dropbox.link()
		}
		
		private function setupDropBox():void{
			if(!dropbox){
				dropbox = new DropboxConnection(theStage,true);
				dropboxBgListeners(true);
			}
		}
		
		private function killDropboxCredsL(e:Event):void{
			setupDropBox();
			if(dropbox.killCredentials()){
				ui.popup("deleted Dropbox credentials");
			}
			else{
				ui.popup("could not delete Dropbox credentials as they doughnut exist");
			}
		}
		
		private function dropboxBgListeners(on:Boolean):void
		{
			var f:Function;
			if(on)	f=dropbox.addEventListener;
			else	f=dropbox.removeEventListener;
			
			f("backgroundtrue",backgroundL);
			f("backgroundfalse",backgroundL);
		}		
		
		protected function backgroundL(e:Event):void
		{
			if(e.type=='backgroundtrue'){
				ui.disable(true);
			}
			else{
				ui.disable(false);
			}
			
		}
		
	}
}