/**
 * 
 * Copyright (c) 2009 Keita Kuroki
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *  
 * This is an example code created for the 
 * "Flash 10, Making music" presentation.
 * 
 * For more information:
 * 	http://labs.hellokeita.com/
 * 	code@hellokeita.in
 * 
 **/

package br.hellokeita.utils 
{
	
	/**
	 * ...
	 * @author keita
	 */
	public class MathUtils 
	{
		
		static public function combination(a:uint, b:uint):uint {
			if (a == b) return 1;
			if (b == 0) return 1;
			if (a < b) return 1;
			var d:uint = a - b;
			var s:uint;
			if (d > b) {
				s = d + 1;
				d = factorial(b);
			}else {
				s = b + 1;
				d = factorial(d);
			}
			return factorial(a, s) / d;
		}
		
		static public function factorial(value:uint, start:uint = 1):uint {
			if (start > value) return 0;
			if (value == start) return value;
			var r:uint = 1;
			for (var i:uint = start; i <= value; i++) {
				r *= i;
			}
			
			return r;
		}
		
		static public function solveCramer(matrix:Array):Array {
			var l:uint = matrix.length;
			var size:uint = Math.sqrt(l);
			if (l != size * size + size) return null;
			
			var result:Array = [];
			var r:Array = [];
			var vs:Array = [];
			
			var d:Number;
			var i:uint, j:uint;
			for (i = 0; i < size; i++) {
				vs = [].concat(vs, matrix.slice(i * (size + 1), i * (size + 1) + size));
				r[i] = matrix[(i + 1) * (size + 1) - 1];
			}
			d = squareMatrixDeterminant(vs);
			
			var tArr:Array;
			for (i = 0; i < size; i++) {
				tArr = [].concat(vs);
				for (j = 0; j < size; j++) {
					tArr[i + j * size] = r[j];
					result[i] = squareMatrixDeterminant(tArr) / d;
				}
			}
			
			return result;
			
		}
		
		static public function squareMatrixDeterminant(matrix:Array):Number {
			var l:int = matrix.length;
			var s:int = Math.sqrt(l);
			if (l != s * s) return Number.NaN;
			
			return _squareMatrixDeterminant(matrix, s);
			
		}
		
		static private function _squareMatrixDeterminant(matrix:Array, size:uint ):Number {
			
			if (size < 1) return Number.NaN;
			if (size == 1) return matrix[0];
			
			if (size == 2) {
				return matrix[0] * matrix[3] - matrix[1] * matrix[2];
			}
			
			var i:int, j:int, h:int;
			var r:Number = 0;
			var tArr:Array;
			var c:int;
			var s:int = 1;
			for (i = 0; i < size; i++) {
				c = 0;
				tArr = [];
				for (j = 1; j < size; j++) {
					for (h = 0; h < size; h++) {
						if (h == i) continue;
						tArr[c++] = matrix[j * size + h];
					}
				}
				
				r += matrix[i] * _squareMatrixDeterminant(tArr, size - 1) * s;
				s *= -1;
				
			}
			
			return r;
			
		}
		
	}
	
}