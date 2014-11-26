package com.xperiment.make.xpt_interface.trialDecorators.Helpers
{
	import com.xperiment.make.comms.Communicator;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.trialDecorators.sizeHelpers.Size;
	import com.xperiment.stimuli.addText;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class EditText
	{
		private static var edit:TextEditor;
		private static var textEdit:String = "textEdit";
		private static var callBackF:Function;
		private static var finishedF:Function;
		private static var size:Size;
		private static var stage:Stage;
		
		public static function doubleClick(stim:object_baseClass, f:Function, f2:Function):Boolean
		{
			if(stim is addText == false) return false;
			callBackF= f;
			finishedF =f2;
			stage = stim.stage;
			stop();
			size = new Size(stim);
			stim.mouseEnabled=true;
			stim.mouseChildren=true
			init(stim as addText);
			return true;
		}
		
		private static function comms(command:String,val:*):void{
			Communicator.pass(textEdit,{command:command,val:val});	
		}
		
		private static function init(stim:addText):void
		{
			edit = new TextEditor(stim);
			
			listeners(true);
			comms('selected',null);
		
		}
		
		public static function stop():void
		{
			if(edit){
	
				//var updated:Object = edit.giveDimensions()
				var dimensions:Object = {};// size.update(updated);	
				/*if(edit.changed()){
					trace(11)*/
					dimensions[BindScript.xmlBODY]=edit.text();
				//}
				//trace(12222,dimensions[BindScript.xmlBODY])
				
				finishedF(dimensions);
				listeners(false);
				edit.kill();
				edit=null;
				comms('stop',null);
			}
			callBackF();
		}
		
		private static function listeners(ON:Boolean):void{
			var f:Function;
			if(ON)	f=edit.addEventListener;
			else	f=edit.removeEventListener;
			
			f(Event.CHANGE, updateFormattingL);
			
			if(stage){
				if(ON)	f=stage.addEventListener;
				else	f=stage.removeEventListener;
				f(MouseEvent.MOUSE_UP, mouseUpL);
			}
			
		}
		
		private static function updateFormattingL(e:Event):void{
			comms('setFormatting',edit.textFormatObj);
		}
		
		private static function mouseUpL(e:MouseEvent):void{
			if(edit.checkIsOver(e.stageX,e.stageY) == false){
				stop();
			}
			
		}
		
		public static function fromJS(data:*):void
		{
			
			if(edit){
				edit.editTextFormat(data.info.command,data.info.val);
			}
			
		}
	}
}



import com.xperiment.stimuli.addText;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

class TextEditor extends Sprite{
	// ©Michael Hejja - 2009 :	michaelhejja.com
	//Registers the event listeners for outside use
	
	private var origSettings:Object = {};
	private var myText_orig:String;
	private var _mainText:TextField;
	private var userFonts:Array;
	private var allFontNames:Array;
	public var textFormatObj:Object = {};
	private var _addText:addText;
	private var height_orig:Number;
	private var background:int;
	private var backgroundOn:Boolean;
	
	public function TextEditor(mainText:addText) {
		_mainText = mainText.basicText.myText;
		_addText  = mainText;
		height_orig = _addText.basicText.myText.height;
		myText_orig = _mainText.text;
		
		doOrigSettings();
		applySettings();
		
		backgroundOn=_mainText.background;
		if(backgroundOn) background=_mainText.backgroundColor;
		
		//_mainText.background=true;
		//_mainText.backgroundColor=0x881122;
		

		_mainText.alwaysShowSelection = true;

		listeners(true);
		
		// Load the fonts from the user's computer into the combobox
		userFonts = Font.enumerateFonts(true);
		userFonts.sortOn("fontName", Array.CASEINSENSITIVE);
		
	
		
		for (var i:int = 0; i < userFonts.length; i++ ) {
			//fontList.addItem( { label: userFonts[i].fontName } );
			//allFontNames.push(userFonts[i].fontName);
		}
	}
	
	public function changed():Boolean{
		return myText_orig != _mainText.text;
	}
	
	public function text():String
	{
		// TODO Auto Generated method stub
		return _mainText.htmlText;	
		//return codeRecycleFunctions.safeText(_mainText.htmlText,true);
		//return _mainText.htmlText.split(">").join("}").split("<").join("{");
	}
	
	
	
	private function listeners(ON:Boolean):void{

		var f:String;
		if(ON)	f='addEventListener';
		else	f='removeEventListener';
		_mainText[f](MouseEvent.MOUSE_UP, checkTextFormat);
		_mainText[f](Event.CHANGE, resizedL);
		if(_mainText.stage)_mainText.stage[f](KeyboardEvent.KEY_UP,keyPressedL);
		
	}
	
	public function keyPressedL(e:KeyboardEvent):void{
		if(e.keyCode == 8 || e.keyCode == 46)resizedL(e);
	}
	
	public function resizedL(e:Event):void{
		var newHeight:Number = _mainText.height;
		
		if(height_orig!=newHeight){
			height_orig=newHeight;
			_addText.basicText.verticallyAlign();
		}
	}
	
	public function giveDimensions():Object{
		return {width:_addText.width,height:_addText.height};
	}
	
	public function giveStage():Stage{
		return _mainText.stage;
	}
	
	
	private function applySettings():void
	{
		_mainText.type = TextFieldType.INPUT;
		_mainText.multiline=true;
		_mainText.selectable=true;
		_mainText.mouseEnabled=true;
		_mainText.setSelection(0,1)
	}
	
	private function doOrigSettings():void
	{
		origSettings.selectable = _mainText.selectable;
		origSettings.textType 	= _mainText.type;
		origSettings.multiLine 	= _mainText.multiline;
		
		_mainText.background=backgroundOn;
		if(backgroundOn)_mainText.backgroundColor=background;
	}	
	
	
	private function changeFont(e:Event):void {
		editTextFormat("font", e.target.selectedItem.label);
	}
	
