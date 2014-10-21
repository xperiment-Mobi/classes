package com.xperiment.live
{

	import com.reyco1.multiuser.data.MessageObject;
	import com.reyco1.multiuser.data.UserObject;
	import com.reyco1.multiuser.filesharing.P2PSharedObject;
	import com.xperiment.P2P.utils.Stimuli_ByteArray;
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.runner.runner;
	
	import flash.display.Stage;

	public class PeerLive extends AbstractLive
	{
		static private var peer:PeerLive;
		static public var findStudiesPeer:FindStudiesPeer;
	
		private var stimuli:Object;
		private var script:XML;
		private var requestedAlreadyToRunStudy:Boolean = false;
		private var exptBoss:UserObject;
		private var studyRunning:Boolean = false;
		private var endStudy:Boolean = false;
		private var runStudyLive:RunStudyLive;
		
		
		public function PeerLive(theStage:Stage,foyer:Boolean)
		{
			super(theStage,foyer);
		}
		
		override protected function setupLive():void
		{
			super.setupLive();
			connection.onChatMessage = exptCommands;
		}
		
		
		private function exptCommands(details:MessageObject):void{
			
			var message:Array = details.text.split(SPLIT);
			
			
			//trace(111111,connection.myUser.address,details.destination,connection.myUser.address == details.destination,message[0])
			trace("receivedd this messaaaaage",message[0],message[1],connection.myUser.address == details.destination, details.destination == null,connection.myUser.address ,details.destination);
			if(connection.myUser.address == details.destination || details.destination == null){
		
			
				
				switch(message[0]){
					case BOSS_DEVICE:
	
						for each(var user:UserObject in connection.userArray){
	
							if(user.address==details.sender){
								exptBoss=user;
								
								break;
								
							}
						}
						if(!exptBoss)throw new Error();
		
						break;
					
					case START_STUDY:
						runStudy();
						break;
					
					case FINISH_STUDY:
						if(runStudyLive && endStudy==false){
							endStudy=true;
							runStudyLive.endStudy();
						}
						break;
			
					case NEXT_TRIAL:

						var trial:String = message[1];
						if(trial.indexOf(UNIQUE)!=-1)	trial="";
						
						if(runStudyLive)runStudyLive.nextTrial(trial);
						break;
					
					default: throw new Error("do not know this command:"+message[0]);
				}
			}
			
		}
		
		override protected function beginSetup():void
		{
		}
		
		private function peerSetup():void{
			//setupLive();
			//connection.connect( "User" + Math.round((Math.random() * 100)) );
		}
		
		public static function init(theStage:Stage):PeerLive
		{
			if(!peer){
				peer ||= new PeerLive(theStage, true);
				findStudies(theStage);
			}
			return peer;
			
		}
		
		private static function findStudies(theStage:Stage):void
		{
			findStudiesPeer = new FindStudiesPeer(theStage,true,studyFound);
		}
		
		public static function studyFound(details:Object):void{
			//exptID, password,studyName
			details.command = "expt added";
			peer.commsUI(details);
		}
	
		override public function buttonPressed(data:Object):void
		{
			
			
		}
		
		public function linkToStudy(name:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		override public function fromUI(obj:Object):void{
			switch(obj.command){
				case "study selected":
					findStudiesPeer.kill();
					expt = obj.exptID;
					setupLive();
					connect();
					peer.commsUI({command:"closeUI"});
					break;
				case "reset comms":
					findStudiesPeer.kill();
					findStudies(theStage);
					break;
				
				//requestedAlreadyToRunStudy
				default: throw new Error();
			}
		}
		
		override protected function handleConnect(user:UserObject):void{
			super.handleConnect(user);
			connection.session.fileSharer.startReceiving();
		}
		
		override protected function handleFileReceived( fileObject:P2PSharedObject ):void
		{
			
			var stimuli_bytearray:Stimuli_ByteArray = new Stimuli_ByteArray();
			stimuli_bytearray.bytearrayToStim(fileObject.data);
			stimuli=stimuli_bytearray.toReceive_imgLibrary;
			stimuli_bytearray.kill();
			stimuli_bytearray=null;
			
			connection.sendChatMessage(DOWNLOADED_STIMULI,exptBoss);
			peer.commsUI({command:"downloaded stimuli"});
			if(!stimuli.hasOwnProperty('script.xml'))throw new Error();
			script = stimuli['script.xml'];	
			delete stimuli['script.xml'];
			
			if(requestedAlreadyToRunStudy==true){
				runStudy();
			}
			
		}
		
		private function runStudy():void
		{
			if(stimuli){
			theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.GIVE_RUNNER,passRunner));
			studyRunning=true;
			}
			requestedAlreadyToRunStudy=true;
		}
		
		private function passRunner(run:runner):void{
			trace("given runner");
			
			runStudyLive = new RunStudyLive(theStage, script, stimuli, run, this);
			
		}
		
		public function sendTrialResults(details:Object):void
		{
			connection.sendChatMessage(details.toString(),exptBoss);
		}
	}
}


import com.reyco1.multiuser.data.MessageObject;
import com.xperiment.live.AbstractLive;

import flash.display.Stage;

class FindStudiesPeer extends AbstractLive{
	
	private var studyFound:Function;
	private var list:Object = {};
	
	public function FindStudiesPeer(theStage:Stage,foyer:Boolean, studyFound:Function)
	{
		this.studyFound = studyFound;
		super(theStage,foyer);
		connection.onChatMessage = chatMessage;
	}
	

	
	private function chatMessage(details:MessageObject):void{
		
		if(details.destination == connection.myUser.address){
			var obj:Object = studyDetails(details.text);
			studyFound(obj);
		}
		else trace("WEIRD");
	}	
	
	private function check(selected:String,password:String):void{
		
	}
	
	
}