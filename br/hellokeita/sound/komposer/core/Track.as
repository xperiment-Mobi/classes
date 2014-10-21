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
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author keita keita.kun_at_gmail.com
	 */
	public class Track 
	{
		
		private var _timbre:Timbre;
		private var _notes:Vector.<Note> = new Vector.<Note>();
		
		private var _frequencies:Dictionary = new Dictionary();
		
		public var lastPosition:int;
		public var lastIndex:int;
		public var totalDuration:int = 0;
		

		
		public function Track(timbre:Timbre) 
		{
			_timbre = timbre;
		}
		

		
		public function addNote(note:Note):void {
			_notes.push(note);
			_notes.sort(sortNotes);
			
			var len:int = note.end;
			if(totalDuration<len)totalDuration=len;
		}
		
		private function sortNotes(a:Note, b:Note):int
		{
			return a.start < b.start?-1:(a.start>b.start?1:0);
		}
		
		public function getSamples(numSamples:int, position:int = 0):Vector.<Number> {
			if (position < lastPosition) lastIndex = 0;
			lastPosition = position;
			
			var i:int, l:int;
			var samples:Vector.<Number> = new Vector.<Number>(numSamples);
			l = samples.length;
			for (i = 0; i < l; i++) {
				samples[i] = 0;
			}
			var n:Note;
			l = _notes.length;
			
			var started:Boolean = false;
			for (i = lastIndex; i < l; i++) {
				n = _notes[i];
				if ((n.startPosition < position + numSamples && n.endPosition > position)) {
					if (!started) lastIndex = i;
					pushSamples(position, numSamples, n, samples);
					started = true;
				}else if(started){
					break;
				}
			}

			return samples;
		}
		
		private function pushSamples(position:int, numSamples:int, note:Note, sample:Vector.<Number>):void
		{
			
			var i:int, l:int;
			
			var s:Vector.<Number> = _timbre.getSample(note.frequency);
			l = s.length;
			var d:Number;
			
			var init:int = note.startPosition - position;
			if (init < 0) init = 0;
			var end:int = note.endPosition - position;
			if (end > numSamples) end = numSamples;
			for (i = init; i < end; i++ ) {
				d = (i + position);
				sample[i] += s[d % l];
			}

		}
	}
	
}