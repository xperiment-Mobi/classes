﻿package com.xperiment.trial {

	import com.xperiment.behaviour.behavFullScreen_Android;
	import com.xperiment.behaviour.behavFuture;
	import com.xperiment.stimuli.IStimulus;
	import com.xperiment.stimuli.addComboBox_Android;
	import com.xperiment.stimuli.addInputTextBox_Android;
	import com.xperiment.stimuli.addLive;
	import com.xperiment.stimuli.addTouch;
	import com.xperiment.stimuli.addTouchScreen;
	import com.xperiment.stimuli.addVibrate;




	public class TrialANDROID extends Trial_devices {
				
		override public function deviceSpecific_StimFactory(stimName):IStimulus{
			switch(stimName){
				case "touchscreen":			return new addTouchScreen;
				case "touch": 				return new addTouch;	
				case "vibrate":				return new addVibrate;
				case "inputtextbox":
				case "input":				return new addInputTextBox_Android;
				case "combobox":			return new addComboBox_Android;
				case "p2p":					return new addLive;
				case "fullscreen":			return new behavFullScreen_Android;
				case "future":				return new behavFuture;
					
					//case "admindata": 		return new adminData;
					//case "adminsetvariable": 	return new adminSetVariable;
					//case "adminconsole": 		return new adminConsole;
			}
			return null;
		}
		
		
	}


}