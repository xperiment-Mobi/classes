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

package br.hellokeita.graphics 
{
	import br.hellokeita.utils.MathUtils;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author keita
	 */
	public class MultiBezier 
	{
		
		static public function getQuadControlValue(v1:Number, anchor:Number, v2:Number):Number {
			return - v2 * 0.5 - v1 * 0.5 + anchor * 2;
		}
		
		private var _values:Array;
		private var _useControlAsAnchor:Boolean = false;
		private var _anchors:Array;
		private var _changed:Boolean = true;
		
		public function kill():void{
			_anchors=null;
			_values=null;
		}
		
		public function MultiBezier() 
		{
			_values = [];
		}
		
		public function getBezier(position:Number):Number {
			
			if (position < 0) position = 0;
			if (position > 1) position = 1;
			var vs:Array = (_useControlAsAnchor)?getAnchors():_values;
			var v:Number = 0;
			var l:uint = vs.length - 1;
			var m:Number;
			for (var i:int = 0; i < l + 1; i++) {
				v += (MathUtils.combination(l, i) * Math.pow((1 - position), l - i) * Math.pow(position, i)) * Number(vs[i]);
			}
			
			return v;
		}
		
		public function getQuadraticBezier(precision:Number = 0.5):Array {
			var l:uint = _values.length;
			if (_values.length == 3) return [[getBezier(0.5), Number(getBezier(1))]];
			var v0:Number, v1:Number, v2:Number;
			var v:Number;
			var p:Number = precision / l;
			var vs:Array = [];
			for (var i:Number = 0; i < 1; i += p) {
				v0 = getBezier(i);
				v1 = getBezier(i + p * 0.5);
				v2 = getBezier(i + p);
				
				v = getQuadControlValue(v0, v1, v2);
				vs.push([v, v2]);
			}
			return vs;
		}
		
		private function getAnchors():Array {
			
			if (!_changed) return _anchors;
			
			var r:Array = [];
			var l:int = _values.length - 1;
			var i:int, j:int;
			var t:Number;
			for (i = 1; i < l; i++) {
				t = i / l;
				for (j = 1; j <= l; j++) {
					if (j == l) {
						r.push(_values[i] - Math.pow((1 - t), l) * _values[0] - Math.pow(t, l) * _values[l]);
					}else {
						r.push(MathUtils.combination(l, j) * Math.pow((1 - t), l - j) * Math.pow(t, j));
					}
				}
			}
			
			r = MathUtils.solveCramer(r);
			r.unshift(Number(_values[0]));
			r.push(Number(_values[l]));
			_anchors = r;
			_changed = false;
			
			return r;
		}
		
		private function valueChanged(e:Event):void 
		{
			_changed = true;
		}
		
		public function addValue(value:BezierValue):BezierValue {
			value.addEventListener(Event.CHANGE, valueChanged);
			_values.push(value);
			_changed = true;
			return value;
		}
		
		public function addValueAt(value:BezierValue, index:uint):BezierValue {
			value.addEventListener(Event.CHANGE, valueChanged);
			_values.splice(index, 0, value);
			_changed = true;
			return value;
		}
		
		public function removeValue(value:BezierValue):BezierValue {
			while (_values.indexOf(value) >= 0) _values.splice(_values.indexOf(value), 1);
			value.removeEventListener(Event.CHANGE, valueChanged);
			_changed = true;
			return value;
		}
		
		public function removeValueAt(index:int):BezierValue {
			var value:BezierValue = _values.splice(index, 1)[0];
			value.removeEventListener(Event.CHANGE, valueChanged);
			_changed = true;
			return value;
		}
		
		public function get values():Array { return _values; }
		
		public function get useControlAsAnchor():Boolean { return _useControlAsAnchor; }
		
		public function set useControlAsAnchor(value:Boolean):void 
		{
			_useControlAsAnchor = value;
			_changed = true;
		}
		
		public function get start():Number { return _values[0]; }
		
		public function set start(value:Number):void 
		{
			_values[0] = value;
		}
		
		public function get end():Number { return _values[_values.length - 1]; }
		
		public function set end(value:Number):void 
		{
			_values[_values.length - 1] = value;
		}
		
	}
	
}