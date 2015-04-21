package com.xperiment.behaviour{

	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	
	public class behavRotate extends behav_baseClass {
		
		//public static const RAD_TO_DEG:Number = 57.295779513082325225835265587527; // 180.0 / PI;
		private var angle:String;
		private var point:Point;
		private var distance:Number;
		private var gradientMatrix:Matrix;
		private var rotateWithMouseDown:RotateWithMouseDown
		private var duration:Number;
		private var bounds:Dictionary;
		private var shiftPos:Object; 
		
		override public function kill():void{
			removeListeners();
			if(rotateWithMouseDown)rotateWithMouseDown.kill();
			
			bounds = null;
						
			super.kill();
		}
		
		private function removeListeners():void{
			for each(var us:uberSprite in behavObjects){
				if(us.hasEventListener(Event.ADDED_TO_STAGE))us.removeEventListener(Event.ADDED_TO_STAGE,stageL);
			}
		}
		
		override public function stopBehaviour(callee:uberSprite):void{
			super.stopBehaviour(callee);
			removeListeners();
			if(rotateWithMouseDown)rotateWithMouseDown.kill();
		}
		
		override public function returnsDataQuery():Boolean{
			if(getVar("hideResults")!='true'){
				return true;
			}
			return false;
		}
		
		override public function storedData():Array {
			objectData.push({event:peg,data:angle});
			return objectData;
		}
		
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			
			if(uniqueProps.hasOwnProperty('rotateFromPercent')==false){
				uniqueProps.rotateFromPercent= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) {
						angle=String(3.6*Number(to));
						rotateAll();
					}
					return angle;
				}; 	
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		override public function setVariables(list:XMLList):void {
			
			setVar("int","rotation",180);
			setVar("string","rotateAtStart","","360,2000","the degrees to rotate then a comma, then the time taken for this rotation in ms");
			setVar("number","duration",0);
			//setVar("number","yz","","","rotated value along y-axis but in z plane, in degrees.")
			setVar("boolean","rotateWithMouseDown",false);	
			setVar("boolean","rotateWithMouseDownPreRotate",false,"will move your stimulus to orientate with the mouse before even the mouse moves");
			setVar("boolean","randomStartRotation",false);
			//setVar("string","shiftPos","","","will move stimulus vertically X% first 180 degrees from vertical Y%, then -X% second 180 degrees. Eg 50%,50%");
			super.setVariables(list);
			
			duration 	= 	getVar("duration");
			angle		=	getVar("rotation");
			
			//sortShift(getVar("shiftPos"));
			
			if(getVar("rotateWithMouseDown")){
				rotateWithMouseDown = new RotateWithMouseDown(theStage,applyAngle,getVar("rotateWithMouseDownPreRotate"),getVar("randomStartRotation"));
			}
		}	
		
		
	/*	private function sortShift(shiftStr:String):void
		{
		
			var arr:Array = shiftStr.split(",");
			if(arr.length==2){
				arr[0] = arr[0].split("%").join("");
				arr[1] = arr[1].split("%").join("");
				shiftPos = {x:Number(arr[0]), y: Number(arr[1])};
			}
		}
		*/
		override public function nextStep(id:String=""):void{

			makeBounds();

			for each(var us:uberSprite in behavObjects){
				bounds[us.peg]=us.getChildAt(0).getBounds(us.parent);			
				if(us.stage)	action();
				else			us.addEventListener(Event.ADDED_TO_STAGE,stageL);
			}
		}
		

		private function makeBounds():void
		{
			if(!bounds){
				bounds = new Dictionary;
				var bound:Rectangle;
				for each(var us:uberSprite in behavObjects){
					bounds[us.peg]=us.getChildAt(0).getBounds(us.parent);		
				}
			}
		}
		
		private function action():void{
			
			if(rotateWithMouseDown){
				rotateWithMouseDown.start(behavObjects, getVar("rotateAtStart"));
			}
			rotateAll();
		}
		
		private function rotateAll():void{
			for(var i:int=0;i<behavObjects.length;i++){
				applyAngle(behavObjects[i],angle);
			}	
		}
		
		protected function stageL(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE,arguments.callee);
			action();
		}	
			

		private function applyAngle(us:uberSprite, angle:String):void{	
			
			if(us.parent){
				rotateAroundCenter(us,int(angle));
		
				/*TweenMax.to(us,duration,{transformAroundPoint:{point:centrePoints[us.peg].point,rotation:angle}});	
				if(centrePoints[us.peg].started==false){
					centrePoints[us.peg].started=true;
					centrePoints[us.peg].centerX=us.x+us.width*.5;
					centrePoints[us.peg].centerY=us.y+us.height*.5;
				}
				else{
					us.x=centrePoints[us.peg].centerX-us.width*.5;
				}*/
				
				//us.graphics.beginFill(0xff4400);
				//us.graphics.drawRect(0,0,us.width,us.height);

			}
			(us as object_baseClass).OnScreenElements.rotate=angle;
		}
		
		

		
		public function rotateAroundCenter(us:uberSprite, rotation:Number):void
		{

			angle=rotation.toString();
			// get the bounded rectangle of objects
			var bound:Rectangle = bounds[us.peg];

		
			
			// assign the rotation
			
			
			
			us.rotation = rotation;
			
			
			// assign the previous mid point as (x,y)
			//us.x = midx1;
			//us.y = midy1; 
			
			// get the new bounded rectangle of objects 
			bound = us.getRect(this); 
			
			// calculate new mid points 			
			var midx2:Number = bound.x + bound.width * .5;
			var midy2:Number = bound.y + bound.height * .5; 
			
			


			// calculate difference between the current mid and (x,y) and subtract
			//it to position the object in the previous bound.
			var diff:Number 
			
			diff = midx2 - us.myX - us.myWidth*.5;
			us.x -= diff;
			diff = midy2 - us.myY - us.myHeight*.5;
			us.y -= diff;
		
			
		}
	}
}


