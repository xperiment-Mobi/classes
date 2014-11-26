
package com.xperiment.runner {

	import com.xperiment.Code.CodeJS;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.trial.Trial;
	import com.xperiment.trial.TrialJS;
	
	import flash.display.Stage;
	
	
	public class runnerJS extends runner {
		
		
		public function runnerJS(sta:Stage) {
			CodeJS.init();
			//var p:PScript = new PScript();
			//sta.addChild(p);
			super(sta);
		}	
		
		
		
		
		override protected function populatePropValDict():void
		{
			//if(XptMemory.sessionAlreadyExisted==false){
			var attribs:XMLList = trialProtocolList.SETUP.variables.attributes();
			for (var i:int = 0; i < attribs.length(); i++){
				//PropValDict.addExptProps(String(attribs[i].name()), attribs[i].toXMLString());
			}
			var urlVariables:Array = ExptWideSpecs.IS("urlParams");
			for(var variable:String in urlVariables){
				//PropValDict.addExptProps(urlVariables[variable], variable);
			}
		}	
		
		override public function newTrial():Trial{
			return new TrialJS();
		}
	
	}
}

