package com.xperiment.stimuli.primitives.P2P_UI
{
	import com.bit101.components.Style;
	import com.dgrigg.minimalcomps.graphics.Shape;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class P2P_Start
	{
		private var passwordSpr:Sprite = new Sprite;
		public var peersSpr:Sprite = new Sprite;
		private var experimenterSpr:Sprite = new Sprite;
		
		public var verticalHeight:int = 20;
		private var peers:TextField;
		private var animation:TweenMax;
		private var password:TextField;
		private var passwordStr:String;
		public var parent:Sprite;
		
		
		
		public function P2P_Start(parent:Sprite,passwordStr:String)
		{
			this.parent = parent;
			this.passwordStr=passwordStr;
			
			setup();
			
		}
		
		public function setup():void
		{
			addExperimenterPassword();
			parent.addChild(passwordSpr);
			
			addPeersTxt('Other participants');
			parent.addChild(peersSpr);
			peersSpr.y+=verticalHeight*2+passwordSpr.y;
			
			addExperimenter();
			parent.addChild(experimenterSpr);
			experimenterSpr.y+=verticalHeight*2+peersSpr.y;
		}
		
		private function addExperimenter():void
		{
			
			var experimenter:TextField = new TextField;
			experimenter.textColor = Style.LABEL_TEXT;
			experimenter.text = "Waiting for Scientist";
			experimenterSpr.addChild(experimenter);
			
			var waitingSha:Shape = new Shape();
			var mat:Matrix = new Matrix;
			mat.createGradientBox(2*10,2*10,0,-10+2,-10-2);
			waitingSha.graphics.beginGradientFill(GradientType.LINEAR,[0x000000,0xffffff],[1,1],[0,255],mat);
			waitingSha.graphics.drawCircle(0,0,10);
			experimenterSpr.addChild(waitingSha);
			waitingSha.x=experimenter.width;
			waitingSha.y=5-waitingSha.height*.5;
			
			//animation = TweenMax.to(waitingSha, 2, {rotation:360,x:"70",ease:Back.easeInOut, repeat:-1, yoyo:true});
			
		}
		
		public function stopAnimation():void{
			animation.kill();
		}
		
		
		private function addExperimenterPassword():void
		{
			
			passwordSpr.graphics.lineStyle(Style.borderWidth,Style.borderColour,1);
			passwordSpr.graphics.beginFill(Style.BACKGROUND,.8);
			
			var passwordTxt:TextField = new TextField;
			passwordTxt.textColor = Style.LABEL_TEXT;
			passwordTxt.text = "Experimenter password:";
			
			passwordSpr.addChild(passwordTxt);
			
			password = new TextField;
			password.type = TextFieldType.INPUT;
			password.displayAsPassword=true;
			password.background=true;
			password.backgroundColor=Style.BACKGROUND;
			password.width=80;
			password.height=verticalHeight;
			password.textColor=Style.INPUT_TEXT;
			passwordSpr.addChild(password);
			password.x=passwordTxt.width;
			password.addEventListener(KeyboardEvent.KEY_UP,checkPassword);
			
			
			passwordSpr.graphics.drawRoundRect(0,0,parent.width,verticalHeight,10,10);
			
			var border:Shape = new Shape;
			border.graphics.lineStyle(Style.borderWidth,Style.borderColour,1);
			border.graphics.drawRoundRect(0,0,parent.width,verticalHeight,10,10);
			passwordSpr.addChild(border)
			
			
			
		}
		
		private function checkPassword(e:KeyboardEvent):void
		{
			// if the key is ENTER
			if(e.charCode == 13){
				if(password.text==passwordStr){
					parent.dispatchEvent(new Event(Event.COMPLETE));
				}
				else{
					TweenMax.to(passwordSpr,.3,{tint:0xFF0000, repeat:1, yoyo:true});
					password.text='';
				}
			}
			
		}
		
		public function addPeersTxt(message:String):void
		{
			
			
			peersSpr.graphics.beginFill(Style.BACKGROUND,.8);
			
			var peersTxt:TextField = new TextField;
			peersTxt.textColor = Style.LABEL_TEXT;
			peersTxt.text = message;
			
			peersSpr.addChild(peersTxt);
			
			peers = new TextField;
			peers.textColor = Style.LABEL_TEXT;
			peers.text = "0";
			peers.x=peersTxt.width;
			
			peersSpr.addChild(peers);			
			
			
			passwordSpr.graphics.drawRoundRect(0,0,parent.width,verticalHeight,10,10);
			
			
			
			
		}
		
		public function setPeers(num:int):void{		
			peers.text=String(int(peers.text));
		}
		
		
		
		public function kill():void
		{
			password.removeEventListener(KeyboardEvent.KEY_UP,checkPassword);
			stopAnimation();
			parent.removeChild(passwordSpr);
			parent.removeChild(peersSpr);
			parent.removeChild(experimenterSpr);
		}
	}
}