package com.xperiment.make.xpt_interface
{

	import com.xperiment.behaviour.behavFullScreenDummy;
	import com.xperiment.container.container;
	import com.xperiment.make.OnScreenBoss.OnScreenBossMaker;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.stimuli.IStimulus;
	import com.xperiment.stimuli.StimulusFactory;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trial.Trial;
	import com.xperiment.uberSprite;
	
	public class TrialBuilder extends Trial
	{

		public var bind_id:String;
		public var xml:XML;
		private var uniqueIDs:UniqueNewStim;
		

/*		public function newStim(which:String,params:Object=null):uberSprite{
			
			uniqueIDs ||= new UniqueNewStim();
			var id:String = uniqueIDs.requestID();
			var uniqueParameterVal:String = "uniqueStimID";
			
			var stim:XML=<top/>;
			var stimXML:XML = <{which} />;
			stimXML.@[uniqueParameterVal]=id;
			
			if(params){
				for(var key:String in params){
					stimXML.@[key]=params[key];
				}
			}
			
			stim.appendChild(stimXML);

			elementSetup(stim,null);
			
			if(OnScreenElements.length==0)return null;
			
			var prevAdded:object_baseClass = OnScreenElements[OnScreenElements.length-1];
			
			if(prevAdded.getVar(uniqueParameterVal)!=id) return null;

			return CurrentDisplay.runDrivenEvent(prevAdded.peg);
		}*/
		
		

		
		override public function stimulusFactory(stimName:String):IStimulus{
			var processedName:String = StimulusFactory.processStimName(stimName)
			
			var stim:IStimulus;
				
			switch(processedName){
				case "fullscreen": 				stim = new behavFullScreenDummy;
			}
			
			if(!stim) stim = StimulusFactory.Stimulus(stimName);
			if(stim){
				
				(stim as object_baseClass).maker=true;
				(stim as object_baseClass).makerObj = {};
				(stim as object_baseClass).makerObj.attrsInfo = {};
			}
			
			return stim;
		}
		
		
		override public function run():void{
			super.run();
			//theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND, GlobalFunctionsEvent.START_TRIAL));
		}
		
		
		override public function prepare(Ord:uint, trial:XML):void{	
			//trace(trial.toXMLString());
			bind_id = trial.@[BindScript.bindLabel];
			xml = trial;
			super.prepare(Ord,trial);
		}
		
		override public function setup(info:Object):void {	
			bind_id = info.bind_id;
			super.setup(info);
		}
		
		override public function composeObject(kinder:XML, iteration:uint,inContainer:container,saveParams:Boolean=false,xmlVal:String=''):container {
			return super.composeObject(kinder,iteration, inContainer, true,xmlVal);
		}
		
		override public function getOnScreenBoss():OnScreenBoss{
			return new OnScreenBossMaker;
		}
	
/*		override public function sortoutTiming(startStr:String, endStr:String,duration:String,peg:String,stim:uberSprite):void{
			if(endStr.indexOf('etc')!=-1){
				
			}
			super.sortoutTiming(startStr,startStr,duration,peg,stim);
		}*/
		
	}
}


class UniqueNewStim{
	private var uniqueNewStimID:Array = [];
		
	public function requestID():String{
		var id:String=gen();
		while(uniqueNewStimID.indexOf(id)!=-1){
			id=gen();
		}
		
		uniqueNewStimID.push(id);
		
		return id;
	}
	
	private function gen():String{
		return int(Math.random()*100000).toString();
	}
	

	
}