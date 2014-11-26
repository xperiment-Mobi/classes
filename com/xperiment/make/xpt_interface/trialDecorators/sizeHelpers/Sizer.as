package com.xperiment.make.xpt_interface.trialDecorators.sizeHelpers
{

	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformManager;
	import com.xperiment.make.xpt_interface.trialDecorators.TrialDecorator;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;


	public class Sizer
	{
		protected var stim:object_baseClass;
		protected var manager:TransformManager;
		protected var transparentLayer:Shape;
		protected var size:Size;
		
		public function Sizer( manager:TransformManager ){
			this.manager = manager;
		}
		
		public function kill():void
		{
			//size = null;
			listeners(false);
			
		}
		
		private function listeners(ON:Boolean):void
		{
			/*var L:String;
			if(ON)	L='addEventListener';
			else	L='removeEventListener';
			
			manager[L](TransformEvent.SCALE,resizeL);*/
		}
		
		public function init(stim:object_baseClass):void
		{
			this.stim = stim;
			transparentLayer = stim.getChildByName(TrialDecorator.TRANSPARENT_LAYER) as Shape;
			style(transparentLayer,stim.width, stim.myHeight);
			size= new Size(stim);
			hide();
			
			//listeners(true);
		}
		
		protected function style(transparentLayer:Shape, width:int, height:int):void
		{
			
			var mat:Matrix = new Matrix();
			var colors:Array=[0xFFFFFF,0x000000];
			var alphas:Array=[.2,.2];
			var ratios:Array=[10,160];
			

			//Without the translation parameters, -circRad+25, -circRad-25, the center
			//of the gradient will fall at the point x=circRad, y=circRad relative to
			//the center of the circle. So the center of the gradient will fall in the
			//lower right portion of the perimeter of the circle. -circRad, -circRad
			//move the center of the gradient to the center of the circle; the +25
			//and -25 parts move it a bit up and to the right.
			mat.createGradientBox(width,height,0,width*.25,height*.25);
			transparentLayer.graphics.clear();
			transparentLayer.graphics.lineStyle();
			transparentLayer.graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,mat);
			transparentLayer.graphics.drawRect(0,0,width, height);
		}
		
		protected function hide():void
		{
			for(var i:int=0;i<stim.numChildren;i++){
				if(stim.getChildAt(i)!=transparentLayer)stim.getChildAt(i).visible=false;
			}
		}
		
		protected function resizeL(e:TransformEvent):void{
			//trace(stim.width,stim.height)
		}
		
		public function finalUpdate():Object
		{
			var dimensions:Object = size.dimensions(manager.selectionScaleX,manager.selectionScaleY);
			return dimensions;
		}
	}
}
