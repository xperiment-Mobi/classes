package com.xperiment.script.ProcessScriptHelpers
{
	public class SortoutPREVandNEXT
	{

		public static const PREV:String = 'PREV';
		public static const NEXT:String = 'NEXT';
		
		public static function now(script:XML):XML
		{
			
				
			var list:Array=[PREV,NEXT];
			var startingVal:String;
			var parent:XML;
			var sibling:XML;
			var siblingIndex:int;
			var parentNumChildren:int;
			
			for each(var direction:String in list){
				
				var adjacentStim:XML;
				
				for each (var stimulus:XML in script..*.(attributes().toString().indexOf(direction)!=-1)) {
					//need this loop within a loop as whole objects above are retrieved.  Need to isolate the attribute in the second loop.

					for each (var attrib:XML in stimulus.attributes()) {
						startingVal=attrib.toString();
						
						parent=stimulus.parent();
						
						//trace(stimulus.childIndex(),33)
						
						if(direction==PREV)siblingIndex=stimulus.childIndex()-1;
						else if(direction==NEXT)siblingIndex=stimulus.childIndex()+1;
						else throw new Error();
						
						//siblingIndex=__computeSiblingIndex(parent.children().length(),siblingIndex);
						parentNumChildren=parent.children().length();
						
						
						
					}
				}
			}
			
			return null;
		}
		
		public static function __computeSiblingIndex(parentNumChildren:int, siblingIndex:int):int
		{
			var res:int
			if(siblingIndex==0)return 0;
			else if(siblingIndex>=0)res=siblingIndex%parentNumChildren+1;
			else{
				res=(parentNumChildren-(siblingIndex*-1)+1%parentNumChildren)-1;
			}
			
			return res;
		}
	}
}