import com.xperiment.codeRecycleFunctions;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.Dictionary;
import flash.utils.getTimer;

internal class RotateWithMouseDown {
	private var theStage:Stage;
	private var rotate:Boolean=false;
	private var doRotateF:Function;
	private var point:Point;
	private var origAngles:Dictionary = new Dictionary;
	private var origCursorAngle:Number;
	private var behavObjects:Array;
	private var ping:Boolean;
	private var randStart:Boolean;
	private var newAngle:Number;
	
	public function RotateWithMouseDown(theStage:Stage,doRotateF:Function,ping:Boolean,randStart:Boolean) {
		this.theStage=theStage;
		this.doRotateF=doRotateF;
		this.ping=ping;
		this.randStart = randStart;

	}
	
	
	public function start(behavObjects:Array, rotateAtStart:String):void{
		
		this.behavObjects=behavObjects;
		calcPoint();
		if(randStart == true){
			var randOrient:Number;
			for(var i:int=0;i<behavObjects.length;i++){
				randOrient=360*Math.random();
				doRotateF(behavObjects[i],randOrient);
			}
		}
		calcOrigAngles();
		
		if(rotate==false){
			rotate=true;
			if(rotateAtStart=="")	startMouse();
			else setupRotateStart(rotateAtStart);
		}
	}
	
	private function setupRotateStart(rotateAtStart:String):void
	{
		var arr:Array = rotateAtStart.split(",");
		var or:int=1;
		
		var angle:Number = arr[0];
		if(Math.random()>0.5){
			or=-1;
		}
		var time:int = arr[1];
		
		var curAngle:int;
		var startTime:int = getTimer();
		var ms:int;
		
		
		theStage.addEventListener(Event.ENTER_FRAME,function(e:Event):void{
			ms=getTimer()-startTime;
			if(ms>time){
				theStage.removeEventListener(Event.ENTER_FRAME, arguments.callee);
				for(var i:int=0;i<behavObjects.length;i++){
					doRotateF(behavObjects[i],origAngles[behavObjects[i]]);
				}
				startMouse();
				return;
			}
			
			curAngle=360*ms/time;
			
			
			var newAng:Number = origAngles[behavObjects[i]]+curAngle*or;
			
			for(i=0;i<behavObjects.length;i++){
				doRotateF(behavObjects[i],newAng);
			}
			
		});
		
		
		
	}
	
	private function startMouse():void
	{
		theStage.addEventListener(MouseEvent.MOUSE_MOVE,mouseL);	
		if(ping)mouseL(null);
	}	
	
	
	private function calcOrigAngles():void
	{
		for(var i:int=0;i<behavObjects.length;i++){
			origAngles[behavObjects[i]]=behavObjects[i].rotation;
		}
	}
	
	private function calcPoint():void
	{
		var Xs:Array=[];
		var Ys:Array=[];
		
		var temp_point:Point;
		
		for(var i:int=0;i<behavObjects.length;i++){
			
			temp_point = new Point(behavObjects[i].myX+behavObjects[i].myWidth*.5,behavObjects[i].myY+behavObjects[i].myHeight*.5);
			temp_point = (behavObjects[i] as Sprite).parent.localToGlobal(temp_point);
			
			Xs.push(temp_point.x);
			Ys.push(temp_point.y);
		}
		
		
		point = new Point(codeRecycleFunctions.calcArrayAv(Xs),codeRecycleFunctions.calcArrayAv(Ys));
	}
	
	protected function mouseL(e:MouseEvent):void
	{
		var dx:Number = theStage.mouseX  - point.x;
		var dy:Number = theStage.mouseY - point.y;
		
		newAngle = Math.atan2(dy,dx)* 180 / Math.PI;
		
		if(!origCursorAngle)	origCursorAngle = newAngle;
			
		for(var i:int=0;i<behavObjects.length;i++){
			doRotateF(behavObjects[i],newAngle-origCursorAngle+origAngles[behavObjects[i]]);
		}
	}
	
	public function stop():void{
		if(rotate){
			rotate=false;			
			theStage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseL);
		}
	}
	
	public function kill():void{
		if(rotate)stop();
		behavObjects=null;
		for (var eachKey:String in origAngles) delete origAngles[eachKey];
		origAngles=null;
		doRotateF=null;
	}
	
}
