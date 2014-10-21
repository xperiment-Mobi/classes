package com.xperiment.stimuli.primitives.P2P_UI
{
	import com.bit101.components.List;
	import com.bit101.components.Style;
	import com.xperiment.P2P.service.Peers;
	import com.xperiment.live.AbstractLive;
	import com.xperiment.stimuli.primitives.BasicButton;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;



	public class P2P_UI_Boss extends P2P_UI_Peer
	{
		private var list:List;
		private var buttons:Vector.<BasicButton>;
			
		public var peersSpr:Sprite = new Sprite;
		private var participantCount:TextField;
		
		private var trialSpr:Sprite = new Sprite;;
		private var trialTxt:TextField;
		private var trialCount:TextField;
		
		private var plus:TextField;
		private var minus:TextField;
		
		private var tf:TextFormat = new TextFormat(null,30);
		
		public function P2P_UI_Boss(width:int,height:int){
			super(width,height);
		}
		
		public function serviceComms(obj:Object):Object{
			return {};
		}
		
		override public function fromService(obj:Object):void{
			
			switch(obj.command){
				case 'update sj list':
					peerL_hereListClients(obj.peers);
					break;
				default: throw new Error();
			}
			
		}
		
		override public function setup():void
		{		
			addButtons();
			addTrialTxt('Next trial #');
			this.addChild(trialSpr);
			trialSpr.y+=verticalHeight*2.8;
			
			addPeersTxt('Participants');
			this.addChild(peersSpr);
			peersSpr.y=verticalHeight*2;
			
			
			addComboBox();
			this.addChild(list);
			list.y=verticalHeight*4;
			//list.height=this.height-list.y;
			
		}
		
		
		public function peerL_hereListClients(peers:Peers):void{
	
			list.removeAll();
			var summaries:Array =  peers.getPeerSummaries();
			if(summaries.length==0)list.addItem(""); //crazy bug with List. Does not reset if nothing added.
			for each(var summary:String in summaries){
				list.addItem(summary);
			}
			
			participantCount.text=peers.count().toString()
		}
		
		
		public function addPeersTxt(message:String):void
		{			
			peersSpr.graphics.beginFill(Style.BACKGROUND,.8);
			var peersTxt:TextField = textCompose(message,peersSpr);

			participantCount = textCompose("0",peersSpr);
			participantCount.autoSize = TextFieldAutoSize.LEFT;
			participantCount.x=peersTxt.width;
		}
		
		public function addTrialTxt(message:String):void{
			trialSpr.graphics.beginFill(Style.BACKGROUND,.8);
			var trialTxt:TextField = textCompose(message, trialSpr);
			
			trialCount = textCompose("0",trialSpr,true);
			trialCount.background=true;
			trialCount.backgroundColor=0x444444;
			trialCount.textColor=0xFFFFFF;
			trialCount.type = TextFieldType.INPUT;
			trialCount.x=trialTxt.width;
			trialCount.selectable=true;;
			plus = textCompose("       - ",trialSpr,true);
			minus= textCompose(" + ",trialSpr,true);
			
			plus.x= trialSpr.width;
			minus.x=trialSpr.width;
			
			
			plus.mouseEnabled=true;
			minus.mouseEnabled=true;
			
			
			modifierListeners(true);
		}
		
		private function modifierListeners(on:Boolean):void
		{
			var what:String;
			if(on)	what="addEventListener";
			else    what="removeEventListener";
			
			
			plus[what](MouseEvent.MOUSE_DOWN,updateTrialL);
			minus[what](MouseEvent.MOUSE_DOWN,updateTrialL);
		}
		
		private function updateTrialL(e:MouseEvent):void{
			var change:int;
			if(e.currentTarget==plus){
				change=-1;
			}
			else{
				change=1;
			}
			
			change=int(trialCount.text)+change;
			
			if(change>=0)trialCount.text=String(change);
		}
		
		
		private function textCompose(txt:String,parent:Sprite,auto:Boolean=false):TextField{
			var t:TextField = new TextField;
			t.defaultTextFormat = tf;
			t.textColor = Style.LABEL_TEXT;
			t.text = txt;
			t.setTextFormat(tf);
			t.selectable=false;
			t.width=200;
			if(auto)t.autoSize = TextFieldAutoSize.LEFT;
			parent.addChild(t);
			return t;
		}
		
		public function setPeers(num:int):void{		
			participantCount.text=String(int(participantCount.text));
		}
		
		
		public function trial_change(sj:String, trial:String):void{

			trace(sj,trial,23232)
			var thirtyTwo:String;
			for(var i:int=list.items.length-1;i>=0;i--){
				thirtyTwo=list.items[i].substr(0,32);

				if(thirtyTwo==sj){
					if(trial=='-1')trial="ready";			
					list.removeItemAt(i);
					list.addItem(thirtyTwo+"   "+trial);
					
					break;
				}
			}
		}
	
		private function addButtons():void
		{
			buttons= new Vector.<BasicButton>;
			var basicButton:BasicButton;
			var prev_y_width:int=0;
			
			for each(var buttonLabel:String in [AbstractLive.START_STUDY,AbstractLive.NEXT_TRIAL,AbstractLive.FINISH_STUDY]){
				basicButton = new BasicButton;
				basicButton.label.text=buttonLabel;
				basicButton.name=buttonLabel;
				basicButton.myWidth=myWidth/3;
				basicButton.myHeight=verticalHeight*2;
				basicButton.init();
				basicButton.addEventListener(MouseEvent.CLICK,clickedL);
				
				if(buttonLabel==AbstractLive.START_STUDY)basicButton.toggle=true;
				else{
					basicButton.enabled=false;
				}
				
				this.addChild(basicButton);
		
				basicButton.x=prev_y_width;
				prev_y_width+=basicButton.width+.5;
				
				buttons[buttons.length]=basicButton;
			}
			
		}
		
		protected function clickedL(e:MouseEvent):void
		{
			var button:BasicButton = e.currentTarget as BasicButton;
			if(button.label.text==AbstractLive.START_STUDY){
				
				for each(var basicButton:BasicButton in buttons){
					basicButton.enabled=true;
				}
				
				button.label.text="STARTED";
				button.enabled=false;
			}
			
			commsService({command:e.target.name,trial:trialCount.text});
				
			if(button.label.text==AbstractLive.NEXT_TRIAL){
				trialCount.text=String(int(trialCount.text)+1);
			}
			
		}
		
		
		public function addItems(items:Array):void{
			list.removeAll();
			for each(var item:String in items){
				list.addItem(item);
			}
		}
		
		
		private function addComboBox():void
		{		
			list = new List(null);
			list.width=myWidth;
		}		
		
		override public function kill():void{
			modifierListeners(false);
			while(buttons.length>0){
				buttons[0].removeEventListener(MouseEvent.CLICK,clickedL);
				this.removeChild(buttons[0]);
				buttons[0].kill();
				buttons.shift();
			}
			buttons=null;
			this.removeChild(list);
			super.kill();
		}
		
		
	}
}