package com.xperiment.trial{

	import com.xperiment.behaviour.BehaviourBoss;
	import com.xperiment.container.container;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import flash.display.Stage;


	public class overExperiment extends Trial {
				
		override public function prepare(Ord:uint,trial:XML):void {
			Order=Ord;
		}
		
		override public function run():void {
			theStage.addChild(super.pic);
			if(CurrentDisplay){CurrentDisplay.commenceDisplay(true);}
		}
		

		private var listOfStuffOnScreen:Array=new Array  ;

		public function setupForOverExperiment(theSta:Stage,Attribs:XML):void {
			theStage=theSta;
			instantiateVars();
			CurrentDisplay=new OnScreenBoss();
			manageBehaviours=new BehaviourBoss(pic,CurrentDisplay);
			if (Attribs.length==0)elementSetup(new XML, null)
			else elementSetup(Attribs, null);
		}


		public function updateSomethingNOW(str:String):void {
			var parameters:Array=str.split(",");
			var objectToUpdateID:String=parameters.shift().split("=")[1];
			var noLuck:Boolean=true;

			for (var i:uint=0; i<listOfStuffOnScreen.length; i++) {
				if (String(listOfStuffOnScreen[i].nam)==objectToUpdateID) {
					listOfStuffOnScreen[i].obj.updateMe(parameters);
					noLuck=false;
				}
			}

			/*if (noLuck&&str=="") {
				logger.log("you specified an 'empty' object");
			} else if (noLuck) {
				logger.log("-----PROBLEM: nothing to update with this name: "+objectToUpdateID+ " (with these values: "+parameters+")");
			}*/
		}


		public function composeALLexptObject(myObj:XML, iteration:uint,Attribs:XMLList,xmlVal:String=''):void {
			var tempSpecialOnScreenObject:*;
			super.composeObject(myObj,iteration, new container,null,xmlVal);

			var obj:Object=new Object  ;
			obj.obj=OnScreenElements[OnScreenElements.length-1]; //bodgy.  Should replace this with oop.
			obj.nam=obj.attribute("id");
			listOfStuffOnScreen.push(obj);
		}
	}
}