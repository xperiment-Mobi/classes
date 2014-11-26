package com.xperiment.behaviour
{

	import com.uberSprite;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	


	public class behavListShake extends behav_baseClass
	{
		private var CurrentDisplay:OnScreenBoss;

		
		
		override public function setVariables(list:XMLList):void {
			setVar("string","property","timing"); //timing: shuffles start and end times. 
			super.setVariables(list);
		}
		

		
		override public function returnsDataQuery():Boolean {
			if (getVar("hideResults")) return false;	
			else return true;
		}
		
		public function passOnScreenBoss(CurrentDisplay:onScreenBoss):void{
			this.CurrentDisplay=CurrentDisplay;
		}
		
		override public function nextStep(id:String=""):void {			
			var timesArr:Array=new Array;
			var times:Array;
			for(var i:uint=0;i<behavObjects.length;i++){
				times=CurrentDisplay.getTimes(behavObjects[i] as uberSprite);
				if(times)timesArr.push(times);
			}

			if(timesArr.length==behavObjects.length){

				var randList:Array=new Array;
				for(i=0;i<timesArr.length;i++){randList.push(i);}
				randList=codeRecycleFunctions.arrayShuffle(randList);

				
				for(i=0;i<behavObjects.length;i++){
					if(!CurrentDisplay.setTimes(behavObjects[i] as uberSprite,timesArr[randList[i]]) && logger)
						logger.log("!!Error when doing behavListShake (peg="+getVar("peg")+") - could not set start and/or end times for an object.");
				}
				
			}
			else if(logger)logger.log("!Could not do behavListShake (peg="+getVar("peg")+") as could not find start and end times for all objects.");
			
			
		}
		
		
	}
}