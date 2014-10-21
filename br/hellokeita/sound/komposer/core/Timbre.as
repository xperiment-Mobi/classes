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

package br.hellokeita.sound.komposer.core 
{
	import br.hellokeita.graphics.BezierValue;
	import br.hellokeita.graphics.MultiBezier;
	import br.hellokeita.sound.komposer.Komposer;

	
	/**
	 * ...
	 * @author keita keita.kun_at_gmail.com
	 */
	public class Timbre
	{
		
		private static const RATE:int = Komposer.RATE; 
		private var _multiBezier:MultiBezier = new MultiBezier();
		
		public function kill():void{
			_multiBezier.kill();
		}
		
		public function Timbre() 
		{
			_multiBezier.useControlAsAnchor = true;
		}
		
		public function addValue(value:Number = 0):void {
			_multiBezier.addValue(new BezierValue(value));
		}
		
		public function changeValueAt(index:uint = 0, value:Number = 0 ):void {
			if (index >= _multiBezier.values.length) return;
			_multiBezier.values[index].value = value;
		}
		
		public function getSample(frequency:Number):Vector.<Number> {
			var numSamples:Number = RATE / frequency;
			
			var d:Number = 1 / numSamples;
			var s:Vector.<Number> = new Vector.<Number>();
			for (var p:Number = 0; p < 1; p+=d) {
				s.push(_multiBezier.getBezier(p));
			}
			return s;
		}
		
	}
	
}