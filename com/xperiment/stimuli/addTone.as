package  com.xperiment.stimuli{
	
	import com.xperiment.stimuli.primitives.sound.SoundPrimitive;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	//import com.xperiment.stimuli.primitives.toneMod;
	
	
	
	public class addTone extends object_baseClass {
		private var tone:SoundPrimitive;
		
		private var gap:int=50;
		private var timer:Timer;
		private var toneMemory:String;

		override public function kill():void{
			//tone.kill();
			if(timer) timer.removeEventListener(TimerEvent.TIMER, timerL);
			while(pic.numChildren>0){
				pic.removeChildAt(0);
			}
		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('frequency')==false){
				uniqueProps.frequency= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) {
						return setTone(to);
					}
					return tone.freq(null);
				}; 	
			}
			
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		private function setTone(to:String):String
		{
			
			toneMemory = tone.freq(null);
				
			if(timer.running){
			
				return toneMemory;
			}
			
			timer.reset();
			timer.start();
			
			return tone.freq(to);
		}		
		
		protected function timerL(e:TimerEvent):void
		{
			timer.stop();
			if(tone.freq(null)!==toneMemory) tone.freq(toneMemory);
			
		}
		
		override public function appearedOnScreen(e:Event):void{
			tone.play(getVar("frequency"),getVar("volume"));
			timer = new Timer(gap, 0);
			timer.addEventListener(TimerEvent.TIMER, timerL);
			super.appearedOnScreen(e);
		}
		
		
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList):void {
			setVar("number","frequency",261.63);
			setVar("number","minPitch",10);
			setVar("number","maxPitch",4000);
			setVar("number","volume",1);
			super.setVariables(list);
			
			
			tone = new SoundPrimitive(getVar("minPitch"),getVar("maxPitch"));
		}
		

		
	
		
	}
}