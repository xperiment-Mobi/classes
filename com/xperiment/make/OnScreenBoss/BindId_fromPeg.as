package com.xperiment.make.OnScreenBoss
{
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.stimuli.object_baseClass;

	public class BindId_fromPeg
	{
		public static function DO(peg:String):String{
			
			var stimuli:Array 		= OnScreenBossMaker.instance.allStim;
			var stim:object_baseClass;
			
			for(var i:int=0;i<stimuli.length;i++){
				stim = stimuli[i];
				if(stim.peg == peg) return stim.getVar(BindScript.bindLabel);
			}
			
			return '';
		}
	}
}