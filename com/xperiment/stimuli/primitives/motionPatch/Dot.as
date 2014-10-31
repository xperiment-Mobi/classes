package com.xperiment.stimuli.primitives.motionPatch
{
	internal class Dot{
		
		public var x:Number, y:Number;
		public var colour:int;
		public var angle:Number = int.MAX_VALUE; // radians
		
		protected var width:Number;
		protected var height:Number;
		
		private var vel:Number;
		private var dist:Number;
		protected var lifeTime:int;
		protected var endTime:int = int.MIN_VALUE;		
		private var randStartDelay:int;
		private var randAngle:Boolean=true;
		private var prevTime:int;
		
		public function Dot(params:Object){
			
			for each(var param:String in ['vel','width','height','lifeTime','colour','randStartDelay']){
				if(params.hasOwnProperty(param))this[param] = params[param];
			}
			randStartDelay *=Math.random();
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
		
		
		
		public function calcNewPos(time:int):Boolean{
			if(randStartDelay>time)	{
				return false;
			}
			
			if(endTime <= time){
				prevTime=time;
				endTime = time+lifeTime;
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
			trace(ang)
			randAngle=false;
			angle=ang;
		}
		
		
		public function fixPos(time:int,rand:Boolean):void
		{
			
		}
		
		public function re_init():void
		{
			init();// TODO Auto Generated method stub
			
		}
	}
}