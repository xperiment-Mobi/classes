package com.xperiment.StringStuff
{
	
	import com.Logger.Logger;
	import com.adobe.serialization.json.JSON;
	
	public class StringProcessing
	{
	
		//converts a string into an object.  String specified as such: "{apple:a,'pear':2,banana:'b'}"
		//note that the properties of the Object do not need to be surrounded by quotation marks.
		//note too that the values of object properties do NOT use quotation marks IF they are a number.
		static public function StringToObject(str:String):Object
		{
			str=str.replace(/'/g,String.fromCharCode(34));
			var tempTxt:String;
			var oldTxt:String;
			var isLetter:RegExp=/^[a-zA-Z0-9]/
			var arr:Array=str.split(":");
			for (var i:uint=0;i<arr.length-1;i++){
				tempTxt=String.fromCharCode(34);
				oldTxt=arr[i];
				if(oldTxt.charAt(oldTxt.length-1)!=String.fromCharCode(34))tempTxt=oldTxt.charAt(oldTxt.length-1)+tempTxt;
				for(var j:int=oldTxt.length-2;j>=0;j--){
					if(isLetter.test(oldTxt.charAt(j)))tempTxt=oldTxt.charAt(j)+tempTxt;
					else if(oldTxt.charAt(j)==String.fromCharCode(34)){
						tempTxt=oldTxt.substr(0,j+1)+tempTxt;
						break;
					}
					else if(oldTxt.charAt(j)=="{"){
						tempTxt=oldTxt.substr(0,j+1)+String.fromCharCode(34)+tempTxt;
						break;
					}
					else {
						tempTxt=oldTxt.substr(0,j+1)+String.fromCharCode(34)+tempTxt;
						break;
					}
				}
				arr[i]=tempTxt;
			}
			
			tempTxt=arr.join(":");
			var obj:Object;
			try{
				obj=com.adobe.serialization.json.JSON.decode(tempTxt) as Object;
			}
			catch(e:Error){
				var logger:Logger=Logger.getInstance();
				if(logger)logger.log("!Problem with how you entered data. This is wrong: "+str);
				obj={};
			}
			
/*			for (var s:String in obj){
				trace(s,obj[s]);
				
			}*/
			
			return obj;
		}
	}
}