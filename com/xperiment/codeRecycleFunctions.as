package com.xperiment{
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	public class codeRecycleFunctions {
		
		private static var shuffleArrDict:Dictionary;
		
		public static function kill():void{
			shuffleArrDict = null;
		}
		
		public static function calcArrayAv(arr:Array):Number{
			var av:Number=0;
			
			for(var i:int=0;i<arr.length;i++){
				av+=arr[i];
			}
			
			return av/arr.length;
		}
		

		public static function multipleTrialCorrection(s:String,seperator:String,duplicateTrialNumber:uint):String {

			if (s.indexOf(seperator)!=-1) {
				var tempArray:Array=s.split(seperator);
				s=String(tempArray[duplicateTrialNumber%tempArray.length]);
			}
	
			return s;

		}
		
					
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
			var arr:Array = newStr.split("<-~split~->");
			return arr;
		}

		public static function roundToPrecision(numberVal:Number, precision:int = 0):Number{
			var decimalPlaces:Number = Math.pow(10, precision);
			return Math.round(decimalPlaces * numberVal) / decimalPlaces;
		}
/*		
		public static function roundUpToNearest(numberVal:Number, roundTo:Number):Number{
			if(roundTo==0)return int(numberVal);
			return Math.ceil(numberVal / roundTo) * roundTo;
		}
 

		public static function roundDownToNearest(numberVal:Number, roundTo:Number):Number{
			if(roundTo==0){
				return int(numberVal);
			}
			return Math.floor(numberVal / roundTo) * roundTo;
		}*/
		
		//below tests dp() below.  Seems fine
		/*var rand:Number;
		var nth:uint;
		var res:Number;
		for(var i:int=0;i<100000;i++){
			rand=Math.random()*10;
			nth=3;
			res=dp(rand,nth);
			if(String(res).length>nth+3){
				trace(res,String(res),rand,nth);
				break;
			}
		}*/
/*		public static function dp(num:Number, decPla:Number):Number{
			decPla=Math.pow(10,decPla);
			num=Math.round(num * decPla)/decPla;
			return num;
		}*/

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
		
		
		public static function uniquePegs(arr:Array,id:String=''):Array{ 
			var listPegs:Array = [];
			
			for(var i:int=arr.length-1;i>=0;i--){
				
				if(listPegs.indexOf(arr[i].peg)==-1){
					listPegs.push(arr[i].peg);
				}
				else{
					arr.splice(i,1);
				}
				
			}
			
			return arr;
		}
		
		
		//Fisher-yates Shuffle, adapted from JS from here: http://bost.ocks.org/mike/shuffle/		
		public static function arrayShuffle(arr:Array,id:String=''):Array{ 
			
			var randomList:Array;
			var m:uint = arr.length, t:*, i:uint;
			
			if(id!=''){
				shuffleArrDict ||= new Dictionary;
				
				if(shuffleArrDict[id]!=undefined)randomList=shuffleArrDict[id]

			}
			
			if(!randomList){
				randomList=[];
				for(i=0;i<m;i++){
					randomList[i]=Math.random();
				}
			}
			
			
			// While there remain elements to shuffle…
			while (m) {
				// Pick a remaining element…
				
				i = Math.floor(randomList[m-1] * m--);
				// And swap it with the current element.
				t = arr[m];
				arr[m] = arr[i];
				arr[i] = t;
			}
			
			if(id!='' && shuffleArrDict[id]==undefined){
				shuffleArrDict[id]=randomList;
			}
			
			return arr;
		}
		
		
		//unit test me
		/*var a1:Array=[1,2,3];
		var a2:Array=[1,2,3];
		var a3:Array=[1,2,3];

		
		var arr:Array = [a1,a2,a3];
		uniqueShuffle(arr);
		
		trace(a1);
		trace(a2);
		trace(a3);*/
		public static function uniqueShuffle(arr:Array):void{
		//takes an array of equally lengthed arrays and shuffles them so that none of them are identically 'vertically'
			
			function isSame(limit:int):Boolean{
				var list:Array;
				var val:String;
				
				for(var row_i:int=0;row_i<arr[0].length;row_i++){
					list=[];
					for(var col_i:int=0;col_i<=limit;col_i++){
						val=arr[col_i][row_i].toString();
						if(list.indexOf(val)==-1)list.push(val);
						else return false;
					}
				}
				return true;
			}
			
			var threshold:int=arr[0].length;
			threshold*=threshold;
			threshold=1000/threshold;
			//gives up after approx 1000 attempts (I may be out by a factorial!).
			
			arrayShuffle(arr[0]);
			
			var count:int=0;
			var backSteps:int=0;
			outerLoop: for(var i:int=1;i<arr.length;i++){
				count=0;
				while(true){
					arrayShuffle(arr[i]);
					if(isSame(i) || i==0)break;
					if(count>threshold){
						if(backSteps>threshold)break outerLoop;
						i--;
						backSteps++;
						count=0;
					}
					count++;
				}
			}
		}
		
		public static function getColour(colour:String):int{
			
			
			
			switch((colour as String).toLowerCase()){
				case "red":
					return 0xFF0000;
				case "green":
					return 0x00FF00;
				case "blue":
					return 0x0000FF;
				case "yellow":
					return 0xFFFF00;
				case "pink":
					return 0xFFC0CB;
				case "orange":
					return 0xFFA500;
				case "white":
					return 0xFFFFFF;
				case "brown":
					return 0xA52A2A;
				case "black":
					return 0x000000;
				case "gray":
				case "grey":
					return 0x808080;
				case "purple":
					return 0x800080;
					//colours defined here http://www.htmlgoodies.com/tutorials/colors/article.php/3478961/So-You-Want-A-Basic-Color-Code-Huh.htm
			}
			
			if(colour.charAt(0)=="#")colour = "0x" + colour.substr(1);
			
			if(!isNaN(int(colour))){
				return int(colour);
			}
			
			throw new Error("you have specified a colour incorrectly or have used text I don't understand:"+colour);
			return null;
		}
		

		public static function removeQuots(str:String):String{
			if(str.charAt(0)=="'" && str.charAt(str.length-1)=="'")	return str.substr(1,str.length-2);
			return str;
		}
		
		public static function addQuots(str:String):String{
			if(str.charAt(0)=="'" && str.charAt(str.length-1)=="'")	str;
			return "'"+str+"'";
		}
		
		public static function rotateAroundCenter (ob:DisplayObject, angleDegrees:Number):void
		{
			var matrix:Matrix = ob.transform.matrix; 
			
			var rect:Rectangle = ob.getBounds(ob.parent); 
			
			matrix.translate(- (rect.left + (rect.width/2)), - (rect.top + (rect.height/2))); 
			
			matrix.rotate((angleDegrees/180)*Math.PI); 
			
			matrix.translate(rect.left + (rect.width / 2), rect.top + (rect.height / 2));
			
			ob.transform.matrix = matrix;
		}
		
		public static function centre(obj:DisplayObject,parentWidth:Number,parentHeight:Number):void{
			centreX(obj,parentWidth);
			centreY(obj,parentHeight);
		}
		
		public static  function centreX(obj:DisplayObject,parentWidth:Number):void{
			obj.x=parentWidth*.5-obj.width*.5;	
		}
		
		public static  function centreY(obj:DisplayObject,parentHeight:Number):void{
			obj.y=parentHeight*.5-obj.height*.5;	
		}
		
		
		public static function fixLocalDir(localDirectory:String):String
		{
			var seperator:String='';
			for(var i:int = 0;i<localDirectory.length;i++){
				//this awkwardness here is a compromise for IOS, who use weird slashes.
				if(['/',String.fromCharCode(92)].indexOf(localDirectory.charAt(i))!=-1){
					seperator=localDirectory.charAt(i);
					break;
				}
			}
			
			//needed for web experiments
			if(seperator=='')seperator='/'; 
			
			//below removes inconsistencies in slashes
			if(seperator=='/')	localDirectory.split(String.fromCharCode(92)).join('/');
			else 				localDirectory.split('/').join(String.fromCharCode(92));
			
			return localDirectory+=seperator;
		}			
		
		public static function getRand(randStr:String):int
		{
			
			var randArr:Array = randStr.split("rand(").join('').split(")").join('').split(":");
			
			if(randArr.length!=2)throw new Error("you must provide random number argument as follows: rand(1:20)");
			var range:int = int(randArr[1])-int(randArr[0]);
			return int(randArr[0])+Math.round(Math.random()*range);
			
		}
		
		public static function getFilename(url:String):String
		{
			var arr:Array;
			if(url.indexOf("/")!=-1)arr=url.split("/");
			else if(url.indexOf(String.fromCharCode(90))!=-1)arr=url.split(String.fromCharCode(90));
			if(arr)return arr[arr.length-1];
			return url;
		}
		
/*		unitTest svp fgfgfg6
		
		trace(safeText("fgfgf",true) == "<![CDATA[fgfgf]]>");
		try{
			safeText("<![CDATA[fgfgf",true)
		}
		catch(e:Error){
			trace(true);
		}
		try{
			safeText("fgfgf]]>",true)
		}
		catch(e:Error){
			trace(true);
		}
		try{
			safeText("fgfgf]]>",false)
		}
		catch(e:Error){
			trace(true);
		}
		try{
			safeText("<![CDATA[fgfgf",false)
		}
		catch(e:Error){
			trace(true);
		}
		trace(safeText("<![CDATA[fgfgf]]>",false) == "fgfgf");*/
		
		
		
		public static function safeText(htmlText:String, add:Boolean):String
		{
			if(add){
				if(htmlText.substr(0,9)=="<![CDATA[" || htmlText.substr(htmlText.length-3,3)=="]]>")throw new Error();
				return htmlText
				return "<![CDATA["+htmlText+"]]>";
			}
			
			if(htmlText.substr(0,9)!="<![CDATA[" || htmlText.substr(htmlText.length-3,3)!="]]>")throw new Error();
			
			return htmlText.substr(9,htmlText.length-12);
		}
	}
}