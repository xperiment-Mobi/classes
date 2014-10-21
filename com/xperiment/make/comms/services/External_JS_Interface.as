package com.xperiment.make.comms.services
{
	import flash.external.ExternalInterface;
	
	public class External_JS_Interface implements iExternal_JS_Interface
	{
		
		public function addCallback(as3FunctionName:String,toAS3:Function):void{

			if (ExternalInterface.available) {
				try{
					ExternalInterface.addCallback(as3FunctionName,toAS3)
				}
				catch(e:Error){
					//trace(as3FunctionName,222,toAS3)
					throw new Error("External JS interface not available");
				}
				catch(e:SecurityError){
					throw new Error("External JS Security error");
				}
			}
		}
		
		public function call(jsFunction:String,what:String, to:*):void{
			try{
				ExternalInterface.call(jsFunction,what,to);
			}
			catch(e:Error){
				
				//throw new Error("External JS interface not available");
			}
		}
		
	}
}

