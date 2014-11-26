package com.xperiment.script
{	
	import flash.events.Event;

	public class Test_BetweenSJs_SortOutMultiExperiment extends BetweenSJs
	{
		public var response:String;
			

		
		override public function forceConditionF(forceCondition:String):void
		{
			response='forceConditionF:'+forceCondition;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override public function __getCondFromServer(SJsPercondPerStep:Array):void
		{	
			response='__needSJcountThenWhichStep';
			dispatchEvent(new Event(Event.COMPLETE));
		}
		

		
		override public function __singleMultiStep(attribs:XMLList):Array
		{
			response='__singleMultiStep';
			dispatchEvent(new Event(Event.COMPLETE));
			return null;
		}
		
		override public function getCondOverSJquants(steps:XMLList):void{
			response='__needSJcountThenWhichStep'
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
	}
}