package com.xperiment.behaviour{

	import com.xperiment.stimuli.addButton;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.stimuli.primitives.BasicButton;
	
	import flash.events.Event;

	public class behavAnd extends behav_baseClass {
		private var listenFor:String;
		private var whichPegs:Array;
		protected var listenPegs:Object;
		private var action:String;

		override public function setVariables(list:XMLList):void {
			setVar("string","listenFor","onFinish","onFinish","eg onFinish");
			setVar("string","doToWhichPegs","","","list of comma seperated Pegs actions will be performed on");
			setVar("string","action","","","eg start,stop");
			super.setVariables(list);
			
		}

		
		
		override public function nextStep(id:String=""):void{
			listenFor = getVar("listenFor");
			
			whichPegs = getVar("doToWhichPegs").split(",");
			

			var unknownList:Array = [];
			var s:int;
			
			var listPegs:Array = [];
			
			for(var i:int=0;i<behavObjects.length; i++){
				listPegs.push(behavObjects[i].peg);
			}
			
			for(i=0;i<whichPegs.length; i++){
				s=listPegs.indexOf(whichPegs[i]);
				if(s!=-1) whichPegs[i] = behavObjects[s];
				else unknownList.push(whichPegs[i]);
			}
			if(unknownList.length>0) throw new Error('Problem in behavAnd. You have items in the doToWhichPegs list that have not been added to the usePegs list: '+unknownList);
			
			listenPegs = {};
			for each(var stim:object_baseClass in behavObjects){
				if(whichPegs.indexOf(stim)==-1){
					listenPegs[stim.peg] = {stim:stim, happened:false};
				}
			}
			
			action = getVar("action")
			
			if(	BehaviourBoss.permittedActions.indexOf(action)==-1 ){
				throw new Error("Problem in behavAnd as unknown 'action' specified: "+action);
			}
			if(	abstractBehaviourBoss.availEvents.indexOf(listenFor)==-1 ){
				throw new Error("Problem in behavAnd as unknown 'listenFor' specified: "+action);
			}
			listeners(true);
		}
		
		private function listenL(e:Event):void{
			var stim:object_baseClass;
			if(e.target is BasicButton) stim = e.currentTarget.parent as object_baseClass;
			else stim = e.currentTarget as object_baseClass;
			
			if(listenPegs.hasOwnProperty(stim.peg)==false){
				throw new Error('devel error');
			}
			
			listenPegs[stim.peg].happened = true;
			checkLogic();
		}
		
		protected function checkLogic():void
		{	
			for each(var obj:Object in listenPegs){
				if(obj.happened == false) return;
			}
			doAction();	
		}
		
		protected function doAction():void
		{
			var f:Function;
			for each(var stim:object_baseClass in whichPegs){
				f = manageBehaviours.actionWrapper(stim,action);
				f(this.peg);
			}
		}
		
		private function listeners(ON:Boolean):void
		{
			var eventF:String;
			if(ON) eventF = 'addEventListener';
			else   eventF = 'removeEventListener';
			
			for each(var obj:Object in listenPegs){
					if(obj.stim is addButton )obj.stim.button[eventF](listenFor,listenL);
					else obj.stim[eventF](listenFor,listenL)
			}
		}
		
		override public function kill():void{
			listeners(false);
			super.kill();
		}
	}
}