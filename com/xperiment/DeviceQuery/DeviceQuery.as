package com.xperiment.DeviceQuery
{
	import com.xperiment.uuid;
	
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;

	public class DeviceQuery
	{
		public static var __memory:Memory_service;
		public static var sessionAlreadyExisted:Boolean;
		public static var device_id:String = 'unknown';
		
		private static var UUID:String = "uuid";
		private static var DEVICE_UUID:String = "device_uuid";
		private static var SCRIPT:String = "script";
		public static var EXPTPROPS:String = "exptProps";
		private static var TRIALORDER:String = "trialOrder";
		
		
		
		public static function init():void
		{
			if(Capabilities.isDebugger)	SharedObject.getLocal('xpt').clear();
			__memory = new Memory_service();
			initSessionUUID();
			initDeviceUUID();
		}
		
		private static function initDeviceUUID():void
		{
			var exists:Boolean = __memory.EXISTS(DEVICE_UUID);
			if(!exists){
				device_id = uuid.toString();
				__memory.SET(DEVICE_UUID,device_id);
			}
			else{
				device_id = __memory.GET(DEVICE_UUID);
			}
		}
		
		public static function getUUID():String{
			return __memory.GET(UUID);
		}
		
		public static function wipeSessionUUID():void{
			__memory.DELETE(UUID);
		}
		
		public static function wipe():void{
			__memory.mem.clear();
			__memory = null;
		}
		
		private static function initSessionUUID():void{
			var myUUID:String;
			if(checkExists()){
				sessionAlreadyExisted=true;
				myUUID = __memory.GET(UUID);
			}
			else{
				myUUID = uuid.toString();
				__memory.SET(UUID,myUUID);
			}
		}	
		
		private static function checkExists():Boolean{
			var count:int=0;
			var exists:Boolean;
			var report:Array = ["XptMemory debug list"];
			var requiredList:Array=[UUID,SCRIPT,EXPTPROPS,TRIALORDER]
			for(var required:String in requiredList){
				exists=__memory.EXISTS(required)
				if(exists) count++;
				else count--;
				report.push(required+" exists = "+exists);
			}
			if(Math.abs(count)!=requiredList.length)throw new Error(report.join("/n"));
			
			if(count<0)return false;
			return true;
		}
		
		public static function script(trialProtocolList:XML):void
		{
			__memory.SET(SCRIPT,trialProtocolList);
		}
		
		public static function getScript():XML
		{
			return __memory.GET(SCRIPT)
		}
	
		
		public static function exptProps():Object
		{
			// TODO Auto Generated method stub
			return __memory.GET(EXPTPROPS);
		}
		
		public static function updateExptProps(exptProps:Dictionary):void
		{
			// TODO Auto Generated method stub
			__memory.bulkSet(exptProps);
		}
		
		public static function getTrialOrder():Array
		{
			return __memory.GET(TRIALORDER);
		}
		
		public static function giveTrialOrder(trialOrder:Array):void
		{
			__memory.SET(TRIALORDER,trialOrder);			
		}
	}
}



import com.xperiment.DeviceQuery.DeviceQuery;
import flash.net.SharedObject;
import flash.utils.Dictionary;

class Memory_service{
	
	public var mem:SharedObject;
	
	public function Memory_service(){
		mem ||= SharedObject.getLocal('xpt');
	}
	
	public function EXISTS(what:String):Boolean{
		return mem.data.hasOwnProperty(what);
	}
	
	public function DELETE(what:String):void{
		mem.data[what]=null;
	}
	
	public function GET(what:String):*{
		return mem.data[what];
	}
	
	public function SET(what:String,to:*):void{
		mem.data[what] = to;
		mem.flush();
	}
	
	public function bulkSet(exptProps:Dictionary):void
	{
		if(mem.data.hasOwnProperty(DeviceQuery.EXPTPROPS)==false)mem.data.exptProps={};
		for(var key:String in exptProps){
			mem.data.exptProps[key]=exptProps[key];
		}
		mem.flush();
		
	}

}