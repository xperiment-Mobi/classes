package com.xperiment.stimuli
{
	public class test_stim extends object_baseClass
	{
		public var textVal:String = '';
		
		public function test_stim()
		{
			super();
		}
		
		
		override public function myUniqueProps(prop:String):Function{
			
			switch(prop){
				case "text"	:		return function(what:String=null,to:String=null):String{
					if(what) text(to);
					return textVal;
				}; 	
					break;
			}
			return null;
		}
		
		public function text(str:String=""):String{
			
			if(arguments.length!=0){
				str=getVar("prefix")+str+getVar("suffix");
				textVal=str;
			}
			return textVal;
		}
		
	}
}