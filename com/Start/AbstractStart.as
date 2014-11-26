package com.Start
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.xperiment.messages.XperimentMessage;
	import com.xperiment.runner.runner;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class AbstractStart implements CanRestart
	{
		private var scriptLoader:XMLLoader;
		protected var content:XML;
		public var expt:runner;
		
		public var theStage:Stage;
		
		
		public function AbstractStart(theStage:Stage,scriptName:String=''){
			theStage.align=StageAlign.TOP_LEFT;
			theStage.scaleMode=StageScaleMode.SHOW_ALL;
			//theStage.autoOrients = true;
			//theStage.setOrientation(StageOrientation.DEFAULT);
			this.theStage=theStage;
		}
		
		public function kill():void{
			LoadingAnimation.kill();
			scriptListeners(false);
			scriptLoader=null;
		}
		
		public function scriptLoad(scriptName:String):void
		{
			scriptLoader = new XMLLoader(scriptName,{noCache:true});
			scriptListeners(true);	
			LoadingAnimation.init(theStage);
			scriptLoader.load();
			
		}
		
		public function kill_expt():void{
			if(expt)expt.kill();
		}
		
		public function restart():Function{

			return function():void{
				expt.kill();
				startExpt(content);}
		}
		
		private function dataLoaded(e:LoaderEvent):void
		{
			if(!content)content=e.target.content;	
			startExpt(content);
			kill();
		}	
		
		private function dataLoading(e:LoaderEvent):void
		{
			LoadingAnimation.progress(scriptLoader.progress)
		}	
		
		
		public function dataNotLoaded(e:LoaderEvent):void
		{
			
			XperimentMessage.message(theStage, "Afraid your Xperiment Script cannot be loaded.  Here is the error message: \n"+e.text);
			kill();
		}
		
		public function scriptListeners(load:Boolean):void{
			if(load){
				if(scriptLoader && !scriptLoader.hasEventListener(LoaderEvent.COMPLETE)){
					scriptLoader.addEventListener(LoaderEvent.COMPLETE,dataLoaded);
					scriptLoader.addEventListener(LoaderEvent.CHILD_PROGRESS,dataLoading);
					scriptLoader.addEventListener(LoaderEvent.FAIL,dataNotLoaded);
				}
			}
			else{
				if(scriptLoader && scriptLoader.hasEventListener(LoaderEvent.COMPLETE)){
					scriptLoader.removeEventListener(LoaderEvent.COMPLETE,dataLoaded);
					scriptLoader.removeEventListener(LoaderEvent.CHILD_PROGRESS,dataLoading);
					scriptLoader.removeEventListener(LoaderEvent.FAIL,dataNotLoaded);
					}
			}
		}
				
		public function startExpt(script:XML):void
		{
			expt = exptPlatform();
			expt.giveScript(script);
		}
		
		public function exptPlatform():runner{
			return new runner(theStage);
		}
	}
}