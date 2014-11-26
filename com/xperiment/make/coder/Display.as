package com.xperiment.make.coder
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Display extends Sprite
	{
		
		public function Display(){
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}

		
		public function init(e:Event):void{
			this.graphics.beginFill(0xffffff*Math.random(),.4);

			this.graphics.drawRect(0,0,this.stage.stageWidth,this.stage.stageHeight);
		}
		

		
		public function add(icons:Array):void
		{
			var icon:Sprite;
			for(var i:int = 0;i<icons.length;i++){
				icon = icons[i];
				trace(icon.width,icon.height);
				this.addChild(icons[i]);
			}
			
		}
	}
}