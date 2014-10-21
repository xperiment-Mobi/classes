package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.myArduino;

	public class addArduino extends object_baseClass
	{

		private var arduino:myArduino;
		
		override public function setVariables(list:XMLList):void {
			
			setVar("uint","port",8);
			
			super.setVariables(list);
			
			arduino = myArduino.getInstance();
			arduino.commenceArduino({port:getVar("port") as uint});
		}

		override public function doAction(str:String, scratchpad:Function=null,origObj:uberSprite=null,params:Array=null):void{
			//trace("herere",str);
			switch(str.toLowerCase()){
				case "off":
				case "on":
				case "toggle":
					arduino.action(str,params);
					break;
				case "kill":
					arduino.kill();
					break;
				default:
					super.doAction(str);
					break;
			}
			
		}
	}
		
		
}