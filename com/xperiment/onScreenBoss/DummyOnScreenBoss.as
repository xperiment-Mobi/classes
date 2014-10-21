package com.xperiment.onScreenBoss
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import com.xperiment.uberSprite;
	
	public class DummyOnScreenBoss extends Sprite implements IOnScreenBoss
	{
		public function DummyOnScreenBoss()
		{
			super();
		}
		
		public function getObjTimes(obj:uberSprite):Array
		{
			return null;
		}
		
		public function getPegTimes(peg:String):Array
		{
			return null;
		}
		
		
		public var timeStart:Number;
		public var timeEnd:Number;
		public var duration:Number; //purely for testing
		
		public var timing:Object = {};
		
		public function setTimes(obj:uberSprite, startTime:Number, endTime:Number,duration:Number):Boolean
		{
			
			timeStart=startTime;
			timeEnd=endTime;
			this.duration=duration;
			
			if(timing[obj.peg]==undefined)timing[obj.peg] = {};
			

			
			if(startTime!=-1)timing[obj.peg]["timeStart"]=timeStart as Number;
			if(endTime!=-1)timing[obj.peg]["timeEnd"]=timeEnd;
			if(duration!=-1)timing[obj.peg]["duration"]=duration;
			
			
			return false;
		}
		
		public function kill():void{
			timing=null;
		}
		
		public function sortSpritesTIME():void
		{
		}
		
		public function checkForEvent():void
		{
		}
		
		public function commenceDisplay():void
		{
		}
		
		public function cleanUpScreen():void
		{
		}
		
		public function removeVars():void
		{
		}
		
		public function addtoTimeLine(hasBehavs:Boolean,element:uberSprite, startTime:Number, endTime:Number):void
		{
		}
		
		public function sortSprites(sprites:Array, attribute:String):void
		{
		}
		
		public function killPeg(id:String):void
		{
		}
		
		public function stopObj(id:String):Boolean
		{
			return false
		}
		
		public function runDrivenEvent(peg:String, delay:String="", dur:String=""):void
		{
		}
	}
}