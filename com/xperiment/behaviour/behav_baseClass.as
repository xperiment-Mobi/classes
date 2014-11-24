package com.xperiment.behaviour{


	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.events.Event;

		
	public class behav_baseClass extends object_baseClass {
		public var toShow:Array=[];
		public var behavObjects:Array = [];
		private var notYetRun:Boolean=true;
		private var storeRandomDecision:Boolean;

		protected function nextStepONCE():void{

			if(notYetRun || OnScreenElements.doMany){
				notYetRun=false;
			
				//first check there are no doBefore behaviours
				//trace("here",this.behav ,this.behav.hasOwnProperty("doBefore"));
				var occured:Boolean=doRun();
				
				//trace(occured,this);
			
				//AW JAN FIX
				pic.dispatchEvent(new StimulusEvent(StimulusEvent.DO_BEFORE));
				//trace("dispatched doBefore");
				//if(occured && this.actions && this.actions.hasOwnProperty("doBefore"))if(behavObjects)manageBehaviours.doBehaviourFirst(this);

				if(occured){
					ran=true;
					nextStep();
				}
				//if(occured && pic && !theStage.contains(pic))manageBehaviours.actionHappened(this,"onShow"); //some behaviours have nothing added to stage.  This fakes that :-)
			}
		}
		
		
		public function nextStep(id:String=""):void{
		}
		
		
		private function doRun():Boolean
		{
			//trace(134, peg, this,getVar("random"),2);
			if(getVar("random")=='') return true
			else{
					
				var rand:String = getVar("random");
			
				rand = rand.split("%").join('');

				var prob:int=Math.random()*100;
				//if(logger)logger.log("behaviour "+getVar("peg") +" was given a "+rand+"% chance of occurring.  The generated random % was "+prob+"%.");

				if (prob>=Number(rand)){
					if(storeRandomDecision)storeDecision(true);
					return true;
					
				}
				else{
					if(storeRandomDecision)storeDecision(false);
					return false;
				}

			}
			throw new Error();
			return false;
		}
		
		private function storeDecision(occured:Boolean):void
		{
			var tempData:Array = new Array();
			tempData.event=String("behaviourRND_"+getVar("peg"));
			tempData.data=occured;
			super.objectData.push(tempData);
			
		}
		
		public function givenObjects(obj:uberSprite):void{	
			behavObjects.push(obj);
		}
		
		public function behaviourFinished():void{
			this.dispatchEvent(new StimulusEvent(StimulusEvent.ON_FINISH));
		}

		override public function setVariables(list:XMLList):void {
			
			if(list.@random.toString.length!=0)list.@random = list.@random.toString().split("%").join('');
			
			setVar("string","random",'-1',"0% to 100%");
			setVar("string","result","");
			setVar("string","listenForChange","");
			setVar("boolean","listenForChangeOnce",false);
			setVar("string","logic","");
			setVar("boolean","receiveData",false);
			//setVar("string","timeStart",""); //used to be set at -1, pre logic-update
			setVar("string","sendWhatData","");
			setVar("boolean", "doMany",false);
			setVar("boolean","storeRandomDecision",false);
			setVar("string","usePegs","");
						
			super.setVariables(list);	
			
			if(getVar('random')!='-1' && getVar('storeRandomDecision') == true){
				storeRandomDecision = true;
			}
	
		}
		

		override public function returnsDataQuery():Boolean {
			var re:Boolean = true;
			if (getVar("hideResults")) re=re&&false;	
			return re;
		}		
		



		override public function setUniversalVariables():void {
		}

		override public function RunMe():uberSprite {
			
			if(pic!=null && peg!=null && ((getVar("peg") as String)==""  || (getVar("timeStart") as Number)!=-1)){

				pic.addEventListener(Event.ADDED_TO_STAGE, behavAddedToStageNO_peg);
				//trace('behav listener added:',peg);
			}
			return pic;//note empty as nothing on stage :)
		}
		
		protected function behavAddedToStageNO_peg(e:Event):void
		{	
			if(pic.hasEventListener(Event.ADDED_TO_STAGE))pic.removeEventListener(Event.ADDED_TO_STAGE, behavAddedToStageNO_peg);
			nextStepONCE();
		}
		
		/*public function errorMessage():void{
			if(logger)logger.log("Problem: afraid you have not given your behaviour a peg (e.g. peg='myBehav1') so there is no way it can identify objects to which to apply itself too.");
		}
*/
		override public function removedFromScreen(e:Event):void{
			stopBehaviour(null);
		}
		
		public function stopBehaviour(callee:uberSprite):void{
			if(pic)pic.removeEventListener(Event.REMOVED_FROM_STAGE,removedFromScreen);
			//stopBehaviourFromID("ALL");
		}


		override public function kill():void {

			for (var i:uint=0; i<behavObjects.length;i++) {
				if(behavObjects[i]){
					behavObjects[i]=null;
				}
			}		
			if(pic.hasEventListener(Event.ADDED_TO_STAGE))pic.removeEventListener(Event.ADDED_TO_STAGE, behavAddedToStageNO_peg);
			
			driveEvent=null;
			behavObjects=null;
			super.kill();
		}
	}
}