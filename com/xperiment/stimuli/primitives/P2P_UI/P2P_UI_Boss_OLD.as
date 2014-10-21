package com.xperiment.stimuli.primitives.P2P_UI
{
	import flash.display.Sprite;
	import flash.events.Event;


	
	public class P2P_UI_Boss_OLD extends Sprite
	{
		private var p2p_start:P2P_Start;
		private var p2p_boss:P2P_Boss_DEAD;

		
		public function P2P_UI_Boss_OLD(password:String):void{
			decorate();
			p2p_start = new P2P_Start(this,password);
			this.addEventListener(Event.COMPLETE,switchToBossView);
			//this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function switchToBossView(event:Event):void
		{
			p2p_start.kill();
			p2p_boss = new P2P_Boss_DEAD(this);
			trace("boss view")
		}		
		
		
		private function decorate():void
		{
			this.graphics.beginFill(0x000fff,.9);
			this.graphics.drawRoundRect(0,0,200,200,10,10);
		}		
		
		public function kill():void{
			this.removeEventListener(Event.COMPLETE,switchToBossView);
			p2p_start.kill();

		}
		
		
		
	}
}