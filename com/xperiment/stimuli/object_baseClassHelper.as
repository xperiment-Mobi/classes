package com.xperiment.stimuli
{
	import com.xperiment.codeRecycleFunctions;

	public class object_baseClassHelper
	{
		public function object_baseClassHelper()
		{
		}
		
		public static function SHUFFLE_SOMETHING(shuffleSomething:String, OnScreenElements:Array):void
		{
			var arr:Array=shuffleSomething.split(",");
			var param:String=arr[0];
			var split:String = ";"
			if(arr.length>1)split=arr[1];
			
			if(OnScreenElements.hasOwnProperty(param)){
				arr=OnScreenElements[param].split(split);
				OnScreenElements[param]=codeRecycleFunctions.arrayShuffle(arr)[0];
			}
			else throw new Error("you asked to SHUFFLE_SOMETHING, but the parameter you specifed ("+param+") does not exist.  SHUFFLE_SOMETHING='"+shuffleSomething+"'");
			
		}
		
		/*public static function escalatingProps(what:String,OnScreenElements:Array):*
		{
			var num:int=-1;
			if(OnScreenElements.hasOwnProperty(what+"0"))num=0;
			else if(OnScreenElements.hasOwnProperty(what+"1"))num=1;
			
			if(num==-1)return OnScreenElements[what];
			

			else{
				var returnVal:String = OnScreenElements[what].toString();
				while(OnScreenElements[what+num.toString()]!=undefined){
					returnVal+=OnScreenElements[what+num.toString()].toString();
					num++;
				}
			}
			
			
			
			if(OnScreenElements[what] is String) return returnVal;
			else if(OnScreenElements[what] is Number) return Number(returnVal);
			else if(OnScreenElements[what] is Boolean) return Boolean(returnVal);

			return null;
		}
		*/

	}
}