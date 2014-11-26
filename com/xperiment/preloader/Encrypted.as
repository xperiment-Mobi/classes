package com.xperiment.preloader
{
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.Network.WebService;
	import flash.net.URLRequest;
	import flash.events.Event;

	public class Encrypted extends WebService
	{
		
		static private var service:WebService;
		static public var key:String;
		
		static public function getKey(callBack:Function):void
		{
			
			
			var url:String = ExptWideSpecs.encryptKeyLoc+ExptWideSpecs.IS('one_key');
			trace(url,222)
			var xmlURLReq:URLRequest=new URLRequest(url)
			xmlURLReq.contentType="text/xml";
			
			service = new Encrypted(url, successF,xmlURLReq);
			
			function successF(success:Boolean):void{
				trace(123,success,222,service.__myLog)
				callBack(key);
				service=null;
			}	
		}
		
		override protected function checkResponse(e:Event):void
		{
			var response:String = e.target.data;
			succeeded = response.indexOf("success")!=-1;
			
			if(	succeeded &&	!__calcKey(response)	){
				log("error retrieving key (was reported as 'success' but no key in response'")
				succeeded=false;
			}
			
			
			if(succeeded){
	
				log("      success retrieving key "+key);	
			}
			else log('error retrieving key: '+response)
			if(success)success(succeeded);
		
		}
		
		public function __calcKey(response:String):Boolean{
			var pos:int=response.indexOf("secret_key");
			if(pos==-1)	return false;
			var count:int=0;
			key='';
			for(var i:int=pos;i<response.length;i++){
				if(response.charCodeAt(i)==34)	count++;
				if(count>1 && response.charCodeAt(i)!=34)	key+=response.charAt(i);
				if(count>=3)	break;
			}
			return true;
		}
		
		
		public function Encrypted(phpLocation:String, success:Function,xmlURLReq:URLRequest) {
			super(phpLocation, success, xmlURLReq);
		}
		
		

	}
}