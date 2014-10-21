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
	import br.hellokeita.sound.komposer.Komposer;
	
	/**
	 * ...
	 * @author keita keita.kun_at_gmail.com
	 */
	public class Note 
	{
		
		private var _frequency:Number = 0;
		private var _start:Number;
		private var _end:Number;
		private var _duration:Number;
		
		private var _startPosition:Number = 0;
		private var _endPosition:Number = 0;
		
		public function Note(frequency:Number, start:Number = 0, end:Number = 0) 
		{
			_frequency = frequency;
			this.start = start;
			this.end = end;
		}
		
		private function updateDuration():void
		{
			_duration = _end - _start;
		}
		
		public function get frequency():Number { return _frequency; }
		
		public function set frequency(value:Number):void 
		{
			_frequency = value;
		}
		
		public function get start():Number { return _start; }
		
		public function set start(value:Number):void 
		{
			_start = value;
			_startPosition = _start * Komposer.MILISECONDS_TO_RATE;
			updateDuration();
		}
		
		public function get end():Number { return _end; }
		
		public function set end(value:Number):void 
		{
			_end = value;
			_endPosition = _end* Komposer.MILISECONDS_TO_RATE;
			updateDuration();
		}
		
		public function get duration():Number { return _duration; }
		
		public function set duration(value:Number):void 
		{
			_duration = value;
			_end = _start + _duration;
		}
		
		public function get startPosition():Number { return _startPosition; }
		
		public function set startPosition(value:Number):void 
		{
			_startPosition = value;
			_start = _startPosition* Komposer.RATE_TO_MILISECONDS;
			updateDuration();
		}
		
		public function get endPosition():Number { return _endPosition; }
		
		public function set endPosition(value:Number):void 
		{
			_endPosition = value;
			_end = _endPosition * Komposer.RATE_TO_MILISECONDS;
			updateDuration();
		}
		
		
	}
	
}