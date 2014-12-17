package com.xperiment.make.xpt_interface.trialDecorators.StimBehav
{
	import com.xperiment.make.xpt_interface.TrialBuilder;
	import com.xperiment.make.xpt_interface.runnerBuilder;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.stimuli.StimulusFactory;


	public class StimBehav
	{
		private static var runner:runnerBuilder;
	
		
		public static function setup(r:runnerBuilder):void
		{
			runner=r;		

		}
		
	
		
		public static function addStimulus(type:String,params:Object=null,update:Boolean=true):void
		{
	
			type = StimulusFactory.getName(type)
			
			var stim:XML = <{type} />;
			for(var key:String in params){
				stim.@[key] = params[key];
			}
			
			
			BindScript.addStimulus((runner.runningTrial as TrialBuilder).bind_id,stim,update);	
			(runner.runningTrial as TrialBuilder).xml.prependChild(stim.copy());
			
		}

		
		public static function addLoadableStimuli(filenames:Array,overTrials:Boolean):void
		{
			
			var type:String;
			var stimType:String;
			var filename:String;
			var arr:Array;
			var countTypes:int=0;
			var stimuli:Object = {};
			
			var split:String="---";
			if(overTrials){
				split=';';
			}
			
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
				if(stimuli.hasOwnProperty(stimType)==false){
					countTypes++;
					stimuli[stimType] = [];
				}
				stimuli[stimType].push(filename);
			}
			
			var count:int=0;
			var update:Boolean = false;
			var props:Object;
			 
			for(stimType in stimuli){
				count++;
				if(count==countTypes){
					update = true;		
				}
				props = {filename:stimuli[stimType].join(split)};
				//trace(2222,JSON.stringify(props));
				if(overTrials==false){
					props.howMany = stimuli[stimType].length;
				}
				
				runner.preloader.appendToQueueAndLoad(stimuli[stimType]);
				addStimulus(stimType,props,update);
			}
			
			

			
		}		
	}
}