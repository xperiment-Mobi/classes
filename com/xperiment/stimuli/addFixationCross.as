package com.xperiment.stimuli{


	public class addFixationCross extends addText {

		override public function setVariables(list:XMLList):void {
							
			if(list.hasOwnProperty('@text')==false)list.@text='+';
			if(list.hasOwnProperty('@align')==false)list.@align='center';
			if(list.hasOwnProperty('@width')==false)list.@width='5%';
			if(list.hasOwnProperty('@height')==false)list.@height='5%';

			super.setVariables(list);
		}
	}
}