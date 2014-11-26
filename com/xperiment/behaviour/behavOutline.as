package com.xperiment.behaviour{
	import flash.events.MouseEvent;
	import flash.display.*;	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.xperiment.trial.overExperiment;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
	import com.xperiment.uberSprite;

	public class behavOutline extends behav_baseClass{ //note without 'public' nothing happens!!
		
		override public function setVariables(list:XMLList):void {
		//setVar("int","lineThickness",2); cannot have this as it kills other behaviours as it extends the size of the sprite (see behavdragtoshiftingarea);
		setVar("number","transparency",.9);
		setVar("number","lineColour",0xFF00FF); 
		setVar("number","cardColour",0xFFFFFF); 

		super.setVariables(list);
		}

		override public function givenObjects(obj:uberSprite):void{
			
			super.givenObjects(obj);
			carderise(obj);
		}
		
		
		private function carderise(obj:uberSprite):void{
			var tempSpr:uberSprite;
				tempSpr=new uberSprite;
				tempSpr.graphics.clear();
				
				tempSpr.graphics.beginFill(getVar("cardColour"), getVar("transparency"));
				tempSpr.graphics.lineStyle(0 ,getVar("lineColour"));
				tempSpr.graphics.drawRect(0, 0, obj.width/obj.scaleX, obj.height/obj.scaleY);
				tempSpr.graphics.endFill();
				obj.mask=tempSpr;
				obj.addChild(tempSpr);			
		}
		
		
		override public function stopBehaviour(obj:uberSprite):void{
			if (obj.mask) obj.removeChild(obj.mask);
			obj.mask=null;
		}
		

		override public function kill():void {
			for (var i:uint=0;i<behavObjects.length;i++){
				if(behavObjects[i].pic && behavObjects[i].mask) behavObjects[i].pic.removeChild(behavObjects[i].mask);
				behavObjects[i].mask=null;
			}
			super.kill();
		}
	}
}