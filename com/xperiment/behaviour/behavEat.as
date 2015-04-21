package com.xperiment.behaviour{
	
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.Dictionary;


	public class behavEat extends behav_baseClass {

		private var foods:Foods = new Foods;
		private var plate:object_baseClass;
		
		
		override public function setVariables(list:XMLList):void {
			setVar("String","plate","");
			super.setVariables(list);
			
		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			
			if(uniqueProps.hasOwnProperty('penSizeFromPercent')==false){
				uniqueProps.penSizeFromPercent= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) {
						return foods.penSizeFromPercent(to).toString();
					}
					return foods.penSize().toString();
				}; 	
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}

		override public function nextStep(id:String=""):void{
			sortItems();	
			foods.start();
		}
		
		private function sortItems():void
		{
			var plateName:String = getVar("plate");
			
			for each(var stim:object_baseClass in behavObjects){
				if(stim.peg==plateName){
					foods.addPlate(stim);
				}
				else	foods.add(stim);
			}			
		}		
		
		override public function givenObjects(obj:uberSprite):void{	
			var str:String=(obj as object_baseClass).getVar(this.getVar("var"));
			if(str!="")setVar("String","goto",str);
			
			super.givenObjects(obj);
		}
		
		override public function kill():void {
			foods.kill();
		}
	}
}
import com.dgrigg.minimalcomps.graphics.Shape;

import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Timer;
import flash.utils.getTimer;

class Foods{
	
	private var foods:Vector.<Food> = new Vector.<Food>;
	private var plate:Plate;
	private var stage:Stage;
	private var startTime:int;
	
	public function kill():void{
		removePlateStageL();	
		listeners(false);
		for each(var food:Food in foods){
			food.kill();
		}
		plate.kill();
		foods=null;
		plate=null;
	}
	
	private function listeners(DO:Boolean):void
	{
		if(DO)	stage.addEventListener(KeyboardEvent.KEY_DOWN, deleteL);
		else	stage.removeEventListener(KeyboardEvent.KEY_DOWN, deleteL);
	}
	
	protected function deleteL(e:KeyboardEvent):void
	{

		if(e.keyCode == Keyboard.SPACE){
			

			if(plate.hasDrawn()){
				var overlay:Sprite = plate.getDrawing();
				
				var time:int = getTimer() - startTime;
				for each(var food:Food in foods){
					food.removePart(overlay, time);
				}
			}
		}
		
		
	
	}
	
	public function start():void{
		if(!plate) throw new Error("you must define your plate");	
		plate.stim.addEventListener(Event.ADDED_TO_STAGE,plateStageL);		
		
	}
	
	private function removePlateStageL():void{
		if(plate && plate.stim && plate.stim.hasEventListener(Event.ADDED_TO_STAGE)) plate.stim.removeEventListener(Event.ADDED_TO_STAGE,plateStageL);
	}
	protected function plateStageL(e:Event):void
	{
		removePlateStageL();
		startTime = getTimer();
		stage = plate.stim.stage;
		listeners(true);
	}
	
	public function add(stim:object_baseClass):void
	{
		foods[foods.length] = new Food(stim);
	}
	
	public function addPlate(stim:object_baseClass):void
	{
		this.plate = new Plate(stim);
		
	}
	
	public function penSize():String
	{
		// TODO Auto Generated method stub
		if(!plate) return '';
		return plate.penSize();
	}
	
	public function penSizeFromPercent(to:String):String
	{
		// TODO Auto Generated method stub
		return plate.penSizeFromPercent(to);
	}
}

class Plate{
	public var stim:object_baseClass;
	private var interact:InteractivePNG = new InteractivePNG;
	private var bitmap:Bitmap;
	private var bitmapData:BitmapData;
	private var now:Date;
	private var started:Date;
	private var _drawn:Boolean;
	private var _continuous:Boolean = true;
	private var logData:LogData = new LogData();
	public var overlay:Sprite = new Sprite;
	public var overlayCopy:Sprite = new Sprite;
	private var buttonDown:Boolean=false;
	private var origPoint:Point;
	private var lineSize:int = 2;
	private var maxLineSize:int=100;
	private var minLineSize:int=2;
	private var blob:Shape;
	private var colour:int = 0x000000;
	private var blobTimer:Timer = new Timer(1000);
	
