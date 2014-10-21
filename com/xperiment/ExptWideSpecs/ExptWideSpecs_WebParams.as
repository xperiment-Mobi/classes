package com.xperiment.ExptWideSpecs
{	
	import flash.external.ExternalInterface;

	
	public class ExptWideSpecs_WebParams
	{
		
		
		public static function SET():void{
			
			var params:Object = ExptWideSpecs._ExptWideSpecs;
			
			var val:String = "not available";
			try{
				val = ExternalInterface.call("function(){return navigator.appVersion+'-'+navigator.appName;}");
			}
			catch(e:Error){
				
			}
			
			params.computer.browser = val;

			
			
			
			

		}
		
		
	}
}