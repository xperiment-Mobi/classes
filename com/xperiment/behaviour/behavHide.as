﻿package com.xperiment.behaviour{
	
	public class behavHide extends behav_baseClass {

		override public function nextStep(id:String=""):void{
			for(var i:uint=0;i<behavObjects.length;i++){
				behavObjects[i].pic.visible=!behavObjects[i].pic.visible;
			}
		}

	}

}