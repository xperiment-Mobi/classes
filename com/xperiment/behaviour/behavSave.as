package com.xperiment.behaviour
{
	import com.xperiment.Results.Results;
	
	import flash.utils.Dictionary;


	public class behavSave extends behav_baseClass
	{
		
		//note that to pass this data iT MUST be running already (timeStart=0);
		private var data:Array=new Array;
		private var exptResults:Results;
		private var count:uint=0;
		
		override public function setVariables(list:XMLList):void {
			setVar("boolean","saveToResults",true); 
			setVar("boolean","saveToMemory",true); 
			setVar("string","replace1","");
			setVar("string","seperator",",");
			setVar("string","data","");
			setVar("string","saveName","");
			setVar("string","suffix","");
			setVar("string","prefix","");
			setVar("string","timeStamp",""); 
			setVar("boolean","hideResults",false);
			super.setVariables(list);
			if(getVar("saveName")=="")OnScreenElements.saveName=getVar("peg");
		}
		
		public function dataList(str:String):void{
			//trace("ine rerererere",str);
			if(str!="")data=data.concat(str.split(","));
		}
		
		override public function returnsDataQuery():Boolean {
			return false;
		}	
		
		override public function myUniqueActions(action:String):Function{
			if(!uniqueActions){
				uniqueActions = new Dictionary;
				uniqueActions.savetoresultsfile=function():void{saveToResultsFile();};
			}
			if(uniqueActions.hasOwnProperty(action)) return uniqueActions[action]
			
			return null;
		}


		public function saveToResultsFile():String{
			//trace(22,getVar("prefix")+getVar("data"));
			if(!exptResults)exptResults = Results.getInstance();
			super.objectData.push({event:getVar("saveName")+String(count++),data:getVar("prefix")+getVar("data")});
			OnScreenElements.data="";
			return "";
		}
		
		
		
		
		
		public function store(str:String):void{
			data.push(str);
			if(OnScreenElements.data=="")OnScreenElements.data=str;
			else OnScreenElements.data +=","+str;
		}
		

		
		override public function nextStep(id:String=""):void {	
			//trace("in here","abc",peg,getVar("data"),getVar("prefix"),22);
			//trace("333",getVar("saveName"),data.join(","));
			if(getVar("saveToResults") as Boolean)putInResults(getVar("saveName"),data.join(","));
			if(getVar("saveToResults") as Boolean){
				if(!exptResults){
	
					exptResults = Results.getInstance();
					
					for(var i:uint=0;i<data.length;i++){
						data[i]=getVar("prefix")+data[i]+getVar("suffix");
					}
					var str:String=data.join(getVar("seperator"));
					if(getVar("replace1")!="") str = replaceText(str,getVar("replace1"));
	
					OnScreenElements.data=data;
					//trace(this.peg+".savedData:"+data);
					exptResults.storeVariable({name:getVar("saveName"),data:str});
					//trace(exptResults.getStoredVariable(getVar("saveName")),peg,22,getVar("saveName"));
					this.behaviourFinished();
					//trace("iiii",peg);
				}
			}
		}
		
		public function replaceText(str:String,params:String,count:uint=1):String {
			var arr:Array = params.split("with");
			if(arr.length==2){
				var toReplace:String=arr[0];
				var replaceWith:String=arr[1];
				
				while (str.indexOf(toReplace)!=-1) {
					str=str.replace(toReplace,replaceWith);
				}
			}
			//else if(logger)logger.log("!You've tried to run this replace action ("+params+") but you specified it wrongly.  Should be e.g. rwithx.");
			if(OnScreenElements.indexOf("replace"+String(count+1))!=-1){
				str=replaceText(str,OnScreenElements["replace"+String(count+1)],count+1);
			}
			return str;
		}
		

	}
}