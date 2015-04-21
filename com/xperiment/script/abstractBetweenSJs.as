package com.xperiment.script
{
		
	import flash.display.Sprite;
	import flash.events.Event;

	public class abstractBetweenSJs extends Sprite
	{
		public var script:XML;
		
		//unit tested in test_RandCond
		public function forceConditionF(forceCondition:String):void
		{

			var found:Boolean = false;
			for (var i:int=0; i< script.children().length(); i++){
				if(script.children()[i].name().toString()==forceCondition){
					
					script = MeldConditions.DO(script,i);
					
					this.dispatchEvent(new Event(Event.COMPLETE));
					found = true;
					break;
				}
			}
			if(found==false)	throw new Error("you asked to force a between SJ condition, but that condition does not exist!: "+forceCondition);
		}
		
		public function sortOutMultiExperiment(parentScript:XML,urlParam_Cond:String):void{
			this.script=parentScript;
			
			//trace(11111,urlParam_Cond)
			if(script.hasOwnProperty('MULTISETUP')){
			
				var multisetup:XMLList=script.MULTISETUP;
				var forceCondition:String=urlParam_Cond;

				if(forceCondition=="" && multisetup.hasOwnProperty('@forceCondition')){	
					forceCondition=script.MULTISETUP.@forceCondition;
				}
				//trace(23,script.MULTISETUP.toXMLString())
				delete script.MULTISETUP;
				if(forceCondition!='')forceConditionF(forceCondition);
					
					//if there are any @SJs and atleast one SJs with value greater than zero (or blank)
				else if(multisetup..*.(hasOwnProperty('@conditionSJs') && ['','0'].indexOf(String(@conditionSJs))==-1).length()>0){
					getCondOverSJquants(multisetup.children());	
				}
				
				else randomlySelectCond();
			}		
			else {
				
				__singleMultiStep(script.attributes());
			}
		}
		
		protected function randomlySelectCond():void
		{
			throw new Error('must override randomlySelectCond function');
		}		
		
		
		public function getCondOverSJquants(param0:XMLList):void
		{
			throw new Error('must override getCondOverSJquants function');
		}
		
		public function __singleMultiStep(param0:XMLList):Array
		{
			throw new Error('must override __singleMultiStep function');
		}

		
		public function __getCondFromServer(param0:Array):void
		{
			throw new Error('must override this function');
		}		
		
	}
}