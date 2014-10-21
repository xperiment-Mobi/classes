package com.xperiment.behaviour
{
	public class TimeLogicPiece
	{
		private var _ID:String;
		private var _origLogic:String;
		private var _startTime:uint;
		private var _endTime:uint;
		private var _currentTime:uint
		
		
		public function TimeLogicPiece(ID:String,origLogic:String,startTime:uint,endTime:uint)
		{
			_currentTime=(new Date()).time;
			
			_ID=			ID;
			_origLogic=		origLogic;
			_startTime=		_currentTime-startTime;
			_endTime=		_currentTime+endTime;
		}
	}
}