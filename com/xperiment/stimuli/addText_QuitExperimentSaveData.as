package com.xperiment.stimuli{

	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.events.*;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addText;
	
	public class addText_QuitExperimentSaveData extends addText {

		private var count:uint = 0;

		override public function setVariables(list:XMLList) {
			setVar("uint","clicksNeeded", 5);
			super.setVariables(list);
		}



		override public function RunMe():uberSprite {
			super.setupText();
			
			super.pic.addChild(super.myText);
			super.pic.addEventListener(MouseEvent.CLICK,Clicked);
			setUniversalVariables();			
			return (super.pic);

		}
		
		
		
		private function Clicked(e:MouseEvent){
			count++;
			if (count>=getVar("clicksNeeded")){
				super.pic.dispatchEvent(new Event("saveDataEndStudy",true));
			}
		}
		
		
	}
}