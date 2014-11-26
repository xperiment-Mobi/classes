package com.xperiment.make.comms.services
{
	public class MOCK_ExternalInterface implements iExternal_JS_Interface
	{
		
		public var mockCallList:Array= [];
		public var mockCallBackList:Array = [];
		public var toAS3:Function;
		
		public function MOCK_ExternalInterface()
		{
		}
		
		public function addCallback(as3FunctionName:String, toAS3:Function):void
		{
			this.toAS3=toAS3;
			mockCallBackList.push({as3FunctionName:as3FunctionName,toAS3:toAS3});			
		}
			
		public function call(jsFunction:String, what:String, to:*):void
		{
			mockCallList.push({jsFunction:jsFunction,what:what, to:to})
			
		}
	}
}