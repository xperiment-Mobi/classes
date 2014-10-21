package com.xperiment.stimuli.primitives.graphs.bar {
	import com.bit101.components.Style;
	import com.xperiment.codeRecycleFunctions;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Dominic Gelineau
	 */
	public class VerticalAxis extends Sprite {
		private var _numberOfMarks:int = 10;
		public function VerticalAxis(heightOfAxis:int, maximumValue:Number) {
			drawAxisLine(new Point(0, 0), new Point(0, -heightOfAxis));
			var textField:TextField;
			var scaleHeight:Number = (heightOfAxis) / maximumValue;
			for (var i:int = 0; i < _numberOfMarks; i++) {
				drawAxisLine(new Point( -3, (i + 1) * -heightOfAxis / _numberOfMarks ), new Point(3, (i + 1) * -heightOfAxis / _numberOfMarks));
				textField = new TextField;
				textField.textColor = Style.LABEL_TEXT;
				textField.text = String(codeRecycleFunctions.roundToPrecision(((i + 1) / (_numberOfMarks)) * maximumValue,0 ));
				textField.width = textField.textWidth + 5;
				textField.height = textField.textHeight + 3;
				textField.x = -textField.width - 3;
				textField.y = (i + 1) * -heightOfAxis / _numberOfMarks - textField.height / 2;
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