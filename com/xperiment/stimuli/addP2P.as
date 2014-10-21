package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.P2P.Abstract_P2P;
	import com.xperiment.P2P.P2P_Foyer;
	import com.xperiment.P2P.P2P_Peer;
	import com.xperiment.P2P.components.P2P_Event;
	import com.xperiment.P2P.service.Peers;
	import com.xperiment.stimuli.primitives.P2P_UI.P2P_UI_Boss;
	import com.xperiment.stimuli.primitives.P2P_UI.P2P_UI_Peer;
	import flash.events.Event;

	public class addP2P extends object_baseClass
	{
		private var ui_peer:P2P_UI_Peer;
		private var ui_boss:P2P_UI_Boss;
		
		private var p2p:P2P_Peer;
		private var boss:P2P_Foyer;
		
		private static var HUB:String = "experiment hub"
		
		override public function setVariables(list:XMLList):void {
			setVar("boolean","boss",false);
			setVar("string","password",'abc');
			setVar("string","studyName","");
			setVar("boolean","autoStart",false);
		
			super.setVariables(list);
			
			if(getVar("boss")==true && getVar("studyName")=="")throw new Error("you must specify a study name when you are controlling a P2P study");
		}
		
		override public function kill():void{
			listeners(false);
			listeners_UI(false);
			if(ui_peer)ui_peer.kill();
			if(ui_boss)ui_boss.kill();
		}
		
		
		
		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			
			if(getVar("boss")==true){
				boss = new P2P_Foyer(ExptWideSpecs.getSJuuid(),theStage, getVar("studyName"),getVar("password"));				
			}
			else{
				p2p = P2P_Peer.init(ExptWideSpecs.getSJuuid(),theStage);				
			}
			listeners(true);

		}
		

		private function listeners(on:Boolean):void{
		
			if(boss || p2p){
				var f:String;
				
				if(on)	f="addEventListener";
				else	f="removeEventListener";
					
				if(boss){
					boss[f](Abstract_P2P.HERE_LIST_CLIENTS, peerL_hereListClients);
					//boss[f](P2P_Event.TRIAL_CHANGE,uiBoss_trial_change)
				}
				else{
					p2p[f](Abstract_P2P.HERE_LIST_STUDIES, peerL_hereListStudies);
					p2p[f](P2P_Event.PEER_MESSAGE,peerL_message);
				}
			}
		}
		
		
		private function peerL_message(e:P2P_Event):void{
			var message:String = e.data.toString();
			if(e.data2)message+=e.data2.toString();
			ui_peer.peerMessage(message);
		}
		
		private function peerL_hereListClients(e:P2P_Event):void{
			ui_boss.peerL_hereListClients(e.data as Peers);
			
		}
		
		private function peerL_hereListStudies(e:P2P_Event):void{
			ui_peer.peerL_hereListStudies(e.data as Array);
			
		}
		
		private function listeners_UI(on:Boolean):void
		{
			var f:Function;
			
			var fString:String;
			if(on)	fString='addEventListener';
			else	fString='removeEventListener';
			
			if(ui_peer){	
				f=ui_peer[fString];
				f(P2P_UI_Peer.RUN_STUDY,peer_runStudy);
			}
			else{
				f=ui_boss[fString];
				f(P2P_Event.BUTTON_PRESSED,uiBoss_button_pressed);
			}
		}
		
		/*private function uiBoss_trial_change(e:P2P_Event):void{
			
			ui_boss.trial_change(e.data.sj, e.data.trial);
		}*/
		
		private function peer_runStudy(e:P2P_Event):void{
			ui_peer.kill_initial_screen();
			ui_peer.start_linked_screen();
			p2p.linkToStudy(String(e.data));
		}
		
		private function uiBoss_button_pressed(e:P2P_Event):void{
			
			boss.buttonPressed(e.data);			
		}
	
		
		override public function RunMe():uberSprite {
			
			if(getVar("boss")==true){
				//this.ui = new P2P_UI_Boss_OLD(getVar("password"));
				ui_boss = new P2P_UI_Boss();
			}
			else{
				ui_peer = new P2P_UI_Peer();
			}
			
			listeners_UI(true);
			
			
			
			//ui.addEventListener(Event.COMPLETE,amBoss);
			if(ui_boss)pic.addChild(ui_boss);
			if(ui_peer)pic.addChild(ui_peer);
			
			super.setUniversalVariables();
			return pic;
		}
		
		
		
		
		
			
		
		
		
	}
}