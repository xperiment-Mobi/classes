package com.xperiment.stimuli.primitives {
	import flash.events.TimerEvent;
	import flash.utils.Timer;


	
	class toneMod  {
		
		static public var MORPH:String = "morph", PULSE:String = "pulse", FREQ:String = "freq";
		
		private const waveWidth:int = 0x0100;
		private const waveHeight:int = 128;
		
		private var morph:Number;
		private var buffer:Array;
		
		private var phase:Number;
		private var freq:Number;
		private var pulse:Number;
		private var h2:int; 
		private var cycle:CycleBuffer;

		private var osc:PulseQuad;
		var t:Timer = new Timer(1,0);
		
		public function kill():void{
			t.stop();
			t.removeEventListener(TimerEvent.TIMER,timerL);
		}

		public function toneCycleBuffer(){
			
			osc = new PulseQuad();
			
			h2 = (waveHeight >> 1);
			
			
			
			cycle = new CycleBuffer(3, 1, 16, 22050);
			cycle.onInit = onCycleBufferInit;
			cycle.onComplete = onCycleBufferComplete;
			phase = 0;
			osc.freq = (freq = 440);
			osc.morph = (morph = 1);
			osc.pulse = (pulse = 0.5);

		}
		private function onCycleBufferInit(_arg1:CycleBuffer):void{
			var _local2:int;
			buffer = new Array();
			_local2 = 0;
			while (_local2 < _arg1.sampleCount) {
				buffer.push(new Sample());
				_local2++;
			};
			computeBuffer();
			_arg1.start();
			
		}
		
		public function change(what:String, val:int):void{
			//val min=0, max=1
			switch (what){
				case MORPH:
					morph = val;
					break;
				case PULSE:
					pulse = val;
					break;
				case FREQ:
					freq = (110 + (val * 880));
					break;
			};
		}
		private function computeBuffer():void{
			var _local1:int;
			var _local2:Number;
			var _local3:Number;
			var _local4:Number;
			var _local5:int;
			_local1 = buffer.length;
			_local2 = ((morph - osc.morph) / _local1);
			_local3 = ((pulse - osc.pulse) / _local1);
			_local4 = ((freq - osc.freq) / _local1);
			_local5 = 0;
			while (_local5 < _local1) {
				phase = (phase + (osc.freq / 22050));
				osc.morph = (osc.morph + _local2);
				osc.pulse = (osc.pulse + _local3);
				osc.freq = (osc.freq + _local4);
				Sample(buffer[_local5]).l = (osc.getAmp((phase - int(phase))) / 2);
				_local5++;
			};

			cycle.fill(buffer);
		}
		
		private function timerL(e:TimerEvent):void{
			t.stop();
			computeBuffer();
		}
		
		private function onCycleBufferComplete(_arg1:CycleBuffer):void{
			t.reset();
			t.start();
		}
		
	}
}
import flash.display.Loader;
import flash.events.Event;
import flash.media.Sound;
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.media.SoundChannel;



