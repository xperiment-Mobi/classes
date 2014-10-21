package com.xperiment.make.xpt_interface.trialDecorators.sizeHelpers
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trial.Trial;
	
	public class Size{
		public var origHeight:int;
		public var origWidth:int;
		public var stim:object_baseClass;
		private var percentHeight:Boolean = true;
		private var percentWidth:Boolean = true;
		
		
		
		public function Size(stim:object_baseClass):void{
			origWidth = stim.myWidth;
			origHeight = stim.myHeight;
			this.stim = stim;
			if(stim.getVar("width").indexOf("%")==-1)percentWidth=false;
			if(stim.getVar("height").indexOf("%")==-1)percentHeight=false;
		}
		
		
		public function dimensions(scaleX:Number, scaleY:Number):Object
		{
			var newWidth:Number = scaleX * origWidth;
			var newHeight:Number= scaleY * origHeight;
			
			return calcUpdate(newWidth,newHeight);
		}
		
		private function calcUpdate(newWidth:Number, newHeight:Number):Object
		{
			stim.myWidth = newWidth;
			stim.myHeight= newHeight;
			
			var returnWidth:String;
			var returnHeight:String;
			
			if(percentWidth){
				returnWidth=(codeRecycleFunctions.roundToPrecision(newWidth/Trial.RETURN_STAGE_WIDTH*100,1)).toString()+"%";
			}
			else{
				returnWidth=newWidth.toString();
			}
			
			if(percentHeight){
				returnHeight=(codeRecycleFunctions.roundToPrecision(newHeight/Trial.RETURN_STAGE_HEIGHT*100,1)).toString()+"%";
			}
			else{
				returnHeight=newHeight.toString();
			}
			
			return {width:returnWidth,height:returnHeight};
		}		
		
		public function update(giveDimensions:Object):Object
		{
			// TODO Auto Generated method stub
			
			return calcUpdate(giveDimensions.width,giveDimensions.height);
		}
	}
}