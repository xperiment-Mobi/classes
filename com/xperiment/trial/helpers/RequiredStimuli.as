package com.xperiment.trial.helpers
{
	import com.xperiment.stimuli.IStimulus;
	import com.xperiment.stimuli.object_baseClass;

	public class RequiredStimuli
	{
		private var required:Vector.<object_baseClass> = new Vector.<object_baseClass>;

		
		public function add(tempObj:IStimulus):void
		{
			required.push(tempObj);
		}
		
		public function compute(bind:Function, updateVal:Function):void
		{
			var result_Fs:Vector.<Function> = new Vector.<Function>;
			
				
			
			function check_F():String{
				
				var result:String;
	
				for each(var stim:object_baseClass in required){
					
					result = stim.myUniqueProps("result")();
					//trace(stim,result);
					var requiredStr:String = "'"+stim.getVar("required")+"'";

					if(requiredStr.length>1 && requiredStr.substr(1,2)=="=="){	
						requiredStr=requiredStr.substr(3);
						requiredStr=requiredStr.substr(0,requiredStr.length-1);
						if(result != "'"+requiredStr+"'") return 'false';
					}
					
					
					else{
						if(result == requiredStr){
							return 'false';
						}
					}
				}
				
				return 'true';
			}
			
			updateVal("required",check_F);
			bind("required",check_F);
			
			
			
		}
		
		public function kill():void
		{
			required=null;
		}
	}
}