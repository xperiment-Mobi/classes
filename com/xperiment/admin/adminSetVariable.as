package com.xperiment.admin{

	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.trial.overExperiment;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.uberSprite;
	import com.xperiment.script.ProcessScript;
	import flash.events.MouseEvent;

	public class adminSetVariable extends admin_baseClass {
				
		override public function setVariables(list:XMLList):void {
			setVar("string","attribute","timeStart");
			setVar("string","changeForThisIDonly","");
			super.setVariables(list);
		}
		
		private function updateScript(val:String):void{
			if (getVar("attribute")!=""){
				if (getVar("changeForThisIDonly")==""){
					//logger.log("adminSetVariable will attempt to update the value of all attributes called '"+getVar("attribute")+"' to '"+val+"'.");
					ProcessScript.replaceAllInstancesOfSpecificAttrib(getVar("attribute"), val, exptScript,logger);
				}
				else if(getVar("attribute")=="actualValue"){
					ProcessScript.overwriteValueFromID(getVar("changeForThisIDonly"), val, exptScript,"id",logger);
				}
				else{
					//logger.log("adminSetVariable will attempt to update an object (id='"+getVar("changeForThisIDonly")+"') attribute ('"+getVar("attribute")+"') to '"+val+"'.");
					ProcessScript.overwriteAttributeFromID(getVar("changeForThisIDonly"), getVar("attribute"), val, exptScript,"id",logger);
					
				}
			}
			else logger.log("adminSetVariable cannot do anything as you have to not given it enough info:e.g. attribute='bla' / attribute='bla' changeForThisIDonly='changeMe'");
		}
		

		override public function listen_ck(e:MouseEvent):void{
			updateScript(e.target.parent.myScore());
		}
		


	}
}