	private function changeSize(e:Event):void {
		editTextFormat("size", e.target.value);
	}
	
	private function changeColor(e:Event):void {
		editTextFormat("color", e.target.selectedColor);
	}
	
	private function changeBold(e:Event):void {
		editTextFormat("bold");
	}
	
	private function changeItalic(e:MouseEvent):void {
		editTextFormat("italic");
	}
	
	private function changeUnderline(e:MouseEvent):void {
		editTextFormat("underline");
	}
	
	private function setLeft(e:MouseEvent):void {
		editTextFormat("left");
	}
	
	private function setCenter(e:MouseEvent):void {
		editTextFormat("center");
	}
	
	private function setRight(e:MouseEvent):void {
		editTextFormat("right");
	}
	
	private function setURL(e:Event):void {
		editTextFormat("url", e.target.text);
	}
	
	private function setTarget(e:Event):void {
		editTextFormat("target", e.target.selectedItem.data);
	}
	
	
	//___________________________________________________________________ Text Format Calculation and Editing
	
	private function checkTextFormat(e:Event = null):void {
		textFormatObj={};
	
		if (_mainText.selectionBeginIndex != _mainText.selectionEndIndex)
		{
			var tempTextFormat:TextFormat = _mainText.getTextFormat(_mainText.selectionBeginIndex, _mainText.selectionEndIndex);
			
			// Set the style buttons
			
			
			if(tempTextFormat.bold == true) textFormatObj.bold=true;
			if(tempTextFormat.italic == true) textFormatObj.italic=true;
			if(tempTextFormat.underline == true) textFormatObj.underline=true;
			
			// Set the alignment button
			if(tempTextFormat.align == "left") textFormatObj['align_left']=true;
			if(tempTextFormat.align == "center") textFormatObj['align_center']=true;
			if(tempTextFormat.align == "right") textFormatObj['align_right']=true;
			if(tempTextFormat.align == "justify") textFormatObj['align_justify']=true;
			
			textFormatObj['text_color'] = uint(tempTextFormat.color);
			textFormatObj['font_face'] = tempTextFormat.font;
			textFormatObj.fontSize = int(tempTextFormat.size);
			textFormatObj['back_color'] = _mainText.backgroundColor;
			if(tempTextFormat.bullet)textFormatObj.bullets = true;
		
			// Look for a link
			if(tempTextFormat.url != null) textFormatObj.url = String(tempTextFormat.url);
		}
		this.dispatchEvent(new Event(Event.CHANGE));
	}
	

	//edits theactual text format
	public function editTextFormat(type:String, val:* = null):void {
		
		if (_mainText.selectionBeginIndex != _mainText.selectionEndIndex)
		{
			
			// Get the current Format
			var tempTextFormat:TextFormat = _mainText.getTextFormat(_mainText.selectionBeginIndex, _mainText.selectionEndIndex);

			// Edit the Format
			//trace(454545,type,val);
			switch(type)
			{
				case "increase-font":
					tempTextFormat.size=int(tempTextFormat.size)+1;
					trace(1121222342,tempTextFormat.size)
					break;
				case "decrease-font":
					tempTextFormat.size=int(tempTextFormat.size)-1;
					break;
				case "bullets":
					tempTextFormat.bullet = val;
					break;
				case "font":
					tempTextFormat.font = val;
					break;
				case "size":
					tempTextFormat.size = val;
					break;
				case "back-color":
					_mainText.background=true;
					_mainText.backgroundColor=val;
					break;
				case "color":
					tempTextFormat.color = val;
					break;
				case "bold":
					tempTextFormat.bold = val;
					break;	
				case "italic":
					tempTextFormat.italic = val;
					break;	
				case "underline":
					tempTextFormat.underline = val;
					break;
				case "align-left":
					tempTextFormat.align = "left";
					break;				
				case "align-center":
					tempTextFormat.align = "center";
					break;				
				case "align-right":
					tempTextFormat.align = "right";
					break;		
				case "align-justify":
					tempTextFormat.align = "justify";
					break;	
				case "url":
					tempTextFormat.url = val;
					tempTextFormat.target = '';
					val != "" ? tempTextFormat.underline = true : tempTextFormat.underline = false;
					break;
				case "target":
					tempTextFormat.target = val;
					break;							
				default:
			}
			
			// Apply the changed format
			_mainText.setTextFormat(tempTextFormat, _mainText.selectionBeginIndex, _mainText.selectionEndIndex);
			checkTextFormat();
		}
	}
	
	
	
	
	
	//______________________________________________________________________BG Color Switch
	
	private function changeBG(e:MouseEvent):void {
		
/*		
		if (e.target.name == "Btn_black") {
			BGcolor.color = 0x000000;	
		} else {
			BGcolor.color = 0xFFFFFF;	
		}
		_mainText.background=true;
		_mainText.backgroundColor=BGcolor
		background.txtBG.transform.colorTransform = ;*/
	}
	
	
	
	
	
	
	//______________________________________________________________________Text Saving
	
/*	private function submitText(e:MouseEvent):void {
		
	
	}*/
	
	// Undo all changes
	private function undoText(e:MouseEvent):void {
		
		_mainText.htmlText = myText_orig;
	}
	
	
	public function kill():void
	{
		listeners(false);
		//_mainText.setSelection(0,0);
		doOrigSettings();
		
		
	}
	
	public function checkIsOver(_x:int,_y:int):Boolean
	{
		return _mainText.hitTestPoint(_x,_y);
	}
	
}