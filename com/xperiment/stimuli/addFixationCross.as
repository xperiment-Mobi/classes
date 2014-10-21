package com.xperiment.stimuli{

	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.*;
	import com.xperiment.uberSprite;
	
	
			//function fixation(tex:String, Xloc:int, Yloc:int):TextField {
			//return (addText(tex,0xFFFFFF,20,"CENTER",Xloc, Yloc));
		//}
	

	public class addFixationCross extends addText {

		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList) {
			setVar("string","symbol","+");
			super.setVariables(list);
		}


		override public function RunMe():uberSprite {
			var myTextFormat:TextFormat=new TextFormat  ;
			var textInput:TextField=new TextField  ;
			if (getVar("alignment")=="CENTER") {
				myTextFormat.align=TextFormatAlign.CENTER;
				textInput.autoSize=TextFieldAutoSize.CENTER;

			} else if (getVar("alignment")=="RIGHT") {
				myTextFormat.align=TextFormatAlign.RIGHT;
				textInput.autoSize=TextFieldAutoSize.RIGHT;
			} else if (getVar("alignment")=="LEFT") {
				myTextFormat.align=TextFormatAlign.LEFT;
				textInput.autoSize=TextFieldAutoSize.LEFT;
			}
			myTextFormat.color=getVar("colour");

			myTextFormat.size=getVar("size");
			//textInput.type = TextFieldType.DYNAMIC;
			//textInput.width = textInputSize;
			textInput.text=getVar("symbol");
			textInput.setTextFormat(myTextFormat);
			textInput.selectable=false;
			
			super.pic.addChild(textInput);
			super.setUniversalVariables();
			return (super.pic);
		}



	}






}