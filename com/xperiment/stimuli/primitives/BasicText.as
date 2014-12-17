package com.xperiment.stimuli.primitives{
	
	import com.bit101.components.Style;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.primitives.text.TextHelper;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	
	
	public class BasicText  {
		public var pic:Sprite = new Sprite;
		public var myTextFormat:TextFormat=new TextFormat  ;
		public var myText:TextField=new TextField;
		private var border:Shape;
		public var OnScreenElements:Array = []
		public var myWidth:Number;
		public var myHeight:Number;
		static public var makerObj:Object;

		public function kill():void{
			if(pic.hasEventListener(MouseEvent.CLICK))pic.removeEventListener(MouseEvent.CLICK,activateTextField);
			while (pic.numChildren>0){
				pic.removeChildAt(0);
			}
			pic=null;
			OnScreenElements=null;
		}
		
		public function text(str:String=""):String{
			if(arguments.length!=0){
				str=str.replace(new RegExp("{","g"), "<");
				str=str.replace(new RegExp("}","g"), ">");
				//trace(122334,str,222)
				myText.htmlText=str
				setupText();
			}

			return myText.text;
		}
		
		private function setVar(typ:String, nam:String, val:*,defaultVals:String='',info:String=''):void {
			if(OnScreenElements.indexOf(nam)==-1){
				OnScreenElements[nam]=val;
			}

			if(makerObj){
				saveMakerInfo(typ,nam,val,defaultVals,info);
			}
		}
		
		protected function saveMakerInfo(typ:String, nam:String, val:*,defaultVals:String="",info:String=""):void
		{
			nam=nam;
			val=val;
			info=info;
			if(makerObj.attrs) makerObj.attrs[nam] = defaultVals.split("||");
			if(makerObj.attrsInfo) makerObj.attrsInfo[nam]={type:typ,info:info,defaultVal:val, possibleVals:defaultVals};
			//if(nam=="showBox")trace(123,nam,typ,info,val, defaultVals)
		}
		
		static public function init_makerObj():void{
			makerObj = {};
			makerObj.attrs={};
			makerObj.attrsInfo={};
		}
		
		public function getVar(nam:String):* {
			
			if (OnScreenElements && OnScreenElements[nam]!=undefined) return OnScreenElements[nam];
			return "";	
		}

		
		public function setVariablesChild(obj:Object):void{
			setVar("string","text","demo text");
			setVar("string","colour",String(Style.LABEL_TEXT));
			setVar("string","background", "");
			setVar("number","border",0);
			setVar("boolean","allowColour",false);
			setVar("boolean","multiLine",true);
			setVar("string","selectable",'true');
			setVar("boolean","wordWrap",true);
			setVar("number","fontSize",15);
			setVar("string","font", Style.fontName);//"_sans, _serif, _typewriter, ios:times");
			setVar("string","align","");
			setVar("boolean","autosize",false);
			setVar("Number","borderAlpha",Style.borderAlpha);
			setVar("string","borderColour",Style.borderColour);
			setVar("number","exactSpacing",0);
			setVar("string","replace1","");
			setVar("string","suffix","");
			setVar("string","prefix","");
			setVar("uint","multiplySpaces",1);
			setVar("int","lineSpace",1);
			setVar("boolean","mouseEnabled",false);
			setVar("string","verticalAlign",'middle')//middle,top,bottom

			if(OnScreenElements.multiLine == true){
				myText.multiline= true;
			}
			
			if(obj){				
				for (var nam:String in obj){
					OnScreenElements[nam]=obj[nam];
				}
			}
		}
		
		
		public function giveBasicStimulus(obj:Object):Sprite {
			setVariablesChild(obj);
			if(obj.name)pic.name=obj.name;
			
			myText.width=obj.width;
			myText.height=obj.height;
	
			text(getVar("text"));
			pic.addChild(myText);
			myText.autoSize = TextFieldAutoSize.CENTER; //if not set, below wont work
			
			
			if(myHeight){
				switch(getVar("verticalAlign").toLowerCase()){
					case "middle":
						myText.y+=myHeight*.5-myText.height*.5;
						break;
					case "bottom":
						myText.y+=myHeight-myText.height;
						
				}				
			}

			sortStyle();
			setupText()
			return pic;
		}
		
		public function createStimulus():Sprite{
						
			myText.width=pic.width;
			myText.height=pic.height;

			text(getVar("text"));

			pic.addChild(myText);

			sortStyle();

			pic.width=myText.width;
			pic.height=myText.height;
					
			myText.autoSize = TextFieldAutoSize.CENTER; //if not set, below wont work

			verticallyAlign();

			return pic;
		}
		
		public function verticallyAlign():void{
			if(myHeight){
				switch(getVar("verticalAlign").toLowerCase()){
					case "middle":
						myText.y=myHeight*.5-myText.height*.5;
						break;
					case "bottom":
						myText.y=myHeight-myText.height;
						
				}				
			}
		}
		
		private function sortStyle():void{
			

			var borderColour:int 	= codeRecycleFunctions.getColour(getVar("borderColour"));
			var background:int		= -1;
			if(getVar("background")!=""){
				background=codeRecycleFunctions.getColour(getVar("background"));
			}
				
			if(background!=-1){
				TextHelper.sortBorderBackground(pic, myText, getVar("border"),borderColour,getVar("borderAlpha"),background);
			}
			
		}
		
		public function createTextField(obj:Object):TextField{
			setVariablesChild(obj);
			if(obj.name)pic.name=obj.name;
			text(getVar("text"));
			sortStyle();
			
			return myText;
		}
		

		
		private function setupText():void {

			myText.multiline=getVar("multiLine");
			myText.condenseWhite=true;
			myText.wordWrap=getVar("wordWrap");
			if(getVar("allowColour")==false){
				myTextFormat.color=codeRecycleFunctions.getColour(getVar("colour"));
			}
			if(OnScreenElements.lineSpace!=1)myTextFormat.leading=(getVar("lineSpace") as int);
			myTextFormat.size=uint(getVar("fontSize"));
			if(getVar("font")!="")sortFont();
			


			if(OnScreenElements.align!='') 	TextHelper.align(getVar("align"),myTextFormat);	
			
			if(OnScreenElements.autosize!=false)	autosize();	
			
			
			if((OnScreenElements.align!='' || OnScreenElements.autosize!='') && getVar("exactSpacing")!=0)throw new Error("in basicText, only allowed to set (align || autosize) || exactSpacing");
			else if(getVar("exactSpacing")!=0)TextHelper.exactSpacing(pic,myText,myTextFormat,getVar("fontSize"),getVar("exactSpacing"));
			
					
			myText.setTextFormat(myTextFormat);
			myText.defaultTextFormat=myTextFormat;
			

			if(String(getVar("selectable")) == 'false'){

				myText.mouseEnabled=false;
				pic.mouseChildren = false;
				myText.selectable=false;
				//pic.mouseEnabled = false;

			}
			else{
				myText.selectable=true;
			}
			if(getVar("mouseEnabled")==true){

				myText.mouseEnabled=true;
				//pic.mouseChildren = true; // disabling allows cursor to change when mouse over
				pic.mouseEnabled = true;
				pic.buttonMode = true;
			}
			
			
			if(getVar("editable")){
				myText.type = TextFieldType.INPUT;
				myText.selectable = true;
				myText.tabEnabled=true;
				myText.mouseEnabled=true;
				pic.addEventListener(MouseEvent.CLICK,activateTextField);
					

			}
			
			
			if(getVar("restrict")!=""){
				myText.restrict=getVar("restrict");
			}
			
			if(getVar("maxChars")!=""){
				myText.maxChars=int(getVar("maxChars"));
			}
			
			
			if(getVar("selectable") == 'false'){
	
				myText.mouseEnabled=false;
			}			
			
			//myText.background=true;
			//myText.backgroundColor=0x881122;
			
		}
		
		protected function activateTextField(event:MouseEvent):void
		{
			myText.stage.focus = myText;
			myText.setSelection(myText.text.length, myText.text.length);
			
		}
		
		private function autosize():void
		{

			myText.autoSize=TextFieldAutoSize.CENTER;
			pic.scaleY=1;
			pic.scaleX=1;
			
			
			myText.scaleX=myWidth/myText.width;
			myText.scaleY=myHeight/myText.height;
			
			myText.y+=(myText.height-myText.textHeight)*.5;
			
		}
		
		private function sortFont():void
		{
			if(getVar("font")=="rotatable") {
				myText.embedFonts=true;
				myTextFormat.font=Style.fontName;
			}
			else myTextFormat.font=getVar("font");
		}			
		
	}
}


