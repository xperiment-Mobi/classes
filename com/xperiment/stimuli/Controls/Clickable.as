package com.xperiment.stimuli.Controls
{
	import flash.display.Sprite;
	
	
	public class Clickable extends Sprite
	{
		
		private var _selected:Boolean = false;
		public var position:int;
		
		public static var radius:int=10;

	
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
			this.alpha=int(value);
		}

		public function kill():void{
			
		}
		
		public function Clickable(count:int,colour:int)
		{
			this.position=count;
			this.graphics.beginFill(colour,1);
			this.graphics.drawCircle(0,0,radius);
			this.alpha=0;
			super();
		}
	}
}