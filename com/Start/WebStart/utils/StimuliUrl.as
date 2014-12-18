package com.Start.WebStart.utils
{
	public class StimuliUrl
	{
	
		public static function getStimLoc(loc:String):String
		{
			//'experiment/62a62aea21fb4e35918890eaeb90c2fd/app/'
			loc = loc.split("\\").join("/"); //think apple needs this
			
			var arr:Array = loc.split("/");	
			for each(loc in arr){
				if(loc.length==32){
					return 'https://www.xpt.mobi/stimuli/'+loc+"/";
				}
			}
			
			if(loc.indexOf('127.0.0.1')!=-1){
				
			}
			
			return '';
		}	
	}
}