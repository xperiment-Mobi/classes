package com.Start.MobilePlayerStart.utils
{
	public class ParseMobileScript
	{

		public static function addRemoteStimFolder(script:XML,url:String):XML
		{
			
			var loc:String = url;
			loc = splitPop(loc,"/");
			loc = splitPop(loc,"\\");


			setAttrib(script, 'SETUP','results','saveDataURL',loc);
			setAttrib(script, 'SETUP','computer','stimuliFolder',getStimLoc(loc) );
			
			XML.prettyPrinting=true;
			//trace(script)
			//https://www.xpt.mobi/stimuli/62a62aea21fb4e35918890eaeb90c2fd/P005_010911_OV_ST_COMP.flv
			return script;
		}
		
		private static function getStimLoc(loc:String):String
		{
			//'experiment/62a62aea21fb4e35918890eaeb90c2fd/app/'
			loc = loc.split("\\").join("/"); //think apple needs this
			
			var arr:Array = loc.split("/");	
			for each(loc in arr){
				if(loc.length==32){
					return 'https://www.xpt.mobi/stimuli/'+loc+"/";
				}
			}
			throw new Error();
				
			return loc;
		}		
		
		//below, testing setAttrib
		/*private static var my_xml:XML = <a><c cc='1'><c cc='1'/></c></a>;
		public static function DO():void
		{
			
			setAttrib(my_xml, 'c','cc','123');
			trace(my_xml);
			
		}*/
		
		private static function setAttrib(script:XML, parentParent:String, parent:String,attrib:String,to:String):void{
			//trace(22,to)
			for each(var xml:XML in script..*.(name()==parentParent)){
				if(xml.hasOwnProperty(parent)==false){
					xml.appendChild(<{parent}/>);
				}
				xml[parent].@[attrib] = to;
				trace(to,xml);
			}
		}
		
		
		
		private static function splitPop(str:String,splitBy:String):String{
			var arr:Array = str.split(splitBy);
			if(arr.length>1)arr[arr.length-1]='';
			return arr.join(splitBy);
		}
	}
}