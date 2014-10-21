package com.xperiment.preloader{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.core.LoaderItem;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.messages.XperimentMessage;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.ByteArray;
	
	public class PreloadStimuli extends Sprite implements IPreloadStimuli {
		public static var queue:LoaderMax;
		public var files:Array = new Array;
		public var maximumTries:String="5";
		//public var remoteDirectory:String="";
		public var localDirectory:String="";
		
		private var FunctsOnLoaded:Vector.<Function>;
		private var FunctsOnAllProgress:Vector.<Function>;
		private var FunctsOnAllError:Vector.<Function>;
		private var FsRequestingPingonSuccess:Vector.<Function>;
		
		private var FunctsOnFileLoaded:Object;
		private var FunctsOnFileProgress:Object; 
		private var FunctsOnFileError:Object;
		
		private var forceReload:Boolean = false;;
		private var theStage:Stage;
		private var killXperimentF:Function;
		private var encrypted:Boolean = false;
		
		public static var preserveQueue:Boolean = false;
		
		public function kill():void{
			if(queue && preserveQueue==false){
				queue.cancel()
				queue.empty(true,true);
			}
			
			for each(var v:Vector.<Function> in [FunctsOnLoaded,FunctsOnAllProgress,FunctsOnAllError]){
				wipeVector(v);
			}
			
			for each(var a:Object in [FunctsOnFileLoaded,FunctsOnFileProgress,FunctsOnFileError]){
				if(a){
					for(var key:String in a){
						v = a[key]
						wipeVector(v);
					}
					a=null;
				}
			}
			
			function wipeVector(v:Vector.<Function>):void{
				if(v){
					for(var i:int=0;i<v.length;i++){
						v[i]=null;					
					}
					v=null;
				}
			}
			
			removeListeners();
		}
		
		private function removeListeners():void
		{
			if(queue){
				if(queue.hasEventListener(LoaderEvent.CHILD_COMPLETE))queue.addEventListener(LoaderEvent.CHILD_COMPLETE,fileCompleted);
				if(queue.hasEventListener(LoaderEvent.CHILD_PROGRESS))queue.addEventListener(LoaderEvent.CHILD_PROGRESS,fileProgress);
				if(queue.hasEventListener(LoaderEvent.CHILD_FAIL))queue.addEventListener(LoaderEvent.CHILD_FAIL,fileFailed);
			}
		}	
		
		public function cleanupFunctsListeners(onAllLoaded:Function,onAllProgress:Function,onAllError:Function):void
		{
			
			if(Boolean(onAllLoaded) && Boolean(FunctsOnLoaded)){
				var pos:int=FunctsOnLoaded.indexOf(onAllLoaded);
				if(pos!=-1)FunctsOnLoaded.splice(pos,1);
			}
			
			if(Boolean(onAllProgress) && Boolean(FunctsOnAllProgress)){
				pos=FunctsOnLoaded.indexOf(onAllProgress);
				if(pos!=-1)FunctsOnAllProgress.splice(pos,1);
			}
			
			if(Boolean(onAllError) && Boolean(FunctsOnAllError)){
				pos=FunctsOnAllError.indexOf(onAllError);
				if(pos!=-1)FunctsOnAllError.splice(pos,1);
			}
			//trace("here")
		}
		
		
		public function countOfLoadingItems():uint{
			return files.length;
		}
		
		public function progress():Number
		{
			if(queue){
				//changed Feb 2014 to give better indication of process for odd sized files.
				
				return  queue.rawProgress;
				//return queue.progress;
			}
			return 0
		}
		
		private function countOfLoadedItems():uint{
			if(queue) return queue.rawProgress;
			return 0;
		}
		
		public function countOfBytesLoaded():uint{
			if(queue) return queue.bytesLoaded;
			return 0
		}
		
		
		public function mbTotal():uint{
			if(queue) return queue.bytesTotal;
			return 0;
		}
		
		public function removeFileFromMemory(nam:String):void{

			var loader:LoaderItem = queue.getLoader(localDirectory+nam)
			if(loader==null) throw new Error ("loaded stimulus does not exist - please report this message to developers");
			queue.remove(loader);
			loader.dispose(true);
			//trace('disposed');
		}
		
		//public function 
		public function fileLoaded(nam:String):Number
		{					
			if(queue){
				if(queue.progress==1)return 1;

						
				var loader:LoaderItem = queue.getLoader(localDirectory+nam)

				if(loader==null){
					
					if(nam.indexOf("undefined")!=-1) throw new Error ("Error when loading a stimulus. You have not defined 'filename' somewhere.");
					else throw new Error ("loaded stimulus "+nam+" does not exist - please report this message to developers");
				}
				else{
					return loader.progress;
				}
			}
			
			return 0
		}
		
		
		public function PreloadStimuli(script:XML,theStage:Stage,kill:Function=null):void{
			this.theStage=theStage;
			this.killXperimentF=kill;
			
			if(script!=null){
				localDirectory=codeRecycleFunctions.fixLocalDir(ExptWideSpecs.IS('stimuliFolder'));
				if(ExptWideSpecs.IS('forceStimuliReload') == true) 	forceReload=true;
				seekLoadable(script);
			}
		}
		
		public function seekLoadable(script:XML):void
		{
			var arr:Array;
			var fileExtension:String='';
			var filename:String;
			
			for each(var attrib:XML in script..@*){
				if(attrib.name().toString().toLowerCase()=="filename"){	
					
					fileExtension = attrib.parent().@extension;

					if(fileExtension!='' && fileExtension.indexOf(".")==-1)	fileExtension = "."+fileExtension;	
					
					arr=attrib.toString().replace(/---/g,",").replace(/&/g,",").replace(/;/g,",").split(",");
					
					for (var i:int=0;i<arr.length;i++){
						filename=arr[i];
						if(fileExtension!='' && filename.indexOf(".")==-1)	filename=filename+fileExtension;
						
						if(files.indexOf(localDirectory+filename)==-1)		files.push(localDirectory+filename);							
					}
				}
			}
			
			if(files.length>0){
				
				if(ExptWideSpecs.IS("one_key")!=""){// && ExptWideSpecs.IS("isDebugger")==false) {
					encrypted = true;
					Encrypted.getKey(encryptCallBack);
					///encryptCallBack('WDR9XzJlCwIEuiB4');
					
					function encryptCallBack(key:String):void{
						if(key)	{
							EncryptedDataLoader.stage=theStage;
							EncryptedDataLoader.setCipher(key);
							getFilesFromWeb();
						}
						else{
							var problem:String = 'This experiment is encrypted. We have tried repeatedly but have been unable to unencrypt media used in this study.';
							theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.PROBLEM,problem));
						}
						
					}
				}
					
				else getFilesFromWeb();
			}
		}
		
		public function give(filename:String,appendLocalDir:Boolean=true):ByteArray{			
			
			if(appendLocalDir==true)filename=localDirectory+filename;
			var loadedItem:LoaderItem = queue.getLoader(filename);
		
			if(loadedItem==null)return null;
			var ba:ByteArray= (loadedItem as DataLoader).content as ByteArray;
			ba.position=0;
			return ba
		}
		
		
		public function giveStimuli_to_P2PExpt(f:Function):void{
			var stimuli:Array= [];
			
			if(progress()==1)send();
			else{
				
				queue.addEventListener(LoaderEvent.COMPLETE,function(e:LoaderEvent):void{
					//anonymous function
					queue.removeEventListener(LoaderEvent.COMPLETE,arguments.callee);
					//
					send();
				})
			}
			
			function send():void{
				
				for each(var loader:DataLoader in queue.getChildren()){
					stimuli[loader.url] = loader.content;
				}
				f(stimuli);
			}
		}
		
		
		public function giveBinary(str:String):uint{
			return(queue.bytesLoaded);
		}
		
		public function getFilesFromWeb(pause:Boolean=false):void{

			if(pause)queue.pause(); //for testing
			
			if(!pause){
				if(!queue)	setupQueue();
				var loadingOccurs:Boolean = appendToQueue(files);
				if(loadingOccurs)	queue.load(); //for testing	
			}
		}
		
		private function setupQueue():void{
			LoaderMax.defaultAuditSize = false;
			queue = new LoaderMax({name:"mainQueue", onProgress:onItemsProgress, onComplete:onFilesLoaded, onError:onAllError,maxConnections:5});
		}
		
		public function appendToQueueAndLoad(filesToLoad:Array):void{
			var urls:Array=[];
			for(var i:int=0;i<filesToLoad.length;i++){
				urls[i]=localDirectory+filesToLoad[i];
			}
			if(!queue)	setupQueue();
			if(appendToQueue(urls)){
				queue.load();
			}

		}
		
		public function appendToQueue(fileToLoad:Array):Boolean
		{
			var typ:String;
			var fil:String;
			
			var loadingOccurs:Boolean=false;
			for (var i:uint=0;i<fileToLoad.length;i++){				
				fil=fileToLoad[i];
				//trace(1234,queue.getLoader(fil),queue.getLoader(fil))
				
				if(queue.getLoader(fil) == null){
					loadingOccurs=true;
					
					var loader:Class;
					if(encrypted)	loader = EncryptedDataLoader;
					else			loader = DataLoader;

					//does not work with encryption
					if(fil.indexOf("swf")!=-1)	FontLoad.init(this,fil,'');
						//else if(encrypted)			queue.append( new loader(remoteDirectory+fil, {noCache:forceReload}) );
					else 						queue.append( new loader(fil, {format:'binary', noCache:forceReload}) );
				}
				
			}

			return loadingOccurs;
		}
		
		public function onFilesLoaded(e:LoaderEvent):void {

			if(encrypted) EncryptedDataLoader.kill();
			if(FunctsOnLoaded){
				for(var i:int=0;i<FunctsOnLoaded.length;i++){
					if(FunctsOnLoaded[i] is Function)	FunctsOnLoaded[i](countOfBytesLoaded());
				}
			}
			removeListeners();
		}
		
		public function onItemsProgress(e:LoaderEvent):void {	
			//trace(e.currentTarget,e.target.progress);
			if(FunctsOnAllProgress){
				for(var i:int=0;i<FunctsOnAllProgress.length;i++){
					if(FunctsOnAllProgress[i] is Function)	FunctsOnAllProgress[i](progress(),countOfBytesLoaded());
				}
			}
		}
		
		private function onAllError(e:LoaderEvent ): void{
			if(FunctsOnAllError){
				for(var i:int=0;i<FunctsOnAllError.length;i++){
					if(FunctsOnAllError[i] is Function)	FunctsOnAllError[i](e.toString());
				}	
			}
			removeListeners();
			trace ("error loading files unfortunately: "+e); 
			
			var file:String = e.text;
			var arr:Array = file.split('\\');
			if(arr.length==1)arr=file.split("/");
			
			XperimentMessage.message(theStage, "Afraid a stimulus cannot be loaded "+arr[arr.length-1],false);
			if(killXperimentF)killXperimentF();
		}
		
		
		
		
		/////////////////////////////////////////////
		/////////////////////////////////////////////
		//trace below for stimuli to listen for file when it has loaded
		
		public function linkUp(onAllLoaded:Function, onAllProgress:Function, onAllError:Function):void
		{
			if(!Boolean(FunctsOnLoaded) && Boolean(onAllLoaded))FunctsOnLoaded 			= 			new Vector.<Function>;
			if(!Boolean(FunctsOnAllProgress) && Boolean(onAllProgress))FunctsOnAllProgress =		new Vector.<Function>;
			if(!Boolean(FunctsOnAllError) && Boolean(onAllError))FunctsOnAllError = 				new Vector.<Function>;
			
			if(Boolean(onAllLoaded))FunctsOnLoaded[FunctsOnLoaded.length]=				onAllLoaded;
			if(Boolean(onAllProgress))FunctsOnAllProgress[FunctsOnAllProgress.length]=	onAllProgress;
			if(Boolean(onAllError))FunctsOnAllError[FunctsOnAllError.length]=			onAllError;
		}
		
		public function listenFileLoad(onFileLoaded:Function, onFileProgress:Function, onFileError:Function, filename:String):void
		{

			if(!filename || filename=="")	throw new Error ("not given file name: "+filename);
			
			if(Boolean(onFileLoaded))	createListener(onFileLoaded,1,filename);
			if(Boolean(onFileProgress))	createListener(onFileProgress,0,filename);
			if(Boolean(onFileError))	createListener(onFileError,-1,filename);	
		}
		
		private function createListener(actionf:Function,type:int,filename:String):void{

			var obj:Object;
			
			if(fileLoaded(filename) && type!=-1){
				actionf();	//avoids a race condition when there are MANY files to load
			}
			
			else{
				if(type==1){
					
					FunctsOnFileLoaded ||= {};
					obj=FunctsOnFileLoaded;
					var listener:String=LoaderEvent.CHILD_COMPLETE
					var listenerF:Function = fileCompleted;
				}
				else if(type==0){
					FunctsOnFileProgress ||= {};
					obj=FunctsOnFileProgress;
					listener=LoaderEvent.CHILD_PROGRESS;
					listenerF = fileProgress;
				}
				else if(type==-1){
					FunctsOnFileError ||= {};
					obj=FunctsOnFileError;
					listener=LoaderEvent.CHILD_FAIL
					listenerF = fileFailed;
				}
				
				if(queue && !queue.hasEventListener(listener))queue.addEventListener(listener,listenerF);	

				
				obj[localDirectory+filename] ||=new Vector.<Function>;
				obj[localDirectory+filename].push(actionf);
			}
			
		}
		
		protected function fileFailed(e:LoaderEvent):void{
			fileLoadAction(e,-1);
		} 
		
		protected function fileProgress(e:LoaderEvent):void{
			
			fileLoadAction(e,0);
		}
		
		protected function fileCompleted(e:LoaderEvent):void{
			fileLoadAction(e,1);
		}
		
		protected function fileLoadAction(e:LoaderEvent,type:int=1):void
		{
			var obj:Object;
			if(type==1)			obj=  FunctsOnFileLoaded;
			else if(type==0) 	obj=  FunctsOnFileProgress;
			else if(type==-1) 	obj = FunctsOnFileError;
			
			var nam:String=e.target.url;
			
			if(obj && obj.hasOwnProperty(nam)){
				for(var i:int=0;i<obj[nam].length;i++){
					//trace(nam,222,fileLoaded(nam))
					obj[nam][i]();
					obj[nam][i]=null;	
				}
				delete obj[nam];
				if(type!=0)removeOtherFileListeners(obj,type);
			}
		}	
		
		private function removeOtherFileListeners(obj:Object,type:int):void
		{
			
			var isEmpty:Boolean = true;
			for each(var a:Vector.<Function> in obj){
				isEmpty=false;
				break;
			}
			if(isEmpty){
				if(obj == FunctsOnFileLoaded   && queue.hasEventListener(LoaderEvent.CHILD_COMPLETE))queue.removeEventListener(LoaderEvent.CHILD_COMPLETE,fileCompleted);
				if(obj == FunctsOnFileError    && queue.hasEventListener(LoaderEvent.CHILD_PROGRESS))queue.removeEventListener(LoaderEvent.CHILD_FAIL,fileFailed);
				if(obj == FunctsOnFileProgress && queue.hasEventListener(LoaderEvent.CHILD_PROGRESS))queue.removeEventListener(LoaderEvent.CHILD_PROGRESS,fileProgress);
				obj=null;
			}
		}
	}
	
}
