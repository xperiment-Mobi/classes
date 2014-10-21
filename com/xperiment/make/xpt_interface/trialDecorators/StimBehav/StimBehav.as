package com.xperiment.make.xpt_interface.trialDecorators.StimBehav
{
	import com.xperiment.make.xpt_interface.TrialBuilder;
	import com.xperiment.make.xpt_interface.runnerBuilder;

	public class StimBehav
	{
		private static var runner:runnerBuilder;
		private static var addStim:Function;
		
		public static function setup(r:runnerBuilder, a:Function):void
		{
			runner=r;
			addStim=a;			
		}
		
		public static function addLoadableStimuli(stims:Array):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public static function addStimulus(type:String,params:Object=null):void
		{
			type = type.charAt(0).toUpperCase()+type.substr(1);
			var stim:XML = <{type} />;
			addStim((runner.runningTrial as TrialBuilder).bind_id,stim);	
			(runner.runningTrial as TrialBuilder).xml.prependChild(stim.copy());
		}
/*		
		public static function addStimToBind(stim:uberSprite):void
		{
			var trial:TrialBuilder = runner.runningTrial as TrialBuilder;
			//trace(123,trial.bind_id,addStim,stim as object_baseClass)
			var bind_id:String = addStim(trial.bind_id,(stim as object_baseClass).stimXML);
			(stim as object_baseClass).OnScreenElements[BindScript.bindLabel] = bind_id;
		}
		*/
		
	
		
		private static function addLoadableStimuli(filenames:Array):void
		{
			
			var type:String;
			var stimType:String;
			var filesToLoad:Array=[];
			var arr:Array;
			for each(var filename:String in filenames){
				arr=filename.split(".");
				type = arr[arr.length-1].toLowerCase();
				if(["jpg","jpeg","png"].indexOf(type)!=-1){
					stimType="jpg";
				}
				else if(["mp3"].indexOf(type)!=-1){
					stimType="mp3";
				}
				else if(["flv","f4v","mp4"].indexOf(type)!=-1){
					stimType="video";
				}
				else{
					throw new Error("was passed unknown filetype from JS "+filename);
				}
				filesToLoad.push(filename);
			}
			
			
			if(filesToLoad.length>0){
				runner.preloader.appendToQueueAndLoad(filesToLoad);
				for each(filename in filesToLoad){
					addStimulus(stimType,{filename:filename});
				}
			}
			
			
			
		}		
	}
}