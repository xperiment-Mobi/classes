package com.xperiment.behaviour{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.stimuli.IneedCurrentDisplay;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.Dictionary;

	
	public class behavScheduleStuff extends behav_baseClass implements IneedCurrentDisplay {

		
		private var currentStimPeg:String = '';
		private var setup:Boolean = false;
		private var currentGroup:int = 0;
		private var currentDisplay:OnScreenBoss;
		
		private var doAfter:object_baseClass;
		private var groups:Array;
		
		public function passOnScreenBoss(CurrentDisplay:OnScreenBoss):void{
			this.currentDisplay=CurrentDisplay;
		}
		
		override public function setVariables(list:XMLList):void {			
			setVar("string","doAfter","","run this after");//vertical, horizontal
			setVar("string","schedule","","","the schedule to use. use []s to have groups start at the same time. comma seperated.")
			super.setVariables(list);
			
		}
		
		
		override public function myUniqueActions(action:String):Function{
			if(!uniqueActions){
				uniqueActions = new Dictionary;
				uniqueActions.next=function(contents:Array):void{next(contents[0]);}; 	
			}
			if(uniqueActions.hasOwnProperty(action)) return uniqueActions[action]
			
			return null;
		}
		
		
		override public function nextStep(id:String=""):void {
			if(setup==false)	do_setup();
			DO();
			
		}
		
		
		private function next(param0:Array):void
		{
			if(setup==false){
				do_setup();
				DO();
			}
			else{
				
				stop();
				
				if(currentGroup+1<behavObjects.length){
					currentGroup++;
					DO();
				}
				else doAtEnd();
			}
		}		
		
		private function doAtEnd():void
		{
			if(doAfter)	currentDisplay.runDrivenEvent(doAfter.peg, doAfter.getVar("delay"),doAfter.getVar("duration"));
		}
		
		private function stop():void
		{
			var currentStims:Array = groups[currentGroup];
			var stim:object_baseClass;
			
			for(var i:int=0;i<currentStims.length;i++){
				stim =getStim(currentStims[i]);
				if(stim)	currentDisplay.stopPeg(stim.peg);
				else throw new Error();
			}
		}
		
		private function DO():void
		{
			var currentStims:Array = groups[currentGroup];
			var stim:object_baseClass;
			
			if(currentStims){
				for(var i:int=0;i<currentStims.length;i++){
					stim =getStim(currentStims[i]);
					if(stim)	currentDisplay.runDrivenEvent(stim.peg, stim.getVar("delay"),stim.getVar("duration"));
					else throw new Error();
				}
			}
			else{
				stim = getStim(getVar("doAfter"));
				if(stim)	currentDisplay.runDrivenEvent(stim.peg, stim.getVar("delay"),stim.getVar("duration"));
			}
		}
		
		private function getStim(stimPeg:String):object_baseClass{
			var stim:object_baseClass;
			
			for(var i:int=0;i<behavObjects.length;i++){
				if(behavObjects[i].peg==stimPeg)	return behavObjects[i] as object_baseClass;
			}	
			return null;
		}
		
		private function do_setup():void
		{
			setup=true;
			setupGroups(getVar("schedule"));
			codeRecycleFunctions.arrayShuffle(groups);
		}		
		
		private function setupGroups(schedule:String):void
		{

			var squareBracketContents:RegExp = /\[.+?\]/g;
			var result:Array = squareBracketContents.exec(schedule); 
			groups = [];
			var str:String;
			
			var listPegs:Array = [];
			for(var i:int=0;i<behavObjects.length;i++){
				listPegs.push(behavObjects[i].peg);
			}
			while (result != null) 
			{ 
				str = result.toString();
				str = str.toString().substr(1,str.length-2);
				groups.push(str.split(","));
				checkExist(listPegs, groups[result.length-1]);
				result = squareBracketContents.exec(schedule); 
			} 
			
			if(groups.length==0)groups = listPegs;
		}
		
		private function checkExist(listPegs:Array,arr:Array):void
		{
			for each(var stim:String in arr){
				if(listPegs.indexOf(stim)==-1){
					throw new Error("in BehavSchedule, you are trying to schedule a stimulus (peg="+stim+") that either does not exist or has not been given to behavSchedule via usePegs.");
				}
			}
			
		}
		
	

	}

}