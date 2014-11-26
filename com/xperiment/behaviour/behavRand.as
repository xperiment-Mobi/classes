package com.xperiment.behaviour{
	import com.xperiment.Results.Results;
	import com.xperiment.behaviour.interfaces.IbehavSaveVariable;
	import com.xperiment.events.StimulusEvent;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.stimuli.IneedCurrentDisplay;
	
	import flash.events.Event;
	
	
	
	public class behavRand extends behav_baseClass implements IbehavSaveVariable, IneedCurrentDisplay{
		private var what:Array;
		private var likelihood:Array;
		private var run:String="";
		private var exptResults:Results;
		private var currentDisplay:OnScreenBoss;
		
		override public function setVariables(list:XMLList):void {
			setVar("boolean","saveVariables",true); //add these to setVariables at top
			setVar("string","saveVariableID","");
			setVar("string","likelihood","");
			setVar("string","action","onShow");
			setVar("string","doWhat","start");
			super.setVariables(list);
			
			what=(getVar("usePegs") as String).split(",");
			if(what.length==0)throw new Error("you have not specified anything to happen for a behavRand behaviour.  Specify 'usePegs'");
			
			if(getVar("likelihood")!=''){
				likelihood=(getVar("likelihood") as String).split(",");
			}
			else{
				likelihood=[];
				for(var i:uint=0;i<what.length;i++){likelihood.push(1/what.length);} //if no likelihood scores, create even distribution				
			}

			var sumLikelihood:Number=0;
			
		
			for(i=0;i<likelihood.length;i++){sumLikelihood+=Number(likelihood[i]);} 
			for(i=0;i<likelihood.length;i++){likelihood[i]=likelihood[i]/sumLikelihood;} //if scores add up over 1, fix this
			for(i=1;i<likelihood.length;i++){likelihood[i]+=likelihood[i-1];} //make scores accumulative
			
			addSetVars();
		}

		public function addSetVars():void{
			if(getVar("saveVariables") && getVar("saveVariableID")==""){
				if(getVar("peg")!="") setVar("string","saveVariableID",getVar("peg"));		
				else setVar("boolean","saveVariables",false);
			}
		}
		
		public function storeVariable(dat:String):void{
			if(!exptResults)exptResults = Results.getInstance();
			if(getVar("saveVariables")){
				var savNam:String="";
				if(getVar("saveVariableID")!="")savNam=getVar("saveVariableID");
				else if(getVar("peg")!="")savNam=getVar("peg");
				if(savNam!="")exptResults.storeVariable({name:savNam,data:dat});
				//else logger.log("!Could not save outcome of decision in BehavIf as you have not provided a saveVariableID and there is no peg to use.  BTW data="+dat);
			}
		}

		override public function nextStep(id:String=""):void{

			var randNumber:Number = Math.random();
			for(var i:uint=0;i<likelihood.length;i++){
				if(randNumber<likelihood[i])break;
			}
			
			run=what[uint(i%what.length)]; //need the ran variable for the results
			 //n.b. % circular number stuff.  If run out of positions in an array, restart at position 0
			storeVariable(run);
			//trace(111111,run)

			var doWhat:String=getVar("doWhat");
			switch(getVar("doWhat").toLowerCase()){
				case "start":
					currentDisplay.runDrivenEvent(run);
					break;
				case "stop":
					currentDisplay.stopPeg(run);
					break;
				default:
					throw new Error("In a behavRand behaviour you asked for this unknown event to happen: "+getVar("doWhat"));
				
			}

			//AW JAN FIX
			pic.dispatchEvent(new Event(StimulusEvent.ON_FINISH));
			//manageBehaviours.doEvents(this, ran+"["+doWhat+"]","onFinish");
		}
		
		public function passOnScreenBoss(CurrentDisplay:OnScreenBoss):void{
			this.currentDisplay=CurrentDisplay;
		}
		
		private function sortResults():void
		{
			var tempData:Array = new Array;
			tempData.event=getVar("peg");
			tempData.data=run;						
			objectData.push(tempData);
		}
		
		override public function storedData():Array {
			
					
			objectData.push({event:peg,data:run});
			return objectData;
		}
		
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
	}
}