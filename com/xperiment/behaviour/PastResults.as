package com.xperiment.behaviour
{
	import com.xperiment.Animation.MessageAnimation;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.events.StimulusEvent;
	import com.xperiment.behaviour.PastResults.PastResultsLoader;

	public class PastResults extends behav_baseClass
	{
		private var loader:PastResultsLoader;
		
		override public function setVariables(list:XMLList):void {
			
			setVar("int","filenames","*");
			setVar("string","variables","average:approxDurationInSeconds");
			var s: ExptWideSpecs
			super.setVariables(list);

		}	
		
		
		override public function nextStep(id:String=""):void{
			
			loader = new PastResultsLoader(getVar("filenames"),getVar("variables"), null, loadedF);
			loader.load();
			
		}
		
		private function afterLoaded():void
		{
			pic.dispatchEvent(new StimulusEvent(StimulusEvent.ON_FINISH));
			
		}	
		
		private function loadingF(val:Number):void{
			trace('have loaded',val);
		}
		
		private function loadedF(success:Boolean):void{
			if(success){
				if(loader.fileCount==0){
					var s:MessageAnimation = new MessageAnimation(pic,"no past data to load!",5,true);
				}
				else afterLoaded();
				
					
			}
			else	s = new MessageAnimation(pic,"could not load past data!",5,true);
				
		}		
		
	}
}