class CycleBuffer extends ByteArray {

	
	public static const UNIT_SAMPLES_NUM:uint = 0x0800;

	
	private var bits:uint;
	private var multiple:uint;
	public var onComplete:Function;
	private var buffer:Sound;
	private var $byteCount:uint;
	public var onInit:Function;
	private var bufferChannel:SoundChannel;
	private var sync:Sound;
	private var channels:uint;
	private var rate:uint;
	private var $sampleCount:uint;
	private var syncChannel:SoundChannel;
	private var busy:Boolean;

	
	public function CycleBuffer(_arg1:uint, _arg2:uint, _arg3:uint, _arg4:uint){
		this.multiple = _arg1;
		this.channels = _arg2;
		this.bits = _arg3;
		this.rate = _arg4;

		init();
	}
	

	
	public function stop():void{
		if (syncChannel != null){
			syncChannel.stop();
			syncChannel = null;
		};
		if (bufferChannel != null){
			bufferChannel.stop();
			bufferChannel = null;
		};
		buffer = null;
		busy = false;
	}
	private function init():void{
		var _local1:ByteArray;
		var _local2:int;
		endian = Endian.LITTLE_ENDIAN;
		switch (rate){
			case 44100:
				$sampleCount = (UNIT_SAMPLES_NUM * multiple);
				break;
			case 22050:
				$sampleCount = ((UNIT_SAMPLES_NUM * multiple) >> 1);
				break;
			case 11025:
				$sampleCount = ((UNIT_SAMPLES_NUM * multiple) >> 2);
				break;
			case 5512:
				$sampleCount = ((UNIT_SAMPLES_NUM * multiple) >> 3);
				break;
			default:
				throw (new Error("SamplingRate is not supported."));
		};
		$byteCount = $sampleCount;
		if (channels == 2){
			$byteCount = ($byteCount << 1);
		};
		if (bits == 16){
			$byteCount = ($byteCount << 1);
		};
		_local1 = new ByteArray();
		switch (bits){
			case 16:
				_local1.length = ((sampleCount - 1) << 1);
				break;
			case 8:
				_local1.length = (sampleCount - 1);
				_local2 = 0;
				while (_local2 < _local1.length) {
					_local1[_local2] = 128;
					_local2++;
				};
				break;
			default:
				throw (new Error("SamplingBits is not supported."));
		};
		
		SoundFactory.generate(_local1, 1, bits, rate, onGenerateSyncSound);
	}
	private function onGenerateSyncSound(_arg1:Sound):void{
		sync = _arg1;
		onInit(this);
	}
	public function isBusy():Boolean{
		return (busy);
	}
	public function start():void{
		busy = false;
		if (sync != null){
			syncChannel = sync.play(0, 1);
			syncChannel.addEventListener(Event.SOUND_COMPLETE, onSyncComplete);
			if (bufferChannel != null){
				bufferChannel.stop();
			};
			if (buffer != null){
				bufferChannel = buffer.play(0, 1);
			};
			busy = true;
		};
	}
	private function onSyncComplete(_arg1:Event):void{
		if (syncChannel != null){
			syncChannel.stop();
		};
		syncChannel = sync.play(0, 1);
		syncChannel.addEventListener(Event.SOUND_COMPLETE, onSyncComplete);
		if (bufferChannel != null){
			bufferChannel.stop();
		};
		if (buffer == null){
			return;
		};
		bufferChannel = buffer.play(0, 1);
		buffer = null;
		onComplete(this);
	}
	public function fill(_arg1:Array):void{
		var _local2:int; 
		var _local3:Sample;
		switch (channels){
			case 1:
				_local2 = 0;
				while (_local2 < $sampleCount) {
					_local3 = _arg1[_local2];
					if (_local3.l < -1){
						writeShort(-32767);
					} else {
						if (_local3.l > 1){
							writeShort(32767);
						} else {
							writeShort((_local3.l * 32767));
						};
					};
					_local3.l = 0;
					_local3.r = 0;
					_local2++;
				};
				break;
			case 2:
				_local2 = 0;
				while (_local2 < $sampleCount) {
					_local3 = _arg1[_local2];
					if (_local3.l < -1){
						writeShort(-32767);
					} else {
						if (_local3.l > 1){
							writeShort(32767);
						} else {
							writeShort((_local3.l * 32767));
						};
					};
					if (_local3.r < -1){
						writeShort(-32767);
					} else {
						if (_local3.r > 1){
							writeShort(32767);
						} else {
							writeShort((_local3.r * 32767));
						};
					};
					_local3.l = 0;
					_local3.r = 0;
					_local2++;
				};
				break;
		};
		SoundFactory.generate(this, channels, bits, rate, onNewBufferCreated);
		length = 0;
	}
	public function get sampleCount():uint{
		return ($sampleCount);
	}
	private function onNewBufferCreated(_arg1:Sound):void{
		if (this.buffer == null){
			this.buffer = _arg1;
		} else {
			new Error("PROBLEM");
		};
	}
	public function get positionMillis():Number{
		if (bufferChannel == null){
			return (0);
		};
		return (bufferChannel.position);
	}
	public function get byteCount():uint{
		return ($byteCount);
	}
	public function get lengthMillis():Number{
		return (((0x0800 * multiple) / 44.1));
	}
	
}


