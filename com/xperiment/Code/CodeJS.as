package com.xperiment.Code
{
	import com.xperiment.Code.Interpretter.Interpretter;

	public class CodeJS
	{
		private static var interpretter:Interpretter;
		
		static public function init():void
		{
			interpretter = new Interpretter;
			//hack();

		}
		
		private static function hack():void
		{
			
		}		
		
	}
}