	public function hasDrawn():Boolean{
		overlay.graphics.clear();
		if(logData.exists()) return true;
		return false;
	}
	

	
	public function kill():void{
		logData.kill();
		if(blobTimer){
			blobTimer.stop();
			if(blobTimer.hasEventListener(TimerEvent.TIMER)) blobTimer.removeEventListener(TimerEvent.TIMER,blobTimerL);
		}
		if(blob && blob.parent){
			blob.parent.removeChild(blob);
			blob = null;
		}
		if(overlay && overlay.parent)overlay.parent.removeChild(overlay);
		overlay=null;
		overlayCopy=null;
		stim = null;
		
	}	
	
	public function Plate(stim:object_baseClass):void{
		this.stim=stim;
		bitmapErise(stim);
		listeners(true);
		
	}
	
	private function listeners(DO:Boolean):void
	{
		if(DO){
			stim.theStage.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			stim.theStage.addEventListener(MouseEvent.MOUSE_UP, stopDraw);	

		}
		else if(buttonDown==false){
			stim.theStage.removeEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			stim.theStage.removeEventListener(MouseEvent.MOUSE_UP, stopDraw);	
			listeners(true);
		}
	}
	
	
	protected function stopDraw(e:MouseEvent):void
	{
		drawCommand("link",new Point(e.stageX, e.stageY));
		buttonDown=false;
		if(stim.theStage.hasEventListener(MouseEvent.MOUSE_MOVE))	stim.theStage.removeEventListener(MouseEvent.MOUSE_MOVE, paintLine);
		
		
	}
	
	protected function paintLine(e:MouseEvent):void
	{
		blobTimerL(null);
		drawCommand("draw",new Point(e.stageX, e.stageY));
		e.updateAfterEvent();
	}
	
	protected function startDraw(e:MouseEvent):void
	{
		buttonDown=true;
		if(_continuous)	drawCommand("reset",null);
		drawCommand("start",new Point(e.stageX, e.stageY));
		stim.theStage.addEventListener(MouseEvent.MOUSE_MOVE, paintLine);
	}
	

	private function setupCanvas():void{
		stim.stage.addChild(overlay);
		overlay.graphics.clear();
		overlay.graphics.beginFill(colour,.3);
		overlay.graphics.lineStyle(lineSize, colour);
		
		stim.stage.addChild(overlayCopy);
		overlayCopy.alpha=0;
		overlayCopy.graphics.clear();
		overlayCopy.graphics.beginFill(0xffffff,1);
		overlayCopy.graphics.lineStyle(lineSize, 0xffffff);
		
	}
	
	public function drawCommand(what:String, p:Point):void{
		if(what=="draw"){
			now = new Date;
			overlay.graphics.lineTo(p.x, p.y);
			overlayCopy.graphics.lineTo(p.x, p.y);
			logData.log(p,started.valueOf()-now.valueOf());
		}
		else if(what=="start"){
			now = started = new Date;
			origPoint = p;
			_drawn=true;
			overlay.graphics.moveTo(p.x, p.y);
			overlayCopy.graphics.moveTo(p.x, p.y);
			logData.log(p,started.valueOf()-now.valueOf());
		}
		else if(what=="reset"){
			
			_drawn=false;
			logData.wipe();
			setupCanvas();
		}
		else if(what=="link"){
			now = started = new Date;
			overlay.graphics.lineTo(origPoint.x, origPoint.y);
			overlayCopy.graphics.lineTo(origPoint.x, origPoint.y);
			logData.log(origPoint,started.valueOf()-now.valueOf());
			
		}
		
		else throw new Error();
	}
	
	public function getDrawing():Sprite{
		return overlayCopy;
	}
	
	
	private function bitmapErise(s:object_baseClass):void{
	
		
		var bounds : Rectangle = s.getBounds(s);
		var m : Matrix = new Matrix();
		m.translate(-bounds.x, -bounds.y);
		bitmapData = new BitmapData(bounds.width,bounds.height, true, 0x00000000);
		bitmapData.draw(s, m);
		
		bitmap = new Bitmap(bitmapData);
		
		interact.addChild(bitmap);
		interact.enableInteractivePNG();
		interact.buttonMode = true;
		stim.addChild(interact);
		
	}
	
	
	public function penSize():String
	{
		return lineSize.toString();
	}
	
	public function penSizeFromPercent(to:String):String
	{
		var i:int = int(to.split("'").join("")); 
		
		lineSize = (maxLineSize-minLineSize)*i * .01;
		
		
		showSize();
		
		return  penSize();
	}
	
