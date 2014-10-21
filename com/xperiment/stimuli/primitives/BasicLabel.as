package com.xperiment.stimuli.primitives
{
	import com.bit101.components.Style;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	
	public class BasicLabel extends TextField
	{

		private var _fontSize:int = Style.fontSize;

		public var myWidth:Number;
		public var myHeight:Number;
		public var font:String;

		
		
		public function init():void{
			mouseEnabled = false;	

			this.multiline=true;
			this.width=myWidth;
			this.height = myHeight;
			
			this.selectable = false;
			this.mouseEnabled = false;
			this.autoSize = TextFieldAutoSize.CENTER;
			this.type = TextFieldType.DYNAMIC;
			
			if(!font){
				font= Style.fontName;
			}
			else{
				this.embedFonts = Style.embedFonts;
			}

			var format:TextFormat = new TextFormat(font, _fontSize, Style.LABEL_TEXT,null,null,null,null,null,"center");
		
			this.setTextFormat(format);
			this.defaultTextFormat=format;
				
			var l:TextLineMetrics = this.getLineMetrics(0);			
		}
		
		public function heightCorrection():Number{
			
			var height:Number = 0;
			for(var i:int = 0;i< this.numLines; i++){
				height+=this.getLineMetrics(i).height + this.getLineMetrics(i).leading;
			}

			return (this.height-height)*.5;
		}
		
		
		public function get fontSize():int
		{
			return _fontSize;
		}
		
		public function set fontSize(value:int):void
		{
			_fontSize = value;
			defaultTextFormat.size=value;
		}
		
	}
}