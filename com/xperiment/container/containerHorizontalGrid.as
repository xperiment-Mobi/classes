package com.xperiment.container{

	public class containerHorizontalGrid extends containerVerticalGrid {


		override public function getA(i:uint):uint {
			return ((i-(i%getVar("columns")))/getVar("columns"));
		}

		override public function getB(i:uint):uint {
			
			return i%getVar("columns");
		}
		
		override public function splitVCorrection():int{
			return -1;
		}
		
		override public function splitHCorrection():int{
			return 0;
		}
		
		

	}
}