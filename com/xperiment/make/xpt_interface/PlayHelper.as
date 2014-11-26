package com.xperiment.make.xpt_interface
{
	public class PlayHelper
	{
		
		private static var r:runnerBuilder;
		
		public static function setup(ru:runnerBuilder):void
		{
			r = ru;
		}
		
		public static function action(str:String):void{
			if(str=='play') {  play(); return }
			if(str=='pause'){ pause(); return }
			if(str=='reset'){ reset(); return }
			
		}
		
		private static function pause():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private static function reset():void
		{
			// TODO Auto Generated method stub
			
		}
		
		private static function play():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}