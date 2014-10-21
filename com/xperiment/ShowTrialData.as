package com.xperiment
{
	import com.xperiment.stimuli.primitives.windows.WindowPrimitive;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ShowTrialData extends Sprite
	{
		
		private var window:WindowPrimitive;
		
		public function ShowTrialData()
		{
			window = new WindowPrimitive({title:"trial data",width:300,height:300})
			window.addMessage('no data so far','');	
			//theStage.addChild(window);
			
			window.myWindow.addEventListener(Event.CLOSE, function(e:Event):void{
				e.currentTarget.removeEventListener(Event.CLOSE,arguments.callee);
				stage.removeChild(window);
				window.kill();
				window=null;
			});
			

			

			this.addChild(window);
			super();
		}
		
		public function giveData(trialData:XML,trialnum:int):void
		{
			window.updateHeader('trial '+String(trialnum));
			if(!trialData)	window.updateText('no data submitted');
			else 			window.updateText(trialData.toString());
			
		}
	}
}