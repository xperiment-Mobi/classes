package com.xperiment.behaviour
{

	import com.xperiment.events.GlobalFunctionsEvent;
	import flash.utils.Dictionary;

	
	public class behavLanguage extends behav_baseClass
	{
		private var exptScript:XML;

		
		
		override public function setVariables(list:XMLList):void {
			
			setVar("string","language","");
			super.setVariables(list);
		}	
		
		
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('language')==false){

				uniqueProps.language= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what && to!=null) {
						OnScreenElements.language=to.substr(1,to.length-2);
					}
					return getVar("language");
				}; 	
			}

			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		public function giveExptScript(exptScript:XML):void{
			this.exptScript=exptScript;
		}
		
		override public function nextStep(id:String=""):void
		{

			theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.LANGUAGE,getVar("language")));
			super.nextStep();
		}
	}
}