class SoundFactory {
	

	
	public static function generate(_arg1:ByteArray, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:Function):void{
		var swf:* = null;
		var byte2:* = 0;
		var numSamples:* = 0;
		var onSWFLoaded:* = null;
		var loader:* = null;
		var bytes:* = _arg1;
		var channels:* = _arg2;
		var bits:* = _arg3;
		var rate:* = _arg4;
		var onComplete:* = _arg5;
		swf = ByteArray("");
		
		swf.endian = Endian.LITTLE_ENDIAN;
		swf.position = swf.length;
		swf.writeShort(959);
		swf.writeUnsignedInt((bytes.length + 7));
		byte2 = 0;
		switch (rate){
			case 44100:
				byte2 = 12;
				break;
			case 22050:
				byte2 = 8;
				break;
			case 11025:
				byte2 = 4;
				break;
		};
		numSamples = bytes.length;
		if (channels == 2){
			byte2 = (byte2 | 1);
			numSamples = (numSamples >> 1);
		};
		if (bits == 16){
			byte2 = (byte2 | 2);
			numSamples = (numSamples >> 1);
		};
		swf.writeShort(1);
		swf.writeByte(byte2);
		swf.writeUnsignedInt(numSamples);
		swf.writeBytes(bytes);
		swf.writeShort((1 << 6));
		swf.position = 4;
		swf.writeUnsignedInt(swf.length);
		onSWFLoaded = function (_arg1:Event):void{
			onComplete(Sound(new ((loader.contentLoaderInfo.applicationDomain.getDefinition("SoundItem") as Class))()));
		};
		
		loader = new Loader();
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSWFLoaded);
		loader.loadBytes(swf);
	}
	public static function generateFromArray(_arg1:Array, _arg2:uint, _arg3:uint, _arg4:uint, _arg5:Function):void{
		var _local6:int;
		var _local7:int;
		var _local8:Sample;
		var _local9:ByteArray;
		_local7 = _arg1.length;
		_local9 = new ByteArray();
		_local9.endian = Endian.LITTLE_ENDIAN;
		switch (_arg2){
			case 1:
				_local6 = 0;
				while (_local6 < _local7) {
					_local8 = _arg1[_local6];
					if (_local8.l < -1){
						_local9.writeShort(-32767);
					} else {
						if (_local8.l > 1){
							_local9.writeShort(32767);
						} else {
							_local9.writeShort((_local8.l * 32767));
						};
					};
					_local6++;
				};
				break;
			case 2:
				_local6 = 0;
				while (_local6 < _local7) {
					_local8 = _arg1[_local6];
					if (_local8.l < -1){
						_local9.writeShort(-32767);
					} else {
						if (_local8.l > 1){
							_local9.writeShort(32767);
						} else {
							_local9.writeShort((_local8.l * 32767));
						};
					};
					if (_local8.r < -1){
						_local9.writeShort(-32767);
					} else {
						if (_local8.r > 1){
							_local9.writeShort(32767);
						} else {
							_local9.writeShort((_local8.r * 32767));
						};
					};
					_local6++;
				};
				break;
		};
		generate(_local9, _arg2, _arg3, _arg4, _arg5);
	}
	
}



class Sample {
	
	public var r:Number;
	public var l:Number;
	
	public function Sample(){
		l = (r = 0);
	}
}




class PulseQuad {
	
	public var morph:Number;
	public var pulse:Number;
	public var freq:Number;
	
	public function PulseQuad(){
		morph = 0;
		pulse = 0.5;
	}
	public function getAmp(_arg1:Number):Number{
		var _local2:Number;
		var _local3:Number;
		if (pulse < 0.5){
			_local2 = ((morph * pulse) / 2);
		} else {
			_local2 = ((morph * (1 - pulse)) / 2);
		};
		if (_arg1 < pulse){
			if (_arg1 < _local2){
				_local3 = ((_arg1 / _local2) - 1);
				return ((1 - (_local3 * _local3)));
			};
			if (_arg1 < (pulse - _local2)){
				return (1);
			};
			_local3 = (((_arg1 - pulse) + _local2) / _local2);
			return ((1 - (_local3 * _local3)));
		};
		if (_arg1 < (pulse + _local2)){
			_local3 = (((_arg1 - pulse) / _local2) - 1);
			return (((_local3 * _local3) - 1));
		};
		if (_arg1 <= (1 - _local2)){
			return (-1);
		};
		_local3 = (((_arg1 - 1) + _local2) / _local2);
		return (((_local3 * _local3) - 1));
	}
	
}
