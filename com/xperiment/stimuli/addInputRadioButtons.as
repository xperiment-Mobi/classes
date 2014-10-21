package com.xperiment.stimuli{

	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.*;
	import fl.controls.RadioButton;
	import fl.controls.RadioButtonGroup;
	import fl.controls.ButtonLabelPlacement;
	import com.xperiment.uberSprite;


	public class addInputRadioButtons extends addButton {


		
		var id:Array;
		var textInput:Array;
		var listOfTextInfo:Array;
		var tempTextInput:TextField;

		private var j:uint;
		private var padding:uint=10;
		private var currHeight:uint=0;
		private var verticalSpacing:uint=30;
		private var questionLabel:TextField;
		private var radioTags:Array;
		private var questionList:Array;
		private var myTextFormat:TextFormat;
		private var RadioButtonList:Array;

		
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList) {
			setVar("string","questionList","");
			setVar("uint","XdistanceBetweenObjects",0);
			setVar("uint","YdistanceBetweenObjects",50);
			setVar("string","id","specify_ID_next_time!");
			setVar("uint","XdistanceBetweenRadioButtons",20);
			setVar("uint","YdistanceBetweenRadioButtons",0);
			setVar("uint","height",50);
			setVar("uint","width",100);
			setVar("string","radioButtonTags","");
			setVar("number","colour",0x111999);
			setVar("uint","size",10);
			setVar("string","alignment","LEFT","LEFT,CENTRE,RIGHT");
			setVar("number","backgroundColor", "");
			setVar("number","borderColor","");
			setVar("boolean","inputBoxMultiline","false");
			setVar("uint","XdistanceBetweenTextAndButtons",50);
			setVar("uint","YdistanceBetweenTextAndButtons",0);
			setVar("string","LabelPlacement","left","bottom||left||top||right");
			textInput=new Array();
			id = new Array();
			radioTags = new Array();
			questionList = new Array();
			RadioButtonList = new Array();
			setupFonts();
			super.setVariables(list);

		}

		override public function storedData():Array {
			var tempData:Array = new Array;
			for (var i:uint=0; i<questionList.length; i++) {
				tempData.event="InputRadioButtons="+questionList[i].replace(/ /g, "_");
				try{
					//logger.log ("QQQ: "+RadioButtonList[i].selection.label);
				var tempResults:String=RadioButtonList[i].selection.label;
				}
				catch(error:Error){
					tempResults="0";
					}
					tempData.data = tempResults;
				super.objectData.push(tempData);
			}
			radioTags=null;
			id=null;
			questionList=null;
			RadioButtonList=null;
			return objectData;
		}



		
		
		override public function RunMe():uberSprite {

			var tempRadioTags:Array=generateArray(String(getVar("radioButtonTags")),":");
			for (var i:uint=0; i<tempRadioTags.length; i++) {
				radioTags.push(generateArray(tempRadioTags[i],","));
			}
			id=generateArray(String(getVar("id")),":");
			questionList=generateArray(String(getVar("questionList")),":");
			var tempSprite:uberSprite=new uberSprite  ;

			for (var j:uint = 0; j<questionList.length; j++) {
				tempSprite.addChild(addRadioButtons(j));
			}
			super.pic.addChild(tempSprite);
			super.setUniversalVariables();
			return (pic);
		}

		private function addRadioButtons(val:uint):uberSprite {
			var tempSprite:uberSprite=new uberSprite();
			var rbg:RadioButtonGroup=new RadioButtonGroup(id[val]);
			for (var j:uint=0; j<radioTags[val].length; j++) {
				var rb:RadioButton = new RadioButton();
				rb.group=rbg;
				rb.label=radioTags[val][j];
				//logger.log("QQQi"+rb.label);
				rb.x=getVar("width")+getVar("XdistanceBetweenTextAndButtons")+(j*getVar("XdistanceBetweenRadioButtons"))+(val*getVar("XdistanceBetweenObjects"));
				rb.y=getVar("YdistanceBetweenTextAndButtons")+(j*getVar("YdistanceBetweenRadioButtons"))+(val*getVar("YdistanceBetweenObjects"));
				rb.labelPlacement = ButtonLabelPlacement[getVar("LabelPlacement")];
 
				tempSprite.addChild(rb);
			}
			RadioButtonList.push(rbg);

			questionLabel = new TextField();
			questionLabel.selectable=false;
			questionLabel.multiline=getVar("multiline");
			questionLabel.height=getVar("height");
			questionLabel.width=getVar("width");
			if (getVar("backgroundColor")!="") {
				questionLabel.background=true;
				questionLabel.backgroundColor=getVar("backgroundColor");
			}
			if (getVar("borderColor")!="") {
				questionLabel.border=true;
				questionLabel.backgroundColor=getVar("borderColor");
			}
			questionLabel.x=(val*getVar("XdistanceBetweenObjects"));
			questionLabel.y=(val*getVar("YdistanceBetweenObjects"));
			questionLabel.text=String(questionList[val]);
			questionLabel.setTextFormat(myTextFormat);
			tempSprite.addChild(questionLabel);

			return (tempSprite);
		}



		private function setupFonts() {
			myTextFormat=new TextFormat  ;
			if (getVar("alignment")=="CENTRE") {
				myTextFormat.align=TextFormatAlign.CENTER;
			} else if (getVar("alignment")=="RIGHT") {
				myTextFormat.align=TextFormatAlign.RIGHT;
			} default{
				myTextFormat.align=TextFormatAlign.LEFT;
			}
			myTextFormat.color=getVar("colour");
			myTextFormat.size=getVar("size");
		}




		private function generateArray(t:String,divider:String):Array {
			return t.split(divider);
		}
		

	}
}