package com.xperiment.behaviour{
	import com.xperiment.uberSprite;
	import com.xperiment.trial.overExperiment;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class behavClick extends behav_baseClass {//note without 'public' nothing happens!!
		
		private var clickedObj:String;
		
		
		override public function setVariables(list:XMLList):void {
			setVar("uint","durationOfStep",0);
			setVar("string","strengthYoverT","16");//[from 0-255 but powers of 2 better at rendering so this score is expressed in 2 power of x]
			setVar("string","strengthXoverT","16");//[from 0-255 but powers of 2 better at rendering so this score is expressed in 2 power of x]
			setVar("string","strength","");
			setVar("uint","quality",1);
			setVar("boolean","applyAsTheyCome",true);
			super.setVariables(list);

		}

		override public function givenObjects(obj:uberSprite):void {
			obj.addEventListener(MouseEvent.MOUSE_DOWN, objClicked,false,0,false);
			obj.useHandCursor=true;
			obj.buttonMode=true;
			super.givenObjects(obj);
		}
		
		protected function objClicked(e:MouseEvent):void
		{
			for each(var obj:uberSprite in behavObjects){
				if(obj.hasEventListener(MouseEvent.MOUSE_DOWN))obj.removeEventListener(MouseEvent.MOUSE_DOWN,objClicked);
			}
			clickedObj=e.target.name;
			this.dispatchEvent(new Event("nextTrial"));
		}		
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		override public function storedData():Array {
			var tempData:Array = new Array();
			tempData.event="clicked";
			tempData.data=clickedObj;
			super.objectData.push(tempData);
			return objectData;
		}
		
		override public function kill():void {
			
			super.kill();
		}
	}
}