package com.xperiment.stimuli{


	public class addFixationCross extends addText {

		override public function setVariables(list:XMLList):void {
							
			if(list.hasOwnProperty('@text')==false)list.@text='+';
			if(list.hasOwnProperty('@align')==false)list.@align='center';
			if(list.hasOwnProperty('@fontSize')==false)list.@fontSize='100';

			super.setVariables(list);
		}
	}
}