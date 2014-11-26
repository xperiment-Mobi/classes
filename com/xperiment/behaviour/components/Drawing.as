package com.xperiment.behaviour.components
{
	import com.dgrigg.minimalcomps.graphics.Shape;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.display.Graphics;

	public class Drawing
	{
		private var drawing:Shape;
		private var canvas:Sprite;
		private var started:Boolean=false;
		private var prevPoint:Point;
		private var size:Number;
	
		public var bg:Sprite;
		public var container: Sprite;

		
		private var lineArray: Array = [];
		private var colorArray: Array = [];
		private var currentPointArray: Array;
		private var currentIndex: int = 0;
		private var g:Graphics;
		
		public function kill():void{
			
			canvas.removeChild(drawing);
			
		}
		
		public function Drawing(canvas:Sprite)
		{
			this.canvas = canvas;
			this.g=canvas.graphics;
			init();
		}
		
		private function init():void{
			drawing = new Shape;
			canvas.addChild(drawing);
		}
		
		public function stop():void{
			started=false;
		}
		
		public function addDot(point:Point):void{
			if(started==true){
				g.lineTo(point.x, point.y);
				currentPointArray[currentIndex] = point;
				currentIndex ++;
				
				if(currentPointArray.length>2)smoothLines();
			}
			else{
				canvas.parent.setChildIndex(canvas,canvas.parent.numChildren-1);
				currentIndex = 0;
				currentPointArray = [];
				lineArray.push(currentPointArray);
				var color: uint = Math.random() * 0.5 * 0xFF << 16 | Math.random() * 0.5 * 0xFF << 8 | Math.random() * 0.5 * 0xFF;
				colorArray.push(color);
				g.moveTo(point.x,point.y);
				g.lineStyle(6, color, 1);
				
				started = true;

			}
		}
		
		private function smoothLines():void {
			g.clear();
			var line: Array;
			var p1: Point;
			var p2: Point;
			var prevMidPoint: Point;
			var midPoint: Point;
			var skipPoints: int = 2; //default 2			
			
			for (var j: int = 0; j < lineArray.length; j++) {
				line = lineArray[j];
				g.lineStyle(6, colorArray[j], 1);
				//trace( "line : " + j + " - " + line );
				prevMidPoint = null;
				midPoint = null;
				for (var i: int = skipPoints; i < line.length; i++) {
					if (i % skipPoints == 0) {
						p1 = line[i - skipPoints];
						p2 = line[i];
						
						midPoint = new Point(p1.x + (p2.x - p1.x) / 2, p1.y + (p2.y - p1.y) / 2);
						
						// draw the curves:
						if (prevMidPoint) {
							g.moveTo(prevMidPoint.x,prevMidPoint.y);
							g.curveTo(p1.x, p1.y, midPoint.x, midPoint.y);
						} else {
							// draw start segment:
							g.moveTo(p1.x, p1.y);
							g.lineTo(midPoint.x,midPoint.y);
						}
						prevMidPoint = midPoint;
					} 
					//draw last stroke
					if (i == line.length - 1) {
						g.lineTo(line[i].x,line[i].y);
					}
				}
			}
		}
		
	}
}