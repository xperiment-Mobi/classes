package com.tools
{
	public class StrTools
	{
		public function StrTools()
		{
		}
		
		
		public static function fixNoAND(str:String):String{
			var pos:int=str.indexOf(":");
			if(pos==-1) return str;
			else{
				var before:String=str.substr(0,pos);
				
				for(var i:int=before.length-1;i>=0;i--){
					//trace(before.charAt(i));
					if(["&",":","]"].indexOf(before.charAt)!=-1)break;
					else if(before.charAt(i)==","){
						before=before.substr(0,i)+"&&"+before.substr(i+1);
						break;
					}
				}	
				if(before.length<str.length) return before+":"+fixNoAND(str.substr(pos+1));
				else return before
			}
		}
				
		/*
		trace("testQuoteReplac:",fixNoANDoutsideQuots("")=="");
		trace("testQuoteReplac:",fixNoANDoutsideQuots(" ")==" ");
		trace("testQuoteReplac:",fixNoANDoutsideQuots("abc''def")=="abc''def");
		trace("testQuoteReplac:",fixNoANDoutsideQuots("'a'abc'b'def'c'")=="'a'abc'b'def'c'");
		trace("testQuoteReplac:",fixNoANDoutsideQuots("rrr:abc,def,sss:ghi")=="rrr:abc,def&&sss:ghi");
		*/
		
		public static function giveUpperLevelSplit(str:String,split:String):Array{
			//if there are not an even number of quotes
			if((str.split("'").length-1)%2!=0){
				throw Error("wrongly formed formula (odd number of quotation marks):"+str);
			}
			
			var inBraces:Boolean=false;
			var inBracesOld:Boolean=false;
			var inBracesStr:String="";
			var newStr:String="";
			var inBracesArr:Array = [];
			var index:int=-1;
			
			for(var i:uint=0;i<str.length;i++){
				if(str.charAt(i)=="'"){
					inBraces=!inBraces; //toggles InBraces depending on whether in braces.
					if(!inBraces){
						index++;
						inBracesArr[index]=inBracesStr.substr(1);
						newStr+="'<~"+index+"~>";
						inBracesStr="";
					}
				}
				if(inBraces)inBracesStr+=str.charAt(i);
				else newStr+=str.charAt(i);
			}
			newStr=newStr.replace(new RegExp(split,"g"),"<-~split~->");
			while(index>=0){
				newStr=newStr.replace("<~"+index+"~>",inBracesArr[index]);
				index--;
			}
			return newStr.split("<-~split~->");
		}
	/*	
		public static function fixNoAND(str:String):String{
			var pos:int=str.indexOf(":");
			if(pos==-1) return str;
			else{
				var before:String=str.substr(0,pos);
				
				for(var i:int=before.length-1;i>=0;i--){
					//trace(before.charAt(i));
					if(["&",":","]"].indexOf(before.charAt)!=-1)break;
					else if(before.charAt(i)==","){
						before=before.substr(0,i)+"&&"+before.substr(i+1);
						break;
					}
				}	
				if(before.length<str.length) return before+":"+fixNoAND(str.substr(pos+1));
				else return before
			}
		}
		
		
		public static function giveUpperLevelSplit(str:String,split:String):String{
			//if there are not an even number of quotes
			if((str.split("'").length-1)%2!=0){
				throw Error("wrongly formed formula (odd number of quotation marks):"+str);
			}
			
			var inBraces:Boolean=false;
			var inBracesOld:Boolean=false;
			var inBracesStr:String="";
			var newStr:String="";
			var inBracesArr:Array = [];
			var index:int=-1;
			
			for(var i:uint=0;i<str.length;i++){
				if(str.charAt(i)=="'"){
					inBraces=!inBraces; //toggles InBraces depending on whether in braces.
					if(!inBraces){
						index++;
						inBracesArr[index]=inBracesStr.substr(1);
						newStr+="'<~"+index+"~>";
						inBracesStr="";
					}
				}
				if(inBraces)inBracesStr+=str.charAt(i);
				else newStr+=str.charAt(i);
			}
			newStr=funct(newStr);
			while(index>=0){
				newStr=newStr.replace("<~"+index+"~>",inBracesArr[index]);
				index--;
			}
			return newStr;
		}
		
*/
	}
}