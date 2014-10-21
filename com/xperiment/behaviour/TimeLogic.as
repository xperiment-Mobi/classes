package com.xperiment.behaviour
{
	public class TimeLogic
	{
		
		private var _uniqueID:uint=0;
		private var timeLogic:Object = {};
		
		
		
		public function add(origLogic:String):String{
			
			var startTime:uint=	0;
			var endTime:uint=	0;
			
			
			var logicPiece:TimeLogicPiece = new TimeLogicPiece("<-logicID->"+String(_uniqueID),origLogic,startTime,endTime);

				
			return "";		
		}
			
			
		
	}
}