package com.xperiment.runner.ComputeNextTrial.Progress
{
	import com.xperiment.Results.Results;
	import com.xperiment.trial.Trial;

	public class Progress
	{
		
		public var attribs:Object = {};
		public var type:String;
		public var peg:String;
		
		public function getNextTrial(prevTrial:Trial,prevTrialNum:int):int{
	
			var ans:String = prevTrial.giveTrialData().answer.toString();
			if(ans.length==0)throw new Error("there is a problem in a trialOrderScheme ("+type+"). One of its trials does not give an answer.");
			

			return __calcNextTrial(ans=="true",prevTrialNum,prevTrial.trialBlockPositionStart+1);
		}
		
		public function finished():void{
			
		}
		

		
		public function saveInfo(data:Object):void
		{
			var myName:String = type;
			if(this.peg)myName= peg;
			

			var xml:XML = <trialData/> 
			xml.@name=myName;
			
			for(var key:String in data){
				xml[key]=data[key];
			}
			
			var results:Results = Results.getInstance();
			
			results.give(xml);
		}
		
		public function __calcNextTrial(ans:Boolean, Order:int,trialPositionInList:int):int
		{
			throw new Error('override me');
			return 0;
		}		

		public function Progress(xml:XML)
		{
			if(xml){ //for testing purposes
				this.type = xml.name();
				setup(xml);
			}
		}
		
		private function setup(xml:XML):void
		{
			//public attributes are defined here
			initDefaults();
			
			var nam:String;
			for each(var prop:XML in xml.attributes()){
				nam=prop.name();
				if(attribs.hasOwnProperty(nam)){
					if(attribs[nam].val is String)			attribs[nam].val=prop.toString();
					else if(attribs[nam].val is Boolean) 	attribs[nam].val=Boolean(prop.toString());
					else throw new Error("devel err");
				}
				else{
					throw new Error("You have specified an unknown value in a Progress: "+nam+"="+prop.toString());
				}
			}
		}
		
		public function initDefaults():void
		{
			attribs.onlyOnce = {val:false,description:'each trial can only be done once'};
			attribs.direction = {val:'forward',description:'either forward or backward'}
				
		}
		
		public function getVar(what:String):*{
			if(attribs.hasOwnProperty(what))return what;
			else throw new Error();
			return '';
		}
	}
}