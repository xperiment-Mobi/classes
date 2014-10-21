package com.xperiment.make.xpt_interface.trialDecorators
{
	import com.xperiment.uberSprite;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class RegenerateStim
	{
		
		public static function DO(stim:object_baseClass):void
		{
			var bind_id:String = stim.getVar(BindScript.bindLabel);
			
			var xml:XML = BindScript.getStimScript(bind_id);
			
			
			var clas:String= getQualifiedClassName(stim);
			var myClass:Class = getDefinitionByName(clas) as Class
			
				
			stim.kill();
			stim.pic = new uberSprite;
			stim.setVariables(XMLList(xml));
			
			//stim.setVariables(XMLList(xml));
			
			//stim.kill();
			
			
			//start= new myClass(theStage);
			
			
			
		}
	}
}