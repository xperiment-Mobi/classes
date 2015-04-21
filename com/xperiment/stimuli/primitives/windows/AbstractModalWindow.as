package com.xperiment.stimuli.primitives.windows
{
	import com.greensock.TweenMax;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.trial.Trial;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AbstractModalWindow
	{
		public var window:WindowPrimitive;
		
		public function AbstractModalWindow(theStage:Stage, params:Object, header:String, body:String, debugger:Boolean = true)
		{
			var grayBG:Sprite = new Sprite;
			grayBG.graphics.beginFill(0,.7);
			
			var myStageWidth:int = Trial.ACTUAL_STAGE_WIDTH;
			var myStageHeight:int = Trial.ACTUAL_STAGE_HEIGHT
			
	
			grayBG.graphics.drawRect(0,0,myStageWidth,myStageHeight);
			theStage.addChild(grayBG);
			
			
			window = getWindow(params);
			theStage.addChild(window);
			
			window.addMessage(header,body);	
			
			window.myWindow.addEventListener(Event.CLOSE, function(e:Event):void{
				e.currentTarget.removeEventListener(Event.CLOSE,arguments.callee);
				theStage.removeChild(grayBG);
				grayBG=null;
				theStage.removeChild(window);
				window.kill();
				window=null;
				//note, checked later if it is approp to restart
				//theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.RESTART_STUDY));
			});
			
			//theStage.addChild(window);
			
			TweenMax.fromTo(window,1,{onStart:function():void{theStage.addChild(window)},x:-myStageWidth, y:-myStageHeight, alpha:0},{x:Trial.RETURN_STAGE_WIDTH*.05,y:Trial.RETURN_STAGE_HEIGHT*.05,alpha:1});
			
			if(ExptWideSpecs.IS('isDebugger') && debugger){
				var t:Timer = new Timer(1000,1);
				t.addEventListener(TimerEvent.TIMER,function(e:Event):void{
					//////////////////////////////////////
					e.target.removeEventListener(e.type,arguments.callee);
					//////////////////////////////////////Anonymous Function
					t.stop();
					window.kill();
					trace("Running in the debug player so killed this screen.");
					//////////////////////////////////////
					//////////////////////////////////////
				});
				//t.start();	
			}
		}	
		
		protected function getWindow(params:Object):WindowPrimitive
		{
			return new WindowPrimitive(params);
		}
		
	}
}