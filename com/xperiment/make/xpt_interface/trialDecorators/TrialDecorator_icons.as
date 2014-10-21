package com.xperiment.make.xpt_interface.trialDecorators
{
	import com.xperiment.trial.Trial;
	import flash.utils.ByteArray;
	
	
	public class TrialDecorator_icons
	{
		private var trial:Trial;
		
		public function TrialDecorator_icons(trial:Trial)
		{
			this.trial=trial;
		}
		
		
		public function composeImage():ByteArray{
			
			gotoTime(100);

			for(var i:int=0;i<trial.CurrentDisplay._startTimeSorted.length;i++){
				for(var s:String in trial.CurrentDisplay._startTimeSorted[i]){
				}
				
				trial.CurrentDisplay.stage.addChild(trial.CurrentDisplay._startTimeSorted[i].pic);
			}
			
			/*var bitmapData:BitmapData = new BitmapData(trial.CurrentDisplay.pic_Sprite.width,trial.CurrentDisplay.pic_Sprite.height);
			bitmapData.draw(trial.CurrentDisplay.pic_Sprite);
			
			for(i=0;i<trial.CurrentDisplay._startTimeSorted.length;i++){
				trial.CurrentDisplay.pic_Sprite.removeChild(trial.CurrentDisplay._startTimeSorted[i].uSprite);
			}
			
			return PNGEncoder.encode(bitmapData);;*/
			
			return null;
		}
		
		public function gotoTime(time:int):void{ //think ms
			if(isNaN(Number(time)))throw new Error("devel error: passed a non numerical value for time");
			trial.CurrentDisplay._mainTimer.currentCount=time;
			trial.CurrentDisplay.checkForEvent();
		}
	}
}