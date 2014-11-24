package com.xperiment.make.xpt_interface.trialDecorators.StimBehav
{
	import com.xperiment.make.xpt_interface.TrialBuilder;
	import com.xperiment.make.xpt_interface.runnerBuilder;
	import com.xperiment.make.xpt_interface.Bind.BindScript;


	public class StimBehav
	{
		private static var runner:runnerBuilder;
	
		
		public static function setup(r:runnerBuilder):void
		{
			runner=r;		

		}
		
		/*public static function addLoadableStimuli(stims:Array):void
		{
			function IS(nam:String,what:String):Boolean{
				return nam.indexOf(what)!=-1;
			}
			
			var type:String;
			for each(var stim:String in stims){
				type='';
				if(	        IS(stim,"jpg" ) )	type="jpg";
				else if(	IS(stim,"png" ) )	type="jpg";
				else if(	IS(stim,"mp3" ) )	type="sound";
				else if(	IS(stim,"flv" ) )	type="video";
				
				if(type!=''){

					addStimulus(	type,{filename:stim}	)
				}
			}
			
		}*/
		
		public static function addStimulus(type:String,params:Object=null,update:Boolean=true):void
		{
	
			var stim:XML = <{type} />;
			for(var key:String in params){
				stim.@[key] = params[key];
			}
			
			(runner.runningTrial as TrialBuilder).xml.prependChild(stim.copy());
			BindScript.addStimulus((runner.runningTrial as TrialBuilder).bind_id,stim,update);	
			
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
		
	
		
		public static function addLoadableStimuli(filenames:Array):void
		{
			
			var type:String;
			var stimType:String;
			var filename:String;
			var arr:Array;
			
			for (var i:int=0;i<filenames.length;i++){
				filename = filenames[i];
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
	
				runner.preloader.appendToQueueAndLoad([filename]);
				addStimulus(stimType,{filename:filename},i==filenames.length-1);
			}
			
			
		}		
	}
}