package com.xperiment.make.xpt_interface.trialDecorators.sizeHelpers
{

	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformManager;
	import com.xperiment.make.xpt_interface.trialDecorators.TrialDecorator;
	import com.xperiment.stimuli.addText;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.stimuli.primitives.BasicText;
	
	import flash.display.Shape;
	import flash.utils.getTimer;


	public class SizerText extends Sizer
	{

		//private var transparentLayer:Shape;

		private var lastMove:int;
		private var currentTime:int;
		private var text:BasicText;
		
		public function SizerText(manager:TransformManager){
			super(manager);
		}
		
		override public function init(stim:object_baseClass):void{
		
			this.text = (stim as addText).basicText;
			lastMove = getTimer();
			size= new Size(stim);
			hide();
			
			for(var i:int=0;i<stim.numChildren;i++){
				if(stim.getChildAt(i).name == TrialDecorator.TRANSPARENT_LAYER){
					transparentLayer = Shape(stim.getChildAt(i));
					break;
				}
			}
		}
		

		
/*		override protected function resizeL(e:TransformEvent):void{
			currentTime = getTimer();
			if(currentTime > lastMove+100){
				lastMove = currentTime;
				update();
			}
			stim.scaleX=1;
			stim.scaleY=1;
		}*/
/*		
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
		}*/
		
/*		override protected function hide():void
		{
			for(var i:int=0;i<text.pic.numChildren;i++){
				if(text.pic.getChildAt(i)!=transparentLayer)text.pic.getChildAt(i).visible=false;
			}
		}*/
		
/*		override public function finalUpdate():Object
		{
			text.myWidth  = text.myText.width;
			text.myHeight = text.myText.height;
			return super.finalUpdate();
		}*/
	
		
		override public function kill():void{
			//updateContainer();
			//update();
			super.kill();
		}
		
	

	}
}