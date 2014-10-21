package com.xperiment.make.xpt_interface.trialDecorators.sizeHelpers
{

	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformManager;
	import com.xperiment.stimuli.addText;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.getTimer;


	public class SizerText extends Sizer
	{

		//private var transparentLayer:Shape;

		private var lastMove:int;
		private var currentTime:int;
		private var text:addText;
		
		public function SizerText(manager:TransformManager){
			super(manager);
		}
		
		override public function init(stim:object_baseClass):void{
			super.init(stim);
			this.text = stim as addText;
			lastMove = getTimer();
			
			
			/*
			for(var i:int=0;i<stim.numChildren;i++){
				if(stim.getChildAt(i).name == TrialDecorator.TRANSPARENT_LAYER){
					transparentLayer = stim.getChildAt(i) as Shape;
					break;
				}
			}*/
			
		}
		

		
		override protected function resizeL(e:TransformEvent):void{
			currentTime = getTimer();
			if(currentTime > lastMove+100){
				lastMove = currentTime;
				update();
			}
			stim.scaleX=1;
			stim.scaleY=1;
		}
		
		private function update():void
		{
			text.x = manager.selectedItems[0].x;
			if(manager.selectionScaleX >.01 && manager.selectionScaleY >.01){
				text.basicText.myText.width = text.basicText.myWidth = manager.selectionScaleX * size.origWidth;
				text.basicText.myText.height = text.basicText.myHeight = manager.selectionScaleY * size.origHeight;
	
			
				text.basicText.verticallyAlign();
			
				text.graphics.clear();
				//text.graphics.beginFill(0x004455,.5);
				//text.graphics.drawRect(0,0,text.basicText.myText.width,text.basicText.myText.height);
			}
		}
		
		override public function finalUpdate():void
		{
			text.myWidth  = text.basicText.myText.width;
			text.myHeight = text.basicText.myText.height;
			
		}
	
		
		override public function kill():void{
			//updateContainer();
			//update();
			super.kill();
		}
		
	

	}
}