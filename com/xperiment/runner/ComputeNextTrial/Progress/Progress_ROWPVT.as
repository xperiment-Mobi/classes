package com.xperiment.runner.ComputeNextTrial.Progress
{

	public class Progress_ROWPVT extends Progress_Staircase
	{
		public var _trialsHaveRun:Vector.<Boolean>;
		public var _correctLog:Vector.<Boolean>;
		public var _first8_counter:int=0;
		public var _positionOfFirstTrial:int;
		public var _positionOfLastTrial:int;
		
		private const maxNumWrongRespones:int = 6;
		
		override public function __calcNextTrial(ans:Boolean, Order:int,trialPositionInList:int):int
		{
		
			//special behaviour if within first 8 trials
			if(_first8_counter<8){
				
				var onFlip:Boolean = false;
				
				if(_first8_counter==0){
					_positionOfFirstTrial = Order-trialPositionInList
					_positionOfLastTrial  = _positionOfFirstTrial+_trialsHaveRun.length;
				}

				if(ans==false){
					
					if(direction == UP) onFlip=true;
					
					direction = DOWN;
					//Order=_positionOfFirstTrial;
					_first8_counter=8; //stops entering this if clause
				}
				
				_first8_counter++;
			}
			
			var origOrder:int = Order-_positionOfFirstTrial;
			_trialsHaveRun[origOrder]=true;
			
			
			var correctCount:int = __correctCounter(ans,onFlip);
			
			if(direction == DOWN && correctCount==8)	direction = UP;
			if(wrongInARowReached())	return end(origOrder);
			
			
			return __findNextNotYetRunTrial(direction,origOrder);
		}
		
		private function wrongInARowReached():Boolean
		{
			var copyCorrectLog:Array = [];
			for(var i:int=0;i<_correctLog.length;i++){
				copyCorrectLog[i]=_correctLog[i];
			}
			if(copyCorrectLog.length<8) copyCorrectLog.push(false);
			
			
			var count:int=0;
			for(i=0;i<copyCorrectLog.length;i++){
				if(copyCorrectLog[i]==false)count++;
			
			}
			return count>=maxNumWrongRespones;
		}
		
		public function end(origOrder:int):int
		{
			
			finished();
			saveInfo(composeData(origOrder));
			return _positionOfLastTrial+1;
		}
		
		private function composeData(origOrder:int):Object
		{
			var data:Object = {};
			data.score = origOrder - (_correctLog.length-____correctCount());
			return data;
		}		

		
		//tested
		public function __findNextNotYetRunTrial(direction:String,origOrder:int=0):int
		{
			var modifier:int=1;
			if(direction == DOWN)modifier=-1;
			origOrder+=modifier;
			while(origOrder > 0 && _trialsHaveRun.length > origOrder){
				if(_trialsHaveRun[origOrder]==false)	return origOrder+_positionOfFirstTrial;
				origOrder+=modifier;
			}
			
			return end(origOrder);
		}
		
		//tested
		public function __correctCounter(ans:Boolean, dontStore:Boolean):int
		{
			if(_correctLog.length==8)	_correctLog.pop();
			if(dontStore==false)	_correctLog.unshift(ans);
			
			return ____correctCount();
		}
		
		private function ____correctCount():int{
			var count:int=0;
			for(var i:int=0;i<_correctLog.length;i++){
				if(_correctLog[i])	count++;
				else count--;
			}
			return count;
		}
		
		public function Progress_ROWPVT(xml:XML)
		{
			super(xml);
		}
		
		override public function initDefaults():void
		{
			super.initDefaults();
			initTrialsHaveRun();
			attribs.onlyOnce.val = true;	
			_correctLog = new Vector.<Boolean>;
		}
		
		private function initTrialsHaveRun():void
		{
			_trialsHaveRun = new Vector.<Boolean>;
			for(var i:int=0;i<190;i++){
				_trialsHaveRun[_trialsHaveRun.length]=false;
			}
		}		
	}
}

