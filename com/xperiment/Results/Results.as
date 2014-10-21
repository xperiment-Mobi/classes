package com.xperiment.Results {

	import com.xperiment.DeviceQuery.DeviceQuery;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.Network.sendToPHP;
	import com.xperiment.Results.services.SoapService;
	
	import flash.system.Capabilities;
	import flash.utils.Dictionary;

	public class Results {
		//this class holds OVERALL experiment data AND intermittant variables which need saving (the latter of which is not saved in the final results of the study).
		
		
		private static var _instance:Results;
		private var _finalResults:XML;
		private var _ongoingExperimentResults:XMLList=new XMLList;
		private var _storedVars:Array = new Array;
		private var _uuid:String;
		private var _soapService:SoapService;
		private var duration:int;
		
		public var trickleToServerBool:Boolean;
		public var trickleToCloudBool:Boolean;
		private var dribbleURL:String;
		private var first:Boolean = true;
		private var _deviceUUID:String;
		private var initial:Boolean = true;
		//private var uniqueTrialNames:Array = [];

		
		public function get ongoingExperimentResults():XMLList
		{
			return _ongoingExperimentResults;
		}

		public function kill():void{
			_finalResults=null;
			_ongoingExperimentResults=null;
			_storedVars=null;
			//uniqueTrialNames=null;
			Results._instance =null;
			Results._instance=new Results(new PrivateResults());
		}
		
		public function checkDataExists():Boolean{
			return _ongoingExperimentResults.length()>0;
		}
		
		public function giveOngoingResults():String{
			return _ongoingExperimentResults.toString();
		}
		
		public function storeVariable(dat:Object):void{
			_storedVars[dat.name]=dat.data;
		}
		
		public function getStoredVariable(nam:String):String{
			//trace("asked for this var:",nam,". Returning this:"+_storedVars[nam]);
			if(_storedVars.indexOf(nam)!=-1)return _storedVars[nam];
			else return "";
		}

		
		public function replaceWithVariables(str:String):String{
			//extracts variables, defined with the dollar symbol and replaces them with their looked up values back into the String;
			var ALLCAPS:RegExp= /^[A-Z0-9]*$/
			var NOLETTERS:RegExp = /[^a-zA-Z0-9]/
			var currentLetter:String;
			var buildingTxtBlock:String="";
			var newStr:String="";
			
			while (str.length>0){
				currentLetter=str.substr(str.length-1,1);
				str=str.substr(0,str.length-1);
				
				if(ALLCAPS.test(currentLetter+buildingTxtBlock)){
					buildingTxtBlock=currentLetter+buildingTxtBlock;
				}
				else{
					if(NOLETTERS.test(currentLetter)){
						//where lookupval=currentLetter+buildingTxtBlock
						if(NOLETTERS.test(newStr.charAt(0))|| newStr.length==0){
							//currentLetter+buildingTxtBlock
							if(_storedVars.hasOwnProperty(buildingTxtBlock))newStr=_storedVars[buildingTxtBlock]+newStr; //exactly the same as 'getStoredVariables' function except what is returned if not exists
							else newStr=currentLetter+"!!!Does-not-exist$"+buildingTxtBlock+newStr;
							buildingTxtBlock="";
						}
						else{
							newStr = currentLetter+buildingTxtBlock+newStr;
							buildingTxtBlock="";
						}
					}
					else{
						newStr = currentLetter+buildingTxtBlock+newStr;
						buildingTxtBlock="";
					}
				}
			}
			//where lookupval=currentLetter+buildingTxtBlock
			if(ALLCAPS.test(currentLetter+buildingTxtBlock) && NOLETTERS.test(newStr.charAt(0))){
				if(_storedVars.hasOwnProperty(buildingTxtBlock))newStr=_storedVars[buildingTxtBlock]+newStr; //exactly the same as 'getStoredVariables' function except what is returned if not exists
				else newStr=currentLetter+"!!!Does-not-exist$"+buildingTxtBlock+newStr;
			}
			else newStr = buildingTxtBlock+newStr
			
			return newStr; //stringlogic cannot deal with text so this converts variable values that are text to unique numbers
		}
		
		public function convertStringValsToNums(str:String):String{
			//extracts variables, defined with the dollar symbol and replaces them with their looked up values back into the String;
			var textBlock:Array=new Array;
			str="1"+str; //a slight hack to avoid a lot of coding to look for specifically for when str.length=0;
			var regExp:RegExp= /^[a-zA-Z_][a-zA-Z0-9_]*$/
			var currentLetter:String;
			var buildingTxtBlock:String="";
			var newStr:String="";
			
			while (str.length>0){
				currentLetter=str.substr(str.length-1,1);
				str=str.substr(0,str.length-1);
				if(!regExp.test(currentLetter)){
					if(buildingTxtBlock.length!=0 && textBlock.indexOf(buildingTxtBlock)==-1)textBlock.push(buildingTxtBlock);
					if(buildingTxtBlock.length!=0)newStr=currentLetter+((textBlock.indexOf(buildingTxtBlock)+1))+newStr; 
					else newStr=currentLetter+newStr;
					buildingTxtBlock="";
				}
				else{
					buildingTxtBlock=currentLetter+buildingTxtBlock;
				}
			}
			return newStr.substr(1);
		}
		
		public function get finalResults():XML
		{
			return _finalResults;
		}

		public function Results(pvt:PrivateResults){
			PrivateResults.alert();
		}

		public static function getInstance():Results
		{
			if(!_instance){
				_instance=new Results(new PrivateResults());
				
				var save:Array=ExptWideSpecs.IS("save").toLowerCase().split(",");
				_instance.trickleToServerBool = save.indexOf("trickletofile")!=-1;
				_instance.trickleToCloudBool = 	save.indexOf("trickletocloud")!=-1;
			}					
			return _instance;
		}	
		
		public function setup():void
		{
			_uuid=ExptWideSpecs.getSJuuid();
			_deviceUUID=ExptWideSpecs.IS("deviceUUID");
			
			//_ongoingExperimentResults=new XMLList;
			//_ongoingExperimentResults=getPracticeData().*;		
		}	
		
		
/*		public function giveOngoing(instructions:Object):Array{
			//trace(_ongoingExperimentResults);
			return XMLMaths.dataListFromTrialNames(_ongoingExperimentResults,instructions) as Array;
		}*/
		
		
		public function give(res:XML):void
		{ 	
			//checkUniqueTrialName(res);
			if(res){
				if(trickleToCloudBool) trickleToCloud(res);
				if(trickleToServerBool)trickleToServer(res.toString());
				if(res!=null)_ongoingExperimentResults+=res;
				//test(res);
			}
		}
		
	
		public function composeInfo(param:Object):void{
			param.info = {};
			
			wrapperInfo(param);
			
			param.info.os =  		Capabilities.os;
			param.info.device_uuid= _deviceUUID;
			param.info.resX = 		Capabilities.screenResolutionX;
			param.info.resY = 		Capabilities.screenResolutionY;
			param.info.DPI = 		Capabilities.screenDPI;
			param.info.CPU = 		Capabilities.cpuArchitecture;
			param.info.version = 	Capabilities.version;
			param.info.betweenSJsID=ExptWideSpecs.IS('betweenSJsID');
			param.info.timeStart =	ExptWideSpecs.IS('timeStart');
			param.info.timeZone =   new Date().getTimezoneOffset()/60;		
			param.info.approxDurationInSeconds = getDuration();
			
			//trace(param.info.approxDurationInSeconds,333,getDuration());
		}
		
		private function wrapperInfo(param:Object):void{
			param.info.uuid = _uuid;
			param.info.expt_id = ExptWideSpecs.IS("id");
		}
		
		private function trickleToCloud(res:XML,final:Boolean=false):void
		{
			_soapService ||= new SoapService;
			
			var param:Object = {};
			param.info = {};
			param.results={};
			
			if(final) 	composeInfo(param);
			else		wrapperInfo(param);
			
			if(initial){
				initial=false;
				ExptWideSpecs.addCourseInfo(res);
				ExptWideSpecs.addTurkInfo(res);
			}
			
			if(res){
				var trialName:String=res.@name.toString();
				for each(var s:XML in res.children()){
					param.results[trialName+"___"+s.name()]=s.toString();
				}
			}
			_soapService.send(param,SoapService.DRIBBLE_RESULTS,successF);

			function successF(worked:Boolean):void{
				//trace(22222,worked);
			}
			
		}
		
		private function trickleToServer(res:String, final:Boolean=false):void
		{
			
		
			if(!res)res='';
			if(first==true){
				first=false;
				res="<Experiment id='"+ExptWideSpecs.IS("id")+"'>\n"+res;
			}
			
			res=_uuid+"\n"+res;
			if(final){
				res+="\n"+exptSpecs().children().toString();

			}

			dribbleURL ||= ExptWideSpecs.getURL('saveXMLdribble.php');

			var sendServer:sendToPHP = new sendToPHP(dribbleURL,res,null);

		}

		
		private function nerdStuff():String{
			var extra:String='';
			if(_deviceUUID!="")extra=" deviceUUID:"+_deviceUUID;
			return "uniqueID:"+_uuid+" browser:" + ExptWideSpecs.IS("browser") +" Web appID:" + extra + " OS:" + Capabilities.os + " resX:" + Capabilities.screenResolutionX + " resY:" + Capabilities.screenResolutionY + " DPI:" + Capabilities.screenDPI + " CPUarch:" + Capabilities.cpuArchitecture + " version:"+Capabilities.version;
		}
		
		public function composeCloudResults():Object{
			var param:Object = {};
			
			composeInfo(param);
			
			param.results=__flattenXMLListtoObj(_ongoingExperimentResults);
			param.results.uuid=_uuid; //key between params.info and params.results
		
			//for (var s:String in param){
			//	for(var t:String in param[s]){
			//		trace(123,s,t,param[s][t]);
			//	}
			//}
			
			return param;
		}
		
		public static function __flattenXMLListtoObj(xmlList:XMLList):Object{
			if(xmlList.children().length()==0)return {empty:'test data'};
			
			var myResults:Object = {};
			var trialName:String;
			var dv:XML;
			var trial:XML;
			var i:int;
			var dv_label:String;
			
			for each(trial in xmlList){
				if(trial!=null && trial.name()!=null){
					if(trial.name().toString()!='trialData') throw new Error('MUST be labelled trialData');
					
					trialName=trial.@name;

					for each(dv in trial.children()){
						dv_label=trialName+"_"+dv.name();
						myResults[dv_label]=dv.toString();
					}
				}
			}
			
			return myResults;
		}
		
		//  THE MAIN FUNCTION THAT IS UNDER TEST 
		public static function __fixTrialsWithSameNames(xmlList:XMLList):XMLList {
			/*if (xmlList.children().length()==0) {
			
			return null;
			}*/
			
			var trialName:String;
			var dv:XML;
			var trial:XML;
			var trial2:XML;
			var i:int;
			var dv_label:String;
			
			var countDict:Dictionary = new Dictionary;
			
			//trace(2323,<e>{xmlList}</e>)
			for each (trial in xmlList) {
				
				if (trial != null && trial.name() != null) {
					
					if (trial.name().toString() != 'trialData') {
						// throw new Error('MUST be labelled trialData');
						continue;
					}
					trialName = trial.@name;
					if (countDict[trialName] == undefined) {
						countDict[trialName]=1;
						
					} else {
						countDict[trialName]++;
						trial.@name =  trial.@name+"_"+(countDict[trialName]-1);
						
					}
				}
			}
			return xmlList;
		}
		
		
		public function composeXMLInfo():XML{
			return <Experiment id={ExptWideSpecs.IS("id")}>{exptSpecs().children()}</Experiment>	
		}
		
		private function exptSpecs():XML
		{
			var xml:XML = <xml>
							<betweenSJsID>{ExptWideSpecs.IS('info.betweenSJsID')}</betweenSJsID>
							<nerdStuff>{nerdStuff()}</nerdStuff>
						    <timeStart>{ExptWideSpecs.IS('results.timeStart')} </timeStart>
							<approxDurationInSeconds>{getDuration()}</approxDurationInSeconds>
						</xml>
			if(DeviceQuery.sessionAlreadyExisted)	xml.browserRefreshed = 'true';
			xml.deviceID = DeviceQuery.device_id;
			return xml;
		}
		
		private function getDuration():Number
		{
			duration ||= ExptWideSpecs.getDuration();
			return duration;
		}
		
		public function composeXMLResults():XML
		{
			trace(_ongoingExperimentResults);
			if(trickleToCloudBool)trickleToCloud(null,true);
			if(trickleToServerBool)trickleToServer(null,true);
			return composeXMLInfo().appendChild(_ongoingExperimentResults);
		}		
	}
	
}

