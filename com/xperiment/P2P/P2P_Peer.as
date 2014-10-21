package com.xperiment.P2P
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.P2P.components.P2P_Event;
	import com.xperiment.P2P.runP2PstudyHelpers.RunP2P_study;
	import com.xperiment.P2P.service.P2PService_events;
	import com.xperiment.P2P.service.P2PService_peer;
	import com.xperiment.P2P.utils.Stimuli_ByteArray;
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.runner.runner;
	
	import flash.display.Stage;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class P2P_Peer extends Abstract_P2P
	{
		public static var static_p2p_peer:P2P_Peer;
		
		
		public var DETERMINE_STUDY:Dictionary = new Dictionary;
		public var SETUP_STUDY:Dictionary = new Dictionary;
		public var RUN_STUDY:Dictionary = new Dictionary;
		
		
		public static var CONNECT_TO_STUDY:String = "get study materials";
		
		public var studies:Array = [];
		
		private var script:XML;
		private var stimuli_bytearray:Stimuli_ByteArray;
		private var runStudy:RunP2P_study;
		private var requestedAlreadyToRunStudy:Boolean = false;
		private var stimuli:Object;
		private var studyRunning:Boolean = false;
		private var study:String;
		private var endStudy:Boolean=false;
		private var connectedToStudy:Boolean = false;
		private var expt_id:String;
		
		override public function kill():void{
			//DETERMINE_STUDY=null;
			//RUN_STUDY=null;
			//super.kill();
			//want to keep this alive
		}
		
		public static function init(nam:String,theStage:Stage):P2P_Peer
		{
			if(static_p2p_peer == null)static_p2p_peer= new P2P_Peer(nam,theStage);
			return static_p2p_peer;
			
		}
		
		public function P2P_Peer(nam:String,theStage:Stage){
			this.name=nam;
			super(nam, theStage);
		}
		
		override public function createConnection():void
		{
			
			service = new P2PService_peer(name,'',true);
			listener(true);
		}
		
		
		public function linkToStudy(study:String):void
		{
			trace("linking to Study");
			changeState("SETUP_STUDY");
			this.study=study;
			listener(false);
			service.kill();
			
			for(var i:int=0;i<studies.length;i++){
				if(studies[i].studyName==study){
					expt_id = studies[i].expt_id;
				}
			}
			
			for(i=0;i<studies.length;i++){studies[i] = null;}
			studies=null;
			
			service = new P2PService_peer(name,study,true);
			listener(true);
		}
				

		
		
		override public function setupStates():void
		{	
					
			START[P2PService_events.CONNECTED] = function(obj:Object):void{
				trace('peer:',"connected to a boss");
			}				
				
			START[P2PService_events.PEER_REMOVED] = function(obj:Object):void{
			}
			
			START[P2PService_events.STUDY_META] = function(obj:Object):void{
				trace('peer:',"was given message", obj.text);
				
				var arr:Array = obj.text.split(SEP);
				if(arr.length==3){
					studies.push({studyName:arr[0],password:arr[1],expt_id:arr[2]});
					dispatch(HERE_LIST_STUDIES,studies);
				}
			}
				

			SETUP_STUDY[P2PService_events.CONNECTED] = function(obj:Object):void{
				
				if(connectedToStudy==false){
					connectedToStudy=true;
					trace('peer:',"connected to Experiment");
					dispatch(P2P_Event.PEER_MESSAGE,P2P_Event.__CONNECTED_TO_EXPT);
					
					service.requestExptFile();
					
					/*var success:Boolean = false;
					for each(var s:Object in studies){
						if(s.studyName==study){
							service.requestStim(s);
							success=true;
							break;
						}
					}
					if(success==false)throw new Error("could not find study info!");*/
				}
				
				//service.sendCommand(GIVE_EXPT_STUFF);
				//trace(1111,service._channel.sharedObjects.length,22222,service._channel.receivedObjects);
			}
			
			SETUP_STUDY[P2PService_events.FILE_LOADING] = function(obj:Object):void{
				dispatch(P2P_Event.PEER_MESSAGE,P2P_Event.__CONNECTED_TO_EXPT,"("+codeRecycleFunctions.roundToPrecision(int(obj),2)+"%)");
			}
				
			
			SETUP_STUDY[P2PService_events.FILE_LOADED] = function(obj:Object):void{
					
				
				//service.send

			
				stimuli_bytearray = new Stimuli_ByteArray();
				stimuli_bytearray.bytearrayToStim(obj as ByteArray);
				stimuli=stimuli_bytearray.toReceive_imgLibrary;
				stimuli_bytearray.kill();
				stimuli_bytearray=null;
				
				if(!stimuli.hasOwnProperty('script.xml'))throw new Error();
				script = stimuli['script.xml'];		
				delete stimuli['script.xml'];
				

				
				
				//loaderMax.giveP2Pobj(stimuli_bytearray.toReceive_imgLibrary);				
				//trace("script:", Boolean(script),'data:',Boolean(stimuli_bytearray),22);
				
				dispatch(P2P_Event.PEER_MESSAGE,P2P_Event.__FILE_LOADED);
				trace('peer: all experiment files loaded');
				changeState('RUN_STUDY');
				if(requestedAlreadyToRunStudy==true){
					RUN_STUDY[COMMENCE_STUDY](null);
				}
						
			}

			SETUP_STUDY[COMMENCE_STUDY] = function(obj:Object):void{
				//if(obj)expt_id=obj.toString();
				requestedAlreadyToRunStudy=true;
			}
				

			
			RUN_STUDY[P2PService_events.CONNECTED] = function(obj:Object):void{
			}
			
			RUN_STUDY[P2PService_events.FILE_LOADED] = function(obj:Object):void{
			}
				
				
			
			RUN_STUDY[COMMENCE_STUDY] = function(obj:Object):void{
				//if(obj)expt_id=obj.toString();
				
				if(studyRunning==false){
					theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.GIVE_RUNNER,passRunner));
					studyRunning=true;
				}
			}
			
			RUN_STUDY[END_STUDY] = function():void{
				if(runStudy && endStudy==false){
					endStudy=true;
					runStudy.endStudy();
				}
			}
			
			RUN_STUDY[NEXT_TRIAL] = function(obj:Object):void{		
				if(runStudy)runStudy.nextTrial(obj.data.toString());
			}
			
		}
		
		
		private function passRunner(run:runner):void{
			trace("given runner");
			runStudy = new RunP2P_study(theStage, script, stimuli, run, service as P2PService_peer,study,expt_id);
			
		}
	}
}