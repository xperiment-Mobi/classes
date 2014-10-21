package com.xperiment.onScreenBoss
{
	import com.xperiment.uberSprite;


	public interface IOnScreenBoss
	{
		
		function getObjTimes(obj:uberSprite):Array
		function getPegTimes(peg:String):Array;
		function setTimes(obj:uberSprite, startTime:Number, endTime:Number,duration:Number):Boolean		
		function sortSpritesTIME():void					
		function checkForEvent(count:int):void 			 
		function commenceDisplay(autoStart:Boolean):void 			 
		function cleanUpScreen():void 
		function addtoTimeLine(element:uberSprite):void 
		function sortSprites(sprites:Array,attribute:String):void			
		function killPeg(peg:String):void 
		//function stopEventWithObj(objec:uberSprite):void
		function stopPeg(peg:String):void
		function runDrivenEvent(peg:String,delay:String="",dur:String=""):uberSprite

	}
}