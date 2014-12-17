package com.xperiment.make.xpt_interface.trialDecorators.sizeHelpers
{
	import com.greensock.transform.TransformItem;
	import com.greensock.transform.TransformManager;
	import com.xperiment.stimuli.addJPG;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class SizerJPG extends Sizer
	{
		private var exactSize:Boolean;
		private var x_aspectRatio:Boolean;
		private var y_aspectRatio:Boolean;
		
		public function SizerJPG(manager:TransformManager,stim:addJPG){
			super(manager);
			var transformStim:TransformItem = manager.getItem(stim as DisplayObject);
			
			
			exactSize= stim.getVar("exactSize");		
			x_aspectRatio = stim.getVar("width")=="aspectRatio";
			y_aspectRatio = stim.getVar("height")=="aspectRatio";
			
			if(x_aspectRatio|| y_aspectRatio) transformStim.constrainScale = true;
		
			
			
		}
		
		override public function finalUpdate():Object
		{
			var dimensions:Object = super.finalUpdate();
			dimensions.exactSize='false';
			return dimensions;
		}
		
		override protected function style(transparentLayer:Sprite, width:int, height:int):void{};
		override protected function hide():void{};
	}
}