package com.xperiment.stimuli.primitives.graphs.bar {
	/**
	 * ...
	 * @author Dominic Gelineau
	 */
	public class BarData {
		public var label:String;
		public var data:Number;
		public var errorBar:Number;
		public var colour:int;
		public function BarData(newLabel:String, newData:Number, newErrorBar:Number = 0, newColour:int=-1) {
			label = newLabel;
			data = newData;
			errorBar = newErrorBar;
			colour = newColour
		}
		
		public function maxHeight():Number{
			return errorBar + data;
		}
		
	}

}