package com.xperiment.make.helpers
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class ResizeHelper
	{

		
		
		public static function init(theStage:Stage, resize:Function):void
		{
			var t:Timer = new Timer(100,1);
			t.addEventListener(TimerEvent.TIMER, resizeStuffL);
			
			theStage.align=StageAlign.TOP_LEFT;
			theStage.scaleMode=StageScaleMode.SHOW_ALL;
			
			theStage.addEventListener(Event.RESIZE,function(e:Event):void{
				t.reset();
				t.start();
			});
			
			var ignoredFirst:Boolean = false;
			
			function resizeStuffL(e:TimerEvent):void{
				if(ignoredFirst){
					t.stop();
					resize();
				}
				else ignoredFirst=true;

			}
			
		}
	}
}