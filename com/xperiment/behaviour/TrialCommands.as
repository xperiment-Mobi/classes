package com.xperiment.behaviour
{
	public class TrialCommands
	{
		public static const TRIAL:String = "TRIAL";
		
		public function TrialCommands()
		{
		}
		
		
		//adds special notation for trial specific actions (underscore, not .)
		public static function parseBehav(str:String):String
		{
			
			var findTrialCommands:RegExp = /TRIAL((\.\w*))*/g;
			
			
			return str.replace(findTrialCommands,function(matchedSubstring:String, capturedMatch1:String, str1:String, str2:String, str3:String):String{
				return matchedSubstring.split(".").join("_");
			});	
			
			
		}
	}
}