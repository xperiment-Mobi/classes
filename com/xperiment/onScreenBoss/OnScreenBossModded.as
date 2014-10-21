package com.xperiment.onScreenBoss{
	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;

	
	
	public class OnScreenBoss extends Sprite implements IOnScreenBoss {

		public static var TOP:int=int.MIN_VALUE+1000; 
		public static var BOTTOM:int=int.MAX_VALUE-1000;
		protected static var MAX_CHILDREN:int = int.MAX_VALUE;
		public static const FOREVER:Number=int.MAX_VALUE;
		
		public var _startTimeSorted:Array;
		public var _endTimeSorted:Array;
		public var _mainTimer:TrueTimer;
		public var __objsOnScreen:Array;
		public var running:Boolean = true;
		
		private var stageCount:int;
		private var depthRecyc:int;
		protected var _allStim:Array;
		
		
		private var chromeBug:Boolean = true;
		
		private var hack:String = int(Math.random()*1000).toString();

		public function OnScreenBoss():void {
			_mainTimer= getTrueTimer(1,checkForEvent);
			_startTimeSorted = [];
			_endTimeSorted = [];
			__objsOnScreen=[];
			_allStim = [];
			running = true;
		}
		
		protected function getTrueTimer(startTime:int, callBackF:Function):TrueTimer{
			return new TrueTimer(startTime,callBackF);
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
		
		protected function stragglers():void{
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

			if(_mainTimer.trialTime<stim.startTime)stim.startTime+=dur;
			if(_mainTimer.trialTime<stim.endTime){
				
				stim.endTime+=dur;
				
				//if(stim.peg=="vibration")trace(stim.peg,_mainTimer.currentCount,stim.startTime,stim.endTime,dur)
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
			
			if(startTime<_mainTimer.trialTime || endTime >_mainTimer.trialTime){
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
			return String(_mainTimer.trialTime);
		}
		/**
		 checkForEvent - this method checks for the event on every clock ticks
		 @param   evet  Event
		 */
		
		public function checkForEvent(count:int):void {

					
			if(running){
			

				//evt=new Event("ElapsedTime");
				//dispatchEvent(evt);
				
		/*		function f():String{
					var arr:Array = [];
					for(var i:int=0;i<_endTimeSorted.length;i++){
						arr.push(_endTimeSorted[i].endTime);
					}
					return arr.join(",");
				}
				
				trace(f());*/

				if (running  && _startTimeSorted.length!=0 && _startTimeSorted[0].startTime == _mainTimer.trialTime) {
				
					do __addToScreen(_startTimeSorted[0] as uberSprite);
					while (running && _startTimeSorted.length != 0 && _startTimeSorted[0].startTime == _mainTimer.trialTime);		
				}
				
				//trace(123, _endTimeSorted.length,_endTimeSorted[0].endTime,_mainTimer.currentCount)
				if (running && _endTimeSorted.length!=0 &&_endTimeSorted[0].endTime==_mainTimer.trialTime) {
					
					do {
						stopObj(_endTimeSorted[0]);

					}
					while (running && _endTimeSorted.length != 0 && _endTimeSorted[0].endTime == _mainTimer.trialTime);
				}
			}
		}

		
		public function commenceDisplay(autoStart:Boolean):void {

			if(this.stage)stageCount = this.stage.numChildren;
			sortSpritesTIME();
			
			//primeDepths();
			//sortSprites(_sortedDepths,"depth");
			startTimer();
			if(autoStart)startTimer();
			
		}
		
		protected function startTimer():void
		{
			_mainTimer.start();
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
			if(stopPeg(peg)){
				var obj:Object;
				for (var i:int=0; i < _allStim.length; i++) {
					if (_allStim[i].peg==peg) {
						_allStim.slice(i,1);
						break;
					}
				}
			}
		}
		
		
		public function stopObj(stim:uberSprite):Boolean {

			var index:int;
			var stopped:Boolean=false;
			
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
			
					
				//else if(logger)logger.log("you asked to remove a screen element ("+peg+") that is not on screen");

			
			if(stopped)sortSpritesTIME();
			
			return stopped; //only used by killObj function above
		}
		
		public function stopPeg(peg:String):void
		{
			for (var i:int=0; i < __objsOnScreen.length; i++) {
				//trace('test',__objsOnScreen[i].peg,peg)
				if(__objsOnScreen[i].peg==peg){
					//trace(111,__objsOnScreen[i].peg,peg)
					stopObj(__objsOnScreen[i]);
				}
				
			}	
	
		}
		

		public function runDrivenEvent(peg:String,delay:String="",dur:String=""):uberSprite {

			var stim:uberSprite;
			for (var i:int=0; i < _allStim.length; i++) {
				if (_allStim[i] && _allStim[i].peg==peg) {
					stim=_allStim[i];
					
					if (stim!=null && __objsOnScreen.indexOf(stim)==-1) {
						
						stim.endTime+=_mainTimer.trialTime;
						
						if(dur!="" && !isNaN(Number(dur)))stim.endTime+=Number(dur);
						
						stim.startTime+=_mainTimer.trialTime;	
						
						if(delay!="" && !isNaN(Number(delay)))stim.startTime+=Number(delay);
						
						_endTimeSorted.push(stim);
						_startTimeSorted.push(stim);
						
						sortSpritesTIME();
						
						if (delay==""){
							//trace("start:",peg);
							__addToScreen(stim);		
						}
					}
				}
			}
			return stim;
		}
		
		public function __removeFromScreen(stim:uberSprite):void{
			
				remove(stim);
				stim.dispatchEvent(new StimulusEvent(StimulusEvent.ON_FINISH));
				if(running){
					removeFromOnScreenList(stim);
				}
		}
		
		private function removeFromOnScreenList(stim:uberSprite):void
		{
			var index:int= __objsOnScreen.indexOf(stim);
			if(index!=-1)__objsOnScreen.splice(index,1);
		}		
		

		public function __addToScreen(stim:uberSprite,doEvents=true):void{

			if(doEvents)stim.dispatchEvent(new Event(StimulusEvent.DO_BEFORE));

			depthManager(stim);
			/*if(__objsOnScreen){
				
				if(__objsOnScreen.indexOf(stim)==-1)	__objsOnScreen.push(stim);
				depthRecyc=stim.depth;
	
				if(depthRecyc==TOP || depthRecyc==0){
					
					add(stim);
				}
				
				else if(depthRecyc==BOTTOM){
					addAt(stim,0);
				}
				
				else if(this.numChildren==0){
					addAt(stim,0);
				}
				
				else {
					var d:int = __getDepth(stim)
					//trace("in here",stim.peg,d)
					addAt(stim,d);
				}		
			}
			else add(stim);*/

			if(running){
				var index:int=_startTimeSorted.indexOf(stim);
				if(index!=-1)_startTimeSorted.splice(index,1);
			}
			
			stim.ran = true;
			if(doEvents)	stim.dispatchEvent(new Event(StimulusEvent.DO_AFTER_APPEARED));
		}
		
		protected function depthManager(stim:uberSprite=null):void
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
				//trace(999,stim.peg)
				
				this.removeChild(stim);
			}
			else{
				//trace(6,this.parent)
			}
		}
		
		/*protected function __getDepth(stimulus:uberSprite):int{

			var minDepthGap:int = MAX_CHILDREN;
			var atVal:int=0;
			var depthDif:int;

			var stimDepth:int = stimulus.depth;

			loop: for(var i:int=0;i<_sortedDepths.length;i++){
				//trace(2222,_sortedDepths[i].uSprite.peg,_sortedDepths[i].uSprite.depth)
				if(_sortedDepths[i].stage){
			
					depthDif = stimDepth - _sortedDepths[i].depth;
				
					if(depthDif>=0){	
						minDepthGap=depthDif;
						atVal=this.getChildIndex(_sortedDepths[i]);
					}
					else{
						break loop;
					}
				}
			}

			if(minDepthGap==MAX_CHILDREN){
				return 0;
			}
			else{
				//trace("2345",atVal+1)
				return atVal+1;
			}
		
			throw new Error();
			return null;;
		}	
*/
		public function time():int
		{
			return _mainTimer.trialTime;
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
		
		public function updateDepths(newOrder:Array):void
		{

			var stimObj:Object;
			for(var depth:int=0;depth<newOrder.length;depth++){
				stimObj=getObjFromPeg(newOrder[depth]);

				if(stimObj && stimObj.depth!=TOP && stimObj.depth!=BOTTOM){
					stimObj.depth=depth;
				}
			}
			
			
			depthManager();
			
		}
		
		public function updateStimTimesFromObj(changed:Object):uberSprite
		{
			var stim:uberSprite = helper__getStim(changed.peg);

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
					if((allStim[i] as uberSprite).peg==peg){
						return allStim[i];
					}
				}
			}
			return null;
		}
	}
}