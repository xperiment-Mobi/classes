package com.xperiment.StarlingSingleton
{
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class Base extends Sprite
	{
		public function Base()
		{
			var textField:TextField = new TextField(400, 250, "Welcome to Starling!");
			addChild(textField);
		}
	}
}