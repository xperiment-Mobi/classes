package com.xperiment.make.xpt_interface
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.Bind.MultiTrialCorrection;
	import com.xperiment.make.xpt_interface.Bind.UpdateRunnerScript;
	import com.xperiment.stimuli.object_baseClass;

	public class Stim_Juggle
	{
	

		public static function DO(command:String, r:runnerBuilder):void
		{
			
			
			var stimuliSelected:Array = r.pos_scale.selected();
			
			//trace(11,bindIds.length)
			if(stimuliSelected.length==0) return;

			if(command == 'duplicate')		multi(duplicate);		
			//else if(command == 'combine')	combine(bindIds,r);		
			//else if(command == 'splitup')	multi(splitup);
			
			function multi(f:Function):void
			{
				//trace(111,bindIds)
				for(var i:int=0;i<stimuliSelected.length;i++){
					f(stimuliSelected[i],r);
				}
			}
		}
		
		
		private static function splitup(bindId:String,r:runnerBuilder):void
		{
			var stim:XML = BindScript.getStimScript(bindId).copy();
			//trace(stim.toXMLString());
			var howManyStr:String = stim.@howMany.toString();
			if(howManyStr == '' || howManyStr == '1' || isNaN(Number(howManyStr))) return;
			var howMany:int = int(howManyStr);

			BindScript.deleteX(bindId,false);
			
			stim.@howMany=1;
			var parentId:String = (r.runningTrial as TrialBuilder).bind_id;
		
			for(var i:int=0;i<howMany;i++){
				//trace(111,i==howMany-1)
				BindScript.addStimulus(parentId,generateStim(stim.copy(),i),i==howMany-1);
			}
			
			var duplicateTrialNumber:int;
			
			function generateStim(newStim,i):XML{
				var val:String;

				for each (var att : XML in newStim.@*){
					val=att.valueOf();
					
					if(val.indexOf("---")!=-1){
						duplicateTrialNumber ||= r.runningTrial.trialBlockPositionStart;
						val = codeRecycleFunctions.multipleTrialCorrection(val,object_baseClass.multTriCorSym,duplicateTrialNumber);
						val = codeRecycleFunctions.multipleTrialCorrection(val,object_baseClass.multObjCorSym,i);
						newStim.@[att.name()] = val;
					}
				}
				
				return newStim;
			}

		}
		
/*		private static function combine(bindIds:Array,r:runnerBuilder):void
		{
			var stim:XML;
			var stims:Array = [];
			for(var i:int=i;i<bindIds.length;i++){
				stims[i] = BindScript.getStimScript(bindIds[i]).copy();
				BindScript.deleteX(bindIds[i],false);
			}
			stim = stims[0];
			for(i=1;i<bindIds.length;i++){
				
			}
			
			
		}*/
		
		private static function duplicate(stimObj:object_baseClass,r:runnerBuilder):void
		{
			
			var bind_id:String = stimObj.getVar(BindScript.bindLabel);
			
			var stim:XML = BindScript.getStimScript(bind_id).copy();
			

			var howManyStr:String = stim.@howMany.toString();
			if(howManyStr == '' || isNaN(Number(howManyStr))) howManyStr = '1';
			var howMany:int = int(howManyStr)+1;
			
			var toUpdate:Object = MultiTrialCorrection.duplicateUp(howMany,stim,stimObj);
			toUpdate.howMany=howMany;
			
			BindScript.StimulusUpdate(bind_id,toUpdate);
			UpdateRunnerScript.DO(bind_id);
			
			BindScript.updated(['BindScript.duplicated']);

		}
	}
}