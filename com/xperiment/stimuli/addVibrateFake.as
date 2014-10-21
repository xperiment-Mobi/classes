package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class addVibrateFake extends addShape
	{
		public function addVibrateFake() 
		{
		}
		
		override public function RunMe():uberSprite {
			
			super.RunMe();
			var txt:TextField = new TextField;
			txt.text=getVar("pattern");
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.scaleY=txt.scaleX=pic.width/txt.width;
			
			//pic.addChild(txt);
			pic.addChild(txt)
			
			return pic;
		}
	}
}