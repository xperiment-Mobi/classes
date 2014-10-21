package com{
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	public class codeRecycleFunctionsdead {

		public static function multipleTrialCorrection(s:String,seperator:String,duplicateTrialNumber:uint):String {

			if (s.indexOf(seperator)!=-1) {
				var tempArray:Array=s.split(seperator);
				s=String(tempArray[duplicateTrialNumber%tempArray.length]);
			}
	
			return s;

		}
		//far too messy to use this. Interactions EVERYWHERE made this impossible to implement
		/*public static function multipleTrialCorrectionTime(s:String,seperator:String,duplicateTrialNumber:uint):String {
			if((s.length<7 || s.substr(s.length-6,6))!="---etc") return multipleTrialCorrection(s,seperator,duplicateTrialNumber);
			else{
				trace("ping",s,duplicateTrialNumber)
				var ss:String=s;
				var arr:Array=s.split(seperator);
				arr.pop();
				
				if(duplicateTrialNumber<arr.length)s= arr[duplicateTrialNumber];
				else{
					
					var val:Number=arr[arr.length-1];
					var difArr:Array=new Array;
					difArr[0]=arr[0];
					for (var i:int=1;i<arr.length;i++){
						difArr[i]=arr[i]-arr[i-1];
					}
					if(difArr[0]==0)difArr.shift();
					
					for(i=arr.length-1;i<duplicateTrialNumber;i++){
						val+=Number(difArr[(i+1)%difArr.length]);
					}
					s= String(val);
				
				}
				trace(s);
				return s;
			}
		}*/
		
		
		public static function roundToPrecision(numberVal:Number, precision:int = 0):Number{
			var decimalPlaces:Number = Math.pow(10, precision);
			return Math.round(decimalPlaces * numberVal) / decimalPlaces;
		}
		
		public static function roundUpToNearest(numberVal:Number, roundTo:Number):Number{
			return Math.ceil(numberVal / roundTo) * roundTo;
		}
 

		public static function roundDownToNearest(numberVal:Number, roundTo:Number):Number{
			return Math.floor(numberVal / roundTo) * roundTo;
		}
		
		public static function dp(num:Number, decPla:Number):Number{
			decPla=Math.pow(10,decPla);
			num= int((num)*decPla)/decPla;
			return num;
		}

		public static function mathVal(val:String):int {
			var num:int;
			if (val.length<9) {
				return 0;
			}
			else {
				num=val.indexOf("+");
				if ((num!=-1)) {
					num=int(val.substring((num+1),val.length));
					return num;
				}
				num=val.indexOf("-");
				if ((num!=-1)) {
					num=-1*int(val.substring((num+1),val.length));
					return num;
				}
			}
			return 0;
		}

		public static function clone(source:Object):* {
			var copier:ByteArray=new ByteArray  ;
			copier.writeObject(source);
			copier.position=0;
			return (copier.readObject());
		}

		public static function getUniqueValues(originalArray:Array):Array {
			var lookup:Array=new Array  ;
			var uniqueArr:Array=new Array  ;
			var num:int;
			for (var idx:int=0; idx<originalArray.length; idx++) {
				num=originalArray[idx];
				if (! lookup[num]) {
					var obj:Object=new Object  ;
					obj.id=num;
					obj.count=0;
					uniqueArr.push(obj);
					lookup[num]=true;
				}
			}
			return uniqueArr;
		}

		//from here (other good functions here too): http://www.designscripting.com/2008/11/string-utils-in-as3/
		public static function IsNumeric(inputStr:String):Boolean {
			var obj:RegExp=/^(0|[1-9][0-9]*)$/;
			return obj.test(inputStr);
		}

		public static function addUpArray(arr:Array):int {
			var value:int;
			for (var i:uint=0; i<arr.length; i++) {
				value+=arr[i];
			}
			return value;
		}

		
		
		public static function biggestInArray(arr:Array):int {
			var biggestSoFar:int;
			for (var i:uint=1; i<arr.length; i++) {
				if (! biggestSoFar) {
					biggestSoFar=int(arr[0]);
				}
				if (arr[i]>biggestSoFar) {
					biggestSoFar=int(arr[i]);
				}
			}
			return biggestSoFar;
		}

		public static function smallestInArray(arr:Array):int {
			var smallestSoFar:int;
			for (var i:uint=1; i<arr.length; i++) {
				if (! smallestSoFar) {
					smallestSoFar=int(arr[0]);
				}
				if (arr[i]<smallestSoFar) {
					smallestSoFar=int(arr[i]);
				}
			}
			return smallestSoFar;
		}

		public static function findStart(arr:Array,num:int):uint {
			var returnNum:uint=arr[arr.length-1];
			for (var i:uint=0; i<arr.length; i++) {
				if (arr[i]==num) {
					returnNum=i;
					break;
				}
			}
			return returnNum;
		}
		
		public static function findEnd(arr:Array,num:int):uint {
			var returnNum:uint=arr[arr.length-1];
			for (var i:uint=arr.length; i<0; i--) {
				if (arr[i]==num) {
					returnNum=i;
					break;
				}
			}
			return returnNum;
		}
		
		public static function returnType(obj:*):*{
			return getDefinitionByName(obj);
		}
		
		
		//Fisher-yates Shuffle, adapted from JS from here: http://bost.ocks.org/mike/shuffle/
		public static function arrayShuffle(arr:Array):Array{ 
			var m:uint = arr.length, t:*, i:uint;
			// While there remain elements to shuffle…
			while (m) {
				// Pick a remaining element…
				i = Math.floor(Math.random() * m--);
				// And swap it with the current element.
				t = arr[m];
				arr[m] = arr[i];
				arr[i] = t;
			}
			return arr;
		}
		
	}
}