package com.xperiment.make.xpt_interface.trialDecorators.SnapMenu
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import com.xperiment.make.xpt_interface.trialDecorators.SnapMenu.background.Background;
	import com.xperiment.make.xpt_interface.trialDecorators.SnapMenu.UI.ZeroZero.ZeroZero;
	
	public class SnapMenu extends Sprite
	{		

		
		private var theStage:Stage;
		private var background:Background;
		private var zerozero:ZeroZero;
		

		
		public function kill():void
		{
			listeners(false);
			zerozero.kill();
			background.kill()
			
		}
		
		public function SnapMenu(theStage:Stage)
		{
			this.theStage=theStage;
			theStage.addChild(this);
			createMenu();
			
		}
		
		private function createMenu():void
		{
			zerozero   = new ZeroZero(theStage);
			
			background = new Background(theStage);
			
			
			listeners(true);
		}
		
		private function listeners(on:Boolean):void
		{
			var fNam:String;
			
			if(on)fNam='addEventListener';
			else  fNam='removeEventListener';
			
			background[fNam](Event.CHANGE,updateLocL);
		}
		
		protected function updateLocL(e:Event):void
		{
			trace(e, background.snapSide);
			
		}		

	}
}