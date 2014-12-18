package com.xperiment.make.xpt_interface.trialDecorators.Timeline
{
	import com.xperiment.uberSprite;
	import com.xperiment.make.xpt_interface.runnerBuilder;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trial.Trial;
	
	import avmplus.getQualifiedClassName;

	public class Timeline
	{
		private static var runner:runnerBuilder;
		private static var depthOrderChanged:Function;
		private static var timingChanged:Function;
		private static var toJS:Function;
		//private static var info:Object;
		private static var currentTrial:Trial;
		
		

		
		public static function setup(r:runnerBuilder, _toJS:Function, _depthOrderChanged:Function, _timingChanged:Function):void
		{
			runner = r;
			toJS = _toJS;
			depthOrderChanged 	= _depthOrderChanged;
			timingChanged 		= _timingChanged;	
		}
		
		public static function update(r:Trial):void
		{
		
			currentTrial = r;
			var stimuli_info:Array = [];
			var stim:Object;
			var end:int;
			var arr:Array = r.CurrentDisplay.allStim;

			for(var i:int=0;i<arr.length;i++){
				stim = {};
				stim.group	= cleanType(getQualifiedClassName(arr[i].pic).split("::")[1]);
				stim.start	= arr[i].startTime;
				end			= arr[i].endTime;
				if(end==OnScreenBoss.FOREVER)	stim.end ="forever";
				else 							stim.end= end;
				
				stim.info = (arr[i].pic as uberSprite).peg;
				stimuli_info.push(stim);
				
			}
			
			toJS('timelineItems',stimuli_info);
		}
		
		private static function cleanType(str:String):String
		{
			str = str.split("add").join("").split("behav").join("");
			
			str = str.charAt(0).toLowerCase()+str.substr(1);
			
			return str;
		}
		
		public static function depthChange(newOrder:Array, unitTestStim:Array = null):Array // return only used for unittesting
		{	
			var stim:Array;
			
			if(currentTrial){
				//currentTrial.CurrentDisplay.updateDepths(newOrder);
				stim = currentTrial.CurrentDisplay.allStim;
			}
			else{ //unit testing
				stim = unitTestStim;
			}
			
			if(stim.length!=0){

				var bindlabel:String = BindScript.bindLabel;
				var stimuli:Array = [];
				var newOrd:int;
				var peg:String;
				var stimObj:Object;
				var stimMultiDetect:Object = {};
				
				for(var i:int=0;i<stim.length;i++){
					peg=stim[i].peg
					newOrd = newOrder.indexOf(peg);

					stimObj = {bind:stim[i].OnScreenElements[bindlabel],peg: peg, newOrd:newOrd};
					stimMultiDetect[stimObj.bind] ||= [];
					//if(stimMultiDetect[stimObj.bind].length==1) 	stimMultiDetect[stimObj.bind][0].xml = stim[i].stimXML; //adds xml to first stim only
					
					stimMultiDetect[stimObj.bind].push(stimObj);
					
				}
				
				//sort out all solitary stim first
				for(var key:String in stimMultiDetect){
					if(stimMultiDetect[key].length==1){

						stimuli.push(stimMultiDetect[key][0]);
						delete stimMultiDetect[key];
					}
				}
				
				stimuli.sortOn("newOrd",Array.NUMERIC);
				
				
				/////////----
				//then add multiStim to bottom of the list
				
				var multStimuli:Array = [];
				
				for(key in stimMultiDetect){

					multStimuli.push(	__processMultiStim(stimMultiDetect[key])		);
				}

				
				if(multStimuli.length>=1){

					multStimuli.sortOn("newOrd",Array.NUMERIC);

					for(i=0;i<multStimuli.length;i++){
						stimuli.push(multStimuli[i]);
					}
				}

				/////////
				/////////----
				
				newOrder = [];
				
				for(   i  =0;i<stimuli.length;i++){
					newOrder.push(stimuli[i].bind);
				}

				if(depthOrderChanged)	depthOrderChanged(newOrder);
			}
			return newOrder;
		}
		
		public static function __processMultiStim(stims:Array):Object
		{

			var multiStim:Object = stims[0];
			//var stimXML:XML = (multiStim.xml as XML).copy();
	
			var depthArr:Array = [];
			//var doNothing:Boolean = false;
			//var increasingDepth:int = stims[i].newOrd;
			
			for(var i:int=0;i<stims.length;i++){
/*				if(i>0 && doNothing==false){
					if(increasingDepth+1!=stims[i].newOrd)doNothing=true;
					
					increasingDepth++;
				}*/

				depthArr.push(stims[i].newOrd);

			}

			var bind:String = multiStim.bind;

			BindScript.updateAttrib(bind,"depth",depthArr.join("---"),null,null,['Timeline.__processMultiStim'],true);

			//trace(multiStim,333333,multiStim.bind)
			return multiStim;
		}
		
		public static function timeChange(changed:Object):void{

			var stim:uberSprite = currentTrial.CurrentDisplay.updateStimTimesFromObj(changed);
			if(stim){
				var bind_id:String = (stim as object_baseClass).OnScreenElements[BindScript.bindLabel];
				timingChanged(bind_id,{timeStart:changed.start,timeEnd:changed.end},stim);
			}
	
		}
	}
}
