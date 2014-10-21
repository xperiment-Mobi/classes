package com.xperiment.stimuli
{
	public class Test_object_baseClass extends object_baseClass
	{
		

		public var myVal:String="not set";
		
		
		override public function myUniqueProps(prop:String):Function{
			switch(prop){
				case "myVal"	:		return function(what:String=null,to:String=null):String{
					if(what) myVal=to;
					return myVal;
				}; 	
				case "testProp"	:		return function(what:String=null,to:String=null):String{
					if(what) myVal=to;
					return myVal;
				}; 	
					break;
			}
			return null;
		}
		
		
		
	}
}