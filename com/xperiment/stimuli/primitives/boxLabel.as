package com.xperiment.stimuli.primitives{
	import com.xperiment.stimuli.primitives.shape;
	import flash.display.Sprite;
	import flash.display.Shape;
	
	public class boxLabel extends Sprite {

		public function boxLabel(l:String,w:uint,h:uint) {
			var offset:uint=20;
			var box:Shape=shape.makeShape("square",1,0x000000,1,-1,w+offset,h+offset);
			box.x-=offset/2;
			box.y-=offset/2;
			this.addChild(box);

			var obj:Object=new Object  ;
			obj.autoSize="left";
			obj.text=l;
			obj.textSize=17;
			obj.colour=0x000000;
			obj.background=0xFFFFFF;
			var tempTxt:BasicText=new BasicText;
			var title:Sprite=tempTxt.giveBasicStimulus(obj);
			title.y-=offset+title.height/3;
			this.addChild(title);
		}

	}

}