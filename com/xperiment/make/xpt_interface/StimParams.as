package com.xperiment.make.xpt_interface
{
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.make.xpt_interface.trialDecorators.StimBehav.PropsEventsActions;
	import com.xperiment.stimuli.StimulusFactory;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.Dictionary;
	
	import avmplus.getQualifiedClassName;

	
	public class StimParams
	{
		
		static private var params:Object = {}
		static private var stimuliBehavs:Object = {};
		
		static public function collect():Object{
			
			ExptWideSpecs.__init();
			StimulusFactory.setupDict();
			
			
			params.script = {};
			params.script.children = ['SETUP','TRIAL'];
			
			getExptProps(params);
			getTrialAttribs(params);
			
			
			stimuliBehavs.stimuli = [];
			stimuliBehavs.behavs  = [];
			getTrialProps(params,stimuliBehavs);
			
	
			
			
			
			//hack.h(params);
			return {params:params,stimuliBehavs:stimuliBehavs};
		}
		
		private static function getTrialAttribs(props:Object):void
		{
			props.TRIAL = {}
			props.TRIAL.attrs={};
			
		}
		
		private static function getTrialProps(props:Object,stimuliBehavs:Object):void
		{
			props.TRIAL.children = [];
			
			var stimuliDict:Dictionary = StimulusFactory.stimuli;
			var stimulus:object_baseClass;
			
			for (var stimulusName:String in stimuliDict){
				
				stimulus = new stimuliDict[stimulusName] as object_baseClass;
				
				stimulusName = getQualifiedClassName(stimulus).split("::")[1];
				
				if(stimulusName.substr(0,3)=="add")
					 stimuliBehavs.stimuli.push(stimulusName);
				else stimuliBehavs.behavs.push(stimulusName);
				
				stimulus.myUniqueProps('null');
				stimulus.maker=true;
				stimulus.init_makerObj();
				
				

				stimulus.setVariables(new XMLList);
				props.TRIAL.children.push(stimulusName);
				
				PropsEventsActions.extract(stimulus,stimulus.makerObj);
				
				props[stimulusName]=stimulus.get_makerObj();
				
				
			}
		}
		
		private static function getExptProps(props:Object):void
		{
				
			var sp:Object	= ExptWideSpecs._ExptWideSpecs;
				props.SETUP = {};
				props.SETUP.children = [];
			
			for (var group:String in sp){
				props[group] = {};
				props[group].attrs = {};
				props.SETUP.children.push(group);
				
				for(var prop:String in sp[group]){
					props[group].attrs[prop]=[escape(sp[group][prop].toString())]; 
						
				}
			}
		}		

	
		
			
			

/*		
		private static var groups:Object = {};
		groups.position = ['x','y','vertical','horizontal'];
		groups.appearence = ['colour','color','shape','visible'];
		groups.time = ['timeStart','timeEnd','duration'];
		groups.text = ['text','fontColour'];
		groups.perTrial = ['shuffle_something','shuffle_somethings'];
		groups.perExperiment = ['SHUFFLE_SOMETHING','SHUFFLE_SOMETHINGS'];*/
		
	}
}


import com.hurlant.util.Base64;
import flash.utils.ByteArray;

class hack{
	public static function h(obj:Object):void{
		
		
		var ba:ByteArray = new ByteArray();
		ba.writeObject(obj);
		
		
		//trace(Base64.encodeByteArray(ba));
		//trace("--")
		
		//ba.position=0;
		//var ob:Object = ba.readObject();
		
		
		
		//trace(JSON.stringify(ob.addText));
		
		
		/*for each(var obj:Object in arr2){
		for (var key:String in obj){
		if(key=='bitmap'){
		
		ByteArray
		trace(key,obj[key]);
		}
		else trace(key,obj[key]);
		}
		}*/
		
	}
	
	
}