package com.xperiment.make.richSync
{
	import flash.xml.XMLDocument;

	public class SimpleAttrib
	{
		public var name:String;
		public var value:String;
		public var updated:Boolean=false;
		
		private var orig:String;
		private var quotMarkType:String;
		private var blanksBeforeVal:int;
		private var blanksAfterNam:int;
		
		public function SimpleAttrib(str:String,orig:String)
		{
			this.orig=orig;
			_parse(str);
		}
		
		public function reconstructOrig():String{
			var str:String = " " + name;
			
			for(var i:int=0;i<blanksAfterNam;i++){
				str+=" ";
			}
			str+="=";
			
			for(i=0;i<blanksBeforeVal;i++){
				str+=" ";
			}
			str+=quotMarkType+value+quotMarkType;

			return str
		}
		
		public function buildNameVal():String{
			return name + "=\"" + value + "\"";
		}
		
		public function _parse(str:String):void
		{
			var arr:Array = str.split("=");
			calcBlanksAfterNam(arr[0]);
			
			name=arr[0].replace(" ","");
			
			value=_removeBlanks(arr[1]);
			quotMarkType=value.substr(0,1);
			value=_clipWings(value)
		}	
		
		private function calcBlanksAfterNam(str:String):void
		{
			blanksAfterNam=0;
			for(var i:int=str.length-1;i>=0;i--){
				if(str.charAt(i)==" ")blanksAfterNam++;
				else break;
			}
		}
		
		public function _clipWings(str:String):String
		{
			return str.substr(1,str.length-2);
		}		
		
		public function _removeBlanks(str:String):String
		{
			blanksBeforeVal = 0;
			
			while(blanksBeforeVal<str.length){
				if(str.charAt(blanksBeforeVal)!=" ")break;
				blanksBeforeVal++;
			}

			str=str.substr(blanksBeforeVal);

			return str;
		}
		
		public function updatedAttrib(newValue):String{			
			return orig.replace(quotMarkType+value+quotMarkType,quotMarkType+cleanHTMLcode(newValue)+quotMarkType);
		}
		
		//used when e.g. there are html code such as 'new line (&#xA;) in the new node value
		private function cleanHTMLcode(str:String):String{
			return new XMLDocument(str).firstChild.nodeValue;
		}
		
	}
}