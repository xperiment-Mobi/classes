
package  com.xperiment.stimuli{

	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.*;
	//import fl.controls.TextInput;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addText;


	public class addInputTextBoxMultiple extends addText {

		var id:Array;
		var textInput:Array;
		var myInputFormat:TextFormat;
		var myTextFormat:TextFormat;
		var listOfTextInputBoxInfo:Array;
		var listOfTextInfo:Array;
		var tempTextInput:TextField;

		override public function storedData():Array {
			var tempData:Array;
			for (var i:uint=0; i<id.length; i++) {
				tempData.object=String("InputTextBox="+id[i]);
				tempData.data=textInput[i].text;
				super.objectData.push(tempData);
			}
			id=null;
			textInput=null;
			return objectData;
		}

		override public function returnsDataQuery():Boolean {
			return true;
		}

		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList) {
			setVar("string","textInputBoxInfo","");
			setVar("number","textInputBoxColour",0x111999);
			setVar("uint","textInputBoxFontSize",10);
			setVar("string","textInputBoxAlignment","LEFT","LEFT||CENTER||RIGHT");
			setVar("uint","inputBoxNumCharacters", 10);//maxChars
			setVar("boolean","password", false);
			setVar("string","restrict","","","any list of characters with no space, e.g. abc");
			setVar("uint","textInputBoxWidth",100);
			setVar("uint","textInputBoxHeight",50);
			setVar("uint","XdistanceBetweenObjects",50);
			setVar("uint","YdistanceBetweenObjects",0);
			setVar("number","inputBoxBackgroundColor", "");
			setVar("number","inputBoxBorderColor","");
			setVar("boolean","inputBoxMultiline",false);
			setVar("string","id","specify_ID_next_time!");
			setVar("uint","XdistanceBetweenInputBoxes",0);
			setVar("uint","YdistanceBetweenInputBoxes",80);
			setVar("uint","height",50);
			setVar("uint","width",100);
			super.setVariables(list);
			setVar("boolean","hideResults",true);
			textInput=new Array();
			id = new Array();
			setupFonts();
		}



		override public function RunMe():uberSprite {

			id=generateArray(String(getVar("id")));
			listOfTextInputBoxInfo=generateArray(String(getVar("textInputBoxInfo")));
			listOfTextInfo=generateArray(String(getVar("text")));
			var tempSprite:uberSprite=new uberSprite  ;
			for (var i:uint = 0; i<listOfTextInputBoxInfo.length; i++) {
				tempSprite.addChild(inputToAdd(i));
				tempSprite.addChild(textToAdd(i));
			}

			super.pic.addChild(tempSprite);
			super.setUniversalVariables();
			return (super.pic);
		}

		private function inputToAdd(val:uint):TextField {
			if (tempTextInput==null) {
				var tempTextInput:TextField=new TextField;
				tempTextInput.type=TextFieldType.INPUT;
				tempTextInput.wordWrap=true;
				if (getVar("inputBoxBackgroundColor")!="") {
					tempTextInput.background=true;
					tempTextInput.backgroundColor=getVar("inputBoxBackgroundColor");
				}
				if (getVar("inputBoxBorderColor")!="") {
					tempTextInput.border=true;
					tempTextInput.backgroundColor=getVar("inputBoxBorderColor");
				}
				tempTextInput.maxChars=getVar("inputBoxNumCharacters");
				tempTextInput.displayAsPassword=getVar("password");
				if (getVar("restrict").length!=0) {
					tempTextInput.restrict=getVar("restrict");
				}
				tempTextInput.multiline=getVar("inputBoxMultiline");
				tempTextInput.width=getVar("textInputBoxWidth");
				tempTextInput.height=getVar("textInputBoxHeight");
				tempTextInput.x=getVar("XdistanceBetweenObjects");
				tempTextInput.y=getVar("YdistanceBetweenObjects");
				
			}

			tempTextInput.text=listOfTextInputBoxInfo[val];
			tempTextInput.x=(getVar("XdistanceBetweenObjects"))+(val*getVar("XdistanceBetweenInputBoxes"));
			tempTextInput.y=(getVar("YdistanceBetweenObjects"))+(val*getVar("YdistanceBetweenInputBoxes"));
			tempTextInput.setTextFormat(myInputFormat);
			textInput.push(tempTextInput);
			return (tempTextInput);
		}


		var tempText:TextField;

		private function textToAdd(val:uint):TextField {
			tempText=new TextField();
			//textInput.type = TextFieldType.DYNAMIC;
			//textInput.width = textInputSize;
			tempText.selectable=false;
			tempText.multiline=getVar("multiline");
			tempText.height=getVar("height");
			tempText.width=getVar("width");
			if (getVar("backgroundColor")!="") {
				tempText.background=true;
				tempText.backgroundColor=getVar("backgroundColor");
			}
			if (getVar("borderColor")!="") {
				tempText.border=true;
				tempText.backgroundColor=getVar("borderColor");
			}
			tempText.x=val*getVar("XdistanceBetweenInputBoxes");
			tempText.y=val*getVar("YdistanceBetweenInputBoxes");
			tempText.text=listOfTextInfo[val];
			tempText.setTextFormat(myTextFormat);
			return (tempText);
		}







		private function setupFonts() {
			myTextFormat=new TextFormat  ;
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

			myInputFormat=new TextFormat  ;
			if (getVar("textInputBoxAlignment")=="CENTER") {
				myInputFormat.align=TextFormatAlign.CENTER;
			} else if (getVar("textInputBoxAlignment")=="RIGHT") {
				myInputFormat.align=TextFormatAlign.RIGHT;
			} else if (getVar("textInputBoxAlignment")=="LEFT") {
				myInputFormat.align=TextFormatAlign.LEFT;
			}
			myInputFormat.color=getVar("textInputBoxColour");
			myInputFormat.size=getVar("textInputBoxFontSize");
		}




		private function generateArray(t:String):Array {
			return t.split("[]");
		}



	}






}