package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.live.BossLive;
	import com.xperiment.live.PeerLive;
	import com.xperiment.stimuli.primitives.P2P_UI.P2P_UI_Boss;
	import com.xperiment.stimuli.primitives.P2P_UI.P2P_UI_Peer;
	
	import flash.events.Event;
	
	public class addLive extends object_baseClass
	{
		private var ui_peer:P2P_UI_Peer;
		private var ui_boss:P2P_UI_Boss;
		
		private var boss:BossLive;
		private var peer:PeerLive;
		
		override public function setVariables(list:XMLList):void {
			setVar("boolean","boss",false);
			setVar("string","studyName","");
			setVar("boolean","autoStart",false);
			setVar("string","password",'');
			super.setVariables(list);
			
			if(getVar("boss")==true && getVar("studyName")=="")throw new Error("you must specify a study name when you are controlling a P2P study");
		}
		
		override public function kill():void{
			if(ui_peer)ui_peer.kill();
			if(ui_boss)ui_boss.kill();
		}
	
		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			
			if(getVar("boss")==true){
				boss = new BossLive(ExptWideSpecs.getSJuuid(),theStage, getVar("studyName"),getVar("password"));
				boss.expt.toUI = ui_boss.fromService;
				ui_boss.toService = boss.expt.fromUI;
			}
			else{
				peer = PeerLive.init(theStage);		
				peer.toUI = ui_peer.fromService;
				ui_peer.toService = peer.fromUI
			}			
		}
		
		

		
		
		
		override public function RunMe():uberSprite {
		

			super.setUniversalVariables();
			this.scaleX=1;
			this.scaleY=1;
			
			if(getVar("boss")==true){
				//this.ui = new P2P_UI_Boss_OLD(getVar("password"));
				ui_boss = new P2P_UI_Boss(this.myWidth,this.myHeight);
		
				
				pic.addChild(ui_boss);
			}
			else{
				ui_peer = new P2P_UI_Peer(this.myWidth,this.myHeight);
				pic.addChild(ui_peer);
			}

			return pic;
		}
			
		
	}
}

