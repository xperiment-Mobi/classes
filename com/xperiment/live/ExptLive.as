package com.xperiment.live
{
	import com.projectcocoon.p2p.util.FileUtil;
	import com.reyco1.multiuser.data.MessageObject;
	import com.reyco1.multiuser.data.UserObject;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.P2P.P2P_grandResults;
	import com.xperiment.P2P.service.Peers;
	import com.xperiment.P2P.utils.Stimuli_ByteArray;
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.preloader.PreloadStimuli;
	
	import flash.display.Stage;

	public class ExptLive extends AbstractLive
	{
	
		private var stimuli_byteArray:Stimuli_ByteArray;
		private var grandResults:P2P_grandResults;
		private var start:Boolean = false;
		private var callBackOnInitF:Function;
		private var peers:Peers = new Peers;
		private var sharedYet:Boolean=false;

		
		public function ExptLive(studyName:String,theStage:Stage):void{
			expt=EXPT+ExptWideSpecs.getSJuuid();
			grandResults = new P2P_grandResults();
			
			super(theStage);
			var graphicsHack:GraphicsHack = new GraphicsHack(theStage);
			grandResults.ping = graphicsHack.ping;
		}
		

		
		private function exptCommands(details:MessageObject):void{
			
			var message:Array = details.text.split(SPLIT);	
			//trace("expt device:",connection.myUser.address,details.destination,connection.myUser.address == details.destination,message[0])

			if(connection.myUser.address == details.destination){
	
				switch(message[0]){
					case TRIAL_RESULTS:						
						receivedResults(getID(details.sender),message[1],message[2]);
						break;
					case DOWNLOADED_STIMULI:
						peers.addMessage(getID(details.sender),"✓");
						commsUI({command:"update sj list",peers:peers})
						break;
					default: throw new Error();
				}
			}
		}
		
		private function receivedResults(sender:String, results:String, trialNum:String):void
		{
			peers.addMessage(sender,"trial#: "+trialNum);
			commsUI({command:"update sj list",peers:peers})
			if(results.length>0)	grandResults.giveData(sender,XML(results))
		}
		
		private function getID(info:String):String{
			for each(var user:UserObject in connection.userArray){
				if(user.address==info){
					return user.id;
				}
			}
			return ''
		}
		
		override public function fromUI(obj:Object):void{
			switch(obj.command){
				
				case AbstractLive.START_STUDY:
					start=true;
				case AbstractLive.NEXT_TRIAL:
				case AbstractLive.FINISH_STUDY:
				connection.sendChatMessage(obj.command+SPLIT+UNIQUE+int(Math.random()*100000));
					break;
				
				default: throw new Error();
			}
		}
		
		override protected function setupLive():void
		{
			super.setupLive();
			connection.onUserAdded 		= handleUserAdded;
			connection.onChatMessage 	= exptCommands;
			connection.onUserRemoved    = handleUserRemoved;
		}
		
		// method should expect a UserObject
		protected function handleUserAdded(user:UserObject):void				
		{
			//trace("send bonjour",	user.address);
			connection.sendChatMessage(BOSS_DEVICE,user);
			if(start)	connection.sendChatMessage(AbstractLive.START_STUDY,user);
			//trace("user added:",user.id);
			peers.add(user.id);
			commsUI({command:"update sj list",peers:peers})
			
		}
		
		protected function handleUserRemoved(user:UserObject):void{
			peers.remove(user.id);
			commsUI({command:"update sj list",peers:peers})
		}
		
		override protected function handleConnect(user:UserObject):void{
			var e:GlobalFunctionsEvent = new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.P2P_GIVE_EXPT_STUFF,transmitScript);
			theStage.dispatchEvent(e);
			super.handleConnect(user);
		}
		
		
		public function transmitScript(script:XML,preload:PreloadStimuli):void
		{	
			
			for each(var trial:XML in script..*.(name()=="addLive").parent()){
				delete trial.parent().children()[trial.childIndex()];		
			}
			
			if(sharedYet==false){
				sharedYet=true;
				if(!stimuli_byteArray){
					if(preload){
						
						if(preload.progress()==1)	preload.giveStimuli_to_P2PExpt(needStimuli); //potentially non-synchronous so needs a function to call when ready
						
						else{
							trace("not all loaded");
							preload.linkUp(onAllLoaded,null,null);
							
							function onAllLoaded(bytes:Number):void{
								preload.giveStimuli_to_P2PExpt(needStimuli)
							}
						}
					}
				}
				else needStimuli(null);
				
				function needStimuli(stim:Array):void{					
					if(!stimuli_byteArray)composeStimuliByteArray(stim);
					stimuli_byteArray.saveXML('script.xml',script);
					
					//var shaObj:P2PSharedObject = P2PSharedObject.generate(stimuli_byteArray.);
					connection.sendP2Pfile(stimuli_byteArray.bytearray());
				}	
			}
		}
		
		private function composeStimuliByteArray(stim:Array):void{
			
			stimuli_byteArray = new Stimuli_ByteArray;
			var type:String;
			
			for(var name:String in stim){
				var hackedName:String = name;
				if(name.indexOf("www.xpt.mobi")==-1)	type = name.split(".")[1].toLowerCase();
				else{
					var arr:Array = name.split("/").reverse();
					var arr2:Array= arr[0].toLowerCase().split(".")
					type = arr2[1];
					hackedName = arr[2]+"/"+arr2[0]+"."+arr2[1];
				}
				trace(name,hackedName,232232,arr,stim[name])
				var file:FileUtil;
				
				switch(type){
					case "xml":
						stimuli_byteArray.saveXML(hackedName, stim[name]);
						break;
					case "jpg":
					case "png":
						stimuli_byteArray.saveImage(hackedName,stim[name]);
						break;
					default: throw new Error("P2P error: cannot transmit this sort of file yet: "+type+" (stim name:"+name+")");
				}			
			}
		}
	}
}