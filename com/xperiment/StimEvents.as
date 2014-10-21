package com.xperiment
{
	import flash.utils.Dictionary;
	
	public class StimEvents
	{
		
		private var events:Dictionary;
		private var permittedEvents:Array = [];
		private var strictMode:Boolean = true;
		private var errorPrefix:String;
		private var nativeListeners:Array;

		public function error(err:String):void{
			throw new Error(errorPrefix+err);
		}
		
		
		public function StimEvents(peg:String,type:String,strictMode:Boolean=true):void{
			this.strictMode=strictMode;
			this.errorPrefix="Error with peg "+peg+" (type "+type+"): ";
		}
		
		public function registerEvents(events:Array):void{
			var pos:int;
			for(var i:uint=0;i<events.length;i++){
				pos=permittedEvents.indexOf(events[i]);
				if(pos==-1)permittedEvents.push(events[i]);
			}	
		}
		
		public function deRegisterEvents(unEvents:Array):void{
			var pos:int;
			for(var i:uint=0;i<unEvents.length;i++){
				pos=permittedEvents.indexOf(unEvents[i]);
				if(pos!=-1)permittedEvents.splice(i,1);
			}	
		}
		
		public function occured(what:String,params:Object=null):Boolean{
			if(strictMode && permittedEvents.indexOf(what)==-1) error("Problem: an event occured ("+what+") that was not preregisted (thus so probably a bug!)");
			if(events && events[what] != undefined){
				for(var i:uint=0;i<events[what].length;i++){
					events[what][i](params);
				}
				return true;
			}
			else return false;
		}
		
		public function listenFor(what:String, then:Function):void{
			if(strictMode && permittedEvents.indexOf(what)==-1) error("Problem: you asked to listen for an event to occur ("+what+") that never occurs for this object!");
			if(!events)events=new Dictionary
			if(events[what] == undefined) events[what]=[];
			events[what].push(then);
		}
		
		public function giveListenersFor(what:String):Array{
			return events[what];
		}
		
		public function countListeners():int{
			var i:int=0;
			for(var str:String in events)i++
			return i;
		}
		
		public function countListenersFor(what:String):int{
			if (events[what]==undefined) return 0;
			else return events[what].length;
		}
		
		public function listenKill(what:String):void
		{
			delete events[what];
		}
		
		public function killListeners():void
		{
			for(var str:String in events){
				delete events[str];
			}
			events = null;
		}
		
		public function kill():void{
			killListeners();
			permittedEvents=null;
			events=null;
		}
	}
}