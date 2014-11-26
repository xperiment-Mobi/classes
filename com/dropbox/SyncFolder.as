package com.dropbox
{

	
	import com.dropbox.FileLists.SyncPairUp;
	import com.dropbox.Services.GetDropBoxFilesInfo;
	import com.dropbox.Services.GetLocalFilesInfo;
	import com.dropbox.SQLliteDB.DropboxSyncTable;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.hamster.dropbox.DropboxClient;

	public class SyncFolder extends Sprite
	{
		private var log:Function;
		private var getDropBoxFilesInfo:GetDropBoxFilesInfo;
		private var getLocalFilesInfo:GetLocalFilesInfo;
		private var t:Timer;
		private var syncPairUp:SyncPairUp;
		private var dropAPI:DropboxClient;
		private var syncAction:SyncAction;
		private var folder:String;
		private var mobileDB:DropboxSyncTable;
		
		public function kill():void{
			if(getDropBoxFilesInfo.hasEventListener(Event.COMPLETE))getDropBoxFilesInfo.removeEventListener(Event.COMPLETE,gotDropBoxFiles);
			mobileDB.kill();
			mobileDB=null;
		}
		
		public function SyncFolder(folder:String,dropAPI:DropboxClient,log:Function)
		{
			this.dropAPI=dropAPI;
			this.folder=folder;
			this.log=log;
			getDropBoxFilesInfo = new GetDropBoxFilesInfo(folder, dropAPI,log);
			getDropBoxFilesInfo.addEventListener(Event.COMPLETE,gotDropBoxFiles);
			getDropBoxFilesInfo.getFiles();
			
			mobileDB= new DropboxSyncTable(log);
			
			getLocalFilesInfo = new GetLocalFilesInfo(mobileDB,log);
			getLocalFilesInfo.addEventListener(Event.COMPLETE,gotLocalFiles);
			getLocalFilesInfo.getFiles();

			t = new Timer(10000,1);	
			t.addEventListener(TimerEvent.TIMER,timerListener);
		}
		
		public function start():void{
			t.start();
		}
		
		protected function timerListener(event:TimerEvent):void
		{
			log("search for files that need updating has been going on longer than expected");
			killTimer();
		}
		
		private function killTimer():void{
			t.stop();
			t.removeEventListener(TimerEvent.TIMER, timerListener);
		}
		
		protected function gotDropBoxFiles(e:Event):void
		{
			getDropBoxFilesInfo.removeEventListener(Event.COMPLETE,gotDropBoxFiles);	
			doNext();	
		}
		
		protected function gotLocalFiles(e:Event):void
		{
			getLocalFilesInfo.removeEventListener(Event.COMPLETE,gotLocalFiles);
			doNext();
		}
		
		private function doNext():void
		{
			
			if(getDropBoxFilesInfo.completed && getLocalFilesInfo.completed){
				killTimer();
				log("^-------checking for updates-------^");
				syncPairUp = new SyncPairUp(getDropBoxFilesInfo.file_loc_vers, getLocalFilesInfo.file_loc_vers,log);			
				getLocalFilesInfo.kill();
				getDropBoxFilesInfo.kill();
				syncAction = new SyncAction(dropAPI, folder, syncPairUp.pairs,mobileDB,log);
				syncAction.doActions();
				log("^-------updating if needed----------^");
				
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}		
	}
}