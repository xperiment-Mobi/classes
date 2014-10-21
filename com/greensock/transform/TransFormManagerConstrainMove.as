package com.greensock.transform
{
	public class TransFormManagerConstrainMove extends TransformManager
	{
		private var constrained:Boolean;
		private var myStepJumps:Object;
		private var stepJumpArrX:Array;
		private var stepJumpArrY:Array;
		private var additionalStepZones:uint=5;;
		public function TransFormManagerConstrainMove($vars:Object=null)
		{
			super($vars);
		}
		
		public function passConstraints(PercentageStepJumps:Object,containerWidth:Number,containerHeight:Number):void
		{
			this.myStepJumps=PercentageStepJumps;
			constrained=true;
			
			if(PercentageStepJumps.x!=0){
				stepJumpArrX=new Array;
				for(var percent:Number=-(additionalStepZones*PercentageStepJumps.x);percent<100+(additionalStepZones*PercentageStepJumps.x);percent+=PercentageStepJumps.x){
					stepJumpArrX.push(percent*containerWidth*.001);//-correctionX); // containerWidth=cardWidth/myScaleX
					
				}
				trace(stepJumpArrX);
			}
			else(stepJumpArrX=null);
			
			if(PercentageStepJumps.y!=0){
				stepJumpArrY=new Array;
				for(percent=-(additionalStepZones*PercentageStepJumps.y);percent<100+(additionalStepZones*PercentageStepJumps.y);percent+=PercentageStepJumps.y){
					stepJumpArrY.push(percent*containerHeight*.001);//-correctionY); // containerHeight=cardHeight/myScaleY
				}
			}
			else(stepJumpArrY=null);
		}
		
		
		
		override public function moveSelection(x:Number, y:Number, $dispatchEvents:Boolean = true):void {
			if(constrained){
				var origx:Number=x,origy:Number=y;
				var newPos:Array=sortPos(x,y);
				super.moveSelection(newPos[0],newPos[1],$dispatchEvents);	
			}
			else super.moveSelection(x,y,$dispatchEvents);	
			}
	
		
		
		public function sortPos(x:Number,y:Number):Array //odd that scaleX needs to be passed.  Can't seem to access scaleX inside this class
		{						
			var returnVal:Array=new Array;
			returnVal[0]=binary_search(stepJumpArrX,x);//-correctionX);		
			returnVal[1]=binary_search(stepJumpArrY,y);	
			
			return returnVal;
		}
		
		private function binary_search(arr:Array, key:int):int {
			
			//as discussed here: http://www.actionscript.org/forums/showthread.php3?p=1129506#post1129506
			//originally taken from en.wikipedia.org/wiki/Binary_search_algorithm
			var imin:int;
			var imax:int = arr.length - 1;
			var imid:int;
			var best:int;
			
			while (imax >= imin) {
				imid = imin + imax >> 1;
				best = arr[imid];
				
				if (best < key) imin = imid + 1;
				else if (best > key ) imax = imid - 1;
				else return best;
			}
			if (key - arr[imin] > arr[imax] - key) return arr[imin];
			return arr[imax];
		}		
	
	}
		
		
	
}