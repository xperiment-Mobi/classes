package com.xperiment.stimuli.Controls
{
	


	public class Controls
	{


		
		public static function sound(params:Object):Panel
		{
			
			var panel:Panel = new Panel();
			
			for(var key:String in params){
				panel.giveElement(new Button(key,params[key]));
			}
			
			
			panel.compose()
			
			
			return panel;
		}
	}
}