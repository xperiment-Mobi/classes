package com.xperiment.Network{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	public class sendToPHP extends WebService{
		

		
		public function sendToPHP(phpLocation:String, results:String, success:Function) {
			var xmlURLReq:URLRequest=new URLRequest(phpLocation)
			xmlURLReq.data=results;
			xmlURLReq.contentType="text/xml";
					
			super(phpLocation,success,xmlURLReq);
		}
		
		override protected function checkResponse(e:Event):void
		{
			var variables:URLVariables = new URLVariables( e.target.data );
			var response:String = variables.success;
			
			if(response.indexOf("saved")!=-1){
				succeeded=true;
				if(success)success(true);
				log("      success saving data");	
			}
			else{
				succeeded=false;
				log('error saving data: '+response)
				if(success)success(false)	
			}
		}
		

	}
	
}
