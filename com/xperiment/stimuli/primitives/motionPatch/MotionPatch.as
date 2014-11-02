package com.xperiment.stimuli.primitives.motionPatch
{
	import com.xperiment.random.Rndm;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class MotionPatch extends Sprite
	{

		private var params:Object;
		private var dots:Vector.<Dot>;
		private var startTime:int;
		private var curTime:int;
		private var radius:int = 1;
		private var type:String;
		private var patch:Sprite;
		private var globalX:Number;
		private var globalY:Number;
		
		public function kill():void{
			this.removeChild(patch);
			listeners(false);
			dots = null;
		}
		
		public function MotionPatch(params:Object){
			
			this.params=params;
			
			Rndm.init();
			
			for each(var param:String in ['radius','type','globalX','globalY']){
				if(params.hasOwnProperty(param))this[param] = params[param];
			}
			
			generateParent();

			radius*=.5;
			
			//this.graphics.beginFill(0x003322,.5);
			
			//this.graphics.drawCircle(params.width*.5,params.height*.5,params.height*.5);
			
			initDots();
			//width:_width, height: _height, dots: 10, colour: 0xff1133
			listeners(true);
		}
		
		private function generateParent():void
		{
			patch = new Sprite;
			if(type=="circle"){
				var r:Number;
				if(params.height<params.width)r=params.height*.5;
				else r=params.width*.5;
				
				patch.graphics.beginFill(0x003322,.5);
				patch.graphics.drawCircle(params.width*.5,params.height*.5,r);

			}
			else throw new Error("not finished square patches yet");
			this.addChild(patch);
			
		}
		
		private function initDots():void
		{
			dots = new Vector.<Dot>;
			
			var dotParams:Object = {};
			dotParams.vel = params.vel;
			dotParams.width = params.width - radius*2;
			dotParams.height = params.height - radius*2;
			dotParams.lifeTime = params.lifeTime;
			dotParams.colour = params.colour;
			dotParams.minDur = params.minDur;
			dotParams.maxDur = params.maxDur;
			
			if(params.height<params.width)dotParams.r=params.height*.5;
			else dotParams.r=params.width*.5;
			dotParams.r-=radius;
			
			dotParams.p_x = params.width*.5;
			dotParams.p_y = params.height*.5;
			//dotParams.circ_r = 0;
	
			var numCoherent:int = params.numCoherent * params.dots;
	
			var angle:Number = params.angle;
			var dot:Dot;
			for(var i:int=0;i<params.dots;i++){
				dot = generateDot(dotParams);
				dots[dots.length] = dot;
				if(numCoherent>0){
					numCoherent--;
					dot.setAngle(angle);
				}
			}
		}
		
		private function generateDot(params:Object):Dot{
	
			if(type=="circle"){
				return new DotCircle(params);
			}
			return new Dot(params);
		}
		
		private function listeners(ON:Boolean):void
		{
			var f:Function;
			if(ON)	f=this.addEventListener;
			else	f=this.removeEventListener;
			
			f(Event.ENTER_FRAME,refreshL);
			
			
		}
		
		protected function refreshL(e:Event):void
		{
			if(!startTime){
				startTime = getTimer();
				updateDots(0);
				return;
			}
			
			curTime = getTimer();
			updateDots(curTime - startTime);
		}
		
		private var hack:int = 0;
		
		private function updateDots(time:int):void
		{
			this.graphics.clear();
			for each(var dot:Dot in dots){
				
				if(dot.calcNewPos(time))	
				{
					if(!patch.hitTestPoint(dot.x+globalX,dot.y+globalY,true)){
						dot.fixPos(time);
					}

					this.graphics.beginFill(dot.colour,1);
					this.graphics.drawCircle(dot.x,dot.y,radius);
				}
			}
		}
	}
}


