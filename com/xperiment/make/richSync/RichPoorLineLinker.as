package com.xperiment.make.richSync
{
	public class RichPoorLineLinker
	{
		public var line:String;
		public var labelled:String;
		
		public var startBracket:Boolean=false;
		public var endBracket:Boolean=false;
		
		private var lineNumber:int;
		

		
		public static var _isNode:RegExp = /<\w+\s/g //captures a partial node <t 
		private static var lineIdentifier:String = '_L=';
		
		
		public function computeRichPoor(orig:String,lineNumber:int):void
		{
			this.line=orig;
			this.lineNumber=lineNumber;
			
			if(orig.indexOf("<")!=-1)startBracket=true;
			if(orig.indexOf(">")!=-1)endBracket=true;
			
			this.labelled = _addLineNumsToNodes(orig,lineNumber);
		}
		
		public function addNameVal(nameVal:String):void{
			
			var find:String = "/>";
			var newLine:String = line.replace(find,nameVal+" "+find);
			if(newLine==line){
				line = line + " "+ nameVal;
			}
			else{
				line=newLine;
			}
		}
		
		public function removeNameVal(nameVal:String):void
		{
			line=line.replace(nameVal,"");
		}
	
		public static function _addLineNumsToNodes(str:String,line:int):String{
			var start_i:int;
			var end_i:int;
			var found:String;
			var strArr:Array = [];
			var strObj:Object;
			_isNode.lastIndex=0; // craziness: http://stackoverflow.com/questions/2455867/as3-regexp-exec-method-in-loop-problem
			
			_isWellformed(str);
			
			var result:Object = _isNode.exec(str);
			if(result){
				
				while(result!=null){
					found=result[0].replace(" "," "+ lineIdentifier +"'"+line+"' ");
					start_i=result.index;
					end_i=start_i+result[0].length;
					strObj={found:found,start_i:start_i, end_i:end_i}
					strArr.push(strObj)
					result = _isNode.exec(str);
				}
				
				end_i=0;
				var newStr:String = '';
				
				for(var i:int=0;i<strArr.length;i++){
					strObj=strArr[i]
					newStr+=str.substr(end_i,strObj.start_i-end_i)+strObj.found;
					end_i=strObj.end_i;
				}
				
				newStr+=str.substr(strObj.end_i);
				return newStr;
			}
			
			return str;
		}
		
		//makes sure that two << or >> are not in a row
		public static function _isWellformed(str):Boolean{
			var prev:String = '';
			for(var i:int=0;i<str.length;i++){
				if(["<",">"].indexOf(str.charAt(i))!=-1){
					if(prev==str.charAt(i)) throw new Error("Malformed Script!! Two << or >> in a row");
					else prev=str.charAt(i);
				}
			}
			
			if(str.split("<").length-1>1 || str.split(">").length-1>1)throw new Error("not allowed more than one node on a line!: "+str);
			return true;
		}
		
	}
	
}