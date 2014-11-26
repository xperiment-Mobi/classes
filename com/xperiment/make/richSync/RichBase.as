package com.xperiment.make.richSync
{
	public class RichBase
	{
		public var _rich_poor_connects:Vector.<RichPoorLineLinker>;
			
		public function compute(str:String):void
		{
			if(_rich_poor_connects)wipe();
			
			_rich_poor_connects = new Vector.<RichPoorLineLinker>;
			
			var orig:String;
			var richPoorLink:RichPoorLineLinker; 
			
			var lineArr:Array=str.split("\n")
			
			for(var line:int=0; line<lineArr.length; line++){
				
				richPoorLink = new RichPoorLineLinker();
				
				richPoorLink.computeRichPoor(lineArr[line],line);
				
				_rich_poor_connects[line]=richPoorLink;
			}	
		}
		
		public function wipe():void{
			for(var line:int=0;line<_rich_poor_connects.length;line++){
				_rich_poor_connects[line]=null;
			}
			_rich_poor_connects=null;
		}
	}
}