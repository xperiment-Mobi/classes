package com.xperiment.behaviour.components
{
	import flash.geom.Rectangle;

	public class BinPacking_algorithm
	{
		//adapted from http://www.openfl.org/archive/community/programming-haxe/gm2d-rectangle-packing-class/
		
		public var freeRectangles:Vector.<Rectangle>;
		
		private var binWidth:Number;
		private var binHeight:Number;
		
		public function kill():void{
			freeRectangles=null;
		}
		
		public function NEW(width:Number, height:Number):void
		{
			init(width, height);
		}
		
		public function init(width:Number, height:Number):void 
		{
			binWidth = width;
			binHeight = height;
			freeRectangles = new Vector.<Rectangle>;
			freeRectangles.push(new Rectangle(0, 0, width, height));
		}
		public function quickInsert(width:Number, height:Number):Rectangle
		{
			var newNode = quickFindPositionForNewNodeBestAreaFit(width, height);
			
			if (newNode.height == 0) {
				return newNode;
			}
			
			var numRectanglesToProcess:int = freeRectangles.length;
			var i = 0;
			while (i < numRectanglesToProcess)
			{
				if (splitFreeNode(freeRectangles[i], newNode)) {
					freeRectangles.splice(i, 1);
					--numRectanglesToProcess;
					--i;
				}
				i++;
			}
			
			pruneFreeList();
			return newNode;
		}
		
		[IIInline]
		private final function quickFindPositionForNewNodeBestAreaFit(width:Number, height:Number):Rectangle {
			var score:int = int.MAX_VALUE;
			var areaFit:Number;
			var bestNode:Rectangle = new Rectangle();
			for each(var r:Rectangle in freeRectangles) {
				// Try to place the rectangle in upright (non-flipped) orientation.
				if (r.width >= width && r.height >= height) {
					areaFit = r.width * r.height - width * height;
					if (areaFit < score) {
						bestNode.x = r.x;
						bestNode.y = r.y;
						bestNode.width = width;
						bestNode.height = height;
						score = areaFit;
					}
				}
			}
			return bestNode;
		}
		
		private function splitFreeNode(freeNode:Rectangle, usedNode:Rectangle):Boolean {
			var newNode:Rectangle;
			// Test with SAT if the rectangles even intersect.
			if (usedNode.x >= freeNode.x + freeNode.width ||
				usedNode.x + usedNode.width <= freeNode.x ||
				usedNode.y >= freeNode.y + freeNode.height ||
				usedNode.y + usedNode.height <= freeNode.y) {
				return false;
			}
			if (usedNode.x < freeNode.x + freeNode.width && usedNode.x + usedNode.width > freeNode.x) {
				// New node at the top side of the used node.
				if (usedNode.y > freeNode.y && usedNode.y < freeNode.y + freeNode.height) {
					newNode = freeNode.clone();
					newNode.height = usedNode.y - newNode.y;
					freeRectangles.push(newNode);
				}
				// New node at the bottom side of the used node.
				if (usedNode.y + usedNode.height < freeNode.y + freeNode.height) {
					newNode = freeNode.clone();
					newNode.y = usedNode.y + usedNode.height;
					newNode.height = freeNode.y + freeNode.height - (usedNode.y + usedNode.height);
					freeRectangles.push(newNode);
				}
			}
			if (usedNode.y < freeNode.y + freeNode.height && usedNode.y + usedNode.height > freeNode.y) {
				// New node at the left side of the used node.
				if (usedNode.x > freeNode.x && usedNode.x < freeNode.x + freeNode.width) {
					newNode = freeNode.clone();
					newNode.width = usedNode.x - newNode.x;
					freeRectangles.push(newNode);
				}
				// New node at the right side of the used node.
				if (usedNode.x + usedNode.width < freeNode.x + freeNode.width) {
					newNode = freeNode.clone();
					newNode.x = usedNode.x + usedNode.width;
					newNode.width = freeNode.x + freeNode.width - (usedNode.x + usedNode.width);
					freeRectangles.push(newNode);
				}
			}
			return true;
		}
		
		private function pruneFreeList():void 
		{
			// Go through each pair and remove any rectangle that is redundant.
			var i = 0;
			var j = 0;
			var len = freeRectangles.length;
			var tmpRect:Rectangle;
			var tmpRect2:Rectangle;
			while (i < len)
			{
				j = i + 1;
				tmpRect = freeRectangles[i];
				while (j < len)
				{
					tmpRect2 = freeRectangles[j];
					if (isContainedIn(tmpRect,tmpRect2)) {
						freeRectangles.splice(i, 1);
						--i;
						--len;
						break;
					}
					if (isContainedIn(tmpRect2,tmpRect)) {
						freeRectangles.splice(j, 1);
						--len;
						--j;
					}
					j++;
				}
				i++;
			}
		}
		
		[IIInline]
		private final function isContainedIn(a:Rectangle, b:Rectangle):Boolean
		{
			return a.x >= b.x && a.y >= b.y	&& a.x + a.width <= b.x + b.width && a.y + a.height <= b.y + b.height;
		}
	}
}