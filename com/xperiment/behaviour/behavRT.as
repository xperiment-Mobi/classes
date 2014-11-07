package com.xperiment.behaviour
{
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.Imockable;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class behavRT extends behav_baseClass implements Imockable
	{
		private var startTime:Number;
		private var stopTime:Number;

		override public function setVariables(list:XMLList):void {
			setVar("string","event","rt");
			setVar("number","time",0);
			setVar("boolean","hideResults",false);
			super.setVariables(list);
			
		}
		
		public function mock():void{
			nextStep();
			
		}
		
		public function time(str:String=""):Number{
			if(arguments.length!=0){
				stopTime=Number(str);
			}
			return stopTime;
		}

		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('stopTime')==false){
				uniqueProps.stopTime= function(what:String=null,to:String=null):Number{
					if(what) time(to); 
					return calcDuration();
				}; 	
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		override public function storedData():Array {
			if(!stopTime)stopTime=calcDuration();
			objectData.push({event:peg,data:stopTime});
			return objectData;
		}
		
		override public function stopBehaviour(obj:uberSprite):void {//remove this?
			stopTime=getTimer()-startTime;
			//trace("stopRT",String(stopTime));
			
			behaviourFinished();		
			OnScreenElements.time=calcDuration();
		}
		
		private function calcDuration():Number{
			return getTimer()-startTime;
		}
		
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		override public function nextStep(id:String=""):void {
			startTime=getTimer();	
		}
		
	}
}