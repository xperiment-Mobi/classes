package com.xperiment.preloader
{
	import com.greensock.events.LoaderEvent;
	
	import flash.utils.ByteArray;

	public interface IPreloadStimuli
	{
		function kill():void
		function cleanupFunctsListeners(onAllLoaded:Function,onAllProgress:Function,onAllError:Function):void
		function countOfLoadingItems():uint
		function progress():Number
		function countOfBytesLoaded():uint
		function mbTotal():uint
		function removeFileFromMemory(nam:String):void
		function fileLoaded(nam:String):Number
		function give(filename:String,appendLocalDir:Boolean=true):ByteArray
		function giveStimuli_to_P2PExpt(f:Function):void
		function giveBinary(str:String):uint
		function getFilesFromWeb(pause:Boolean=false):void
		function onFilesLoaded(e:LoaderEvent):void
		function onItemsProgress(e:LoaderEvent):void 
		function linkUp(onAllLoaded:Function, onAllProgress:Function, onAllError:Function):void
		function listenFileLoad(onFileLoaded:Function, onFileProgress:Function, onFileError:Function, filename:String):void	
		function appendToQueue(fileToLoad:Array):Boolean
		function appendToQueueAndLoad(filesToLoad:Array):void
	}
}