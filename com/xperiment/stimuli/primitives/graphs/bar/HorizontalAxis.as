package com.xperiment.stimuli.primitives.graphs.bar {
	import com.bit101.components.Style;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Dominic Gelineau
	 */
	public class HorizontalAxis extends Sprite {
		
		public function HorizontalAxis(listOfMark:Vector.<Number>, data:Vector.<BarData>, width:Number) {
			drawAxisLine(new Point(0, 0), new Point(width, 0));
			
			for (var i:int = 0; i < listOfMark.length; i++) {
				drawAxisLine(new Point(listOfMark[i], -3), new Point(listOfMark[i], 3));
				
				var textField:TextField = new TextField();
				textField.textColor = Style.LABEL_TEXT;
				textField.text = data[i].label;
				textField.width = textField.textWidth + 5;
				textField.height = textField.textHeight + 3;
				textField.x = listOfMark[i] - textField.width / 2;
				textField.y = 5;
				addChild(textField);
			}
		}
		public function drawAxisLine(point1:Point, point2:Point):void {
			var line:Shape = new Shape();
			
			line.graphics.lineStyle(Style.borderWidth, Style.LABEL_TEXT,Style.borderAlpha);
			line.graphics.moveTo(point1.x, point1.y);
			line.graphics.lineTo(point2.x, point2.y);
			addChild(line);
		}
	}
}