package com.xperiment.stimuli
{

	import flash.utils.getTimer;

	public class addTime extends addResults implements IneedPokeAtStart
	{		
		private var time1:int;
		
		
		public function addTime(){
			__mID="Time";
			super();
		}
		
		public function pokeOnStart():void{
			time1 = getTimer();
		}
		
		override public function getValue(to:String):String
		{
			return (getTimer() - time1).toString();
		}
		
		
		
	}
}