package com.xperiment.make.OnScreenBoss
{
	import com.xperiment.uberSprite;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.onScreenBoss.TrueTimer;
	import com.xperiment.onScreenBoss.TrueTimerBuilder;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	public class OnScreenBossMaker extends OnScreenBoss
	{
		public static var isStill:Boolean = true;
		public static var instance:OnScreenBossMaker;
		private static var JS_boss:Boolean = false;
		
		private var currentTime:int;
		private var stim:uberSprite;
		
		
		public static function currentTime_toJS(t:int):void{
			if(JS_boss==false){
				if(ExternalInterface.available)	ExternalInterface.call('timelineHelper.setTime',t);
			}
		}
		
		public static function currentTime_fromJS(t:int):void{
			JS_boss=true;
			instance.GOTO(t);
		}
		
		public static function fromJS(info:Object):void{
			if(instance){
				var command:String  = info.command;
				var extra:String	= info.extra;
				JS_boss=true;
				if(command=='play') { instance.PLAY(); return; }
				if(command=='pause'){ instance.PAUSE(); return; }
				if(command=='reset'){ instance.RESET(); return; }
				if(command=='goto') { instance.GOTO(info.time); return; }
			}
		}
			
		
		
		public function OnScreenBossMaker()
		{
			if(!instance)setup_toJS();
			instance=this;
			__objsOnScreen=[];
			_allStim=[];
			_mainTimer= getTrueTimer(50,check);
			
			
		}
		
		private function setup_toJS():void
		{
			if(ExternalInterface.available)	ExternalInterface.addCallback('currentTime_fromJS',currentTime_fromJS);
		}
		
		private var count:int=0;
		private function hack():void
		{
			if(this.stage){
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,function(e:MouseEvent):void{
				count++;
				if(count>40){
					count=0;
					GOTO(e.stageX/1024*5000);
				}
			
			});
			}
		}		
	
		override public function getTrueTimer(interval:int, callBackF:Function):TrueTimer{
			return new TrueTimerBuilder(1,check);
		}
		
		override public function commenceDisplay(autoStart:Boolean):void {
			check(1);
			//PLAY()
			//delay(500, PAUSE );
			//delay(1000, PLAY );
			//delay(100, function():void{GOTO(2000);});
			/*delay(1000, PLAY );
			delay(1000, PAUSE );
			delay(1500, PLAY );
			delay(1000, RESET );
			delay(1500, PLAY );*/
			//hack();
		}
		
		

		public function check(time:int):void{
			if(currentTime_toJS)currentTime_toJS(time);
			
			__objsOnScreen.splice(0);
		
			for(var i:int=0;i<_allStim.length;i++){
				stim = _allStim[i];
				//trace(8,stim.startTime,stim.startTime<=time , stim.endTime > time,stim.endTime , time)
				if(stim.startTime<=time && stim.endTime > time){
					__objsOnScreen.push(stim);
				}
				else if(this.contains(stim)==true){
					this.removeChild(stim);
				}
			}
		

			__objsOnScreen.sortOn("depth", Array.DESCENDING | Array.NUMERIC);
			
			for(i=0;i<__objsOnScreen.length;i++){
				if(__objsOnScreen[i])	this.addChild(__objsOnScreen[i] as uberSprite);
			}
						
		}	
		
		
		
		
		public function GOTO(t:int):void{
			_mainTimer._goto(t);
		}
		
		public function RESET():void{
			_mainTimer.reset();
		}

		public function PLAY():void
		{
			(_mainTimer as TrueTimerBuilder).reStart();
		}
		
		public function PAUSE():void
		{
			_mainTimer.pause();
			
		}
		
		
		
		
		override public function cleanUpScreen():void {
			for(var i:int=0;i<_allStim.length;i++)	_allStim[i]=null;			
			
			stragglers();
			
		}

		public function notSupported():void{
			
		}

		
		override public function PauseStim(objs:Array,Include:Boolean,dur:int):void{notSupported();}
		override public function __extendTime(stim:Object,dur:int):void{notSupported();}
		override public function hardPause(ON:Boolean):void{notSupported();}	
		override public function PauseTrial(dur:int):void{notSupported();}	
		override public function getObjTimes(obj:uberSprite):Array{notSupported();return null;}	
		override public function getPegTimes(peg:String):Array{notSupported();return null;}
		override public function setTimes(stim:uberSprite, startTime:Number, endTime:Number,duration:Number):Boolean{notSupported();return true;} 
		override public function sortSpritesTIME():void{notSupported();}
		override public function elapsedTime():String {notSupported();return currentTime.toString()}
		//override public function addtoTimeLine(stim:uberSprite):void {notSupported();}
		override public function sortSprites(uSprites:Array,attribute:String):void {notSupported();}
		override public function killPeg(peg:String):void {notSupported();}
		override public function stopObj(stim:uberSprite):Boolean{notSupported();return true;}
		override public function runDrivenEvent(peg:String,delay:String="",dur:String=""):uberSprite {notSupported();return null;}
		override public function __removeFromScreen(stim:uberSprite):void{notSupported();}
		override public function __addToScreen(stim:uberSprite,doEvents=true):void{notSupported();}
		override public function time():int{notSupported();return currentTime;}
		override public function stopAll():void{notSupported();}
		override public function updateDepths(newOrder:Array):void{notSupported();}
		override protected function remove(stim:uberSprite):void{notSupported();}

	}
}
import flash.events.TimerEvent;
import flash.utils.Timer;


function delay(time:int,f:Function):void{
		var t:Timer = new Timer(time,1);
		t.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			t.stop();
			f();
		});
		
		t.start();
	
}