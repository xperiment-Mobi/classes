package com.xperiment.stimuli.primitives
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class KeyPad extends Sprite
	{
		
		private var buttons:Vector.<BasicButton>;
		public var pressed:Array;
		
		public function kill():void{
			this.removeEventListener(MouseEvent.CLICK,buttonClickedL);
			
			for(var i:int=0;i<buttons;i++){
				buttons[i].kill();
			}
			

		}
		
		public function reset():void{
			pressed = [];
		}
		
		
		public function KeyPad(myWidth:int, myHeight:int)
		{
			buttons = new Vector.<BasicButton>;
			pressed = [];
			
			var bWidth:int = myWidth * .33;
			var bHeight:int = myHeight *.25;
			
			function genButton(txt:String,x:int,y:int):BasicButton{
				var b:BasicButton = new BasicButton;
				b.myWidth=bWidth;
				b.myHeight=bHeight;
				b.label.fontSize=22;
				b.label.text=txt;
				b.label.name=txt;
				b.name = txt;
				b.init();
				addChild(b);
				b.x=x*bWidth;
				b.y=y*bHeight;
				buttons[buttons.length]=b;
			}
			
			for(var i:int=0;i<=2;i++){
				genButton(String(1+(i*3)),0,i);
				genButton(String(2+(i*3)),1,i);
				genButton(String(3+(i*3)),2,i);
			}
			genButton('0',1,3);
			
			this.addEventListener(MouseEvent.CLICK,buttonClickedL);
		}
		
		protected function buttonClickedL(e:MouseEvent):void
		{
			var stim:DisplayObject;
	
			for(var i:int=0;i<this.numChildren;i++){
				stim = this.getChildAt(i);
				if(stim.hitTestPoint(e.stageX,e.stageY)){
					pressed.push(stim.name);
				
					break;
				}
			}
			trace(pressed)
			
		}
	}
}