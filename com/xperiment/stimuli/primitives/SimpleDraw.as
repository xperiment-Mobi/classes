package com.xperiment.stimuli.primitives
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class SimpleDraw extends Sprite
	{
		
		private var _backgroundColour:int = 0x000000;
		private var _penColour:int = 0xffffff;
		private var _thickness:int = 2;
		private var _continuous:Boolean = false;
		private var myWidth:int;
		private var myHeight:int;
		private var _drawn:Boolean = false;
		private var _doDraw:String;
		private var started:Date;
		private var now:Date;
		private var logData:LogData;
		private var runDrawing:RunDrawing;
		
		
		public function kill():void{
			if(runDrawing) runDrawing.kill();
			logData.kill();
			listeners(false);
		}
		
		public function set backgroundColour(c:int):void{
			_backgroundColour = c;
		}
		
		public function set doDraw(str:String):void{
			_doDraw=str;
		}
		
		private function get doDraw():String{
			return _doDraw;
		}
		
		public function set penColour(c:int):void{
			_penColour = c;
		}
		
		public function set thickness(c:int):void{
			_thickness = c;
		}
		
		public function set continuous(value:Boolean):void
		{
			_continuous = value;
		}
		
		public function SimpleDraw(width:int,height:int)
		{
			myWidth=width;
			myHeight=height;
			logData = new LogData;
			super();
		}
		
		
		public function setup():void{
			setupCanvas();
			
			if(_doDraw==""){
				this.buttonMode = true;
				listeners(true);
			}
			else{
				runDrawing = new RunDrawing(this,_doDraw);
			}
		}
		
		private function setupCanvas():void{
			
			this.graphics.clear();
			this.graphics.beginFill(_backgroundColour);
			this.graphics.drawRect(0, 0, myWidth, myHeight);
			this.graphics.endFill();
			this.graphics.lineStyle(_thickness, _penColour);
		}
		
		private function listeners(ON:Boolean):void{
			if(ON){
				if(this.stage){
					this.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
					stage.addEventListener(MouseEvent.MOUSE_UP, stopDraw);		
				}
				else{				
					this.addEventListener(Event.ADDED_TO_STAGE,addedStage);
				}
			}
			else{
				if(this.hasEventListener(Event.ADDED_TO_STAGE)) this.removeEventListener(Event.ADDED_TO_STAGE,addedStage);
				this.removeEventListener(MouseEvent.MOUSE_DOWN, startDraw);
				if(stage)	stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraw);	
				
			}
		}
		
		protected function addedStage(e:Event):void
		{
			listeners(true);
		}
		
		protected function stopDraw(event:MouseEvent):void
		{
			if(this.hasEventListener(MouseEvent.MOUSE_MOVE))	this.removeEventListener(MouseEvent.MOUSE_MOVE, paintLine);

						
		}
		
		protected function paintLine(event:MouseEvent):void
		{
			drawCommand("draw",new Point(event.localX, event.localY));
			event.updateAfterEvent();
		}
		
		protected function startDraw(event:MouseEvent):void
		{
			if(_continuous)	drawCommand("reset",null);
			drawCommand("start",new Point(event.localX, event.localY));
			this.addEventListener(MouseEvent.MOUSE_MOVE, paintLine);
		}
		
		private var drawTime:int;
		
		public function drawCommand(what:String, p:Point):void{
			if(what=="draw"){
				now = new Date;
				this.graphics.lineTo(p.x, p.y);
				logData.log(p,started.valueOf()-now.valueOf());
			}
			else if(what=="start"){
				now = started = new Date;
				_drawn=true;
				this.graphics.moveTo(p.x, p.y);
				logData.log(p,started.valueOf()-now.valueOf());
			}
			else if(what=="reset"){
				_drawn=false;
				logData.wipe();
				setupCanvas();
				
			}
			else throw new Error();
		}
		
		
		public function reset():void
		{
			drawCommand("reset", null);
		}
		
		public function drawn():Boolean
		{
			return _drawn;
		}
		
		public function results():String{
			return logData.compile();
		}


	}
}
import com.hurlant.util.Base64;
import com.xperiment.stimuli.primitives.SimpleDraw;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.utils.ByteArray;

class LogData{
	
	private var data:Vector.<Data>;
	
	public function LogData():void{
		wipe();
	}
	
	public function compile():String{
		
		var arr:Array = [];
		
		for(var i:int=0;i<data.length;i++){
			arr[arr.length] = (data[i] as Data).str();
		}
		
		var str:String = arr.join("\n");
		var ba:ByteArray = new ByteArray();
		ba.writeUTFBytes(str);
		
		return Base64.encodeByteArray(ba);
	}
	
	public function log(p:Point, time:int):void
	{
		if(data)	data[data.length] = new Data(time, p.x, p.y);
	}
	
	public function recompile(str:String):void{
		var arr:Array = str.split(",");

		data[data.length] = new Data(arr[0],arr[1],arr[2]);
	}
	
	public function wipe():void
	{
		data = new Vector.<Data>;		
	}
	
	public function getCommand():Data{
		if(data.length>0) return data.shift();
		else return null;
	}
	
	public function kill():void
	{
		data = null;
		
	}
}

class Data{
	public var time:int;
	public var x:int;
	public var y:int;
	
	public function Data(time:int, x:int, y:int):void{
		this.time 	= time;
		this.x		= x;
		this.y		= y;
	}
	
	public function str():String{
		return [time, x, y].join(",");
	}
	
}

class RunDrawing{
	private var logData:LogData;
	private var spr:SimpleDraw;
	private var frame:int = 0;
	
	public function kill():void{
		logData.kill();
		spr.removeEventListener(Event.ENTER_FRAME, frameDraw);
	}
	
	protected function frameDraw(event:Event):void
	{
		var command:Data = logData.getCommand();
		if(command==null) kill();
		else{
			if(frame==0)	spr.drawCommand("start",new Point(command.x, command.y));
			else{
				if(command.y!=0)	spr.drawCommand("draw",new Point(command.x, command.y));
			}
			frame++;
		}
		
	}
	
	public function RunDrawing(spr:SimpleDraw, info:String):void{
		this.spr=spr;
		setup(info);
		spr.addEventListener(Event.ENTER_FRAME, frameDraw);
	}
	

	
	private function setup(info:String):void
	{
		logData = new LogData();	
		
		var ba:ByteArray =  Base64.decodeToByteArray(info);
		
		var str:String = ba.readUTFBytes(ba.length);

		var arr:Array = str.split("\n");
		for(var i:int=0;i<arr.length;i++){
			logData.recompile(arr[i]);
		}
		
	}	
	
}