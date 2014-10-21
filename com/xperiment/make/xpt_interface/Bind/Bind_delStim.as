package com.xperiment.make.xpt_interface.Bind
{
	import com.xperiment.make.xpt_interface.runnerBuilder;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trial.Trial;

	public class Bind_delStim
	{
		private static var runner:runnerBuilder;
		
		
		public function from_JS(obj:Object):void
		{
			
		}
		
		public static function stim(binds:Array):void
		{
			var xml:XML
			var howMany:int;
			
			for each(var stim:object_baseClass in binds){
				xml = stim.stimXML;
				if(xml.hasOwnProperty('@howMany') && xml.@howMany!="1"){
					howMany = xml.@howMany.toXMLString();
					deletePartMultiStim(stim,xml.@howMany);
				}
				else {

					deleteSolitaryStim(xml.@[BindScript.bindLabel].toXMLString());
				}
			}
			
		}
		
		private static function deleteSolitaryStim(bind_id:String):void
		{
			BindScript.deleteX(bind_id);
			deleteStimRunnerScript(bind_id);
			BindScript.updated(['Bind_delStim.deleteStim']);
		}
		
		private static function deletePartMultiStim(stim:object_baseClass, howManyStr:String):void
		{
			if(howManyStr=="1"){
				deleteSolitaryStim(stim.stimXML);

				return;
			}
			//trace(BindScript.script)
			var multiSpecs:Object = MultiTrialCorrection.compute(stim);
			multiSpecs.defaults = getDefaultsForAllProps(stim);
			multiSpecs.defaults.howMany = multiSpecs.numItems;

			
			var bindId:String = stim.getVar(BindScript.bindLabel);
			var newVal:String;
			for(var prop:String in multiSpecs.defaults){	
				//trace(prop,stim.getVar(prop),stim.stimXML.@[prop])	
				if(prop!='howMany')	BindScript.updateAttrib(bindId,prop,null,multiSpecs,-1,null, false);		
			}

			BindScript.updateAttrib(bindId,'howMany',multiSpecs.defaults.howMany-1,multiSpecs,-1,null, false);
			
			//trace(BindScript.script.TRIAL[0].addButton[0].toXMLString());
			
			UpdateRunnerScript.DO(bindId);
			
			BindScript.updated(['Bind_delStim.deletePartMultiStim']);
		}
		
		
		
		private static function deleteStimRunnerScript(bindId:String):void
		{
			var xml:XML = BindScript.getStimScript(bindId);
			var bindLabel:String = BindScript.bindLabel;
			
			for each(var stim:XML in runner.trialProtocolList..*.(name()!="TRIAL")){	
				if(stim.@[bindLabel].toXMLString() == bindId){
					
					delete stim.parent().children()[stim.childIndex()];
					break;
				}
			}
		}	
		
		
		public static function getDefaultsForAllProps(stim:object_baseClass):Object
		{
			var obj:Object = {};
			var prop:String;
			var val:String;
			for each (var att : XML in stim.stimXML.@*){
				prop = att.name();
				val  = att.toXMLString();
				if(val.indexOf("---")==-1 && val.indexOf(";")==-1){
					
				}
				else if(stim.makerObj.attrsInfo[prop]){
					
					obj[prop] = stim.makerObj.attrsInfo[prop].defaultVal;
				/*if(obj.hasOwnProperty(prop)==false){
					obj[prop] ='';
					trace(111)
				}*/
				}
			
			}

			return obj;
		}
		
		
		public static function delPegs(list:Array, r:runnerBuilder):void
		{
			var stim:Array;
			var currentTrial:Trial = r.runningTrial;
			
			if(currentTrial){
				stim = currentTrial.CurrentDisplay.allStim;
			}
			
			if(stim.length!=0){
				
				var bindlabel:String = BindScript.bindLabel;
				var stimuli:Array = [];
				
				var peg:String;
				var stimObj:Object;
				var stimMultiDetect:Object = {};
				
				for(var i:int=0;i<stim.length;i++){
					peg=stim[i].peg
				
					
					stimObj = {bind:stim[i].OnScreenElements[bindlabel],peg: peg};
					stimMultiDetect[stimObj.bind] ||= [];
					//if(stimMultiDetect[stimObj.bind].length==1) 	stimMultiDetect[stimObj.bind][0].xml = stim[i].stimXML; //adds xml to first stim only
					
					stimMultiDetect[stimObj.bind].push(stimObj);
					
				}
			}
			
		}
		
		public static function setup(r:runnerBuilder):void
		{
			runner=r;
		}
	}
}