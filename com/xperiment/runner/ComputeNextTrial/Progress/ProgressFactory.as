package com.xperiment.runner.ComputeNextTrial.Progress
{
	import flash.utils.Dictionary;

	public class ProgressFactory
	{
		static public function make(script:XML):Dictionary
		{
			var dict:Dictionary;
			var progressNamesArr:Array = [];
			var nam:String
			for each(var nameXML:XML in script..*.@trialOrderScheme){
				nam=nameXML.toString();
				
				dict ||= new Dictionary;
				dict[nam] = give(script,nam);
			}

			return dict;
		}
		
		private static function give(script:XML, nam:String):Progress
		{
			for each(var xml:XML in script..*.(name()==nam)){
				return compose(xml);
			}
			throw new Error("You have asked to use this progression, "+nam+", but no such progression exists");
			return null;
		}
		
		private static function compose(xml:XML):Progress
		{
			switch (xml.@type.toString()){
				case '':
					return new Progress_ROWPVT(xml);
				
				default:
					return new Progress(xml);
			}
			return null;
		}		
		
	}
}