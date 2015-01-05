package com.xperiment.behaviour {

import com.xperiment.codeRecycleFunctions;
import com.xperiment.stimuli.object_baseClass;

import flash.events.Event;


public class behavOcclude extends behav_baseClass{

		private var _stimuli:Array;
		private var _occluders:Array;
		private var stimuli:Array;
		private var occluders:Array;

		override public function setVariables(list:XMLList):void {
			setVar("string","with",'','','the stimulus peg(s) to which to occlude all the others with. Make sure there are equal numbers of stimuli and stimuli to occlude with');
			super.setVariables(list);
		}



		override public function nextStep(id:String=""):void{
			sortStimuli();
		}

		private function sortStimuli():void {

			_stimuli = getVar("usePegs").split(",");
			_occluders =  getVar("with").split(",");

			function err(str:String):void{
				throw new Error("error in specifying behavOcclude: "+str)
			}

			if(_stimuli.length==0) err('you have not specified any pegs to use (pegs)');
			if(_occluders.length==0) err('you have not specified any occluders to use (with)');

			var i:int;
			for each(var stimPeg:String in _occluders){
				i = _stimuli.indexOf(stimPeg);
				if(i!=-1){
					_stimuli.splice(i,1)
				}
			}
			if(_stimuli.length==0) err('after removing Occluders from the Pegs you specified, there are no Pegs to apply the occluders to left');

			stimuli = [];
			occluders = [];



			for each(var stim:object_baseClass in behavObjects){

				i=-1;
				i = _stimuli.indexOf(stim.peg);
				if(i!=-1){
					stimuli.push( stim );
				}
				else{
					i = _occluders.indexOf(stim.peg);
					occluders.push( stim );
					stim.addEventListener(Event.ADDED_TO_STAGE, addedToStageL);
				}
			}

			if(occluders.length!=stimuli.length){
				function stringify(arr:Array):String{

					for(i = 0;i< arr.length;i++){
						arr[i] = (arr[i] as object_baseClass).peg;
					}
					return arr.join(",");
				}
				err('you do not have equal numbers of stimuli('+stringify(stimuli)+') and occluders('+stringify(occluders)+')');
			}

			_stimuli=null;
			_occluders=null;
		}

		private function addedToStageL(e:Event):void{

			var occluder:object_baseClass = e.currentTarget as object_baseClass;

			var index:int = occluders.indexOf(occluder);
			var stimulus:object_baseClass = stimuli[index];

			var xPos:Number = codeRecycleFunctions.posSetterGetter(stimulus,'x')();
			var yPos:Number = codeRecycleFunctions.posSetterGetter(stimulus,'y')();

			codeRecycleFunctions.posSetterGetter(occluder,'x')('x',xPos);
			codeRecycleFunctions.posSetterGetter(occluder,'y')('y',yPos);
		}

		override public function kill():void{
			for each(var stim:object_baseClass in _occluders){
				if(stim.hasEventListener(Event.ADDED_TO_STAGE))	stim.removeEventListener(Event.ADDED_TO_STAGE, addedToStageL);
				stim = null;
			}
			occluders = null;
			stimuli=null;



			super.kill();
		}


			
	}
}