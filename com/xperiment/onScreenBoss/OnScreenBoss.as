package com.xperiment.onScreenBoss{
	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	import flash.display.Sprite;

	public class OnScreenBoss extends Sprite  {
		
		public static var BOTTOM:int=int.MAX_VALUE; 
		public static var TOP:int=int.MIN_VALUE;
		protected static var MAX_CHILDREN:int = int.MAX_VALUE;
		public static const FOREVER:Number=int.MAX_VALUE;
		
		public var _startTimeSorted:Array;
		public var _endTimeSorted:Array;
		public var _mainTimer:TrueTimer;
		public var __objsOnScreen:Array;
		
		private var stageCount:int;
		public var running:Boolean = true;
		//private var depthRecyc:int;
		protected var _allStim:Array;
		
		private var _currentCount:int = -1;
		
		private var chromeBug:Boolean = true;
		
		private var hack:String = int(Math.random()*1000).toString();
		
		public function params(params:Object):void
		{

		}
		
		public function OnScreenBoss() {
			_mainTimer=getTrueTimer(1,checkForEvent);
			_startTimeSorted = [];
			_endTimeSorted = [];
			__objsOnScreen=[];
			_allStim = [];
			running = true;
			
			//			/trace("set up");
		}
		
		public function getMS():int{
			
			return _mainTimer.currentMS;
		}
		
		public function getTrueTimer(interval:int, callBackF:Function):TrueTimer{
			return new TrueTimer(1,checkForEvent);
		}
		
		
		public function get allStim():Array
		{
			return _allStim;
		}
		
		public function cleanUpScreen():void {
			
			running=false;
			_mainTimer.stop();
			_mainTimer = null;
			
			
			
			for(var i:int=0;i<__objsOnScreen.length;i++){
				remove(__objsOnScreen[i]);
				__objsOnScreen[i]=null;
			}
			
			for(i=0;i<_startTimeSorted.length;i++)			_startTimeSorted[i]=null;
			for(i=0;i<_endTimeSorted.length;i++)			_endTimeSorted[i]=null;
			for(i=0;i<_allStim.length;i++)					_allStim[i]=null;			
			
			stragglers();
		}
		
		protected function stragglers():void
		{
			if(this.stage){
				if(stageCount< this.stage.numChildren){
					for(var i:int=0;i<this.stage.numChildren;i++){
						trace("child:",this.stage.getChildAt(i));
					}
					//throw new Error();
					trace("ZZZZZZZZZZZZZZZZZZZZZZZZ");
					trace("ZZZZZZZZZZZZZZZZZZZZZZZZ");
					trace("ZZZZZZZZZZZZZZZZZZZZZZZZ");
					trace("devel error: more elements on screen after end of trial than before start");
				}
			}
		}
		
		public function PauseStim(objs:Array,Include:Boolean,dur:int):void{
			//nb assumes that either objsPause is empty or objsIgnore is empty
			throw new Error("untested feature");
			
			for(var i:int=0;i>_allStim.length;i++){
				if		(Include && objs.indexOf(_allStim[i].peg)!=-1) __extendTime(_allStim[i],dur);
				else if (Include && objs.indexOf(_allStim[i].peg)==-1) __extendTime(_allStim[i],dur);
			}
			sortSprites(_endTimeSorted,"startTime");
			sortSprites(_endTimeSorted,"endTime");
		}
		
		public function __extendTime(stim:Object,dur:int):void{
			
			if(_mainTimer.currentMS<stim.startTime){
				stim.startTime+=dur;
				//trace("startTime",stim.peg,stim.startTime,22)
				
			}
			if(_mainTimer.currentMS<stim.endTime && stim.endTime !=FOREVER){
				//trace("endTime",stim.peg,stim.endTime,11,dur)
				stim.endTime+=dur;
				//trace("endTime",stim.peg,stim.endTime,22)
			}
		}
		
		public function hardPause(ON:Boolean):void
		{
			if(ON)	_mainTimer.pause();
			else	_mainTimer.reStart();
		}
		
		public function PauseTrial(dur:int):void{
			
			for(var i:int=0;i<_allStim.length;i++){
				__extendTime(_allStim[i],dur);
			}
			
		}
		
		public function getObjTimes(obj:uberSprite):Array{
			for(var i:uint=0;i<_startTimeSorted.length;i++){
				if(_startTimeSorted[i].sprite==obj){
					return [_startTimeSorted[i].startTime,_startTimeSorted[i].endTime];
					break;
				}
			}
			return null;
		}
		
		public function getPegTimes(peg:String):Array{
			for(var i:uint=0;i<_startTimeSorted.length;i++){
				if(_startTimeSorted[i].peg==peg){
					return [_startTimeSorted[i].startTime,_startTimeSorted[i].endTime];
					break;
				}
			}
			return null;
		}
		
		//this function needs testing.
		public function setTimes(stim:uberSprite, startTime:Number, endTime:Number,duration:Number):Boolean{

			if(startTime!=-1)	stim.startTime=startTime;
			if(endTime!=-1)		stim.endTime=endTime;
			if(duration!=-1)	stim.endTime=stim.startTime+duration;;
			
			sortSpritesTIME();
			
			if(startTime<_mainTimer.currentMS || endTime >_mainTimer.currentMS){
				stopObj(stim);
			}
				//if object NOW on screen, add it
			else if (!this.contains(stim))__addToScreen(stim);
			
			return true;
		} 
		
		public function sortSpritesTIME():void{
			if(_startTimeSorted)	sortSprites(_startTimeSorted,"startTime");
			if(_endTimeSorted)		sortSprites(_endTimeSorted,"endTime");	
		}
		
		/**
		 elappsedTime - this method returns the elapsed time of the master timer
		 */
		public function elapsedTime():String {
			return String(_mainTimer.currentMS);
		}
		/**
		 checkForEvent - this method checks for the event on every clock ticks
		 @param   evet  Event
		 */

		public function checkForEvent():void {
			
			if(running){
				
				if(_mainTimer.currentMS == _currentCount){
					
					return;
				}
				_currentCount = _mainTimer.currentMS;

				if (running  && _startTimeSorted.length!=0 && _startTimeSorted[0].startTime <= _currentCount) {
					//banana
					
					do {
						__addToScreen(_startTimeSorted[0] as uberSprite);
					}
					while (running && _startTimeSorted.length != 0 && _startTimeSorted[0].startTime <= _currentCount);		
				}
				

				if (running && _endTimeSorted.length!=0 && _endTimeSorted[0].endTime<=_currentCount) {
					
					do {
						stopObj(_endTimeSorted[0]);
					}
					while (running && _endTimeSorted.length != 0 && _endTimeSorted[0].endTime <= _currentCount);
				}
			}
		}
		
		
		public function commenceDisplay(autoStart:Boolean):void {

			if(this.stage)stageCount = this.stage.numChildren;
			sortSpritesTIME();
			
			//primeDepths();
			//sortSprites(_sortedDepths,"depth");
			if(autoStart)_mainTimer.start();
			
		}
		
		/*private function primeDepths():void
		{
		for(var i:int=0;i<_sortedDepths.length;i++){
		trace(123,_sortedDepths[i].depth)
		_sortedDepths[i].depth=i;//_sortedDepths[i].depth;
		}
		}		*/
		
		
		public function addtoTimeLine(stim:uberSprite):void {
			
			_allStim.push(stim);
			
			if(stim.startTime!=-1){
				_startTimeSorted.push(stim);
				_endTimeSorted.push(stim);
				//_sortedDepths.push(stim);
			}				
		}
		
		
		public function sortSprites(uSprites:Array,attribute:String):void {
			uSprites.sortOn(attribute,Array.NUMERIC);
		}
		
		
		
		public function killPeg(peg:String):void {
			stopPeg(peg)
			
			for (var i:int=0; i < _startTimeSorted.length; i++) {
				if (_startTimeSorted[i].peg==peg) {
					_startTimeSorted.splice(i,1);	
					break;
				}
			}
			
			
			for (i=0; i < _endTimeSorted.length; i++) {
				if (_endTimeSorted[i].peg==peg) {
					_endTimeSorted.splice(i,1);
					break;
				}
			}
			
			for (i=0; i < _allStim.length; i++) {
				if (_allStim[i].peg==peg) {
					_allStim.splice(i,1);
					break;
				}
			}
			
		}
		
		
		public function stopObj(stim:uberSprite):Boolean {
			
			var index:int;
			var stopped:Boolean=false;
			
			if(stim && this.contains(stim)){
				
				__removeFromScreen(stim);
				if(running){
					index=_endTimeSorted.indexOf(stim);		
					if (index!=-1){
						_endTimeSorted.splice(index,1);
					}
					
					index=_startTimeSorted.indexOf(stim);	
					if (index!=-1) _startTimeSorted.splice(index,1);
					
				}
				
				stopped=true;
			}
			
			//else if(logger)logger.log("you asked to remove a screen element ("+peg+") that is not on screen");
			
			
			if(stopped)sortSpritesTIME();
			
			return stopped; //only used by killObj function above
		}
		
		public function stopPeg(peg:String):Boolean
		{
			for (var i:int=0; i < __objsOnScreen.length; i++) {
				if(__objsOnScreen[i].peg==peg){
					return stopObj(__objsOnScreen[i]);
				}
			}	
			return false;
		}
		
		
		public function runDrivenEvent(peg:String,delay:String="",dur:String=""):uberSprite {
			var stim:uberSprite;
			for (var i:int=0; i < _allStim.length; i++) {
				if (_allStim[i].peg==peg) {
					stim=_allStim[i];
					break;
				}
			}
			
			if (stim!=null && __objsOnScreen.indexOf(stim)==-1) {
				
				stim.endTime+=_mainTimer.currentMS;
				
				if(dur!="" && !isNaN(Number(dur)))stim.endTime=Number(dur) + _mainTimer.currentMS;
				
				stim.startTime+=_mainTimer.currentMS;	
				
				if(delay!="" && !isNaN(Number(delay)))stim.startTime+=Number(delay);
				
				_endTimeSorted.push(stim);
				_startTimeSorted.push(stim);
				
				sortSpritesTIME();
				
				if (delay==""){
					__addToScreen(stim);		
				}
			}
			return stim;
		}
		
		public function __removeFromScreen(stim:uberSprite):void{
			
			stim.stimEvent(StimulusEvent.ON_FINISH);
			if(running){
				removeFromOnScreenList(stim);
			}
			remove(stim);
		}
		
		private function removeFromOnScreenList(stim:uberSprite):void
		{
			
			var index:int= __objsOnScreen.indexOf(stim);
			if(index!=-1)__objsOnScreen.splice(index,1);
		}		
		
		
		public function __addToScreen(stim:uberSprite,doEvents=true):void{
			
			if(doEvents)stim.stimEvent(StimulusEvent.DO_BEFORE);
	
			depthManager(stim);
			
			if(running){
				var index:int=_startTimeSorted.indexOf(stim);
				if(index!=-1)_startTimeSorted.splice(index,1);
			}

			stim.ran = true;
			if(doEvents)	stim.stimEvent(StimulusEvent.DO_AFTER_APPEARED);
		}
		
		private function depthManager(stim:uberSprite=null):void
		{
			
			if(stim)__objsOnScreen.push(stim);
			

			__objsOnScreen.sortOn("depth", Array.DESCENDING | Array.NUMERIC);


			for(var i:int=0;i<__objsOnScreen.length;i++){

				if(__objsOnScreen[i])	this.addChild(__objsOnScreen[i] as uberSprite);
			}

			
		}		
		
		
		
		/*		protected function add(stim:uberSprite):void{
		this.addChild(stim);
		}
		
		protected function addAt(stim:uberSprite,depth:int):void{
		this.addChildAt(stim,depth);	
		}*/
		
		protected function remove(stim:uberSprite):void{
			if(this.contains(stim)){
				this.removeChild(stim);
			}
		}
		
		
		public function time():int
		{
			return _mainTimer.currentMS;
		}
		
		
		public function stopAll():void
		{
			for(var i:int=0;i<_allStim.length;i++){
				stopObj(	_allStim[i]	);
			}
		}
		
		private function getObjFromPeg(peg:String):Object{
			for(var i:int=0;i<_allStim.length;i++){
				if(_allStim[i].peg==peg)return _allStim[i];
			}
			return null;
		}
		

		public function updateStimTimesFromObj(changed:Object):uberSprite
		{
			//trace("-");
			var stim:uberSprite = helper__getStim(changed.peg);
			//trace("---");
			if(stim && (
				stim.startTime 	!= 	changed.start ||
				stim.endTime 	!= 	changed.end
			)){
				
				stim.startTime 	= 	changed.start;
				stim.endTime 	= 	changed.end;
				
				setTimes(stim,stim.startTime,stim.endTime,-1);
				return stim;
				
			}
			return stim;
		}
		
		
		
		
		
		private function helper__getStim(peg:String):uberSprite{
			if(allStim.length!=0){
				for(var i:int=0;i<allStim.length;i++){
					//trace((allStim[i] as uberSprite).peg,peg);
					if((allStim[i] as uberSprite).peg==peg){
						return allStim[i];
					}
				}
			}
			return null;
		}
	}
}