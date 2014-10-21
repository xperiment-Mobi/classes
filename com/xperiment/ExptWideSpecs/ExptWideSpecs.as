package com.xperiment.ExptWideSpecs
{

	import com.bit101.components.Style;
	import com.xperiment.uuid;
	import com.xperiment.DeviceQuery.DeviceQuery;
	
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	
	public class ExptWideSpecs
	{
		
		static public var __ExptWideSpecs:Object;
		static public var uuidSavedToCloud:Boolean = false;
		static private var SJuuid:String; 
		
		public static var encryptKeyLoc:String =  "https://www.xpt.mobi/api/key/";
		
		public static function get _ExptWideSpecs():Object
		{
			return __ExptWideSpecs;
		}

		public static function MockSort():void
		{
			__ExptWideSpecs.defaults.ITI=100;
		}
		
		public static function update(tree:Array, val:String):void{
			if(__ExptWideSpecs.hasOwnProperty(tree[0])==true && __ExptWideSpecs[tree[0]].hasOwnProperty(tree[1])){
				__ExptWideSpecs[tree[0]][tree[1]] = val;
			}
			else throw new Error("Err, trying to set non existing prop in ExptWideSpecs");
		}
		
		
		public static function __init():void{
			
			/*
			Note that the below exists for variables
			SETUP.variables
			//note that only UPPERCASE are hunted for in the script and replaced with the value within ProcessScript
			*/
			
			__ExptWideSpecs={};
			__ExptWideSpecs.info=new Array  ;
			__ExptWideSpecs.info.id="default ID";
			__ExptWideSpecs.info.betweenSJsID="" ;
			
			__ExptWideSpecs.computer = new Array;
			__ExptWideSpecs.computer.autoClose = true ;
			__ExptWideSpecs.computer.autoCloseTimer = 2000 as int;

			__ExptWideSpecs.computer.saveLocallySubFolder = "results" ;
			__ExptWideSpecs.computer.dataFolderLocation = "My Documents" ;
			__ExptWideSpecs.computer.ip = "" ;
			
			__ExptWideSpecs.computer.preloadStimuli = true ;
			__ExptWideSpecs.computer.stimuliFolder = ''
			__ExptWideSpecs.computer.forceStimuliReload = false;	
			__ExptWideSpecs.computer.app = 'web';
			__ExptWideSpecs.computer.deviceUUID = '';
			__ExptWideSpecs.computer.latitude = '';
			__ExptWideSpecs.computer.longitute = '';
			__ExptWideSpecs.computer.locationAccurary = '';
			__ExptWideSpecs.computer.encryptKey = '';
			__ExptWideSpecs.computer.cloudID = '';
			__ExptWideSpecs.computer.cloud = false;
			__ExptWideSpecs.computer.one_key = '';
			
			__ExptWideSpecs.urlParams = [];
			
			//send email variables
			__ExptWideSpecs.email=new Array  ;
			//__ExptWideSpecs.email.emailResults=false ;
			__ExptWideSpecs.email.myAddress="andy.woods@xperiment.mobi" ;
			__ExptWideSpecs.email.toWhom="backup@xperiment.mobi" ;
			__ExptWideSpecs.email.subject="ExperimentData" ;
			__ExptWideSpecs.email.Host= "" ;
			__ExptWideSpecs.email.Port= "" ;
			__ExptWideSpecs.email.Username= "" ;
			__ExptWideSpecs.email.Password= "" ;
			__ExptWideSpecs.email.SMTPAuth= "" ;		
			__ExptWideSpecs.email.message="Here is some participant data. Best wishes, Xperiment.mobi";
			__ExptWideSpecs.email.filename="sjData.sav";
			__ExptWideSpecs.email.phpAddress='http://www.opensourcesci.com/experiments/email/emailXMLasAttachment.php';
			
			__ExptWideSpecs.results=new Array  ;
			__ExptWideSpecs.results.diagnostics=true ;
			__ExptWideSpecs.results.showTrialData  =false ;
			__ExptWideSpecs.results.cloudURL = '' ;
			__ExptWideSpecs.results.timeStart = new Date();
			//__ExptWideSpecs.results.saveToCloud = false;
			__ExptWideSpecs.results.saveFailMessage="<font size= '20'><b>There was a problem when trying to save your results.</b></font>\n\n<font size= '20'>We hope you don't mind, but could you send the text below to "
				+ "EMAILADDRESS. For your convenience, this text has been copied to your clipboard.\n\n Are you a <b>Mechanical Turker</b>? Make sure to close this window when done to retrieve your code. Thanks.";
			
			__ExptWideSpecs.results.saveSuccessMessage="<font size= '20'><b>Successfully saved your data. You can close this message-window. Thankyou.<font size= '15'>";
			__ExptWideSpecs.results.save='cloud,trickletocloud' ;
			__ExptWideSpecs.results.saveDataURL = "" ; //eg http://www.opensourcesci.com/experiments/Liverpool/perception1 
			//__ExptWideSpecs.results.saveToServerFile = true ;
			__ExptWideSpecs.results.saveToPortableDevice="results";
			__ExptWideSpecs.results.mock = false ;
			__ExptWideSpecs.results.trialOrder = true;
			__ExptWideSpecs.results.trialTime = false;
			
			__ExptWideSpecs.defaults = new Array;
			__ExptWideSpecs.defaults.ITI=500 as uint;
			__ExptWideSpecs.defaults.restart='false' ;	
			__ExptWideSpecs.defaults.quitOnFinish='false' ;
			
			__ExptWideSpecs.trials=new Array  ;
			__ExptWideSpecs.trials.blockDepthOrder = '' ;
			
			__ExptWideSpecs.screen=new Array  ;
			__ExptWideSpecs.screen.BGcolour='black' ;
			__ExptWideSpecs.screen.orientation="horizontal" ;
			__ExptWideSpecs.screen.width='1024';
			__ExptWideSpecs.screen.height='768';
			__ExptWideSpecs.screen.aspectRatio=''; // stretch
			__ExptWideSpecs.screen.percentageFromWidthOrHeightOrBoth="both";
			__ExptWideSpecs.screen.fullScreen = false ;
			__ExptWideSpecs.screen.fullScreenMessage = false ;
			__ExptWideSpecs.screen.alwaysInFront = true;
			__ExptWideSpecs.screen.align = "center";
			
			__ExptWideSpecs.core = [];
			__ExptWideSpecs.core.isDebugger = Capabilities.isDebugger ;
			__ExptWideSpecs.core.touchScreenType = Capabilities.touchscreenType;  //"finger","none","stylus"			
		}
		
		public static function setApp(appID:String):void
		{
			__ExptWideSpecs.computer.app = appID;
		}
		
		public static function __checkSaveGood():void
		{
			//makes sure the save features have all the info they need to save
			
			function s():void{
				save.splice(i,1);
			}
			
			function e(str:String):void{
				throw new Error(str);
			}
			
			var save:Array = (ExptWideSpecs.IS('save')).toLowerCase().split(",");
			
			for(var i:int=save.length-1;i>=0;i--){
	
				switch(save[i]){
					case 'email':
						if(IS("toWhom")=="false")e("You asked to save data by sending an email, BUT, you have not provided an email address to send data to");
						s();
						break;
					case 'portabledevice':
					case 'webfile':
					case 'mobile':
					case 'trickletofile':
						s();
						break;
					case 'cloud':
					case 'trickletocloud':
						s();
						if(__ExptWideSpecs.results.cloudURL=='')	checkCloudLoc();
						break;
				}
			}
			
			if(save.length>0 && ExptWideSpecs.IS('save')!=''){
				e("there are some unknown ways of saving data specified in 'save': "+save.join(","));
			}

			
		}
		
		private static function checkCloudLoc():void
		{
			
			
			function setVals(str:String):void{
				if(str.charAt(str.length-1)!="/")str+="/";
				__ExptWideSpecs.results.cloudURL=str+'gateway/';	
				encryptKeyLoc =  str+'api/key/';
			}
			
			var cloudUrl:String = IS("cloudURL");
			if(cloudUrl==''){
				if(ExternalInterface.available){
				
					var currentUrl:String = ExternalInterface.call("window.location.host.toString");
					if(currentUrl.indexOf('xpt.mobi')!=-1 || currentUrl=='null'){
						setVals('https://www.xpt.mobi');	
					}
					else{
						if(currentUrl.indexOf("http")==-1)currentUrl="http://" + currentUrl;
						
						setVals(currentUrl);
					}
				}
				else	setVals('https://www.xpt.mobi');
				
			}
			else	setVals(cloudUrl);
			
			
		}		

		//hackish
		static public function kill():void{
			__ExptWideSpecs=null;
			SJuuid=null;
			uuidSavedToCloud=false;
		}
		
		static public function setup(myScript:XML):void{ 
			if(!__ExptWideSpecs)__init();
			
			var setup:XMLList=myScript.SETUP;
			
			if(setup.hasOwnProperty('style')){
				sortStyle(setup.style);
				delete setup.style;
			}
			
			for (var i:uint=0; i<setup.children().length(); i++) {
				try {
					var tempClassReference:String=setup.children()[i].name();
					XMLListObjectPropertyAssigner(tempClassReference,setup[tempClassReference]);
				} catch (error:Error) {
					if(tempClassReference!='variables')
						trace("you've tried to set a global experiment property that unfortunately does not exist:",tempClassReference);
				}	
			}
			
			//trace(myScript,myScript.name().toString());
			__ExptWideSpecs.info.betweenSJsID=myScript.name().toString();
			__checkSaveGood()
		}
	
		
		private static function sortStyle(styles:XMLList):void
		{

			for each(var style:XML in styles.attributes()){
				if(Style.hasOwnProperty(style.name())){
					Style[style.name().toString()]=style.toString();
				}
				else if (style.name()=="__BIND"){}
				else throw new Error("you tried to set an unknown global style '"+style.name().toString()+"'.");
				
			}
			
		}
		
		public static function getSJuuid():String{
			if(!SJuuid){
				if(DeviceQuery.sessionAlreadyExisted)	SJuuid = DeviceQuery.getUUID();
				else SJuuid=uuid.toString();
			}
			return SJuuid;
			
		}
		
		public static function IS_parent(what:String):String
		{
			if(!__ExptWideSpecs)__init();
			return __retrieveParamParent(what, __ExptWideSpecs);
		}
		
		
		
		//unit test here svp
		
		/*		var a:Object = {};
		a.b={}
		a.b.c={}
		
		var c:Object=a.b;
		trace(c.toString())		
		
		trace(__retrieveParamParent('c',a))*/
		
		//note that this is very limited.  Variable must be sufficiently deep to be detected.  atleast a.b.c where c is the min depth.
		public static function __retrieveParamParent(param:String,obj:Object):String
		{
			var prop:*;
			for (var level:String in obj){
				
				if(typeof(obj[level])=="object"){
					
					if(obj[level].hasOwnProperty(param))return level;
					
					prop=__retrieveParamParent(param,obj[level])
					if(prop || prop is Boolean)return prop;
				}
			}
			
			return null;
		}
		
		public static function IS(what:String):*{
			var param:Array = what.split(".");
			if(param.length==2){
				if(__ExptWideSpecs[param[0]]==undefined || __ExptWideSpecs[param[0]][param[1]]==undefined) throw new Error('requested unknown variable from ExptWideSpecs: '+what);
				return __ExptWideSpecs[param[0]][param[1]];
			}
			else if(param.length==1){
				return __retrieveParam(what, __ExptWideSpecs);
			}
			
			throw new Error("unknown property requested from ExptWideSpecs: "+what);
			return '';
		}
		
		
		public static function __retrieveParam(param:String,obj:Object):*{

			if(obj.hasOwnProperty(param)){
				return obj[param];
			}
			else{
				var prop:*;
				for (var level:String in obj){
					
					if(typeof(obj[level])=="object"){
						prop=__retrieveParam(param,obj[level])

						if(prop || prop is Boolean || prop=='')return prop;
					}
				}
			}
			return null;
		}
		
		static public function XMLListObjectPropertyAssigner(subType:String,textinfo:XMLList):void {
			
			var attNamesList:XMLList=textinfo.@*;
			
			var VarName:String=attNamesList.parent().name();//this is the problem one
			
			//logger.log("varName: "+VarName);
			//logger.log (attNamesList+ "---"+attNamesList[i].name());
			var tagValue:String
			var tag:String
			var a:Array;
			
			for (var i:int=0; i<attNamesList.length(); i++) {
				tag=attNamesList[i].name();// id and color
				tagValue=attNamesList[i];
				//logger.log("VARIABLES VarName -"+VarName+"-; tag -"+tag+"-; value -"+tagValue+"-");
				if (typeof __ExptWideSpecs[subType][String(attNamesList[i].name())]!="undefined") {
					try {
						//trace("Global experiment property: "+VarName+"."+tag+" = "+tagValue);
						
						a=tag.split('.');
						
						if(a.length==1)__ExptWideSpecs[subType][a[0]]=returnType(typeof __ExptWideSpecs[subType][a[0]],tagValue);
						
						else throw new Error ("PROBLEM----------no variables given to set properties with-----------------!!!!!!!");

						
						
						//ExptWideSpecs[VarName][tag]=returnType(typeof ExptWideSpecs[VarName][tag],tagValue);
					} catch (error:Error) {
						throw new Error ("PROBLEM----------'"+tag+"' is not a known property of '"+VarName+"'-----------------!!!!!!!");
					}
				} else {
					//trace("PROBLEM----------'"+tag+"' property does not exist unfortunately-----------------!!!!!!!");
				}
			}
		}
		
		static private function returnType(type:String,value:*):* {
			var returnType:*;
			switch (type) {
				case "string" :
					returnType=new String  ;
					returnType=String(value);
					break;
				case "int" :
					returnType=new int  ;
					returnType=int(value);
					break;
				case "number" :
					returnType=new Number  ;
					returnType=Number(value);
					break;
				case "boolean" :
					returnType=new Boolean  ;
					if (value=="true"){
						returnType=true;
					}
					else {value=false;}
					
					break;
				case "uint" :
					returnType=new uint  ;
					returnType=uint(value);
					break;
				case "array" :
					returnType=new Array  ;
					returnType=value as Array;
					break;
				default :
					trace("incorrect variable type-----------------!!!!!!!");
			}
			return returnType;
		}
		
		public static function URLVariables(parameters:Object,url:String):void
		{

			for(var param:String in parameters){
				//exclude params in the array

				if(['studyUrl','scriptName','exptId'].indexOf(param)!=-1){
					__ExptWideSpecs.urlParams[param]=parameters[param];
				}
				else if(['ip','assignment_id','worker_id','hit_id'].indexOf(param)!=-1){
					__ExptWideSpecs.computer[param]=parameters[param];
				}
				else if(['ip','assignmentId','workerId','hitId'].indexOf(param)!=-1){ //legacy
					__ExptWideSpecs.computer[param]=parameters[param];
				}
			}
			xptCloudSpecific(parameters,url);
		}
		
		private static function xptCloudSpecific(parameters:Object,url:String):void
		{
			function updateSaveResults():void{
				if(__ExptWideSpecs.results.save=='')	__ExptWideSpecs.results.save='cloud';
			}

			if(parameters.hasOwnProperty('exptId')){
				__ExptWideSpecs.computer.cloud = true;
				__ExptWideSpecs.info.id = __ExptWideSpecs.computer.cloudID = parameters.exptId;
				updateSaveResults();
				
				if(url.indexOf("static")==-1)	url = url.split("/swf")[0];    //when swf is versioned.
				else 							url = url.split("/static")[0]; //when swf is default

				__ExptWideSpecs.computer.stimuliFolder=url+'/stimuli/'+parameters.exptId;
			}
			
			if(parameters.hasOwnProperty('one_key'))		__ExptWideSpecs.computer.one_key = parameters.one_key;
			if(parameters.hasOwnProperty('xpt_course_id'))	__ExptWideSpecs.computer.xpt_course_id = parameters.xpt_course_id;
			if(parameters.hasOwnProperty('xpt_user_id'))	__ExptWideSpecs.computer.xpt_user_id = parameters.xpt_user_id;
			
			//__ExptWideSpecs.urlParams['ip']='173.3.74.171'
			__updateStimuliFolderWithCloudUrl(parameters);
			
		}		
		
		public static function __updateStimuliFolderWithCloudUrl(parameters:Object):void
		{
			if(parameters.hasOwnProperty('studyUrl')){
				var studyUrl:String = parameters['studyUrl'];
				if(["/","\\"].indexOf(studyUrl.charAt(studyUrl.length-1))==-1) throw new Error("must have stimuli folder suffixed with appropriate slash");
				if(["/","\\"].indexOf(__ExptWideSpecs.computer.stimuliFolder.charAt(0))!=-1) studyUrl = studyUrl.substr(0,studyUrl.length-1)
				__ExptWideSpecs.computer.stimuliFolder=studyUrl+__ExptWideSpecs.computer.stimuliFolder;
			}	
		}
		
		public static function remote_url(script_url:String):void
		{
			var arr:Array;
			for each(var split:String in ["/","\\"]){				
				if(script_url.indexOf(split)!=-1){
					arr=script_url.split(split);
					arr.pop();

					script_url=arr.join(split)+split;
					break;
				}
			}	
			__ExptWideSpecs.computer.stimuliFolder=script_url+__ExptWideSpecs.computer.stimuliFolder;	
			__ExptWideSpecs.results.saveDataURL   =script_url+__ExptWideSpecs.results.saveDataURL; 
		}
		
		public static function getURL(fileName:String):String
		{
			var phpLocation:String = IS('saveDataURL');	
			
			if(phpLocation!="" && phpLocation.length>4){
				if(phpLocation.charAt(phpLocation.length-1)!="/")phpLocation+="/";
				phpLocation+=fileName;
			}
			else phpLocation = fileName;
			
			return phpLocation;
		}
		
		public static function addCourseInfo(results:Object):void
		{
			if(IS("course_id")!='')	{
				if(!results)results={};
				results.xpt_user_id = 	IS("xpt_user_id");
				results.xpt_course_id=	IS("xpt_course_id");
			}
		}
		
		public static function addTurkInfo(results:Object):void
		{
			if(IS("assignment_id")!='')	{
				if(!results)results={};
				results.xpt_user_id = 	IS("assignmentId");
				results.xpt_course_id=	IS("workerId");
				results.xpt_course_id=	IS("hit_id");
			}
		}
		
		
		
		public static function getDuration():Number
		{		
			var currentDate:Date = new Date();
			var timeStart:Date=IS("timeStart");
			var millisecondDifference:int = currentDate.valueOf() - timeStart.valueOf();
			return millisecondDifference *.001
		}
	}
}