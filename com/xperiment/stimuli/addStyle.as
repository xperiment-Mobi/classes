package com.xperiment.stimuli
{
	import com.bit101.components.Style;

	public class addStyle extends object_baseClass
	{
	
		
		
		override public function setVariables(list:XMLList):void {
			setVar("string","TEXT_BACKGROUND","");
			setVar("string","BACKGROUND","");
			setVar("string","BUTTON_FACE","");
			setVar("string","BUTTON_DOWN","");
			setVar("string","INPUT_TEXT","");
			setVar("string","LABEL_TEXT","");
			setVar("string","DROPSHADOW","");
			setVar("string","PANEL","");
			setVar("string","PROGRESS_BAR","");
			setVar("string","LIST_DEFAULT","");
			setVar("string","LIST_ALTERNATE","");
			setVar("string","LIST_SELECTED","");
			setVar("string","LIST_ROLLOVER","");
			setVar("string","embedFonts","");
			setVar("string","fontName","");
			setVar("string","fontSize","");
			setVar("string","borderWidth","");
			setVar("string","borderAlpha","");
			setVar("string","borderColour","");
			setVar("string","globalStyle","")//DARK
			super.setVariables(list);
			
			/*Style	TEXT_BACKGROUND:uint = 0xFFFFFF;
			BACKGROUND:uint = 0xCCCCCC;
			BUTTON_FACE:uint = 0xFFFFFF;
			BUTTON_DOWN:uint = 0xEEEEEE;
			INPUT_TEXT:uint = 0x333333;
			LABEL_TEXT:uint = 0x666666;
			DROPSHADOW:uint = 0x000000;
			PANEL:uint = 0xF3F3F3;
			PROGRESS_BAR:uint = 0xFFFFFF;
			LIST_DEFAULT:uint = 0xFFFFFF;
			LIST_ALTERNATE:uint = 0xF3F3F3;
			LIST_SELECTED:uint = 0xCCCCCC;
			LIST_ROLLOVER:uint = 0XDDDDDD;
			embedFonts:Boolean = true;
			fontName:String = "PF Ronda Seven";
			fontSize:Number = 8;
			borderWidth:uint=2;
			borderAlpha:Number=.4;
			borderColour:uint=0x000000;*/
			if(getVar("TEXT_BACKGROUND")!="")Style.TEXT_BACKGROUND=uint(getVar("TEXT_BACKGROUND"));
			if(getVar("BACKGROUND")!="")Style.BACKGROUND=uint(getVar("BACKGROUND"));
			if(getVar("BUTTON_FACE")!="")Style.BUTTON_FACE=uint(getVar("BUTTON_FACE"));
			if(getVar("BUTTON_DOWN")!="")Style.BUTTON_DOWN=uint(getVar("BUTTON_DOWN"));
			if(getVar("INPUT_TEXT")!="")Style.INPUT_TEXT=uint(getVar("INPUT_TEXT"));
			if(getVar("LABEL_TEXT")!="")Style.LABEL_TEXT=uint(getVar("LABEL_TEXT"));
			if(getVar("DROPSHADOW")!="")Style.DROPSHADOW=uint(getVar("DROPSHADOW"));
			if(getVar("PANEL")!="")Style.PANEL=uint(getVar("PANEL"));
			if(getVar("PROGRESS_BAR")!="")Style.PROGRESS_BAR=uint(getVar("PROGRESS_BAR"));
			if(getVar("LIST_DEFAULT")!="")Style.LIST_DEFAULT=uint(getVar("LIST_DEFAULT"));
			if(getVar("LIST_ALTERNATE")!="")Style.LIST_ALTERNATE=uint(getVar("LIST_ALTERNATE"));
			if(getVar("LIST_SELECTED")!="")Style.LIST_SELECTED=uint(getVar("LIST_SELECTED"));
			if(getVar("LIST_ROLLOVER")!="")Style.LIST_ROLLOVER=uint(getVar("LIST_ROLLOVER"));
			if(getVar("embedFonts")!="")Style.embedFonts=Boolean(getVar("embedFonts"));
			if(getVar("fontName")!="")Style.fontName=String(getVar("fontName"));
			if(getVar("fontSize")!="")Style.fontSize=uint(getVar("fontSize"));
			if(getVar("borderWidth")!="")Style.borderWidth=uint(getVar("borderWidth"));
			if(getVar("borderAlpha")!="")Style.borderAlpha=Number(getVar("borderAlpha"));
			if(getVar("borderColour")!="")Style.borderColour=uint(getVar("borderColour"));

			
			if((getVar("globalStyle") as String).toLowerCase()=="dark")Style.setStyle("dark");			
			
			
		}
	}
}