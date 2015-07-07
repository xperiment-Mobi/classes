package com.Start
{

	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.xperiment.messages.XperimentMessage;
	import com.xperiment.runner.runner;
	
	import flash.display.Stage;

	//import flash.display.StageAlign;
	//import flash.display.StageScaleMode;

	public class AbstractStart implements CanRestart
	{
		private var scriptLoader:DataLoader;
		public var scriptXML:XML;
		public var expt:runner;
		public var theStage:Stage;
		
		
		
		public function AbstractStart(theStage:Stage,scriptName:String=''){
			//theStage.align=StageAlign.TOP_LEFT;
			//theStage.scaleMode=StageScaleMode.SHOW_ALL;
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
			
			scriptLoader = new DataLoader(scriptName,{noCache:true});
			scriptListeners(true);	
			LoadingAnimation.init(theStage);
			try{
				scriptLoader.load();
			}
			catch(e:Error){
				trace(e);
			}
			trace("start load");
			
		}
		
		public function kill_expt():void{
			if(expt){
				trace("kill expt");
				expt.kill();
			}
		}
		
		public function restart():Function{

			return function():void{
				expt.kill();
				startExpt(scriptXML);}
		}
		
		private function dataLoaded(e:LoaderEvent):void
		{
			//trace(111)
			var params:Object ;

			if(!scriptXML){
				params = {}
				var str:String = e.target.content;
				var arr:Array = str.split('---end script---')
				if(arr.length>1){
					params = {};
					scriptXML = XML(arr[0]);
					var strSplit:Array;
					for each(str in arr[1].split("\n")){
						strSplit=str.split(":");
						if(strSplit.length>1) {
							params[strSplit[0]] = strSplit[1];
						}
					}
				}
				else scriptXML = XML(str);
			}

			startExpt(scriptXML,params);
			kill();
		}	
		
		private function dataLoading(e:LoaderEvent):void
		{
			LoadingAnimation.progress(scriptLoader.progress)
		}	
		
		
		public function dataNotLoaded(e:LoaderEvent):void
		{
			trace("prob loading data");
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
		
		protected function modifyScript(script:XML):void{
		}
		
		protected function modifyParams(params:Object):void{
			params ||= {};
		}
				
		public function startExpt(script:XML, params:Object = null):void
		{
			
			modifyScript(script);
			modifyParams(params);

			expt = exptPlatform();
			expt.giveScript(script, null, params);
		}
		
		public function exptPlatform():runner{
			return new runner(theStage);
		}
	}
}