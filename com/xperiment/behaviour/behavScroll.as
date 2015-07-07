package com.xperiment.behaviour
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.Imockable;
	import com.xperiment.stimuli.primitives.IResult;
	import com.xperiment.trial.Trial;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class behavScroll extends behav_baseClass implements Imockable, IResult
	{
		private var keys:Boolean = false;
		private var mouse:Boolean = false;
		private var scroll:Boolean = false;
		private var position:Number = -1000;
		private var orientation:String;
		private var timeLastChange:int = 0;
		private var accel:int;
		private var mouseDown:Boolean = false;
		
		
		public function behavScroll()
		{
			uniqueEvents = new Dictionary;
			uniqueEvents["moved"]=true;
		}
		
		override public function kill():void{
			listeners(false);
			super.kill();
		}
		
		public function mock():void{
			position = startingVal();
		}
		
		private function listeners(on:Boolean):void
		{
			var funct:String = 	"addEventListener";
			if(on==false)funct=	"removeEventListener";
	
			if(keys)	theStage[funct](KeyboardEvent.KEY_DOWN,keyL);
			if(scroll)	theStage[funct](MouseEvent.MOUSE_WHEEL,scrollL);
			if(mouse){
				theStage[funct](MouseEvent.MOUSE_DOWN,mouseL);
				theStage[funct](MouseEvent.MOUSE_UP,mouseL);
				theStage[funct](MouseEvent.MOUSE_MOVE,mouseL);
			}
		}
		
		private function mouseL(e:MouseEvent):void{
			if(e.type==MouseEvent.MOUSE_MOVE && mouseDown){
				if(orientation=="y")setPercent(e.stageY/Trial.RETURN_STAGE_HEIGHT*100);
				else setPercent(e.stageX/Trial.RETURN_STAGE_WIDTH*100);
			}
			
			else if(e.type == MouseEvent.MOUSE_DOWN)	mouseDown=true;
			else if(e.type == MouseEvent.MOUSE_UP) 		mouseDown=false;
		}
		

		private function keyL(e:KeyboardEvent):void{

			var change:int=0;
			if(orientation=="y"){
				if(e.keyCode==40)change=-1; //up
				else if(e.keyCode==38) change =1; //down
			}
			else if(orientation=="x"){
				if(e.keyCode==39)change=1; //right
				else if(e.keyCode==37) change =-1; //left
			}
			if(change!=0){
				makeChange(change);
			}
		}
		
		private function makeChange(change:int):void
		{
			if(position<0)position = startingVal();
			var curTime:int = getTimer();
			if(curTime<timeLastChange+100)	accel++;
			else accel = 1;
				
			timeLastChange = curTime;
			setPercent(position+accel*change);
		}
		
		private function scrollL(e:MouseEvent):void{
			if(e.delta>0)makeChange(1);
			else makeChange(-1);
		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('result')==false){
				uniqueProps.result= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) {
						setPercent(Number(to));
					}
					if(position<0){
						return 'not set';
					}

					return position.toString();
				}; 	
			}
			
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		private function setPercent(to:Number):void
		{
			position = to;
			if(position<0){
				position=0;
			}
			else if(position>100){
				position = 100;
			}
			else{
				this.dispatchEvent(new Event("moved"));
			}

		}
		
		
		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			setPercent(	startingVal()	);
			
		}
		
		
		override public function setVariables(list:XMLList):void {
			setVar("string","orientation",'x','must be either x or y');
			setVar("string","listenFor","keys,scroll,mouse","either keys or scroll or mouse or keys,scroll, or...");
			setVar("string","startingVal","random","either random or enter a single value here in %");
			setVar("string","startValMin","");
			setVar("string",",startValMax","");
			setVar("int","acceleration","1");
			super.setVariables(list);
		}
		
		
		override public function storedData():Array {
			var tempData:Array = new Array();
			tempData.event=peg;
			tempData.data=0//pos.toString();
			super.objectData.push(tempData);
			return objectData;
		}
		
		
		
		override public function nextStep(id:String=""):void{
			accel=getVar("acceleration");
			var arr:Array = getVar("listenFor").split(",");
			if(arr.indexOf("keys")!=-1)		keys=true;
			if(arr.indexOf("scroll")!=-1)	scroll=true;
			if(arr.indexOf("mouse")!=-1)	mouse=true;
			orientation = getVar("orientation");

			listeners(true);
			
		}
		
		private function startingVal():int
		{
			if(getVar("startingVal")=='random'){
				var minStr:String = getVar("startValMin");
				var maxStr:String = getVar("startValMax");

				if(minStr=="" || maxStr==""){
					var val:Number = Math.random()*100;
					OnScreenElements.startingVal=codeRecycleFunctions.roundToPrecision(val,2);
					return val;
				}
				else{
					
					var min:Number = Number(minStr);
					var range:Number = Number(maxStr) - min;
					val = ((Math.random() * range)+min ) *100;
					return val;
				}
			}
			return int(getVar("startingVal"));
		}		
		
	}
}