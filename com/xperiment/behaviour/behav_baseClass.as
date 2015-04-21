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

		private var randomlyRun:Boolean = true;

		
	
	
		override public function stimEvent(what:String):void{	
	
			if(randomlyRun==false) return;
			
			if(what == StimulusEvent.DO_AFTER_APPEARED && randomlyRun)	nextStep();
					
			super.stimEvent(what);
		}
		
		
		public function nextStep(id:String=""):void{
		}
		
		
		private function computeRandomRun():void
		{

			if(getVar("random")=='') randomlyRun = true
			else{
					
				var rand:String = getVar("random");
			
				rand = rand.split("%").join('');

				var prob:int=Math.random()*100;

				if (prob>=Number(rand)){
					if(storeRandomDecision)storeDecision(true);
					randomlyRun = true;
					
				}
				else{
					if(storeRandomDecision)storeDecision(false);
					randomlyRun = false;
				}

			}
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
			stimEvent(StimulusEvent.ON_FINISH);
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
		
		public function exptBuilderVisual():void{
		
			OnScreenElements.height='5%';
			OnScreenElements.width='10%';
			super.setUniversalVariables();
			this.scaleX=1;
			this.scaleY=1;
		
		}

		override public function returnsDataQuery():Boolean {
			var re:Boolean = true;
			if (getVar("hideResults")) re=re&&false;	
			return re;
		}		
		
		override public function setUniversalVariables():void {
		}

		override public function RunMe():uberSprite {
			
			computeRandomRun();
			
			return pic;//note empty as nothing on stage :)
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
			
			driveEvent=null;
			behavObjects=null;
			super.kill();
		}
	}
}