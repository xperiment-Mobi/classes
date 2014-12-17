package com.xperiment.behaviour{

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilter;
	import com.xperiment.uberSprite;

	public class behavBlur extends behav_baseClass {//note without 'public' nothing happens!!

		private var myTimer:Timer;
		private var myTimers:Array=new Array  ;
		private var filter:BitmapFilter;
		private var stepsX:Array = new Array();
		private var stepsY:Array = new Array();
		private var currentStep:int=0;
		private var alreadyStarted:Boolean=false;

		override public function setVariables(list:XMLList):void {
			setVar("uint","durationOfStep",0);
			setVar("string","strengthYoverT","16");//[from 0-255 but powers of 2 better at rendering so this score is expressed in 2 power of x]
			setVar("string","strengthXoverT","16");//[from 0-255 but powers of 2 better at rendering so this score is expressed in 2 power of x]
			setVar("string","strength","");
			setVar("uint","quality",1);
			setVar("boolean","applyAsTheyCome",true);
			super.setVariables(list);
			
			if(getVar("strength")==""){
				stepsX=(getVar("strengthXoverT")as String).split(",");
				stepsY=(getVar("strengthYoverT")as String).split(",");
			}
			else{
				stepsX=(getVar("strength")as String).split(",");
				stepsY=(getVar("strength")as String).split(",");
			}	
		}


		override public function nextStep(id:String=""):void{
				if (alreadyStarted==false) {
				myTimer=new Timer(getVar("durationOfStep"),stepsX.length);
				myTimer.addEventListener( TimerEvent.TIMER, onListTimer,false,0,true);
				myTimer.start();
				alreadyStarted=true;
			}
		}

		private function onListTimer(e:Event):void {
			filter=new BlurFilter(stepsX[currentStep],stepsY[currentStep],getVar("quality"));
			for (var i:uint=0; i<behavObjects.length; i++) {
				blur(behavObjects[i].pic);
			}
			currentStep++;
		}

		private function onListTimers(e:Event):void {
			var myArr:Array;
			for (var i:uint=0; i<behavObjects.length; i++) {
				if (behavObjects[i].timer==e.target) {
					myArr=behavObjects[i];
				}
			}
			filter=new BlurFilter(stepsX[myArr.currentStep],stepsY[myArr.currentStep],getVar("quality"));
			blur(myArr.pic);

			currentStep++;
		}



		private function blur(spr:uberSprite):void {
			spr.filters=[filter];
		}
		
		
		override public function stopBehaviour(obj:uberSprite):void{
			if(obj)obj.filters=[];
		}
		

		override public function kill():void {
			if(myTimer && myTimer.hasEventListener(TimerEvent.TIMER))myTimer.removeEventListener( TimerEvent.TIMER, onListTimer);
			filter=null;
			super.kill();
		}
	}
}