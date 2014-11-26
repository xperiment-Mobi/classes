package com.Start.MobilePlayerStart.utils
{
	public class ParseMobileScript
	{
		public function ParseMobileScript()
		{
		}
		
		public static function addRemoteStimFolder(script:XML,url:String):XML
		{
			
		
			
			var loc:String = url;
			loc = splitPop(loc,"/");
			loc = splitPop(loc,"\\");
			
			var location:String = script..computer.@stimuliFolder
			if(location.indexOf("http")==-1) script..computer.@stimuliFolder = loc+location;			
			
			location = script..results.@saveDataURL
			if(location.indexOf("http")==-1) script..results.@saveDataURL = loc+location;
			
			return script;
		}
		
		
		
		private static function splitPop(str:String,splitBy:String):String{
			var arr:Array = str.split(splitBy);
			if(arr.length>1)arr[arr.length-1]='';
			return arr.join(splitBy);
		}
	}
}