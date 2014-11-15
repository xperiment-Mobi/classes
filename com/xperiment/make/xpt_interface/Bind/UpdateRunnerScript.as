package com.xperiment.make.xpt_interface.Bind
{
	import com.xperiment.make.xpt_interface.runnerBuilder;

	public class UpdateRunnerScript
	{
		
		private static var runner:runnerBuilder;
		
		public static function setup(r:runnerBuilder):void
		{
			runner=r;
		}
		
		public static function DO(bindId:String):void
		{
			var xml:XML = BindScript.getStimScript(bindId);
			var bindLabel:String = BindScript.bindLabel;
			
			for each(var stim:XML in runner.trialProtocolList..*.(name()!="TRIAL")){	
				if(stim.@[bindLabel].toXMLString() == bindId){
					for each(var attrib:XML in xml.attributes()){
						//trace(11111111,attrib.toXMLString(),attrib.toString());
						stim.@[attrib.name()] = attrib.toString();
					}
					break;
				}

			}
			
		}	
	}
}