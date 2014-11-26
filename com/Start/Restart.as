package com.Start
{

	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.messages.XperimentMessage;
	
	import flash.display.Stage;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class Restart
	{
		static public function on(theStage:Stage, start:CanRestart):void
		{
			theStage.addEventListener(GlobalFunctionsEvent.FINISH_STUDY, function(e:GlobalFunctionsEvent):void{

				for(var i:int =0;i<theStage.numChildren;i++){

					if(this.toString()!=theStage.getChildAt(i).toString()){
						theStage.removeChildAt(i);
					}
				
				}
			
				
				XperimentMessage.clear(theStage);
				
				//theStage.color = 0xffffff;
				
				var clas:String= getQualifiedClassName(start);
				var myClass:Class = getDefinitionByName(clas) as Class

				start.kill_expt();
				start.kill();
				start=null;
				
				start= new myClass(theStage);
				start.restart()();
				
			});
		}
	}
}