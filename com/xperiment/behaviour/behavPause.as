package com.xperiment.behaviour{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.stimuli.IneedCurrentDisplay;



	public class behavPause extends behav_baseClass implements IneedCurrentDisplay {//note without 'public' nothing happens!!
		private var CurrentDisplay:OnScreenBoss;
		private var excludePegs:Array;
		private var duration:int;

		override public function setVariables(list:XMLList):void {
			setVar("string","time",'1000');
			setVar("int","addTimeForResults",0);
			setVar("string","excludePegs","");
			
			if(list.@timeEnd.toString()==""){
				list.@timeEnd=int(list.@timeStart)+1;
			}
				
			super.setVariables(list);
			
			excludePegs = getVar("excludePegs").split(",");
			if(excludePegs[0]=='' && excludePegs.length==1)excludePegs=[];

			if(getVar("usePegs")!='' && excludePegs.length!=0)throw new Error("you cannot set 'usePegs' and 'excludePegs' at the same time");
		}
		
	
		override public function returnsDataQuery():Boolean{
			if(getVar("hideResults")!='true'){
				return true;
			}
			return false;
		}
		
		override public function storedData():Array {

			objectData.push({event:peg,data:duration+Number(getVar("addTimeForResults"))});
			
			return objectData;
		}

		override public function nextStep(id:String=""):void{
			duration = getDuration();
			OnScreenElements.time=String(duration);
			if(behavObjects.length==0){
				if(excludePegs.length==0){
					CurrentDisplay.PauseTrial(duration);
				}
				else CurrentDisplay.PauseStim(excludePegs,false, duration);
			}
			else{
				CurrentDisplay.PauseStim(behavObjects, true, duration);
			}
		}
		
		private function getDuration():int
		{
			var durStr:String = getVar("time");
			if(!isNaN(Number(durStr))){
				return int(durStr);
			}
			
			return codeRecycleFunctions.getRand(durStr);
		}
		
		public function passOnScreenBoss(CurrentDisplay:OnScreenBoss):void{
			this.CurrentDisplay=CurrentDisplay;
		}
	

		override public function kill():void {
			CurrentDisplay=null;
			super.kill();
		}
	}
}