package com.Start.MobileStart.Screens.view
{
	import flash.display.DisplayObject;

	public class UiItem
	{
		public var name:String;
		private var listenFor:String;
		private var f:Function;
		public var displayObject:DisplayObject;
		
		public function UiItem(name:String,listenFor:String,f:Function)
		{
			this.name=name;
			this.listenFor=listenFor;
			this.f=f;
		}
		
		public function listen(yes:Boolean):void
		{
			if(yes)	displayObject.addEventListener(listenFor,f);
			
			else	displayObject.removeEventListener(listenFor,f);
			
		}
		
		public function kill():void{
			f=null;
			listen(false);
			displayObject=null;
		}
	}
}