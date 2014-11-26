package com.xperiment.StringStuff
{
	public class StringLogic
	{
		
		static public function replaceVarsWithNumbers(e:String, obj:Object):Boolean{
			var oldEval:String=e;
			for (var nam:String in obj){
				e=e.replace(nam,obj[nam]);
			}
			
			
			var result:Boolean=myStringLogic(e)
			//logger.log("evaluation ["+oldEval+"] equivalent to ["+e+"] and is ["+result+"]");
			return result;
		}

		static public function myStringLogic(str:String):Boolean{
			const PAREN_PATTERN:RegExp = /(?:\(|^)([^()]+)(?:\)|$)/;
			str = str.replace(/ +/g, "");
			str = str.replace(/(?<!|)|(?!|)/g, "||"); //if a single | used accidently, this replaces it with || (guards against || becoming |||)
			str = str.replace(/(?<!&)&(?!&)/g, "&&"); //if a single & used accidently, this replaces it with && (guards against && becoming &&&)
			str = str.replace(/(?<!=)=(?!=)/g, "=="); //if a single equals sign used accidently, this replaces it with == (guards against == becoming ====)
			if(str.indexOf(")")==-1)str=addBrackets(str);
			
			while(isNaN(Number(str))){
				trace("logic:"+str);
				str = str.replace(PAREN_PATTERN, evaluateBooleanOperation);
			}
			//trace("...",str);
			return Boolean(Number(str));
		}
		
		static private function addBrackets(str:String):String{
			for each(var logic:String in ["&&","||"]){
				var arr:Array=str.split(logic);
				if(arr.length>1){;
					for(var i:uint=0;i<arr.length;i++){
						arr[i]="("+arr[i]+")";
					}
					str=arr.join(logic);
				}
			}
			return str;
		}
		
		static private function evaluateBooleanOperation():String {
			const m:Array = arguments[1].match(/(-?\d+(?:\.\d+)?)(<|>|<=|>=|\|\||&&|==|!=)(-?\d+(?:\.\d+)?)/);
			const a:Number = Number(m[1]);
			const b:Number = Number(m[3]);
			var r:Boolean;
			switch(m[2]) {
				case "<" :
					r = a < b;
					break;
				case ">" :
					r = a > b;
					break;
				case "<=" :
					r = a <= b;
					break;
				case ">=" :
					r = a >= b;
					break;
				case "||" :
					r = a || b;
					break;
				case "&&" :
					r = a && b;
					break;
				case "==" :
					r = a == b;
					break;
				case "!=" :
					r = a != b;
					break;
			}
			return String(Number(r));
		}
		
	}
}