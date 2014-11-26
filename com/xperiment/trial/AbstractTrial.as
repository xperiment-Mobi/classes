package com.xperiment.trial
{

	import com.xperiment.uberSprite;
	import com.xperiment.behaviour.BehaviourBoss;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	
	public class AbstractTrial extends uberSprite
	{

		
		public var manageBehaviours:BehaviourBoss;
		
		private var TimeStartLog:int=0;
		private var TimeEndLog:int=0;

		
		private function err(str:String):void{throw new Error("Timimg Error: "+str);}
		
		public function sortoutTiming(startStr:String, endStr:String,duration:String,peg:String,stim:uberSprite):void{
		 	var tempTimeStart:int;
			var tempTimeEnd:int;
			
	
			
			if (startStr.toLowerCase().indexOf("prev")==-1 && startStr.indexOf("-")!=-1)	err("'"+peg+"' starts/ends before time 0: starts at "+startStr+", ends at "+endStr+".");
			if (endStr.toLowerCase().indexOf("prev")  ==-1 && endStr.indexOf("-")!=-1)	    err("'"+peg+"' starts/ends before time 0: starts at "+startStr+", ends at "+endStr+".");
			
			
			
			
			if (startStr=="" && peg!="")startStr="-1"
			var tempTimeVal:String=startStr;	
			if(tempTimeVal=="")													tempTimeStart=0;
			else if (tempTimeVal.substring(0,8).toLowerCase()=="withprev") 		tempTimeStart=timeShift(tempTimeVal.substring(8),TimeStartLog);
			else if (tempTimeVal.substring(0,9).toLowerCase()=="afterprev") 	tempTimeStart=timeShift(tempTimeVal.substring(9),TimeEndLog);
			else if (!isNaN(Number(tempTimeVal))) 								tempTimeStart=int(tempTimeVal);
			else if (tempTimeVal.toLowerCase().indexOf("end")!=-1)				tempTimeStart=-1;
			else err("cannot process the start time of stimulus '"+peg+"': start="+startStr+" end="+endStr+".");
			
			
			tempTimeVal=endStr;

			if(duration!=""){
				if(!isNaN(Number(duration)))	tempTimeEnd=tempTimeStart+int(duration);
				else							err("cannot process duration of '"+peg+"': "+duration+".");
			}
			else if (tempTimeVal.toLowerCase()=="forever" || tempTimeVal=="") 	tempTimeEnd=OnScreenBoss.FOREVER;
			else if (tempTimeVal.substring(0,8).toLowerCase()=="withprev") 		tempTimeEnd=timeShift(tempTimeVal.substring(8),TimeStartLog);
			else if (tempTimeVal.substring(0,9).toLowerCase()=="afterprev")		tempTimeEnd=timeShift(tempTimeVal.substring(9),TimeEndLog);
			else if (tempTimeVal!="" && !isNaN(Number(tempTimeVal)) ) 			tempTimeEnd=int(tempTimeVal);
			else err("cannot process the end time of '"+peg+"': start "+startStr+" end "+endStr+".");
	

			if (tempTimeEnd<tempTimeStart) err("'"+peg+"' ends before it begins: start="+tempTimeStart+" end="+tempTimeEnd);
			
			
			if (TimeStartLog<tempTimeStart) 	TimeStartLog=tempTimeStart;			
			if (TimeEndLog<tempTimeEnd)			TimeEndLog=tempTimeEnd;

			stim.startTime=tempTimeStart;
			stim.endTime=tempTimeEnd;
			
		}
		
		private function timeShift(shift:String,val:int):int
		{
			if(shift=="") return val;
			
			var command:String=shift.substr(0,1);
			var numStr:String=shift.substr(1);
			
			if(!isNaN(int(numStr))){
				switch(command){
					case "+":	return val+int(numStr);
					case "-":	return val-int(numStr);
					case "/":	return val/int(numStr);
					case "*":	return val*int(numStr);
					default :	err("non number given in timeShift: "+shift);
				}
			}
			else err("illegal maths operator in timeShift (allowed + - / * ): "+shift);
			
			return 0;
		}
	}
}