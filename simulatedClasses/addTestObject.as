package simulatedClasses
{
	public class addTestObject
	{
		var OnScreenElements:Array = new Array;
		
		public function addTestObject()
		{
		}
		
		
		public function getVar(nam:String):* {
			if (OnScreenElements && OnScreenElements[nam]!=undefined) {
				return OnScreenElements[nam];
			
			}
			else {
				
				return "";
			}
		}
		
		
		public function setVar(typ:String, nam:String, val:*,defaultVals:String="",info:String=""):void {
			if(!OnScreenElements.hasOwnProperty(nam))OnScreenElements[nam]=val;
		}
	}
}