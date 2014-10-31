package com.xperiment.make.xpt_interface.Bind
{
	import com.xperiment.runner.runner;

	public class UpdateRunnerScript
	{
		public static function DO(bindId:String,r:runner):void
		{
			var xml:XML = BindScript.getStimScript(bindId);

			var bindLabel:String = BindScript.bindLabel;

			for each(var stim:XML in r.trialProtocolList..*.(name()!="TRIAL")){	
				trace(stim.toXMLString())
				if(stim.@[bindLabel].toXMLString() == bindId){
					
					for each(var attrib:XML in xml.attributes()){
						stim.@[attrib.name()] = attrib.toXMLString();
					}
					break;
				}
			}
		}
		
		public static function deleteStimRunnerScript(bindId:String,r:runner):void
		{
			var xml:XML = BindScript.getStimScript(bindId);
			var bindLabel:String = BindScript.bindLabel;
			
			for each(var stim:XML in r.trialProtocolList..*.(name()!="TRIAL")){	
				if(stim.@[bindLabel].toXMLString() == bindId){
					
					delete stim.parent().children()[stim.childIndex()];
					break;
				}
			}
		}	
	}
}