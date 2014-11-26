package com.xperiment.stimuli.primitives
{
	import com.greensock.loading.core.LoaderItem;
	import com.xperiment.preloader.IPreloadStimuli;
	import com.xperiment.stimuli.IgivePreloader;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.ByteArray;
	
	import avmplus.getQualifiedClassName;

	public class LoadStimulus extends object_baseClass implements IgivePreloader
	{

		private var myLoader:LoaderItem;
		private var preloader:IPreloadStimuli;
		
		override public function kill():void {
	
			if(getVar("destroyStimulusAfter") as Boolean) removeStimulusFromPreloader(getVar("filename"));
			myLoader=null;

			while(pic.numChildren>0){
				pic.removeChildAt(0);
			}
			super.kill();
		}
		
		public function removeStimulusFromPreloader(filename:String):void{
			preloader.removeFileFromMemory(filename);
		}
		
		public function givePreloaded():*{
		
			if (preloader && preloader.progress()==1){
				
				return preloader.give(getVar("filename"));
			}

			return null;
		}

		public function setVariables_loadingSpecific():void{
			
			setVar("boolean","destroyStimulusAfter",false);

			if(OnScreenElements.hasOwnProperty("extension")==false)	setVar("string","extension","",'do not use a dot here, e.g. jpg, nb this is optional');

			if(getVar("extension")!="" && getVar("filename").indexOf(".")==-1)	{
				OnScreenElements.filename=OnScreenElements.filename+"."+getVar("extension");
			}

		}
		
		public function setupPreloader():void{

			if(preloader)	{
				preloader.listenFileLoad(loaded,null,null,getVar("filename"));
			}
		}
		
	
		public function loaded():void{
			doAfterLoaded(preloader.give(getVar("filename")));
		}
		
		
		public function doAfterLoaded(content:ByteArray):void
		{
			throw new Error("override this function svp");
			
		}		
		
		public function passPreloader(preloader:IPreloadStimuli):void {
			this.preloader=preloader;
		}
	}
}