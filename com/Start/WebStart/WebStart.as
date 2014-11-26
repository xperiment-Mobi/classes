package com.Start.WebStart
{
	import com.Start.AbstractStart;
	import com.Start.CanRestart;
	import com.xperiment.messages.XperimentMessage;
	
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.system.Security;

	//import flash.system.Capabilities;

	public class WebStart extends AbstractStart implements CanRestart
	{
		

		
		override public function kill():void
		{
			super.kill();
		}

		

		
		public function WebStart(theStage:Stage, scriptName:String='')
		{
			//security();
			
			super(theStage,scriptName);

			/*if(!Capabilities.isDebugger){
			
				if(scriptName=='')scriptName = getScript();
				
				if(scriptName!='' && scriptName!=null){
					
					scriptLoad(scriptName);
				}
				else {
					//do nothing
					//XperimentMessage.message(theStage, "devel error: Xperiment is not being run from the cloud, and you have not provided the name of your script in the primary class");
				}
			}
			
			else{*/
				if(scriptName!='' && scriptName!=null){
					scriptLoad(scriptName);
				}
			//}
		}
		
		private function security():void
		{
			if(ExternalInterface.available){
				var currentUrl:String = ExternalInterface.call("window.location.host.toString");
				if(currentUrl.indexOf('xpt.mobi')!=-1 || currentUrl=='null'){
					Security.loadPolicyFile("https://www.xpt.mobi/crossdomain.xml");
				}
			}
		}		

		
		public function getScript():String
		{

			var scriptUrl:String;
			if(	theStage.loaderInfo.parameters.hasOwnProperty('studyUrl') && theStage.loaderInfo.parameters.hasOwnProperty('scriptName')	){
				scriptUrl=theStage.loaderInfo.parameters['studyUrl'] + theStage.loaderInfo.parameters['scriptName'];
			}
			else{
				XperimentMessage.message(theStage, "Afraid your Xperiment Script cannot be loaded from the cloud as cloudUrl or studyName or both have not been provided");
			}
			
			return scriptUrl;
		}
		
		
	}
}