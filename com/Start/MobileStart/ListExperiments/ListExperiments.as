package com.Start.MobileStart.ListExperiments
{
	import com.dropbox.DropboxConnection;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;

	public class ListExperiments extends Sprite
	{
		public static var xptExtension:String = '.xml'
			
		private  var unloaded_exptList:Vector.<ExptInfo>;
		private  var loaded_exptList:Vector.<ExptInfo>;
		
		private var filesNotLoaded:Vector.<ExptInfo>;	
		private var callBackF:Function;
		
		public function ListExperiments(callBackF:Function){
			this.callBackF=callBackF;
		}

		
		public function process():void
		{

			var dir:File = File.applicationStorageDirectory.resolvePath(DropboxConnection.LOCAL_DIR);
			
			unloaded_exptList = new Vector.<ExptInfo>;
			loaded_exptList = new Vector.<ExptInfo>;

			if(dir.exists)pimpFiles(dir,unloaded_exptList);	
			
			//note below IS NOT else if.  Waits til above finished
			if(unloaded_exptList.length>0) beginLoading(unloaded_exptList);
			else callBackF();
		}
		
		private function beginLoading(exptList:Vector.<ExptInfo>):void
		{
			var expt:ExptInfo = exptList.shift();
			expt.addEventListener(Event.COMPLETE,function(e:Event):void{
				expt.removeEventListener(e.type,arguments.callee);
				loaded_exptList.push(expt);
				if(exptList.length>0)	beginLoading(exptList);
				else callBackF();
				
			});
			var t:Timer= new Timer(10,0);
			t.addEventListener(TimerEvent.TIMER,function(e:Event):void{
				t.removeEventListener(TimerEvent.TIMER,arguments.callee);
				t.stop();
				expt.getExpt();
			});
			t.start();	
		}
		
		
		public function getList():Vector.<ExptInfo>{
			return loaded_exptList;
		}		
		
		/*private function checkProcessed(fileList:Vector.<ExptInfo>):void
		{
			
			for each(var exptInfo:ExptInfo in fileList){

				if(!exptInfo.processed){
					exptInfo.addEventListener(Event.COMPLETE,function(e:Event):void{
						e.target.removeEventListener(Event.COMPLETE, arguments.callee);
						/////////////////////
						/////Anonymous Function
						var pos:int = filesNotLoaded.indexOf(e.target as ExptInfo);
						if(pos==-1) throw new Error;
						else{
							filesNotLoaded.splice(pos,1);
							if(filesNotLoaded.length==0){
								filesNotLoaded=null;
								dispatchEvent(new Event(Event.COMPLETE));
							}
						}						
						/////Anonymous Function
						/////////////////////
					},false, 0, true);
					if(!filesNotLoaded)filesNotLoaded= new Vector.<ExptInfo>;
					filesNotLoaded[filesNotLoaded.length]=exptInfo;
				}
			}
		}*/
		
		private function pimpFiles( directory:File, fileList:Vector.<ExptInfo> ):void{

			if (directory.isDirectory){
				var localFiles:Array = directory.getDirectoryListing();
				var exptInfo:ExptInfo;

				for each (var file:File in localFiles){
					
					if (!file.isDirectory){
						
						if(file.name.substr(file.name.length-4)==xptExtension) {
							
							exptInfo = 				new ExptInfo;
							exptInfo.file =			file;
							exptInfo.exptName =		file.name.substr(0,file.name.length-xptExtension.length);
							exptInfo.nativePath =	file.url;
	
							fileList[fileList.length]=exptInfo;

						}
						
					}
					else{
						
						pimpFiles( file, fileList )
					}
					
				}
			}
		}
		

		
	}
}