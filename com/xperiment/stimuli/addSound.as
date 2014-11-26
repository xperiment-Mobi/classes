package com.xperiment.stimuli
{
	import com.xperiment.preloader.PreloadStimuli;
	import com.xperiment.stimuli.Controls.Controls;
	import com.xperiment.stimuli.Controls.Panel;
	import com.xperiment.stimuli.primitives.LoadStimulus;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class addSound extends LoadStimulus 
	{
		private var preloader:PreloadStimuli;
		private var sound:Sound;
		private var soundChannel:SoundChannel;
		
		public var pausePoint:Number = 0.00;
		private var isPlaying:Boolean = false;
		private var panel:Panel;
		private static var onePlayOnly:addSound; 
		private var hasSounded:Boolean = false;
		private var requestedToPlay:Boolean=false;
		
		override public function setVariables(list:XMLList):void {

			setVariables_loadingSpecific();
			
			setVar("string","repeat",'false');
			setVar("string","controls",'',"leave blank for none, play or mini");
			setVar("boolean","autostart",true);
			setVar("boolean","hasPlayed",true);
			setVar("boolean","onePlayOnly",true);
			super.setVariables(list);
			
			if(getVar("controls")!="")	makePanel(getVar("controls"));	
			
			setUniversalVariables();
			setVariables_loadingSpecific();
			
			if(theStage){
				var byteArray:ByteArray;
				if 	((byteArray=givePreloaded())!=null){		
					doAfterLoaded(byteArray);	
				}
				else{
					setupPreloader();
				}
			}

		}
		
		public function makePanel(controls:String):void
		{
			switch(controls){
				case "play":
					panel = Controls.sound({right:play})
					break;
				case "mini":
					panel = Controls.sound({right:play,pause:pause})
					break;
				default:
					throw new Error("unknown 'controls' type in addSound with peg: "+peg);
			}
			pic.addChild(panel);
		}
		
		override public function returnsDataQuery():Boolean{
			if(getVar("hasPlayed"))return true;
			return false;
		}
		
		override public function storedData():Array {
			objectData.push({event:peg+"_sounded",data:hasSounded});

			return objectData;
		}
		
		
		override public function myUniqueActions(action:String):Function{
			if(!uniqueActions){
				uniqueActions = new Dictionary;
				uniqueActions.pause=function():void{pause();};
				uniqueActions.play=function():void{play();} ; 		
				uniqueActions.start=uniqueActions.play
				uniqueActions.stop=function():void{stop();}; 
			}
			if(uniqueActions.hasOwnProperty(action)) return uniqueActions[action]
			
			return null;
		}
		
		private function repeatListener(e:Event):void{
			
			var doWhat:String= getVar("repeat").toLowerCase();
			if(soundChannel && soundChannel.hasEventListener(Event.SOUND_COMPLETE))soundChannel.removeEventListener(Event.SOUND_COMPLETE, repeatListener);
			soundChannel=null;
			isPlaying = false;
			
			if (doWhat=="true"){				
				pausePoint=0;
				play();
			}
			else if(!isNaN(Number(doWhat))){
				var num:int=Number(doWhat);
				OnScreenElements.repeat = String(num-1);
				if(num>0){
					pausePoint=0;
					play();
				}
			}
			this.dispatchEvent(new Event(Event.SOUND_COMPLETE));
		}
		
		public function stop():void
		{
			
			if(soundChannel){
				pausePoint=soundChannel.position;
				soundChannel.stop();
				soundChannel.removeEventListener(Event.SOUND_COMPLETE, repeatListener);
				soundChannel=null;
			}
			isPlaying = false;
			if(panel)panel.ON(false);
			if(onePlayOnly){
				onePlayOnlyF(false);
			}
		}
		
		
		public function pause():void
		{
			if(soundChannel && isPlaying) stop();
			if(onePlayOnly){
				//trace(111)
				onePlayOnlyF(false);
			}
			if(panel)panel.ON(false);
				
		}
		

		private function onePlayOnlyF(ON:Boolean):void{
			if(ON){
				if(onePlayOnly){
					onePlayOnly.stop();
				}
				onePlayOnly=this;
			}
			else{
				if(onePlayOnly==this){
					onePlayOnly=null;
				}
				else{
					onePlayOnly.pausePoint=0;
					onePlayOnly.stop();
					
				}
			}
			if(panel)panel.ON(ON);
		}
		
		public function play():void
		{	
			hasSounded=true;
			if(isPlaying){
				stop();
				if(getVar("onePlayOnly"))onePlayOnlyF(true);
				isPlaying=false;
				pausePoint=0;
			}
			
			if(isPlaying==false){
				if(getVar("onePlayOnly"))onePlayOnlyF(true);
				soundChannel = sound.play(pausePoint);	
				soundChannel.addEventListener(Event.SOUND_COMPLETE, repeatListener);
				
			}
			isPlaying=true;
		}
		
		override public function doAfterLoaded(content:ByteArray):void{
			sound = new Sound;
			sound.loadCompressedDataFromByteArray(content,content.length);
			setUniversalVariables();
			if(requestedToPlay)play();
		}	
		
	
		
		override public function appearedOnScreen(e:Event):void
		{
			if(sound){
				if(getVar("autostart"))play();
			}
			else	requestedToPlay;

			super.appearedOnScreen(e);
		}	
		
		override public function kill():void{
			if(panel){
				pic.removeChild(panel);
				panel.kill();
				panel=null;
			}
			if(soundChannel)soundChannel.stop();
			if(soundChannel && soundChannel.hasEventListener(Event.SOUND_COMPLETE))soundChannel.removeEventListener(Event.SOUND_COMPLETE, repeatListener);
			sound=null;
			super.kill();
		}
		
	}
}