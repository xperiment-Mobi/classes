package com.xperiment.make.comms.services
{

	public interface iExternal_JS_Interface
	{
		function addCallback(as3FunctionName:String, toAS3:Function):void	
		
		function call(jsFunction:String, what:String, to:*):void
			
	}
}