package com.xperiment.stimuli.primitives{

	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldType;
	import com.xperiment.uberSprite;
	
	public class primitiveText extends uberSprite{

		public var myTextFormat:TextFormat=new TextFormat  ;
		public var myText:TextField=new TextField  ;
		public var specs:Object;

		public function setVariables(specs:Object) {
			specs.text= "demo text" as String;
			specs.colour = 0x111999 as Number;
			specs.multiLine = false as Boolean;
			specs.textSize = 20 as uint;
			specs.selectable = false as Boolean;
			specs.wordWrap = false as Boolean
			specs.font = "null" as String

			for (var bit:* in specs){
				specs[bit]=specs[bit];
			}
		}
		
		public function giveStimuli(str:String):TextField {
			
			if (specs.multiline) myText.multiline=true;
			if(specs.wordWrap) myText.wordWrap=true;
			if (str!="")myText.htmlText=sortOutHTML(str);
			else myText.htmlText=sortOutHTML(specs.text);
			
			myTextFormat.font=specs.font;
			
			if (specs.colour!=0){
			myTextFormat.color=specs.colour;
			}
			myTextFormat.size=specs.textSize;
			myText.selectable=specs.selectable;
			
			if (specs.inputBox){
				myText.autoSize=TextFieldAutoSize.NONE;
				myText.type=TextFieldType.INPUT;
				myText.width=specs.width;
				myText.height=specs.height;
			}
			else myText.autoSize=TextFieldAutoSize.CENTER;

			if (specs.backgroundColor) {
				myText.background=true;
				myText.backgroundColor=specs.backgroundColor;
			}

			if (specs.borderColor) {
				myText.border=true;
				myText.backgroundColor=specs.borderColor;
			}
			myText.setTextFormat(myTextFormat);

			return myText;
		}



		public function sortOutHTML(str:String):String {
			var replaced:String=str;
			while (replaced.indexOf("{")!=-1) {
				replaced=replaced.replace("{","<");
			}
			while (replaced.indexOf("}")!=-1) {
				replaced=replaced.replace("}",">");
			}
			return replaced;
		}


		
		
		
		
	}
}