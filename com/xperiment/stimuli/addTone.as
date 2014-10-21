package  com.xperiment.stimuli{
	
	import com.xperiment.stimuli.primitives.sound.SoundPrimitive;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	
	public class addTone extends object_baseClass {
		

		private var tone:SoundPrimitive;
		
		override public function kill():void{
			tone.kill();
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
						return tone.freq(to);
					}
					return tone.freq(null);
				}; 	
			}
			
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		
		override public function appearedOnScreen(e:Event):void{
			tone.play(getVar("frequency"),getVar("volume"));
			
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