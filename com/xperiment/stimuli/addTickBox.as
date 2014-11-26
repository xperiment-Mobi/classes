package  com.xperiment.stimuli{

	import flash.display.*;
	import com.xperiment.uberSprite;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.xperiment.stimuli.primitives.shape;
	
	public class addTickBox extends object_baseClass {
		private var box:Shape;
		private var tick:Shape;
		private var container:Sprite;
		private var boxSelected:Boolean=false;


		override public function setVariables(list:XMLList):void {
			setVar("number","boxColour",0xffe6e6);
			setVar("int","boxLineThickness",.1);
			setVar("number","boxLineColour",0x000000);
			setVar("number","transparency",.9);
			setVar("uint","boxHeight",40);
			setVar("uint","boxWidth",40);
			setVar("uint","size",40);
			setVar("number","tickColour",0x1f16e6);
			setVar("int","tickLineThickness",2);
			setVar("number","tickLineColour",0x000000);
			setVar("uint","tickWidth",40);
			setVar("uint","tickHeight",40);
			setVar("string","tickShape","tick");
			setVar("string","containerShape","circle","","needs updating...");
			super.setVariables(list);
			make();

		}
		
		private function make():void {
			box = new Shape;
			tick = new Shape;
			container = new Sprite;
			
			box=shape.makeShape(getVar("containerShape"),getVar("boxLineThickness"),getVar("boxLineColour"),getVar("transparency"), 
							   getVar("boxColour"), getVar("boxWidth"), getVar("boxHeight"));			
			//box.x=0;
			//box.y=0;
			container.addChild(box);
			
			
			tick=shape.makeShape(getVar("tickShape"),getVar("tickLineThickness"),getVar("tickLineColour"),1, 
							   getVar("tickColour"), getVar("tickWidth"), -getVar("tickHeight"));
			tick.x+=box.width/2-tick.width/2;
			tick.y+=box.height/2-tick.height/2;
			container.addChild(tick);
			container.addEventListener(MouseEvent.CLICK, selected,false,0,true);
			pic.addChild(container);
			
		}
		


		override public function setContainerSize():void {
			
			//pic.myWidth=getVar("textBoxWidth")+getVar("padding-left")+getVar("padding-right");;
			//pic.myHeight=container.height+getVar("padding-top")+getVar("padding-bottom");
		}



		override public function returnsDataQuery():Boolean {
			return true;
		}


		private function selected(e:MouseEvent):void {
			if (tick.alpha==0) {tick.alpha=1; boxSelected=true;}
			else {tick.alpha=0; boxSelected=false};
		}
		

		override public function RunMe():uberSprite {
			setUniversalVariables();			
			return (super.pic);
		}

		override public function kill():void {
			if(container.hasEventListener(MouseEvent.CLICK)){
			   container.removeEventListener(MouseEvent.CLICK, selected);
			   }
			pic.removeChild(container);
			container.removeChild(box);
			container.removeChild(tick);
			container=null;
			box=null;
			tick=null;
			super.kill();
		}
	}
}