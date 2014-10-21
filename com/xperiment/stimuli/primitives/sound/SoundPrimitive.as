package com.xperiment.stimuli.primitives.sound
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;


	public class SoundPrimitive
	{
		private var position:int = 0;
		private var n:Number = 0;
		private var mult:Number;
		
		
		protected const RATE:Number = 44100;
		protected var _sound:Sound;
		protected var _numSamples:int = 8192;
		protected var _volume:Number = 1;
		private var _channel:SoundChannel;
		private var minPitch:Number;
		private var maxPitch:Number;
		private var rangePitch:Number;
		private var frequency:Number;
		private var phase:Number
		private var sample:Number;
		
		public function kill():void{
			_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			_channel.stop();
			_channel=null;
			_sound=null;
		}
		
		public function SoundPrimitive(min:Number,max:Number):void{
			minPitch=min;
			maxPitch=max;
			rangePitch=max-min;
		}
		
		public function play(frequency:Number,volume:Number):void
		{
			if(_channel)	_channel.stop();
			this.frequency=frequency;
			_sound = new Sound();
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			_volume=volume;
			position = 0;
			_channel = _sound.play();
			
		}
		
		protected function onSampleData(event:SampleDataEvent):void
		{
			//from http://www.bit-101.com/blog/?p=2669
			
			for(var i:int = 0; i < _numSamples; i++)
			{
				phase = position / 44100 * Math.PI * 2;
				position ++;
				sample = Math.sin(phase * frequency * Math.pow(2, n / 12)) * _volume;
				event.data.writeFloat(sample); // left
				event.data.writeFloat(sample); // right
			}
			
			
		}

		
		
		public function freq(val:String):String{
			if(val && val!="-100000")play(Number(val)*.01*rangePitch+minPitch,1)
			return val;
		}
		
		
	}
}