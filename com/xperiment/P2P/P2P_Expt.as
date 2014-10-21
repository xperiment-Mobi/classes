package com.xperiment.P2P
{
	
	import com.projectcocoon.p2p.util.FileUtil;
	import com.xperiment.P2P.components.P2P_Event;
	import com.xperiment.P2P.service.P2PService_events;
	import com.xperiment.P2P.service.P2PService_expt;
	import com.xperiment.P2P.utils.Stimuli_ByteArray;
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.preloader.PreloadStimuli;
	import flash.display.Stage;
	import com.xperiment.P2P.service.Peers;
	
	public class P2P_Expt extends Abstract_P2P
	{
		public static var LOADED_STIM:String = "loaded stimuli";
		
		private var sharedYet:Boolean=false;

		private var studyName:String;
		private var SCRIPT:String="script.xml";
		
		private var preload:PreloadStimuli;
		
		private var stimuli_byteArray:Stimuli_ByteArray;
		private var grandResults:P2P_grandResults;
		private var start:Boolean = false;
		private var callBackOnInitF:Function;
		private var peers:Peers;
		
		public function P2P_Expt(nam:String,theStage:Stage,studyName:String,callBackOnInitF:Function)
		{
			this.studyName=studyName;
			this.callBackOnInitF=callBackOnInitF;
			grandResults = new P2P_grandResults();
			super(nam,theStage);		
		}
		
		public function studyDetails():Array{
			return [studyName,''];
		}
		
		override public function createConnection():void
		{
			service = new P2PService_expt(studyName,studyName,true);
			this.peers=service.peers;
			
		}
		
		override public function setupStates():void
		{
			this.boss=true;
			
			START[P2PService_events.CONNECTED] = function(obj:Object):void{
				if(connected==false){	
					trace('expt:',"connected");
					if(callBackOnInitF){
						callBackOnInitF();
						callBackOnInitF=null;
					}
					connected=true;
					var e:GlobalFunctionsEvent = new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.P2P_GIVE_EXPT_STUFF,transmitScript);
					theStage.dispatchEvent(e);
				}
			}

			START[P2PService_events.PEER_ADDED] = function(obj:Object):void{	
				trace('expt:',"peer device added");
				dispatch(HERE_LIST_CLIENTS,service.getPeers());
				if(start)service.sendMessage(COMMENCE_STUDY,obj.toString());
			}	
			
			START[P2PService_events.PEER_REMOVED] = function(obj:Object):void{
				trace('expt:',"peer device removed");
				dispatch(HERE_LIST_CLIENTS,service.getPeers());
			}
			
			
			//START[abstract_P2P_service.FILE_LOADED] = function(obj:Object,e:ObjectMetadataVO):void{
			//	trace('expt:',"experiment file loaded");
			//}
			
			
			START[P2PService_events.EXPT_DATA] = function(obj:Object):void{
				
				
				
				var sj:String = obj.name;
				var trial:String= obj.info.trialNum;
				var results:String=obj.info.trialResults;
	
				peers.trialChange(sj, trial);
				dispatch(HERE_LIST_CLIENTS,service.getPeers());
				
				if(results.length!=0)grandResults.giveData(sj,XML(results))
			}
		}
		
		
		public function buttonPressed(data:Object):void
		{
			var button:String = data.button;
			
			switch(button){
				case P2P_Event.START_STUDY:
					trace("sent commence study command");
					this.start=true;
					service.sendMessage(COMMENCE_STUDY);
					break;
				case P2P_Event.FINISH_STUDY:
					trace("sent end study command");
					service.sendMessage(END_STUDY);
					break;
				case P2P_Event.NEXT_TRIAL:
					trace("sent next trial study command (goto "+data.trial.toString()+")");
					service.sendMessage(NEXT_TRIAL,null,data.trial.toString());
					break;
				default:
					throw new Error;
			}
		}
		
		
		//called from Runner only

		public function transmitScript(script:XML,preload:PreloadStimuli):void
		{	
			for each(var trial:XML in script..*.(name()=="addP2P").parent()){
				delete trial.parent().children()[trial.childIndex()];		
			}

			if(sharedYet==false){
				sharedYet=true;
				if(!stimuli_byteArray){
					if(preload){
						
						preload.giveStimuli_to_P2PExpt(needStimuli); //potentially non-synchronous so needs a function to call when ready
					}
				}
				else needStimuli(null);
				
				function needStimuli(stim:Array):void{					
					if(!stimuli_byteArray)composeStimuliByteArray(stim);
					stimuli_byteArray.saveXML('script.xml',script);
					service.shareFile(stimuli_byteArray.bytearray(),'exptPackage');
					
					dispatch(P2P_Event.LOADED_STIM,null);
				}	
			}
		}
			
		
		private function composeStimuliByteArray(stim:Array):void{
			
			stimuli_byteArray = new Stimuli_ByteArray;
			var type:String;
			
			for(var name:String in stim){
				type=name.split(".")[1].toLowerCase();
				
				var file:FileUtil;
				
				switch(type){
					case "xml":
						stimuli_byteArray.saveXML(name, stim[name]);
						break;
					case "jpg":
					case "png":
						stimuli_byteArray.saveImage(name,stim[name]);
						break;
					default: throw new Error("P2P error: cannot transmit this sort of file yet: "+type);
				}			
			}
		}
		
		public function getServiceID():String
		{
			return service.getPeerId();
		}
	}
}