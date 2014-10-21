package com.xperiment.Results
{
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.Results.services.AccessPastResults;

	public class GiveServerCondition extends AccessPastResults
	{
		
		
		override public function init(expt_id:String,gateway:String,e:Function):void
		{
			throw new Error('should not be called');
		}
		
		
		override public function onSuccess(tempResult:Object):void
		{
			trace('updated server');
			this.kill();
		}
		
		override public function onFail():void
		{
			trace('failed to updated server');
			this.kill();
		}
		
		public function update(expt_id:String,gateway:String,condition:String):void{			
			__init(gateway)	
			
			var param:Object = {};
			param.info = {};
			param.info.expt_id = expt_id;
			param.info.uuid = ExptWideSpecs.getSJuuid();
			param.info.betweenSJsID = condition;
			//trace(123);
			//__send(param, SoapService.SEND_COND_RAN);
		}
	}
}

