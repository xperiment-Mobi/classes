package com.xperiment.make.comms
{
	import com.xperiment.make.comms.services.External_JS_Interface;
	import com.xperiment.make.comms.services.iExternal_JS_Interface;
		

	public class Communicator
	{

		public static var _backlog:Array;
		public static var _linked:Boolean = false;
		public static var commandF:Function;
		
		public static var external_JS_Interface:iExternal_JS_Interface
		
		private static var JSFunctName:String = 'toJS';
		
		
		//once instantiated, always needed
		/*public static function kill():void
		{
			_backlog=null;
			_linked=false;
			external_JS_Interface = null;		
		}*/
		
		public static function setup():void
		{
			//below null is for testing purposes
			if(external_JS_Interface==null)external_JS_Interface= new External_JS_Interface;
			if(_linked == true) throw new Error("devel error; this function should only be called once");
			
			external_JS_Interface.addCallback("toAS3",toAS3)
			external_JS_Interface.call("toJS",'linkup','')
		}
		
			
		//receiver function
		public static function toAS3(what:String, data:*):void{
			if(what=='linkedup' && data=='') {
				_runBacklog();
				}
			else{ //only pass interesting stuff along
				//trace(what,data)
				commandF(what,data);
			}
		}
		
		/*private static function toJS(what:String, data:String):void{
			
			if(_linked)external_JS_Interface.call("toJS",what,data);
			else throw new Error("attempted communication with JS before link established");
		}*/
			
 
		//can pass vars anytime as, if comms not established, stored and then run when established via the runBacklog command.
		public static function pass(what:String, data:*):void
		{
			//XperimentMessage.message(theStage,'link-iii: '+what+" "+data.toString());
			if(_linked==false){
				if(!_backlog)_backlog=[];
				var push:uint = _backlog.push({what:what,data:data});
			}
			else{
				external_JS_Interface.call(JSFunctName,what,data);
			}
			
		}
		
		public static function _runBacklog():void
		{
			_linked=true;
			if(_backlog!=null){
				for each(var item:Object in _backlog){

					pass(item.what, item.data);
				}
			}
			_backlog=null;
		}	
		

	}
}