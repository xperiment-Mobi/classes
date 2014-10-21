package com.xperiment.P2P
{
	import com.xperiment.P2P.service.P2PService_boss;
	import com.xperiment.P2P.service.P2PService_events;
	
	import flash.display.Stage;
	

	public class P2P_Foyer extends Abstract_P2P
	{	
		//private static var p2p_static:P2P_Boss;
		
		public var studyName:String;
		public var password:String;
		
		private var expt:P2P_Expt;
		private var studyDetails:Array;
		
		override public function kill():void{
			this.removeChild(expt);
			expt.kill();
			super.kill();
		}

		public function P2P_Foyer(nam:String,theStage:Stage,_studyName:String,password:String):void{
			
			studyName	= _studyName + int(Math.random()*1000);
			this.password	= password;
			
			super(nam,theStage,true);
			
			function callBackF():void{
				init();
			}
			
			expt = new P2P_Expt('expt',theStage,this.studyName,callBackF);
			this.addChild(expt);
			
			
			
			//expt.addEventListener(P2P_Expt.LOADED_STIM,function(e:Event):void{
			//	expt.removeEventListener(e.type,arguments.callee);
			//	
			//	trace(1)
			//});
			
		}
		
		override public function createConnection():void
		{
			
			service = new P2PService_boss('boss','', true);
		}
		
		//private var once:Boolean=false;
		
		override public function setupStates():void
		{
			this.boss=true;
			

			START[P2PService_events.CONNECTED] = function(obj:Object):void{
				studyDetails = [studyName, password, expt.getServiceID()];
				service.sendMessage(studyDetails.join(SEP));
				trace('boss:',"connected")				
			}
				
			START[P2PService_events.PEER_ADDED] = function(obj:Object):void{
				trace('boss:',"peer added so sending files");
				service.sendMessage(studyDetails.join(SEP),obj.toString());
			}	
					
			START[P2PService_events.CLIENT_ADDED] = function(obj:Object):void{
				trace('boss:',"peer device added ("+obj+")");
				//dispatch(HERE_LIST_CLIENTS,service.getPeers());
			}
				
			START[P2PService_events.PEER_REMOVED] = function(obj:Object):void{
				trace('boss:',"peer device removed");
				//dispatch(HERE_LIST_CLIENTS,service.getPeers());
			}
	
		}
		


		public function buttonPressed(data:Object):void
		{
		/*	if(data.button==P2P_Event.START_STUDY){
				trace(123)
				service.kill();
			}*/
			expt.buttonPressed(data);	
		}
		

	
	}
}