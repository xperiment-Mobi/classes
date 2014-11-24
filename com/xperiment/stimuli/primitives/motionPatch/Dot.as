package com.xperiment.stimuli.primitives.motionPatch
{

	import com.xperiment.random.Rndm;

	internal class Dot{
		
		public var x:Number, y:Number;
		public var colour:int;
		public var angle:Number = int.MAX_VALUE; // radians
		
		protected var width:Number;
		protected var height:Number;
		
		private var vel:Number;
		private var dist:Number;
		protected var endTime:int = int.MIN_VALUE;		
		private var randAngle:Boolean=true;
		private var prevTime:int;
		private var minDur:Number;
		private var maxDur:Number;
		
		public function Dot(params:Object){
			
			for each(var param:String in ['vel','width','height','colour','minDur','maxDur']){
				if(params.hasOwnProperty(param))this[param] = params[param];
			}
		}
		
		
		protected function init():void
		{
			
			
			if(randAngle)	angle = Math.random()*2*Math.PI;
			genPos();
			
			//orig_x=453.7;
			//orig_x=204.4;
			//trace(width, height,orig_x,orig_y)
		}
		
		protected function genPos():void{
			x = Math.random()*width;
			y = Math.random()*height;
			
		}
		
		protected function resetTiming(time:int):void{
			prevTime=time;
			endTime = time+((maxDur-minDur) * Rndm.random()+minDur);
		}
		
		
		public function calcNewPos(time:int):Boolean{
			
			if(endTime <= time){
				resetTiming(time);
				init();	
			}
			
			dist  = (time-prevTime) *.001 * vel;
			y += dist * Math.sin(angle);	
			x += dist * Math.cos(angle);
			prevTime=time;
			sortPos();
					
			return true;
		}
		
		protected function sortPos():void
		{
			while(y>height)	y=y-height;
			while(y<= 0)	y=height+y;
			
			while(x>width) 	x=x-width;
			while(x<= 0) 	x=width +x;
		}
		
		public function setAngle(ang:Number):void{
			randAngle=false;
			angle=ang;
		}
		
		
		public function fixPos(time:int):void
		{
			
		}
		
		public function re_init():void
		{
			init();// TODO Auto Generated method stub
			
		}
	}
}