package com.xperiment.preloader
{
	import com.bit101.components.Style;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.xperiment.codeRecycleFunctions;
	
	import flash.text.Font;

	public class FontLoad
	{

		public static function init(preloader:PreloadStimuli, fontURL:String, remoteDir:String):void
		{
			// TODO Auto Generated method stub
			//
			var fontFilename:String = codeRecycleFunctions.getFilename(fontURL);
			var font:String = fontFilename.split(".swf")[0];
			var loader:SWFLoader = new SWFLoader(remoteDir+fontURL, {onComplete:completeHandler});
			loader.load();
			
			function completeHandler(e:LoaderEvent):void {
	
				var fontClass:Class = loader.getClass(font);
				if(fontClass)	Font.registerFont(fontClass);
				Style.fontName=font;
			}
		}
	}
}