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

package br.hellokeita.sound.komposer 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import br.hellokeita.sound.komposer.core.Track;
	
	// from here http://labs.hellokeita.com/category/komposer/
	/**
	 * ...
	 * @author keita keita.kun_at_gmail.com
	 */
	public class Komposer extends Sprite
	{
		
		public static const NUM_SAMPLES:int = 8192;
		public static const RATE:int = 44100;
		public static const RATE_TO_MILISECONDS:Number = 1000 / RATE;
		public static const MILISECONDS_TO_RATE:Number = RATE / 1000;
		
		private var _tracks:Vector.<Track> = new Vector.<Track>();
		
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		
		private var _volume:Number = 1;
		private var _playing:Boolean = false;
		
		public function kill():void{
			_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, sampleData);
			_sound=null;
			_soundChannel=null;
		}
		
		public function Komposer() 
		{
		}
		
		public function addTrack(track:Track):void {
		
			if (_tracks.indexOf(track) < 0) _tracks.push(track);
		}
		
		private function sampleData(e:SampleDataEvent):void 
		{
			var i:int, l:int;
			l = _tracks.length;
			
			var t:Track;
			var samples:Vector.<Number>;
			
			for (i = 0; i < l; i++) {
				t = _tracks[i];
				samples = t.getSamples(NUM_SAMPLES, e.position);
			}
			
			if (samples) {
				l = samples.length;
				for (i = 0; i < l; i++) {
					e.data.writeFloat(samples[i]);
					e.data.writeFloat(samples[i]);
				}
			}
			
			if(_soundChannel && _soundChannel.position>=t.totalDuration){
				_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, sampleData);
				this.dispatchEvent(new Event(Event.COMPLETE));
				
			}
		
		}
		
		public function play():void {
			if(_sound)throw new Error();
			_sound = new Sound();
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleData);
			_soundChannel = _sound.play();
			_soundChannel.soundTransform = new SoundTransform(_volume);
			_playing = true;
		}
		
		public function stop():void {
			

			//if (_soundChannel) _soundChannel.stop();
		}
		
		public function pause():void {
			_playing = false;
		}
		
		public function get volume():Number { return _volume; }
		
		public function set volume(value:Number):void 
		{
			_volume = value;
			if(_soundChannel) _soundChannel.soundTransform = new SoundTransform(_volume);
		}
		
	}
	
}