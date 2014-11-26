package com.xperiment.behaviour{
	import com.greensock.TweenMax;
	import com.xperiment.uberSprite;

	
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	
	public class behavGradientFill extends behav_baseClass {

		public static const RAD_TO_DEG:Number = 57.295779513082325225835265587527; // 180.0 / PI;
		private var angle:Number;
		private var point:Point;
		private var distance:Number;
		
		private var gradientColors:Object;
		private var gradientMatrix:Matrix;
		
		
		override public function setVariables(list:XMLList):void {

			setVar("int","startOppacity",1);	
			super.setVariables(list);
			
			gradientColors = {left:0xFF0000, right:0x0000FF};
			gradientMatrix = new Matrix();
			gradientMatrix.createGradientBox(100, 100, 0, 0, 0);
		}		
		
		override public function givenObjects(obj:uberSprite):void {
			applyGradient(obj);
			
			super.givenObjects(obj);
		}
		
		

		
		private function applyGradient(obj:uberSprite):void {
			obj.graphics.beginGradientFill(GradientType.LINEAR,
				[gradientColors.left, gradientColors.right], [1, 1], [0, 255],
				gradientMatrix, SpreadMethod.PAD);  
			//obj.graphics.drawRect(0, 0, 100, 100);
		}
		
	
		private function apply(point:Point):void{
			for each(var us:uberSprite in behavObjects){
				distance = Math.sqrt((us.x - point.x) * (us.x - point.x) + (us.y - point.y) * (us.y - point.y));
				angle = Math.atan2( us.y+us.myHeight*.5 - point.y, us.x +us.width*.5- point.x ) * RAD_TO_DEG-180;
				TweenMax.to(gradientColors, 0, {hexColors:{left:0x00FF00, right:0x660066},
					onUpdate:applyGradient(us)});
			}
		}

	}
}

/*		distance : Number [0] 
angle : Number [45] 
color : uint [0x000000] 
alpha :Number [0] 
blurX : Number [0] 
blurY : Number [0] 
strength : Number [1] 
quality : uint [2] 
inner : Boolean [false] 
knockout : Boolean [false] 
hideObject : Boolean [false] 
index : uint 
addFilter : Boolean [false] 
remove : Boolean [false] 
Set remove to true if you want the filter to be removed when the tween completes. 


override public function kill():void {

super.kill();
}
*/