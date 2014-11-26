package com.xperiment.stimuli.primitives.graphs.bar {
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Dominic Gelineau
	 */
	
	public class BarChart extends Sprite {
		
		
		public var maximumValue:Number;
		private var _horizontalAxis:HorizontalAxis;
		private var _verticalAxis:VerticalAxis;
		private var _barWidth:Number;
		private var _barSpacing:Number;
		private const MARGIN:Number = 10;
		public var bars:Vector.<Bar> = new Vector.<Bar>;
		
		private var data:Vector.<BarData>;
		private var myWidth:int;
		private var myHeight:int;
		private var id:String;
		
		public function kill():void{
			data=null;
		}
		
		public function BarChart(data:Vector.<BarData> , params:Object) {
			
			this.data = data;
			if(params.id!=undefined)	this.id = params.id;
			myWidth = params.width;
			myHeight = params.height;

			_barWidth = (myWidth - MARGIN) * 85 / 100 / data.length;
			_barSpacing = (myWidth - MARGIN) * 15 / 100 / (data.length + 1);
			
		
			if(params.hasOwnProperty('maxValue'))	maximumValue = params.maxValue;
			else	calcMaxVal();
			
			init();
		}
		
		private function calcMaxVal():void
		{
			var i:int;
			maximumValue = data[0].maxHeight();
			var newMax:Number;
			for (i = 1; i < data.length; i++) {
				newMax = data[i].maxHeight()
				if (newMax > maximumValue) {
					maximumValue = newMax;
				}
			}	
		}
		
		public function init():void{
			var scaleHeight:Number = (myHeight - MARGIN) / maximumValue;
			
			var listOfMarks:Vector.<Number> = new Vector.<Number>();
			var bar:Bar;
			for (var i:int = 0; i < data.length; i++) {
				bar = new Bar(_barWidth, data[i].data * scaleHeight, data[i].errorBar * scaleHeight, data[i].colour);
				bar.x = MARGIN + _barSpacing + _barWidth / 2 + i * (_barWidth + _barSpacing);
				listOfMarks.push(bar.x - MARGIN);
				bar.y = myHeight - MARGIN;
				addChild(bar);
				bars.push(bar);
			}
			
			_horizontalAxis = new HorizontalAxis(listOfMarks, data, myWidth - MARGIN);
			_horizontalAxis.x = MARGIN;
			_horizontalAxis.y = myHeight - MARGIN;
			addChild(_horizontalAxis);
			
			_verticalAxis = new VerticalAxis(myHeight - MARGIN, maximumValue);
			_verticalAxis.x = MARGIN;
			_verticalAxis.y = myHeight - MARGIN;
			addChild(_verticalAxis);
		}
	}
}