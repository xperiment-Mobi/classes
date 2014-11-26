package com.xperiment.behaviour{
	import com.xperiment.trial.overExperiment;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	
	
	public class behavOpacity extends behav_baseClass {//note without 'public' nothing happens!!
		private var steps:Array;
		private var myTimer:Timer;
		private var timerCounter:uint=0;
		private var run:Boolean=false;


		override public function setVariables(list:XMLList):void {

			setVar("int","startOppacity",1);
			setVar("int","endOppacity",0);
			setVar("uint","timeToChange",1000);
			setVar("int","steps",20);
			super.setVariables(list);
			setVar("int","steps",getVar("steps")-1);

			steps=new Array  ;
			var stepSize:Number=(getVar("startOppacity")-getVar("endOppacity"))/getVar("steps");

			if (getVar("timeToChange")!=0 || getVar("steps")!=0) {
				for (var i:uint=0; i<getVar("steps"); i++) {
					steps.push(codeRecycleFunctions.roundToPrecision(getVar("startOppacity")-stepSize*i,2));
				}
			}
			else {
				timerCounter=0;
			}
			steps.push(getVar("endOppacity"));
			myTimer=new Timer(codeRecycleFunctions.roundToPrecision(getVar("timeToChange")/(getVar("steps")+1)),steps.length);
		}
		
		override public function nextStep(id:String=""):void{
			myTimer.addEventListener(TimerEvent.TIMER, onTimer);
			myTimer.start();
		}
		
		private function onTimer(e:TimerEvent):void {
			changeOpacity();
		}

		private function changeOpacity():void {
			for (var i:uint=0; i<super.behavObjects.length; i++) {
				behavObjects[i].pic.alpha=Number(steps[timerCounter]);
				if (super.behavObjects[i].pic && steps.length-1==timerCounter && getVar("endOppacity")==0) {
					super.behavObjects[i].pic.visible=false;
				}
				
			}
			if(timerCounter==steps.length-1){
				killTimer();
				behaviourFinished();
			}

			timerCounter++;
		}
		
		private function killTimer():void{
			if (myTimer) {
				myTimer.removeEventListener(TimerEvent.TIMER, onTimer);
				myTimer.stop();
				myTimer=null;
			}
		}

		override public function kill():void {
			killTimer();
			super.kill();
		}





	}
}