package com.xperiment.stimuli.primitives.windows
{
	import flash.display.Stage;
	import flash.events.Event;

	public class ModalWindow_fullscreen extends AbstractModalWindow
	{
		private var theStage:Stage;
		private var window:WindowPrimitive_fullscreen;
		private var completeCallBack:Function;
		public var bigScreen:Boolean = false;
		private var header1:String;
		private var header2:String;
		private var goSmallScreen:String;
		private var goFullScreen:String;
		
		public function ModalWindow_fullscreen(theStage:Stage, params:Object, header:String, body:String,completeCallback:Function)
		{
			this.theStage=theStage;
			header1=header;
			if(params.header2!=undefined)header2=params.header2;
			goSmallScreen=params.goSmallScreen;
			goFullScreen=params.goFullScreen;
			this.completeCallBack = completeCallback;
			super(theStage, params, header, body, false);
		}
		
		public function stop():void{
			setScreen(false);
			window.kill();
		}
		
		override protected function getWindow(params:Object):WindowPrimitive{
			this.window = new WindowPrimitive_fullscreen(params,fullscreenL);
			window.addEventListener(Event.CLOSE,function(e:Event):void{
				window.removeEventListener(e.type, arguments.callee);
				window.kill();
				completeCallBack("");
			});
			return window;
		}
		
		public function setScreen(full:Boolean):void{
			if(full) completeCallBack("fs");
			else completeCallBack("normal");
		}
		
		private function fullscreenL(e:Event=null):void{
			
			try {
				if(bigScreen){
					setScreen(false);
					window.button2.label = goFullScreen;
					
					window.setheaderText(header1);
				}
				else{					
					setScreen(true);
					window.button2.label = goSmallScreen;
					window.setheaderText(header2);
				}
				
				bigScreen=!bigScreen;
				
			} catch (e:SecurityError) {
				//if you don't complete STEP TWO below, you will get this SecurityError
				trace("an error has occured. please modify the html file to allow fullscreen mode: "+e);
			}
			
		}
		
	}
	
}