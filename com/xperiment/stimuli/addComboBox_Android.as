package com.xperiment.stimuli
{
	import com.dgrigg.minimalcomps.graphics.Shape;
	import com.xperiment.stimuli.primitives.IResult;
	import com.xperiment.trial.Trial;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.NativePickerDialog;
	import pl.mateuszmackowiak.nativeANE.dialogs.support.PickerList;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;

	
	public class addComboBox_Android extends addComboBox implements Imockable, IResult
	{
			
		private var picker:NativePickerDialog;
		private var comboBoxOverlay:Shape;
		
		override public function kill():void{
			if(picker)picker.dispose();
			removeFocusEvent();
			this.removeChild(comboBoxOverlay);
			super.kill();
			
		}
		
		override public function setVariables(list:XMLList):void {
			super.setVariables(list);

			if(NativePickerDialog.isSupported){
				this.addEventListener(FocusEvent.FOCUS_IN,editL);
				this.addEventListener(MouseEvent.CLICK,editL);
			}
		}
		
		protected function editL(event:Event):void
		{
			removeFocusEvent();
			if(!picker)	init();
			else{
				picker.show();
			}
			
		}		
		
		override protected function createStim():void
		{
			super.createStim();
			if(NativePickerDialog.isSupported){
				comboBoxOverlay = new Shape;
				comboBoxOverlay.graphics.beginFill(0,0);
				comboBoxOverlay.graphics.drawRect(0,0,comboBox.width+1,comboBox.listItemHeight+1);
				pic.addChild(comboBoxOverlay);
				comboBoxOverlay.x=comboBox.x;
				comboBoxOverlay.y=comboBox.y;
			}
		}
		
		private function init():void
		{
			
			
			var pickerlist1:PickerList = new PickerList(getVar("items").split(","),1);
			
			pickerlist1.width = Trial.ACTUAL_STAGE_WIDTH;
			
			picker = new NativePickerDialog();
			picker.title = getVar("label");
			picker.dataProvider = Vector.<PickerList>([pickerlist1]);
			picker.addEventListener(NativeDialogEvent.CLOSED,readAllSelectedValuesFromPickers);
			picker.show();
			
		}
		
		private function removeFocusEvent():void{
			if(this.hasEventListener(FocusEvent.FOCUS_IN))this.removeEventListener(FocusEvent.FOCUS_IN,editL);
		}
		
		private function readAllSelectedValuesFromPickers(event:NativeDialogEvent):void
		{

			var v:Vector.<PickerList> = picker.dataProvider;
			
			if(v.length>0)
				comboBox.selectedItem = v[0].selectedItem;	
		}

	}
}