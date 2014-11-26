package com.xperiment.Logic.components
{
	public class LogicOperator
	{
		
		public static const operators:Array=["&&","||"];
		private var _operator:String;

		public function get operator():String{return _operator};
		
		public function LogicOperator(operat:String)
		{
			_operator=operat;
		}
	}
}