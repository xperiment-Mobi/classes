package com.xperiment.stimuli
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;

	import flash.text.SoftKeyboardType;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog;
	import pl.mateuszmackowiak.nativeANE.dialogs.support.NativeTextField;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;

	public class addInputTextBox_Android extends addInputTextBox
	{
		private var t:NativeTextInputDialog;
		private var input:NativeTextField 
		
		override protected function setEditable():Boolean{

			if(NativeTextInputDialog.isSupported == false){
				return true;
			}
			return false;
		}
		
		
		override public function setVariables(list:XMLList):void {
			super.setVariables(list);
			if(NativeTextInputDialog.isSupported){
				
				this.addEventListener(FocusEvent.FOCUS_IN,editL);
				this.addEventListener(MouseEvent.CLICK,editL);
			}
		}
		
		private function removeFocusEvent():void{
			if(this.hasEventListener(FocusEvent.FOCUS_IN))this.removeEventListener(FocusEvent.FOCUS_IN,editL);
		}
		
		override public function kill():void{
			if(t){
				t.removeEventListener(NativeDialogEvent.CLOSED,onCloseDialog);
				t.dispose();
				t = null;
				removeFocusEvent();
				this.removeEventListener(MouseEvent.CLICK,editL);
			}
			if(input){
				input = null;
			}
			super.kill();
		}
		
		protected function editL(e:Event):void
		{
			removeFocusEvent();
			if(!t)	init();
			else{
				t.show();
			}

			
		}
		
		
		private function init():void
		{
			
			t = new NativeTextInputDialog();
			t.addEventListener(NativeDialogEvent.CANCELED,trace);
			t.addEventListener(NativeDialogEvent.CLOSED,onCloseDialog);
			
			var v:Vector.<NativeTextField> = new Vector.<NativeTextField>();
			
			
			// create text-input
			if(!input){
				input = new NativeTextField(getVar("text"));
				input.softKeyboardType = SoftKeyboardType.DEFAULT;
				v.push(input);
			}
			
			var buttons:Vector.<String> = new Vector.<String>();
			buttons.push("OK","Cancel");
			
			
			t.textInputs = v;
			t.title = getVar("text");
			
			t.show(buttons);
		}
		
		private function onCloseDialog(e:NativeDialogEvent):void
		{
			text(input.text);
			t.hide();
		}
	}
}