package com.xperiment.admin{

	
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.behaviour.behav_baseClass;
	import com.xperiment.interfaces.IGiveScript;
	import com.xperiment.trial.overExperiment;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	

	public class admin_baseClass extends behav_baseClass implements IGiveScript{
		//identical to behav_baseClass.  Note that adminName = behavName, unAdminNmae = unBehavName.
		public var exptScript:XML;

		public function giveExptScript(exptScript:XML):void{
			this.exptScript=exptScript;
		}
		
		override public function errorMessage():void{
			//logger.log("Problem: afraid you have not given your behaviour a behaviourName (e.g. behaviourName='myBehav1') so there is no way it can identify objects to which to apply itself too.");
		}
	}
}