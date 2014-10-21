package com.xperiment.behaviour.responses
{
	public class TimeLogicPiece 
	{
		private var _ID:String;
		private var _origLogic:String;
		private var _startTime:uint;
		private var _endTime:uint;
		private var _currentTime:uint
		private var _relativeStartTime:uint;
		private var _relativeEndTime:uint;

		public function unitTestSetup(startTime:uint,currentTime:uint,endTime:uint):Boolean{
			_startTime=				startTime;
			_endTime=				endTime;
			_currentTime=			currentTime;
			return coreTest();
		}
		
		public function TimeLogicPiece(ID:String,origLogic:String,startTime:uint,endTime:uint)
		{
			setCurrentTime();
			
			_ID=					ID;
			_origLogic=				origLogic;
			_relativeStartTime=		_currentTime-startTime;
			_relativeEndTime=		_currentTime+endTime;
		}
		
		public function setCurrentTime():void{_currentTime =  _currentTime=(new Date()).time;}
		
		public function startAndTest():Boolean{
			setCurrentTime();
			
			_startTime=				_currentTime-_relativeStartTime;
			_endTime=				_currentTime+_relativeEndTime;
			
			return coreTest();
		}
		
		public function test():Boolean{
			setCurrentTime();
			trace( _currentTime,_endTime)
			return coreTest();
		}
		
		public function coreTest():Boolean{
			return _currentTime>_startTime && _currentTime<_endTime;
		}
		
	}
}