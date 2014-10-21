package com.projectcocoon.p2p.util
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	[Event(name="loadComplete", type="flash.events.Event")]
	[Event(name="saveComplete", type="flash.events.Event")]
	[Event(name="cancel", type="flash.events.Event")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	 * Helper class to easily select local files for file sharing and to store received files.
	 */
	public class FileUtil extends EventDispatcher
	{
		private var fileRefLoad:FileReference;
		private var fileRefSave:FileReference;
		
		public function FileUtil()
		{
		}
		
		/**
		 * The selected file's data 
		 * @return the selected file's data 
		 * 
		 */		
		public function get data():ByteArray
		{
			if (fileRefLoad)
				return fileRefLoad.data;
			return null;
		}
		
		/**
		 * The selected file's name 
		 * @return the selected file's name 
		 * 
		 */		
		public function get name():String
		{
			if (fileRefLoad)
				return fileRefLoad.name;
			return null;
		}
		
		/**
		 * Opens up a "File open" dialog 
		 */		
		public function load():void
		{
			fileRefLoad = getFileRefLoad();
			fileRefLoad.browse();
		}
		
		/**
		 * Opens up a "File save" dialog and stores a file 
		 * @param bytes data to be saved
		 * @param name optional file name
		 * 
		 */		
		public function save(bytes:ByteArray, name:String = null):void
		{
			fileRefSave = getFileRefSave();
			fileRefSave.save(bytes, name);
		}
		
		private function getFileRefLoad():FileReference
		{
			if (!fileRefLoad)
			{
				fileRefLoad = new FileReference();
				fileRefLoad.addEventListener(Event.SELECT, onSelect);
				fileRefLoad.addEventListener(Event.CANCEL, onCancel);
				fileRefLoad.addEventListener(Event.OPEN, onOpen);
				fileRefLoad.addEventListener(Event.COMPLETE, onComplete);
				fileRefLoad.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
				
			}
			return fileRefLoad;
		}

		private function getFileRefSave():FileReference
		{
			if (!fileRefSave)
			{
				fileRefSave = new FileReference();
				fileRefSave.addEventListener(Event.SELECT, onSelect);
				fileRefSave.addEventListener(Event.CANCEL, onCancel);
				fileRefSave.addEventListener(Event.OPEN, onOpen);
				fileRefSave.addEventListener(Event.COMPLETE, onComplete);
				fileRefSave.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
				
			}
			return fileRefSave;
		}
		
		private function onSelect(event:Event):void
		{
			if (event.target == fileRefLoad)
				fileRefLoad.load();
		}
		
		protected function onCancel(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		private function onIoError(event:IOErrorEvent):void
		{
			dispatchEvent(event.clone());
		}

		private function onComplete(event:Event):void
		{
			if (event.target == fileRefLoad)
				dispatchEvent(new Event("loadComplete"));
			else if (event.target == fileRefSave)
				dispatchEvent(new Event("saveComplete"));
		}

		private function onOpen(event:Event):void
		{
		}
	}
}