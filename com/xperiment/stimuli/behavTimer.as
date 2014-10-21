package com.xperiment.stimuli
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.behaviour.behav_baseClass;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	
	public class behavTimer extends behav_baseClass
	{
		private var timer:Timer;
		
		override public function myUniqueActions(action:String):Function{
			if(!uniqueActions){
				uniqueActions = new Dictionary;
				uniqueActions.pause=function():void{timer.stop()}; 		
				uniqueActions.resume=function():void{timer.start()};
				uniqueActions.reset=function():void{timer.reset()};
			}
			if(uniqueActions.hasOwnProperty(action)) return uniqueActions[action]
			
			return null;
		}
		
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('time')==false){
				uniqueProps.time=function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what){
						// do nothing
					}
					return String(timer.currentCount);
				}; 
				
			}

			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);

		}

		
		
		
		override public function setVariables(list:XMLList):void {
			
			setVar("int","duration",1000);
		
			super.setVariables(list);
		
			
			timer = new Timer(getVar("duration"));
			timer.addEventListener(TimerEvent.TIMER,timerListener);
		}	
		
		protected function timerListener(event:TimerEvent):void
		{
			behaviourFinished();
		}		
		
		
		override public function nextStep(id:String=""):void
		{
			timer.start();
			super.nextStep();
		}
		
		override public function kill():void{
			timer.removeEventListener(TimerEvent.TIMER,timerListener);
			super.kill();
		}
		
	}
}