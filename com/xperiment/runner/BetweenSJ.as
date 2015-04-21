package com.xperiment.runner
{

	public class BetweenSJ
	{
		
		//private static const label:String = 'overSJs';
		

		public static function process(script:XML, params:Object):XML
		{
			//params.overSJs="overSJs_forceCondition=v2";
	
			
			
			if(params.hasOwnProperty('overSJs')==false || params.overSJs.length==0 ) return script;
			
			var overSJs:String = params.overSJs;
			var info:Object;
			
			for each(var split:String in overSJs.split(",")){
				info = compose(split);
				
				for each(var xml:XML in script..*.(hasOwnProperty('@'+info.what))){
					var param:String = xml.@[info.what];
					
					xml.@[param] = info.to;
					//trace(2,xml.@[param])
				}
			}
			trace(111,script)
			return script;
		}
		
		private static function compose(str:String):Object{
			var arr:Array = str.split("=");
			if(arr.length!=2) throw new Error();
			return {what:arr[0],to:arr[1]};
		}
	}
}