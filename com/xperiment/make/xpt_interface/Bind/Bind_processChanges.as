package com.xperiment.make.xpt_interface.Bind
{

	import com.xperiment.stimuli.object_baseClass;
	

	public class Bind_processChanges
	{
		/*public function Bind_processChanges()
		{
		}*/
		
		public static function timingChanged(bind_id:String, changed:Object,stim:object_baseClass):void{
/*			var stimXML:XML = tagDictionary[changed.bind_id];
			stimXML.@timeStart 	= 	changed.start;
			stimXML.@timeEnd	= 	changed.end;
			
			
			*/
			var multiSpecs:Object = MultiTrialCorrection.compute(stim);
			multiSpecs.defaults = getDefaults(changed,stim);
			
			BindScript.updateAttrib(bind_id,'timeStart',changed.timeStart,multiSpecs,-1,null, false);
			BindScript.updateAttrib(bind_id,'timeEnd'  ,changed.timeEnd  ,multiSpecs,-1,null,false);
			
			BindScript.updated(['Bind_processChanges.timingChanged']);

			//trace(BindScript.script);
			//BindScript.updateAttrib(changed.bind_id,'timeStart',changed.start,multiSpecs,-1,['Bind_processChanges.timingChanged____DO_NOTHING']);
			//BindScript.updateAttrib(changed.bind_id,'timeEnd',changed.end,multiSpecs,-1);
	
		}
		
		public static function stimChanged(stimuli:Array, changed:Object):void
		{
			var stim:object_baseClass;
			var multiSpecs:Object;
			//trace(23,stimuli,changed,3)
			for(var i:int=0;i<stimuli.length;i++){
				stim=stimuli[i];

				multiSpecs = MultiTrialCorrection.compute(stim);
				multiSpecs.defaults = getDefaults(changed,stim);
						
				var update:Boolean = false;
				var bind_id:String = stim.getVar(BindScript.bindLabel);
				
				var propList:Array=[];
				for(var prop:String in changed){ //fairly odd hack. Function within a function has some strange behavs that this prevents
					//trace(123,prop,stim)
					propList.push(prop);
				}
	
				var wasChange:Boolean = false;
				for each(prop in propList){
					wasChange=true;
					//if(prop=='x')		sortX(stim, Number(changed[prop]), bind_id);
					//else if(prop=='y')	sortY(stim, Number(changed[prop]), bind_id);
					//else{
						BindScript.updateAttrib(bind_id,prop,changed[prop],multiSpecs,-1,null,false);
					//}
				}
				trace("in here",222,wasChange)
				if(wasChange) BindScript.updated(['Bind_processChanges']);
			}
			
		}
		
		public static function getDefaults(changed:Object, stim:object_baseClass):Object
		{
			var obj:Object = {};
			
			for(var key:String in changed){
				if(stim.makerObj.attrsInfo[key]){
					obj[key] = stim.makerObj.attrsInfo[key].defaultVal;
					//trace(456,key,JSON.stringify(stim.makerObj.attrsInfo[key]))
				}
			}
			
			return obj;
		}
		

		
			
		
		
	

		
		
		
		/*private static function sortLocation(stim:object_baseClass, dimens:String, val:String):String
		{
			// TODO Auto Generated method stub
			return null;
		}*/
	}
}