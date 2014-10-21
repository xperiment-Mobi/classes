package com.danielfreeman.extendedMadness {

	/**
	 * @author danielfreeman
	 */


	import com.danielfreeman.madcomponents.*;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	
	
	public class UICell extends UILabel {
		
		protected const FORMAT:TextFormat = new TextFormat('Arial', 13, 0x000066, true);
		
		public function UICell(screen:Sprite, xx:int, yy:int, txt:String = "", wdth:Number = 0, format:TextFormat=null, multiLine:Boolean = false, borderColour:uint = 0x666666) {
			super(screen, xx, yy, txt, format);
			format = format ? format : FORMAT;
			border = true;
			borderColor = borderColour;
			multiline = wordWrap = multiLine;
			setTextFormat(format);
			defaultTextFormat = format;
			if (wdth > 0) {
				fixwidth = wdth;
			}
		}
		
		
		override public function set fixwidth(value:Number):void {
			autoSize = TextFieldAutoSize.NONE;
			super.fixwidth = value;
	//		autoSize = TextFieldAutoSize.NONE;
		}
		
		
		public function set defaultColour(value:uint):void {
			background = (value != uint.MAX_VALUE);
			backgroundColor = value;
		}

	}
}
