package com.dropbox.Events
{
	import org.hamster.dropbox.DropboxEvent;
	
	public class DropboxEventExtended extends DropboxEvent
	{
		
		
		
		public function DropboxEventExtended(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}