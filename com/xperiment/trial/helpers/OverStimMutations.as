package com.xperiment.trial.helpers
{
	import com.xperiment.codeRecycleFunctions;

	public class OverStimMutations
	{

		private static var actions:Array = ['mutateswap'];
		
		public static function DO(stim:XML):void
		{
			var pos:int;
			
			for each(var xml:XML in stim.children()){
				pos = actions.indexOf(xml.name().toString().toLowerCase());
				if(pos!=-1	){
					var action:String = actions[pos];
					OverStimMutations[action](xml,stim);
				}
			}
			
		}

		public static function mutateswap(mutation:XML, stimuli:XML):void{
			
			var defaults:Object = {random:true, key:'myKey'};
			
			for each(var param:String in ['random','key']){
				if(mutation.hasOwnProperty('@'+param)){
					if(defaults[param] is Boolean) defaults[param] = Boolean(mutation.@[param].toString());
					else if(defaults[param] is Number) defaults[param] = Number(mutation.@[param].toString());
					else defaults[param] = mutation.@[param].toString();
				}
			}

			
			var swapStim:XMLList = stimuli.*.(hasOwnProperty('@'+defaults.key));
			var paramList:Array = [];
			
			
			for each(var stim:XML in swapStim){
				param = stim.@[defaults.key];
				paramList.push(String(stim.@[param]));
			}
			
			codeRecycleFunctions.arrayShuffle(paramList);
			
			for each(stim in swapStim){
				param = stim.@[defaults.key];
				stim.@[param] = String(paramList.shift());
			}
				
			
		}
	}
}