package com.xperiment.stimuli
{
	import com.xperiment.codeRecycleFunctions;

	public class object_baseClassHelper
	{

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
		


	}
}