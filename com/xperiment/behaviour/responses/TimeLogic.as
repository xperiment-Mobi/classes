package com.xperiment.behaviour.responses
{
	dynamic public class TimeLogic
	{
		
		private var _uniqueID:uint=0;
		private var timeLogic:Object = {};
		
		
		
		/*
		holds snippets of timeLogic: (100) or (-200 to 2000)
		determines if snippets are true at a given time.
		
		*/
		
		public function add(origLogic:String):String{
			
			var startTime:uint=	0;
			var endTime:uint=	0;
			var id:String="<-logicID->"+String(_uniqueID);
			
			timeLogic[id] = new TimeLogicPiece(id,origLogic,startTime,endTime);

				
			return id;		
		}
			
			
		
	}
}