	private function showSize():void
	{

		if(!blob){
			blob = new Shape;
			blobTimer.addEventListener(TimerEvent.TIMER,blobTimerL);
			
		}
		blob.graphics.clear();
		blob.graphics.beginFill(0x0000FF,.7);
		blob.graphics.drawCircle(0,0, lineSize);
		if(overlay)overlay.addChild(blob);
		blob.x = stim.stage.mouseX - .5 * blob.width;
		blob.y = stim.stage.mouseY - .5 * blob.height;
 
		blobTimer.reset();
		blobTimer.start();
		
	}
	
	protected function blobTimerL(e:TimerEvent):void
	{
		if(blob && blob.parent) blob.parent.removeChild(blob);
		
	}
	

}



import com.xperiment.stimuli.object_baseClass;
import com.xperiment.stimuli.helpers.InteractivePNG;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import com.xperiment.stimuli.addJPG;
import flash.display.BlendMode;
import flash.display.DisplayObject;



class Food{
	private var stim:object_baseClass;
	private var bitmap:Bitmap;
	private var layer:Sprite;
	private var bitmapData:BitmapData;
	private var origProps:Object = {mouseEnabled:true, useHandCursor:true, buttonMode:true};
	private var blankPoint:Point = new Point(0,0);
	private var mouseIsOver:Boolean = false;
	private var currentRefresh:int;
	private var morsels:LogMorsels = new LogMorsels;
	private var origNumPixels:int;
	
	public function kill():void{
		if(stim){
			for(var key:String in origProps){
				stim[key] = origProps[key];
			}
			stim = null;
		}
	}
	
	public function Food(stim:object_baseClass):void{
		this.stim = stim;	
		bitmapErise(stim);
		hideChildren(false);
		stim.mouseEnabled=false;
		
	}
	
	private function bitmapErise(s:object_baseClass):void{
		
		
		bitmapData = bitmapdataErise(s);
		origNumPixels = countPixels();	
		bitmap = new Bitmap(bitmapData);
		layer = new Sprite;
		layer.addChild(bitmap);
		bitmap.cacheAsBitmap = true;
		layer.cacheAsBitmap = true;
		stim.addChild(layer);

		
	}
	
	private function bitmapdataErise(s:DisplayObject):BitmapData{
		var bounds : Rectangle = s.getBounds(s);
		var m : Matrix = new Matrix();
		m.translate(-bounds.x, -bounds.y);
		var bData:BitmapData = new BitmapData(bounds.width,bounds.height, true, 0x00000000);
		bData.draw(s, m);
		return bData;
	}
	

	private function hideChildren(DO:Boolean):void
	{
		/*for(var i:int=0;i<stim.numChildren;i++){
			(stim.getChildAt(i) as DisplayObject).visible = DO;
		}*/
		(stim as addJPG).content.visible=DO;
	}
	
	
	public function removePart(overlay:Sprite, time:int):void
	{
		
		
		if(overlay.hitTestObject(bitmap) == false)	return;
		
		var bm:Bitmap =  new Bitmap(	bitmapdataErise(overlay)	);
		
		var overlayBounds:Rectangle = overlay.getBounds(overlay);

		
		var m:Matrix = new Matrix();
		m.translate(overlayBounds.x-stim.x, overlayBounds.y-stim.y);
		
		bitmapData.draw(bm, m, null,BlendMode.ERASE);
		
		trace((origNumPixels-countPixels())/origNumPixels*100);	
		//overlay.alpha=0;
		//bitmap = new Bitmap(bitmapData);
		//stim.cacheAsBitmap=true;
		///stim.addChild(bitmap);

	}
	
	private function countPixels():int{
		var pixels:int=0;
		
		for(var c:int = 0; c < bitmapData.width; c++)
		{
			for(var r:int = 0; r < bitmapData.height; r++)
			{
				
				if(bitmapData.getPixel(c, r) != 0)
				{
					pixels++;
				}
			}
		}
		
		return pixels;
	}
	

}

class LogMorsels{
	
	
	
}

import com.hurlant.util.Base64;
import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.ByteArray;

class LogData{
	
	private var data:Vector.<Data>;
	
	public function LogData():void{
		wipe();
	}
	
	public function exists():Boolean{		
		if(data.length>0) return true;
		return false;
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