package com.xperiment.stimuli.primitives
{

	import com.xperiment.stimuli.IButton;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;


	public class KeyPress
	{
		private var theStage:Stage;
		private var key:int;
		private var button:BasicButton;
		private var buttonParent:IButton;
		// use codes from here: http://www.asciitable.com/  
		//or figure out codes by pressing from here http://www.kirupa.com/developer/as3/using_keyboard_as3.htm
		
		public function KeyPress(keyStr:String,theStage:Stage,buttonParent:IButton,button:BasicButton)
		{
			this.theStage=theStage;
			//trace(1121,(buttonParent as object_baseClass).peg,keyStr)
			if(keyStr.charAt(0).toUpperCase()=="C"){
				this.key=int(keyStr.substr(1,keyStr.length-1));
			}
			else{
				this.key=keyStr.toUpperCase().charCodeAt(0);
			}
			
			this.buttonParent=buttonParent;
			this.button =button;
			
		}
		
		public function init():void{
			theStage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressedDOWN,false,0,true);
			theStage.addEventListener(KeyboardEvent.KEY_UP,keyPressedUP,false,0,true);
			theStage.focus = theStage;
		}
		
		protected function keyPressedDOWN(e:KeyboardEvent):void
		{

			if(button && e.keyCode==key as int) {
				
				buttonParent.__logButtonPress()
				if(button)button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				if(button)button.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
				if(button)button.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));		
			}
		}
		
		protected function keyPressedUP(e:KeyboardEvent):void
		{
			if(e.keyCode==key) {		
				button.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
				
			}
		}
		
		
		
		public function kill():void{
			if(theStage)theStage.removeEventListener(KeyboardEvent.KEY_DOWN,keyPressedDOWN);
			if(theStage)theStage.removeEventListener(KeyboardEvent.KEY_UP,keyPressedUP);
			button=null;
			buttonParent=null;
		}
		

	}
}