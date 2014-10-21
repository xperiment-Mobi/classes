package com.xperiment.P2P
{
	import com.xperiment.P2P.components.P2P_Event;
	import com.xperiment.P2P.service.P2PService_events;
	import com.xperiment.P2P.service.abstractP2PService;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	

	public class Abstract_P2P extends Sprite
	{
		public var boss:Boolean =false;
		public var theStage:Stage;
		public var actions:Object;
		public var service:abstractP2PService;
		public var START:Dictionary = new Dictionary;
		public var connected:Boolean = false;
		
		
		public static var GIVE_SCRIPT:String = "give_script";
		public static var GIVE_LIST_STUDIES:String = "give_list_studies";
		public static var HERE_LIST_STUDIES:String = 'here_list_studies';
		public static var HERE_LIST_CLIENTS:String = "here_list_clients";
		public static var GIVE_EXPT_STUFF:String = "give experiment";
		
		public static var COMMENCE_STUDY:String = "commence study";
		public static var NEXT_TRIAL:String = "next trial";
		public static var END_STUDY:String = "end expt"
		
		public static var SEP:String = "<SEP>"
		
		public function Abstract_P2P(nam:String,theStage:Stage,wait:Boolean=false):void{
			this.name		= nam;
			this.theStage 	= theStage;
			setupStates();
			actions = START;
			
			if(wait==false)init();
				
		}
		
		public function init():void{
			createConnection();
			listener(true);
		}
		
		public function listener(ON:Boolean):void{
			if(ON)service.addEventListener(P2PService_events.GENERAL,serviveL);
			else service.removeEventListener(P2PService_events.GENERAL,serviveL);
		}
		
		protected function serviveL(e:P2PService_events):void
		{

			if(actions.hasOwnProperty(e.what)){
				actions[e.what](e.obj);
			}
				
			else if(e.what.indexOf(SEP)!=-1 && actions[P2PService_events.STUDY_META]!=undefined)actions[P2PService_events.STUDY_META]({text:e.what});
			else if(e.obj && e.obj.hasOwnProperty('text') && actions[e.obj.text]!=undefined){
				
				
				
				actions[e.obj['text']](e.obj);
			}
			else{
				
				trace("devel error: this action not present in "+this+" - "+e.what);	
			}
		}		
		
		public function setupStates():void{
			throw new Error("must override this");
			
		}
		
		public function changeState(state:String):void{
			if(this.hasOwnProperty(state)){
				actions = this[state];
				return;
			}
			throw new Error("devel error, unknown state");
			
		}
		
		public function createConnection():void
		{
			throw new Error("override this");
			
		}
		
		public function dispatch(name:String, data:Object,data2:Object=null):void{
			this.dispatchEvent(new P2P_Event(name,data,data2));
		}

		
		
		public function kill():void{
			listener(false);
			service.kill();
			START=null;
		}
		
	}
}