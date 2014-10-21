package com.Start.MobilePlayerStart.services
{

	import com.xperiment.Results.services.SoapService;
	import com.Start.MobilePlayerStart.ExptInfo;

	public class GetStudies
	{
		private static var soap:SoapService;
		private static var giveF:Function;
		
		public function GetStudies()
		{
		}
		
		public static function DO(f:Function):void
		{
			giveF=f;
			var studies:Vector.<String>;
			
			soap = new SoapService;
			
			soap.send({pass:'int(Math.random()*1000000)'},SoapService.GET_STUDIES,success);
			

		}
		
		private static function success(was:Boolean):void{
		
			if(was){
				var expts:XML=XML(soap.result);
		
				var exptsVect:Vector.<ExptInfo> = new Vector.<ExptInfo>;

				
				for each(var child:XML in expts.children()){
					exptsVect[exptsVect.length]= new ExptInfo(child);
				}
				giveF(exptsVect);
			}
			
			else{
				giveF(null);
				trace('failed');
			}
			
			soap.kill();
		}
	}
}