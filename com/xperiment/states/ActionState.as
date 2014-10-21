package com.xperiment.states
{
	import flash.events.Event;

	public class ActionState
	{
		
		public var action:Function;
		public var successListener:String;
		public var failureListener:String;
		public var onSuccess:Vector.<ActionState>;
		public var onFailure:Vector.<ActionState>;
		public var boss:*;
		
		
		public function ActionState(boss:*)
		{
			this.boss=boss;
			boss.addEventListener(successListener,moveToSuccessState);
			boss.addEventListener(successListener,moveToFailureState);
			action();
		}
		
		public function moveToSuccessState(e:Event):void{
			
			removeListeners();
		}
		
		public function moveToFailureState(e:Event):void{
			
			removeListeners();
		}
		
		
		
		public function success(arr:Array):ActionState{
			onSuccess=vectorise(arr);
			return this;
		}
		
		public function failure(arr:Array):ActionState{
			onFailure=vectorise(arr);
			return this;
		}
		
			
		
		
		public function kill():void{
			if(boss.hasEventListener(successListener))boss.removeEventListener(successListener,moveToSuccessState);
			if(boss.hasEventListener(failureListener))boss.removeEventListener(successListener,moveToFailureState);
		}
		
		
		
		
		private function removeListeners():void{
			boss.removeEventListener(successListener,moveToSuccessState);
			boss.removeEventListener(successListener,moveToFailureState);
		}
		
		
		private function vectorise(arr:Array):Vector.<ActionState>
		{
			var v:Vector.<ActionState> = new Vector.<ActionState>;
			for(var i:int = 0;i<arr.length;i++){
				v[i]=arr[i];
			}
			return v;
		}	
	}
}