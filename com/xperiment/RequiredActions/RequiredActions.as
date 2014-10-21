package com.xperiment.RequiredActions
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class RequiredActions extends Sprite
	{
		
		private var requiredActions:Vector.<RequiredAction>;
		private var FailureFsArr:Array;
		private var grandSuccessArr:Array;
		private var grandFailureArr:Array;
		private var timeoutTimer:Timer;
		private var finished:Boolean = false;
		private var defaultTimeout:int = 500;
		private var grandTimeOut:int = 5000;
		private var requiredActionsStartLaterDict:Dictionary;
		private var failMessage:Array;
		
		public var success:Boolean = 	true;
		
		public function count():int{
			return requiredActions.length;
		}
		
		public function fail_info():String{
			if(!failMessage)return '';
			return failMessage.join("\n");
		}
		
		public function composeFailMessage(message:String):void{
			failMessage ||=[]
			failMessage.push(message);
		}
		
		public function kill():void
		{
			if(timeoutTimer && requiredActions){
				timeoutTimer.stop();
				timeoutTimer.removeEventListener(TimerEvent.TIMER,grandTimedOutF);
				
				
					for(var i:int=0;i<requiredActions.length;i++){
						requiredActions[i].kill();
					}
				requiredActions=null;
			}
			//else throw new Error;
		}
		
		//public function RequiredActions(successArr:Array, failureArr:Array,timeout:int=-1){
		public function RequiredActions(timeout:int=-1, params:Object=null){	

			if(params==null)params = {};
			
			if(timeout!=-1)this.grandTimeOut = timeout;
			
			if(params.success) this.grandSuccessArr=params.success;
			if(params.fail)   this.grandFailureArr=params.fail;
			if(params.defaultTimeout) defaultTimeout = params.actionTimeout;

			requiredActions = new Vector.<RequiredAction>;
		}
		
		
		public function start():void{
			for(var i:int=0;i<requiredActions.length;i++){
				if(requiredActions[i].wait == false){
					requiredActions[i].start();
				}
			}
			timeoutTimer= new Timer(grandTimeOut,1);
			timeoutTimer.addEventListener(TimerEvent.TIMER,grandTimedOutF);
			if(!finished)timeoutTimer.start();
			
		}
		
		private function grandTimedOutF(event:TimerEvent):void
		{
			for each(var requiredAction:RequiredAction in requiredActions){
				if(requiredAction.finished==false){
					requiredAction.successFail(false);
				}
			}
			
			grandSuccessFail(false);
			success=false;
		}
		

		private function grandSuccessFail(success:Boolean):void
		{
			if(success==false)this.success=false;
			finished=true;
			if(this.success){	
				runActions(grandSuccessArr, null,true);
			}
			else{
				runActions(grandFailureArr, null,false);
				
			}
			
			this.dispatchEvent(new Event(Event.COMPLETE));
			kill();
		}
		
		/*
		timeout
		params.actionF / name
		params.startNow
		params.retries
		params.succcessFs
		params.failFs
		*/
		//public function add(action:*, successArr:Array=null, failArr:Array=null, startNow:Boolean = true, timeout:int = -1):Function{
		public function add(timeout:int=-1, params:Object=null,nam:String=''):Function{
			if(timeout==-1)timeout = defaultTimeout;
			if(params==null)params = {};
			
			var requiredAction:RequiredAction = new RequiredAction(runActions,timeout);
			
			requiredAction.name=nam;
						
			if(params.action)	requiredAction.actionF= 	params.action;			
			if(params.success)	requiredAction.successArr=	params.success;
			if(params.fail)		requiredAction.failArr=		params.fail;
			if(params.wait)		requiredAction.wait=		params.wait;
			if(params.retries)	requiredAction.retries=		params.retries;
			if(params.name)		requiredAction.myName=		params.name;
			if(params.resetTimeronRetry)	requiredAction.resetTimeronRetry=		params.resetTimeronRetry;
			
			requiredActions[requiredActions.length]=requiredAction;
			
			if(requiredAction.wait==true){
				if(requiredAction.actionF){
					requiredActionsStartLaterDict ||= new Dictionary;
					requiredActionsStartLaterDict[requiredAction.actionF]=requiredAction;
				}
				else throw new Error("you have asked for an Action to run later but have not specifed an actual function to run {action:function_to_run}");
			}
			
			if(requiredAction.retries && requiredAction.actionF==null){
				throw new Error("you have asked for an Action to be run up to "+requiredAction.retries+" if it fails but have not have not specifed an actual function to run {action:function_to_run}");
			}

			////////////////////////////
			//anonymous function
			return      function(success:Boolean):void{
							requiredAction.successFail(success);
						}
			////////////////////////////
			////////////////////////////
			
		}
		
		private function runActions(fArr, requiredAction:RequiredAction,success:Boolean):void{
			if(fArr){
				
				for each(var action:Function in fArr){
					if(requiredActionsStartLaterDict && requiredAction!=null && requiredActionsStartLaterDict[action]!=undefined){
						
						(requiredActionsStartLaterDict[action] as RequiredAction).start();
					
					
					}
					else action();
					
				}
			}

			if(success==false)this.success=false;
			
			
			if(finished==false){
				//note, cannot combine with above success==false
				if(success==false)composeFailMessage(requiredAction.name);
				requiredActions.splice(requiredActions.indexOf(requiredAction),1);	
				
				if(requiredActions.length==0)grandSuccessFail(success);	
			}
		}
	}
}