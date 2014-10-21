package com.xperiment.make.xpt_interface.Bind
{
	import com.xperiment.make.xpt_interface.Cards.CardLevel;

	public class Bind_delTrial
	{
	
		public static function DO(cards:Array,groups:Array):void
		{
			delCards(cards);
			BindScript.deleteXs(groups);			
		}

		
		private static function delCards(cards:Array):void
		{
			if(cards.length==0)	return;
			
			var uniqueBinds:Object = __tallyUniqueBinds(cards);
			
			var stim:XML, trials:int, str:String;
			
			for(var stimBind:String in uniqueBinds){

				stim = getSelected(stimBind);
				if(stim){
					str = stim.@trials;
					if(str.length==0) BindScript.deleteX(stimBind,false);
					else{
						trials = int(str);
						if(trials<=uniqueBinds[stimBind]){
		
							BindScript.deleteX(stimBind,false);
						}
						else{
							stim.@trials=(trials-uniqueBinds[stimBind]).toString();
						}
					}	
				}
			}

			BindScript.updated(['Bind_delTrial.delCards']);
			
		}
		
		private static function getSelected(bind:String):XML{
			return BindScript.getStimScript(bind);
		}
		
		
		public static function __tallyUniqueBinds(cards:Array):Object
		{
			var obj:Object = {};
			var mod:String;
			for(var i:int=0;i<cards.length;i++){
				mod = removeMultiTag(cards[i]);
				if(obj.hasOwnProperty(mod)==false)	obj[mod] = 1;
				else obj[mod]+=1;
			}
			
			return obj;
		}
		
		private static function removeMultiTag(trialSelected:String):String
		{
			return trialSelected.split(CardLevel.TRIAL_SPLIT)[0];
		}	
	}
}