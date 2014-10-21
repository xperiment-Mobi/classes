package com.xperiment.stimuli.primitives.windows
{
	import flash.display.Stage;
	import flash.events.Event;

	
	public class ModalWindow_send extends AbstractModalWindow
	{
		public function ModalWindow_send(theStage:Stage, params:Object, header:String, body:String, debugger:Boolean=true)
		{
			super(theStage, params, header, body, debugger);
		}
		
		override protected function getWindow(params:Object):WindowPrimitive{
			var send:WindowPrimitive_send = new WindowPrimitive_send(params);
			send.addEventListener(Event.CLOSE,function(e:Event):void{
				send.removeEventListener(e.type, arguments.callee);
				send.kill();
			});
			return send;
		}
		
		
	}
}