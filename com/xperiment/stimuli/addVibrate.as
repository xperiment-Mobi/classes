package  com.xperiment.stimuli{

	import com.distriqt.extension.vibration.Vibration;
	import com.xperiment.uberSprite;
	
	import flash.events.Event;
	import flash.utils.getTimer;

	public class addVibrate extends object_baseClass {
		private var vib_dur:int;
		private static var initialised:Boolean = false;

		override public function setVariables(list:XMLList):void {
			setVar("String","duration","0","On Android you can either specify a duration in ms to vibrate for or can specify a vibration pattern");
			setVar("String","pattern",'',"On Android, to vibrate in a pattern specify a list of comma seperated numbers that are the durations for which to turn on or off the vibrator in milliseconds. First value indicates the delay before starting the vibrations.");
			setVar("int","repeat",-1,"How many times to repeat?  0 repeats pattern indefinately.  On IOS all params ignored and you get exactly 0.4 seconds of vibration and 0.1 seconds of silence.");
			setVar("boolean","saveDuration",true);
			super.setVariables(list);
			
			if(initialised==false){
				try{
					Vibration.init("75d795f721aef531b70e41c6f438a41730036748SoXvDJNmgUYIuW7uC3UHvYSPm4cPNYZms0/7OF+VWUTYS5PHf7dSAOM33HZvnSO04x7P+EtF6H38JKojMqFSFA==");
					initialised=true;
				}
				catch(e:Error){
				
				}
			}
		}
		
		override public function RunMe():uberSprite {
			super.setUniversalVariables();
			return (pic);
		}
		
		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			
			if(Vibration.isSupported){
				var pattern:Array=getVar("pattern").split(",");
				vib_dur = getTimer();
				for(var i:int=0;i<pattern.length;i++){
					pattern[i]=int(pattern[i]);
				}
				
				if(pattern.length>1){
					Vibration.service.vibrate(0, pattern,getVar('repeat'));
				}
				else{
					var dur:int = int(getVar("duration"))
					if(dur!=0)Vibration.service.vibrate(dur);					
				}
			}
			else{
				trace("Vibrate not supported on this device");
			}
		}
		
		override public function returnsDataQuery():Boolean{
			if(getVar("saveDuration")==true){
				return true;
			}
			return false;
		}
		
		override public function storedData():Array {
			var pattern:Array=getVar("pattern").split(",");
			vib_dur = getTimer();
			for(var i:int=0;i<pattern.length;i++){
				pattern[i]=int(pattern[i]);
			}
			objectData.push({event:peg+"_vibTime",data:vib_dur});
			//objectData.push({event:peg,data:vib_dur});
			return objectData;
		}
		
		override public function removedFromScreen(e:Event):void{
			Vibration.service.cancel();
			vib_dur = getTimer()-vib_dur;
			super.removedFromScreen(e);
			
		}
		
		
		
		override public function kill():void{
			Vibration.service.cancel();
			super.kill();
		}
	}
}