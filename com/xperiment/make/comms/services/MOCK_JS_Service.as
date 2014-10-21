package com.xperiment.make.comms.services
{

	public class MOCK_JS_Service implements iJS_Service
	{
		private  var _linked:Boolean;
		private  var _externalReceiver:Function;
		private  var _linkedNotifier:Function;

		public function set linked(value:Boolean):void
		{
			_linked = value;
			if(_linked==true)_linkedNotifier();
		}
		
		public function get linked():Boolean
		{
			return _linked;
		}

		public function setup(externalReceiver:Function,_linkedNotifier:Function):void
		{
			_externalReceiver=externalReceiver;
			if(_linked == true) throw new Error("devel error; this function should only be called once");
			var s:MOCK_ExternalInterface
			if (MOCK_ExternalInterface.available) {
				try{
					MOCK_ExternalInterface.addCallback("toAS3",toAS3)
					MOCK_ExternalInterface.call("toJS",'linkup','')
				}
				catch (e:Error){
					throw new Error("External JS interface not available");
				}
			}
			else{
				trace("ExternalInterface not available: you are not running this in a browser window?");
			}
		}
		
		public function toJS(what:String, data:String):void{
			
			if(_linked)MOCK_ExternalInterface.call("toJS",what,data);
			else throw new Error("attempted communication with JS before link established");
		}
		
		//receiver function
	
		public function toAS3(what:String, data:String):void{
			if(what=='linkedup' && data=='') _linked=true;
			else{ //only pass interesting stuff along
				_externalReceiver(what,data);
			}
		}
		
		
		
	}
}