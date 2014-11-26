package com.xperiment.stimuli
{

	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	import com.xperiment.stimuli.Controls.Controls;
	import com.xperiment.stimuli.Controls.Panel;
	import com.xperiment.stimuli.primitives.KeyPad;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class addAudioCaptcha extends addSound
	{
		private var sounds:Array;
		private var index:int;
		
		private var keypad:KeyPad;
		
		private var code:Array;
		private var CaptchaPanel:Panel;
		private var myMessage:MyMessage;
		
		override public function kill():void{
			
			pic.removeChild(CaptchaPanel);
			CaptchaPanel.removeEventListener(MouseEvent.CLICK,CaptchaClickedL);
			pic.removeChild(myMessage);
			myMessage=null;
			CaptchaPanel.kill();
			CaptchaPanel=null;
			
			keypad.kill();
			listeners(false);
			super.kill();
		}
		
		override public function setVariables(list:XMLList):void {
			
			list.@autostart=false;
			var filename:String = list.@filename;
			//if(!filename || filename=="")throw new Error("no filename property specified in audioCaptcha!");
			
			var filenames:Array = filename.split(",");
			
			setVar("int","length",5);
			setVar("string","message","We need to check the volume of the sound coming from your speakers. Please enter the password you here. Press play to repeat the sound. Please adjust your volume if you cannot hear anything.");
			setVar("int","fontSize",20);
			
			var len:int;
			if(list.@length.toString().length!=0)len=list.@length;
			else len = getVar("length")
		
			code = [];
		
			while(code.length < len){
				code.push(int(Math.random()*9));
			}
			
			list.@filename=filenames[0];
			
			
			list.@controls='';
	

			
			super.setVariables(list);
			
			
			sounds = [];
			sounds.push(this);
			
			var mySound:addSound;
			var myList:XMLList = list.copy();
			
			for (var i:int=1;i<filenames.length;i++){
		
				mySound = new addSound();
				sounds.push(mySound);
				
				myList.@filename=filenames[i];
				
				mySound.theStage = theStage;
				mySound.setVariables(myList);
			}
			
			
			listeners(true);
		}
		
		private function listeners(ON:Boolean):void{
			var hasListener:Boolean;
			
			for each(var mySound:addSound in sounds){
				hasListener = mySound.hasEventListener(Event.SOUND_COMPLETE);
				
				if(ON && !hasListener)		mySound.addEventListener(Event.SOUND_COMPLETE,soundFinishedL);
				else if(!ON && hasListener) mySound.removeEventListener(Event.SOUND_COMPLETE,soundFinishedL);
				
			}
		}
		
		override public function RunMe():uberSprite {
			
			super.setUniversalVariables();
			
			pic.scaleX=1;
			pic.scaleY=1;
			
			myMessage = new MyMessage(getVar("message"),getVar("fontSize"),pic.myWidth,pic.myWidth*.2);
			pic.addChild(myMessage);
			
			keypad = new KeyPad(pic.myWidth, pic.myHeight*.8);
			keypad.addEventListener(MouseEvent.CLICK,CaptchaClickedL);
			pic.addChild(keypad);
			keypad.y=myMessage.height;
			
			CaptchaPanel = Controls.sound({right:captchaPlay})
			CaptchaPanel.width=pic.width*.25;
			CaptchaPanel.height=pic.height*.15;
			
			pic.addChild(CaptchaPanel);
			CaptchaPanel.x=pic.width-CaptchaPanel.width;
			CaptchaPanel.y=pic.height-CaptchaPanel.height;
			
			
			
			
			return pic;
		}
		
		protected function CaptchaClickedL(e:MouseEvent):void
		{
			e.stopPropagation();
			if(code==keypad.pressed.toString()){
				this.dispatchEvent(new StimulusEvent(StimulusEvent.ON_FINISH));
			}
			
		}
		
		protected function soundFinishedL(event:Event):void
		{
			index++;
			if(index<code.length)playNext();
		}
		
		override public function appearedOnScreen(e:Event):void
		{
			
			for(var i:int=0;i<=9;i++){
				
			}
			
			captchaPlay();
			
			super.appearedOnScreen(e);
		}
		
		private function playNext():void{
			var toPlay:int = code[index];
			(sounds[toPlay] as addSound).play();
		}
		
		private function captchaPlay():void
		{
			if(index!=0){
				for(var i:int=0;i>sounds.length;i++){
					(sounds[i] as addSound).stop(); 
				}
			}
			
			index=0;
			playNext();
			
		}
	}
}
import com.bit101.components.Style;
import com.dgrigg.minimalcomps.graphics.Shape;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.display.Sprite;

class MyMessage extends Sprite{


	
	public function MyMessage(message:String,fontSize:int, myWidth:int, myHeight:int):void{

		var textBackground:Shape = new Shape();
		textBackground.graphics.beginFill(Style.BACKGROUND,1);
		textBackground.graphics.lineStyle(2,Style.borderColour,Style.borderAlpha);
		textBackground.graphics.drawRoundRect(0,0,myWidth,myHeight,50,50);
		this.addChild(textBackground);
		
		var txt:TextField = new TextField;
		var tf:TextFormat = new TextFormat(null, fontSize, Style.LABEL_TEXT);
		txt.defaultTextFormat=tf;
		txt.text = message
		txt.width=myWidth;
		txt.height=myHeight;
		txt.multiline=true;
		txt.wordWrap=true;
		txt.autoSize = TextFieldAutoSize.LEFT;
		this.addChild(txt);
		
		txt.y=this.height*.5-txt.height*.5;
		txt.x=this.width*.5-txt.width*.5;
		
	}
	
	
}