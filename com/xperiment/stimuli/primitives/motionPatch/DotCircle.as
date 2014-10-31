package com.xperiment.stimuli.primitives.motionPatch
{
	import flash.geom.Point;

	public class DotCircle extends Dot
	{
		private var centX:Number;
		private var centY:Number;
		private var r:Number;
		private var obj:Object;
		private var circ:Point;
		private var A:Point;
		private var B:Point;
		private var currentLoc:Point;
		private var tempAng:Number;
		private var p_x:Number;
		private var p_y:Number;

		
		public function DotCircle(params:Object)
		{
			this.r=params.r;
			this.p_x=params.p_x;
			this.p_y=params.p_y;
			//this.circ_r = params.circ_r;
			
			super(params);

			sortCircle();
	
		}
		
		private function sortCircle():void
		{
			minLen:Number;
			
	
			circ = new Point(r,r);
			
		}		
		
		override protected function sortPos():void
		{				
		}

		override protected function genPos():void{
			
			tempAng = Math.random() * Math.PI*2;
			
			
			var randDist:Number = Math.random() * r;
			x = p_x + randDist * Math.cos(tempAng);
			y = p_y + randDist * Math.sin(tempAng);	

			//x=p_x-r;
			//y=p_y-0;
			//angle=Math.PI*1.5
			
		}
		
		private var difx:Number;
		private var dify:Number;
		
		override public function fixPos(time:int,rand:Boolean):void
		{
			
			var ang:Number;
			
			tempAng =  Math.atan(   ( y-p_y ) / ( x-p_x )   )
				
			//if(rand)tempAng=(Math.random()-.5)	* Math.PI
			//trace("---",x,y,angle);	
			if(angle>Math.PI*.5 && angle<=Math.PI*1.5){

			}
			else{
			
				tempAng+=Math.PI
			}
			
			//trace(( y-p_y ) , ( x-p_x) )
			
			//trace(tempAng);
			//if(angle>Math.PI){
			//	tempAng-=Math.PI;
			//}
			//trace(angle)
			var opp:Number = Math.cos(tempAng) * r;
			var adj:Number = Math.sin(tempAng) * r;
			//trace(Math.cos(tempAng) * r,opp,adj)
	
			difx=x;
			dify=y;
			
			x=opp+p_x;
			y=adj+p_y;
			
			difx-=x;
			dify-=y;
			
			if(difx*difx+dify*dify<100)init();
			
			
			//trace(x,y,p_x,p_y)
			//y=adj+p_y;
			
			//x=p_x+r;
			//y=p_y+r;
			''
				
				//x=p_x;
			//y=p_y;
			
		}
		


		
	}
}