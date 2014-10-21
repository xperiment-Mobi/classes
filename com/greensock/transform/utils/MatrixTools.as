/**
 * VERSION: 1.21
 * DATE: 2011-07-14
 * AS3 
 * UPDATES AND DOCS AT: http://www.greensock.com/transformmanageras3/
 **/
package com.greensock.transform.utils {
	import flash.geom.Matrix;
/**
 * Used by TransformManager to perform various Matrix calculations. <br /><br />
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/eula.html">http://www.greensock.com/eula.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class MatrixTools {
		/** @private **/
		private static const VERSION:Number = 1.21;
		
		/** @private **/
		public static function getDirectionX($m:Matrix):Number {
			var sx:Number = Math.sqrt($m.a * $m.a + $m.b * $m.b);
			if ($m.a < 0) { 
				return -sx;
			}
			return sx;
		}
		
		/** @private **/
		public static function getDirectionY($m:Matrix):Number {
			var sy:Number = Math.sqrt($m.c * $m.c + $m.d * $m.d);
			if ($m.d < 0) {
				return -sy;
			}
			return sy;
		}
		
		/** @private **/
		public static function getScaleX($m:Matrix, $flipX:Boolean=false):Number {
			var sx:Number = Math.sqrt($m.a * $m.a + $m.b * $m.b);
			return ($flipX) ? -sx : sx;
		}
		
		/** @private **/
		public static function getScaleY($m:Matrix, $flipX:Boolean=false):Number {
			var sy:Number = Math.sqrt($m.c * $m.c + $m.d * $m.d);
			if ($flipX) {
				sy = -sy;
			}
			var a1:Number = Math.atan2($m.b, $m.a);
			var a2:Number = Math.atan2($m.d, $m.c);
			if (a1 > a2) {
				a1 -= Math.PI * 2;
			}
			if (a2 - a1 > Math.PI) {
				return -sy;
			}
			return sy;
		}
		
		/** @private **/
		public static function getAngle($m:Matrix, $flipX:Boolean=false):Number { //If a DisplayObject is flipped (negative scaleX or scaleY), you cannot simply do Math.atan2($m.b, $m.a)!
			var a:Number = Math.atan2($m.b, $m.a);
			if ($flipX) {
				a += (a < 0) ? Math.PI : -Math.PI;
			}
			return a;
		}
		
		/** @private Flash has a somewhat odd way of reporting rotation natively - this replicates it. **/
		public static function getFlashAngle($m:Matrix):Number {
			var a:Number = Math.atan2($m.b, $m.a);
			if (a < 0 && $m.a * $m.d < 0) {
				a = (a - Math.PI) % Math.PI;
			}
			return a;
		}
		
		/** @private **/
		public static function scaleMatrix($m:Matrix, $sx:Number, $sy:Number, $angle:Number, $skew:Number):void {
			var cosAngle:Number = Math.cos($angle);
			var sinAngle:Number = Math.sin($angle);
			var cosSkew:Number = Math.cos($skew);
			var sinSkew:Number = Math.sin($skew);
			
			var a:Number = (cosAngle * $m.a + sinAngle * $m.b) * $sx;
			var b:Number = (cosAngle * $m.b - sinAngle * $m.a) * $sy;
			var c:Number = (cosSkew * $m.c - sinSkew * $m.d) * $sx;
			var d:Number = (cosSkew * $m.d + sinSkew * $m.c) * $sy;
			
			$m.a = cosAngle * a - sinAngle * b;
			$m.b = cosAngle * b + sinAngle * a;
			$m.c = cosSkew * c + sinSkew * d;
			$m.d = cosSkew * d - sinSkew * c;
		}
		
		/** @private **/
		public static function getSkew($m:Matrix):Number {
			return Math.atan2($m.c, $m.d);
		}
		
		/** @private **/
		public static function setSkewX($m:Matrix, $skewX:Number):void {
			var sy:Number = Math.sqrt($m.c * $m.c + $m.d * $m.d);
			$m.c = -sy * Math.sin($skewX);
			$m.d =  sy * Math.cos($skewX);
		}
		
		/** @private **/
		public static function setSkewY($m:Matrix, $skewY:Number):void {
			var sx:Number = Math.sqrt($m.a * $m.a + $m.b * $m.b);
			$m.a = sx * Math.cos($skewY);
			$m.b = sx * Math.sin($skewY);
		}
		
		/* Just for reference - here are methods that don't track flipX which more closely reflect how Flash interprets/applies Matrix values. They never report a negative scaleX. Instead, when any flipping is necessary, scaleY is flipped. Technically this leads to less consistency, like if a user tweens the scaleX and rotation, those would suddenly change once scaleX goes negative (rotation would be altered by 180 degrees and scaleY would go negative)
		
		public static function getScaleX(m:Matrix):Number {
			return Math.sqrt(m.a * m.a + m.b * m.b);
		}
		
		public static function getScaleY(m:Matrix):Number {
			var scaleY:Number = Math.sqrt(m.c * m.c + m.d * m.d);
			var angle1:Number = Math.atan2(m.b, m.a);
			var angle2:Number = Math.atan2(m.d, m.c);
			var dif:Number = angle2 - angle1;
			if (dif < 0) {
				dif += Math.PI * 2;
			}
			return (dif > Math.PI) ? -scaleY : scaleY;
		}
		
		public static function getAngle(m:Matrix):Number { 
			return Math.atan2(m.b, m.a);
		}
		
		*/
	
	}
}