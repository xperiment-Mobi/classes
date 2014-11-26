package com.xperiment.preloader
{
	import com.greensock.events.LoaderEvent;
	import com.xperiment.codeRecycleFunctions;
	import flash.utils.ByteArray;

	public class Preloader_P2P implements IPreloadStimuli
	{
		private var stimuli:Object;
		private var directory:String;
		
		public function Preloader_P2P(stimuli:Object,directory:String)
		{
			this.stimuli = stimuli;
			this.directory = codeRecycleFunctions.fixLocalDir(directory);

		}
		
		public function kill():void{
			for(var stim:String in stimuli){
				stimuli[stim]=null;
			}
			stimuli=null;
		}
		
		public function give(filename:String,appendLocalDir:Boolean=true):ByteArray{
			var obj:Object = stimuli[directory+filename]
			for(var key:String in obj){
				trace(key,22);
			}
			if(!stimuli.hasOwnProperty(directory+filename)){
				throw new Error("stimulus requested that was not transferred during P2p!: "+filename);
			}
			
			else return stimuli[directory+filename].data;
		}
		
		public function cleanupFunctsListeners(onAllLoaded:Function,onAllProgress:Function,onAllError:Function):void{}
		public function countOfLoadingItems():uint{return 1}
		public function progress():Number{return 1}
		public function countOfBytesLoaded():uint{return 1}
		public function mbTotal():uint{return 1}
		public function removeFileFromMemory(nam:String):void{}
		public function fileLoaded(nam:String):Number{return 1}
		public function giveStimuli_to_P2PExpt(f:Function):void{}
		public function giveBinary(str:String):uint{return 1}
		public function getFilesFromWeb(pause:Boolean=false):void{}
		public function onFilesLoaded(e:LoaderEvent):void{}
		public function onItemsProgress(e:LoaderEvent):void {}
		public function linkUp(onAllLoaded:Function, onAllProgress:Function, onAllError:Function):void{}
		public function listenFileLoad(onFileLoaded:Function, onFileProgress:Function, onFileError:Function, filename:String):void	{}
		public function appendToQueue(fileToLoad:Array):Boolean{return false}
		public function appendToQueueAndLoad(filesToLoad:Array):void{}
		
	}
}