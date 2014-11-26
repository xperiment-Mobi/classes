package com.xperiment.stimuli.primitives
{
	import flash.display.Shape;

	public class Cell
	{
		private var _row:uint;
		private var _column:uint;
		private var _ob:Shape;
		private var _name:String;
		
		public function get row():uint
		{
			return _row;
		}

		public function set row(value:uint):void
		{
			_row = value;
		}

		public function get column():uint
		{
			return _column;
		}

		public function set column(value:uint):void
		{
			_column = value;
		}

		public function get ob():Shape
		{
			return _ob;
		}

		public function set ob(value:Shape):void
		{
			_ob = value;
		}
		
		public function kill():void
		{
			_ob=null;
		}

	}
}