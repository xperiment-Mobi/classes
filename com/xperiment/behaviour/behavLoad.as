package com.xperiment.behaviour
{
	import com.xperiment.uberSprite;
	import com.xperiment.Results.Results;
	import com.xperiment.stimuli.object_baseClass;

	public class behavLoad extends behavSave
	{
		private var exptResults:Results;
		private var variable:String;
		
		/*
		This function lets you get data from that stored.  Another object can ask for what variable, e.g. behavLoadPeg[bananaData], or this variable can be stored via the 'what' attribute.
		To pass this value onto another object, call that object and pass it data, e.g. otherObj[data]
		*/
		
		
		
		override public function setVariables(list:XMLList):void {
			setVar("string","what","");
			setVar("string","data","");

			super.setVariables(list);	
		}
		
		override public function givenObjects(obj:uberSprite):void{	
			
			var bc:object_baseClass = obj as object_baseClass;
			var myVar:String = getValFromAction(bc.getVar("behaviours"));
			if(getVar("what")=="")OnScreenElements["what"]=myVar;
		}
		

		override public function nextStep(id:String=""):void {	
			if(!exptResults)exptResults = Results.getInstance();
			var str:String = exptResults.getStoredVariable(getVar("what"));
			//trace("loaded:"+str);
			if(getVar("replace1")!="") str = replaceText(str,getVar("replace1"));
			OnScreenElements["data"]=str;
			behaviourFinished();
		}		
	}
}