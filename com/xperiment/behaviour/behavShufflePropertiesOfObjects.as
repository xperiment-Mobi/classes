package com.xperiment.behaviour
{
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.IneedCurrentDisplay;

	public class behavShufflePropertiesOfObjects extends behav_baseClass implements IneedCurrentDisplay
	{
		private var CurrentDisplay:OnScreenBoss;
		//private var properties:Array=[];
		
		override public function setVariables(list:XMLList):void {
			setVar("string","properties","timing"); //timing: shuffles start and end times. 
			super.setVariables(list);
		}
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		public function passOnScreenBoss(CurrentDisplay:OnScreenBoss):void{
			this.CurrentDisplay=CurrentDisplay;
		}
		
		override public function givenObjects(obj:uberSprite):void{	
			//trace(obj,2);
			super.givenObjects(obj);
		}
		
		override public function nextStep(id:String=""):void {	
			//properties=(getVar("timing") as String).split(",");
			//if(properties
			var timesArr:Array=new Array;
			var times:Array;
			for(var i:uint=0;i<behavObjects.length;i++){
				times=CurrentDisplay.getObjTimes(behavObjects[i] as uberSprite);
				if(times)timesArr.push(times);
			}
		
			if(timesArr.length==behavObjects.length){
				
				var randList:Array=new Array;
				for(i=0;i<timesArr.length;i++){randList.push(i);}
				//trace(222,randList);
				randList=codeRecycleFunctions.arrayShuffle(randList);
				//trace(222,randList);
				var index:int;
				for(i=0;i<behavObjects.length;i++){
					index=randList[i];
					//if(!CurrentDisplay.setTimes(behavObjects[i] as uberSprite,timesArr[index][0],timesArr[index][1],-1) && logger){
						//trace(22)
						//logger.log("!!Error when doing behavListShake (peg="+getVar("peg")+") - could not set start and/or end times for an object.");
					//}
				}
				CurrentDisplay.sortSpritesTIME();
				
			}
			//else if(logger)logger.log("!Could not do behavListShake (peg="+getVar("peg")+") as could not find start and end times for all objects.");
			
			
		}
		
		
	}
}