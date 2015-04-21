package com.xperiment.behaviour
{
	
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	import com.xperiment.stimuli.addSound;
	import com.xperiment.stimuli.Controls.Controls;
	import com.xperiment.stimuli.Controls.Panel;
	import com.xperiment.stimuli.primitives.KeyPad;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class behavAudioPassword extends behav_baseClass
	{
		private var sounds:Object;
		private var index:int;
		
		private var keypad:KeyPad;
		
		private var pword:Array;
		private var CaptchaPanel:Panel;
		private var myMessage:MyMessage;
		private var allLoaded:Boolean = false;
		
		override public function kill():void{
			
			for each(var mySound:addSound in sounds){
				mySound.removeEventListener(Event.SOUND_COMPLETE,soundFinishedL);
			}
			
			pic.removeChild(CaptchaPanel);
			CaptchaPanel.removeEventListener(MouseEvent.CLICK,CaptchaClickedL);
			pic.removeChild(myMessage);
			myMessage=null;
			CaptchaPanel.kill();
			pic.removeChild(keypad);
			keypad.kill();
			CaptchaPanel=null;
			keypad=null;
			super.kill();
		}
		
		override public function setVariables(list:XMLList):void {
						
			setVar("int","length",3);
			setVar("string","message","We need to check the volume of the sound coming from your speakers. Please enter the password you here (just restart entering the password if you make a mistake). Press play to repeat the sound. Please adjust your volume if you cannot hear anything.");
			setVar("int","fontSize",18);
			setVar("boolean","autoStart","false","","note that if the stimuli have not been loaded before this, every 100ms will try to play them until they are");
			setVar("string","pword","");		
			setVar("string","controls","");
			
			
			super.setVariables(list);
			
		}
		
		
		
		private function genPWord(len:int, _pword:String):Array
		{
			var _code:Array = [];
		
			if(_pword!=""){
				 _code = _pword.split("");
			}
			else{
				while(_code.length < len){
					_code.push(int(Math.random()*9));
				}
			}
			return _code;
		}
		
		override public function givenObjects(obj:uberSprite):void{
			
			super.givenObjects(obj);
			
			if(obj is addSound){
				var sound:addSound = obj as addSound;
				sounds ||= {};
				sounds[sound.peg] = sound;
				sound.addEventListener(Event.SOUND_COMPLETE,soundFinishedL);
			}
			
		}
		
		
		override public function setUniversalVariables():void {
			if(pic){
				sortOutScaling();
				sortOutWidthHeight();
				setContainerSize();	
				setPosPercent();
				sortOutPadding();
				if(getVar("opacity")!=1)pic.alpha=getVar("opacity");
			}
			
			if(getVar("mouseTransparent") as Boolean)mouseTransparent();
		}
		
		override public function RunMe():uberSprite {
						
			setUniversalVariables();
			
			pic.scaleX=1;
			pic.scaleY=1;
			
			myMessage = new MyMessage(getVar("message"),getVar("fontSize"),pic.myWidth,pic.myWidth*.2);
			pic.addChild(myMessage);
			
			pword = genPWord(int(getVar("length")),getVar("pword"));


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
			
			if(getVar("autoStart")) captchaPlay();
			
			return pic;
		}
		
		private function identical(arr:Array,arr2:Array):Boolean{

			var dif:int = arr2.length - arr.length;
			if(dif<0) return false;

			for(var i:int=arr.length-1;i>=0;i--){
				if(arr[i]	!=	arr2[dif+i]) return false;
			}
			
			return true;
		}
		
		protected function CaptchaClickedL(e:MouseEvent):void
		{
			e.stopPropagation();
		
			if(identical(pword,keypad.pressed)){
				this.dispatchEvent(new StimulusEvent(StimulusEvent.ON_FINISH));
			}

			
		}
		
		protected function soundFinishedL(e:Event):void
		{
			index++;
			if(index<pword.length)playNext();
		}
		
		
		
		private function playNext():void{	
			var nam:String = pword[index];
			(sounds[nam] as addSound).play();
		
		}
		
		private function captchaPlay():void
		{
			if(allLoaded){
			
				if(index!=0){
					for each(var sound:addSound in sounds){
						sound.stop(); 
					}
				}
				index=0;
				playNext();
			}
			else{

				if(sounds)	allLoaded = true;
				else{
					allLoaded = false;
				}
				for each( sound in sounds){
					if(sound.isLoaded == false){
						allLoaded = false;
					}
				}
				if(allLoaded)	captchaPlay();
				else codeRecycleFunctions.delay(captchaPlay,100);
				
			}
		}
			
		
		
	}
}

import com.bit101.components.Style;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import com.dgrigg.minimalcomps.graphics.Shape;

class MyMessage extends Sprite{

	private var textBackground:Shape;
	
	public function MyMessage(message:String,fontSize:int, myWidth:int, myHeight:int):void{
		
		
		textBackground = new Shape();
		textBackground.graphics.beginFill(Style.BACKGROUND,1);
		textBackground.graphics.lineStyle(5,Style.borderColour,Style.borderAlpha);
		textBackground.graphics.drawRoundRect(0,0,myWidth,myHeight,50,50);
		this.addChild(textBackground);
		
		var txt:TextField = new TextField;
		var tf:TextFormat = new TextFormat(null, fontSize, Style.LABEL_TEXT);
		txt.defaultTextFormat=tf;
		txt.text = message
		txt.width=myWidth-20;
		txt.height=myHeight;
		txt.multiline=true;
		txt.wordWrap=true;
		txt.autoSize = TextFieldAutoSize.LEFT;
		this.addChild(txt);
		
		txt.y=this.height*.5-txt.height*.5;
		txt.x=this.width*.5-txt.width*.5;
		
	}
	
	

}