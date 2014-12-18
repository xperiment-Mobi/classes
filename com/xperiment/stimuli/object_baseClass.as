package com.xperiment.stimuli{
	
	import com.graphics.pattern.Box;
	import com.graphics.pattern.Target;
	import com.greensock.TweenMax;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.xperiment.StimEvents;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.behaviour.BehaviourBoss;
	import com.xperiment.stimuli.primitives.boxLabel;

	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.display.Stage;
	
	public class object_baseClass extends uberSprite implements iBehav, IStimulus{
		
		public static const multTriCorSym:String=";";	
		public static const multObjCorSym:String="---";
		
		public var xmlVal:String;
		public var driveEvent:String="";
		public var OnScreenElements:Array=new Array;
		public var pic:uberSprite;
		public var theStage:Stage;
		public var duplicateTrialNumber:uint=new uint  ;
		public var iteration:uint;
		//public var finishedSettingVariables:Boolean=false;

		public var storedVariables:Array=new Array  ;
		public var temporaryStoredVariables:Array=new Array  ;
		public var returnStageHeight:int;
		public var returnStageWidth:int;
		public var containerX:int;
		public var containerY:int;
		public var trialWithinBlockPosition:int;
		public var orderOfTrial:int;
		public var orderWithinBlock:int;
		//public var behaviours:Array;
		public var objectData:Array=new Array  ;
		//public var myBehaviours:Array;
		public var listOfDrivenEvents:Array;
		public var listOfStopEvents:Array;
		public var outLineBoxes:Array;
		public var percentageScreenSizeFrom:String="both";
		private var myBoxLabel:boxLabel;
		public var myName:String;
		public var parentPic:Sprite;
		public var manageBehaviours:BehaviourBoss;
		private var classLevel:uint=0;
		public var stimEvents:StimEvents;
		
		public var disallowedActions:Vector.<String>;
		public var disallowedEvents:Vector.<String>;
		public var disallowedProps:Vector.<String>;
		
		public var uniqueActions:Dictionary;
		public var uniqueEvents:Dictionary;
		public var uniqueProps:Dictionary;
		
		//public var getVarInfo:Boolean = false;
		//public var varInfo:
		
		public var maker:Boolean = false;
		public var makerObj:Object;
		
		public static var NOT_REQUIRED:String = "NOT_REQUIRED";
		public var stimXML:XML;
		public var numTrials:int;
		
		public function object_baseClass(){
			pic=this;
			
			//above needed for resizing.  If resizing with a value of 0...
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,1,1);
			this.graphics.endFill();
		}
		
		
		
		
		override public function myUniqueProps(prop:String):Function{
			
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('angle')==false){
				uniqueProps.rotate= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					
					if(what){
						OnScreenElements.rotate=Number(to);
						setRotation();
					}	
					return codeRecycleFunctions.roundToPrecision(OnScreenElements.rotate,2).toString();	 
				}
			}; 
			
			if(uniqueProps.hasOwnProperty('visible')==false){
				uniqueProps.visible= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					
					if(what){
						if(to=="true")pic.visible=true;
						else pic.visible=false;
					}	
					return pic.visible.toString();	 
				}
			}; 
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop];
			
			return null;
		}
		
		
		public function mouseTransparent():void{
			pic.mouseEnabled=false;
		}
		
		override public function myUniqueActions(action:String):Function{
		
		return null
		}	
		
		public function events(active:Boolean):void{};
		
		public function getVar(nam:String):* {
			if (OnScreenElements && OnScreenElements[nam]!=undefined) {
				return OnScreenElements[nam];
				//if(logger)logger.log("retrieved variable from baseClass");
			}
			else {
				//if(logger)logger.log("! variable ["+nam+"] asked for but you have not specified it");
				return "";
			}
		}
		
		
		
		public function getTempStoredVars():Array {
			//logger.log("gave stored vars");
			return temporaryStoredVariables;
		}
		
		public function setStoredVars(arr:Array):void {
			storedVariables=arr;
		}
		
		public function setVar(typ:String, nam:String, val:*,defaultVals:String="",info:String=""):void {
			if(maker){
				saveMakerInfo(typ,nam,val,defaultVals,info);
			}
			if(OnScreenElements.indexOf(nam)==-1)OnScreenElements[nam]=returnType(typ.toLowerCase(),val,nam);
			//OnScreenElements[nam]=returnType(typ.toLowerCase(),val,nam);

			
		}
		
		
		public function setVarBase(typ:String, nam:String, val:*,defaultVals:String="",info:String=""):void {
			if(maker){
				saveMakerInfo(typ,nam,val,defaultVals,info);
			}
			if(OnScreenElements.indexOf(nam)==-1)OnScreenElements[nam]=returnType(typ.toLowerCase(),val,nam);

		}
		
		public function init_makerObj():void{
			makerObj = {};
			makerObj.attrs={};
			makerObj.attrsInfo={};
		}
		
		public function get_makerObj():Object{
			return makerObj;
		}
		
		protected function saveMakerInfo(typ:String, nam:String, val:*,defaultVals:String="",info:String=""):void
		{
			nam=nam;
			val=val;
			info=info;
			if(makerObj.attrs) makerObj.attrs[nam] = defaultVals.split("||");
			if(makerObj.attrsInfo) makerObj.attrsInfo[nam]={type:typ,info:info,defaultVal:val, possibleVals:defaultVals};
			//if(nam=="showBox")trace(123,nam,typ,info,val, defaultVals)
		}
		

		public function setUpTrialSpecificVariables(trialObjs:Object):void {
			theStage=trialObjs.theStage;
			if(trialObjs.parent)this.parentPic=trialObjs.parent as Sprite;
			myName=trialObjs.name;
			returnStageHeight=trialObjs.h;
			returnStageWidth=trialObjs.w;
			containerX=trialObjs.containerX;
			containerY=trialObjs.containerY;
			numTrials = trialObjs.numTrials;
			
			if (trialObjs && trialObjs.perSize &&  trialObjs.perSize!="")percentageScreenSizeFrom=trialObjs.perSize.toLowerCase;
			storedVariables=trialObjs.storedVariables;

			iteration=trialObjs.i;
			trialWithinBlockPosition=trialObjs.trialBlockPositionStart;
		}
		
		
		
		public function showBox():void{
			var col:Number = 0x46d1ff
			drawMovePoint(pic.x-1-getVar("padding_left"),pic.y+1-getVar("padding_top"),col);		
			var showBox:Shape = makeBox(pic,col);
			
			if (!outLineBoxes) outLineBoxes = new Array;
			outLineBoxes.push(showBox);
			
		}
		
		private function makeBox(obj:uberSprite, col:Number,thickness:Number=1, alpha:Number=1):Shape
		{
			var myObj:Object = new Object();
			myObj.lineColour=col;myObj.fillColour=0;
			myObj.lineThickness=thickness;
			myObj.alpha=alpha;
			
			myObj.width=obj.myWidth;
			myObj.height=obj.myHeight;
			
			
			var showBox:Shape=Box.myBox(myObj);
			//showBox.x=obj.localToGlobal(new Point()).x-getVar("padding_left"); 
			///showBox.y=obj.localToGlobal(new Point()).y-getVar("padding_top");
			
			if(addParent(pic,showBox,true)){
				showBox.x=pic.x; showBox.y=pic.y;
			}
			return showBox;
		}
		
		public function addParent(obj:uberSprite,what:DisplayObject, DO:Boolean):Boolean{
			if(!obj.parent){
				obj.addChild(what);
				return false;
			}
			else obj.parent.addChild(what);
			return true;
			
		}
		
		public function drawMovePoint(xPos:int,yPos:int,col:Number):void{			
			var obj:Object = new Object();
			obj.lineColourCross=col;obj.lineColourCircle=col;obj.fillColour=0;
			obj.lineCrossThickness=1;obj.lineCircleThickness=2;
			obj.radius=7;
			var movePoint:Shape=Target.myTarget(new Object);
			//movePoint.x=xPos; movePoint.y=yPos;
			if(addParent(pic,movePoint,true)){
				movePoint.x=pic.x; movePoint.y=pic.y;
			}
			if (!outLineBoxes) outLineBoxes = new Array;
			outLineBoxes.push(movePoint);
			obj=null;
		}
		
		/*private function addToStage(sha:Shape):void{
		
		theStage.addChildAt(sha,theStage.numChildren-1);
		}*/
		
		
		public function updateMe(str:String):void {
			//logger.log("-----PROBLEM: you asked to update me with these parameters: "+str+". Afraid I do know what to do with them!");
		}
		
		/*		public function onLoaded():void {
		//trace(111)
		}*/
		
		public function setVariables(list:XMLList):void {
			//setVarBase("boolean","continuouslyShown",true);
			setVarBase("boolean","mouseTransparent",false);
			setVarBase("string","peg","");
			setVarBase("string","behaviours","","needs a good description"); // start,onFinish,onCk,OnCli,onEnd, OnShow,now			
			setVarBase("string","timeStart","");
			setVarBase("string","timeEnd","forever");
			setVarBase("int","scaleX",1);
			setVarBase("int","scaleY",1);
			setVarBase("int","scale", 1);
			//setVarBase("uint","howMany",1); //note, totally rendundant, but included it to stop these annoying 'this var does not exist' error appearing all the time.
			setVarBase("string","width","50%");
			setVarBase("string","height","50%");
			//setVarBase("uint","widthPercent",0);
			//setVarBase("uint","heightPercent",0);
			setVarBase("string","id","","needs a description");
			setVarBase("uint","numberOfTrialsInThisBlock",0,"hide");
			//setVarBase("String","boxLabel","");
			setVarBase("boolean","showBox",false,"","hide");
			setVarBase("string","hideResults",'false',"","if you don't want to collect data for this object, specify false");
			setVarBase("String","x","50%","","the horizontal position of the object on the screen.  Use a % sign if you want specify this as a % of screen size");
			setVarBase("String","y","50%","","the vertical of the object on the screen.  Use a % sign if you want specify this as a % of screen size");
			setVarBase("string","horizontal","middle","left||middle||right","use to change the '0,0' point on the object");
			setVarBase("string","vertical","middle","top||middle||bottom","use to change the '0,0' point on the object");
			setVarBase("int","padding_left",0,"","if you want some blank space to the left of your object");
			setVarBase("int","padding_right",0,"","if you want some blank space to the right of your object");
			setVarBase("int","padding_top",0,"","if you want some blank space on the top of your object");
			setVarBase("int","padding_bottom",0,"","if you want some blank space at the bottom of your object");
			setVarBase("int","padding",0,"if you want some blank space around your object");
			setVarBase("string","name","");
			setVarBase("String","percentageScreenSizeFrom","both","vertical||both||horizontal","this is useful if you ensure that your object is never 'offscreen'");
			setVarBase("String","containerCell_verticalAlign","middle");
			setVarBase("String","containerCell_horizontalAlign","middle");
			setVarBase("Number","opacity",1,"0-1");
			setVarBase("boolean","visible",true);
			setVarBase("uint","howMany",1);
			setVarBase("string","delay","");
			setVarBase("string","duration","");
			setVarBase("string","if","");			
			setVarBase("string","deepID","");//needed for 'xperimentMaker'
			setVarBase("number","outline", 0);
			setVarBase("string",'depth','',"","stimuli are normally presented on screen in the order they have been placed in your script (stimuli placed at the bottom of the script being on top of the stimuli are at the bottom of the script). If you want a stimulus to 'jump' up a place, set it's value to ^1, if you want it to 'jump down' two places, set it's value to v2.  If you do not use ^ and v signs, you exactly specify the depth the stimulus is placed at.  Do note that there can only exist ONE stimulus at each depth. A blank value or a space is the same as the objects default depth.");
			//setVarBase("string","modify","");
			setVarBase("string",'shuffle_something','',"used to randomise a stimulus paramater trial wide (that is, done once per trial).  Eg. timeStart='100;200;300' && shuffle_something='timeStart,;' where the list of options in timeStart is split by ; (MUST be either ; or , BTW) and a random element is selected")
			setVarBase("string",'shuffle_somethings','',"used to randomise stimuli paramaters trial wide (that is, done once per trial). shuffle_something='x,y,;' where the list of options in timeStart is split by ; (MUST be either ; or , BTW) and a random element is selected")
			setVarBase("string",'SHUFFLE_SOMETHING','',"used to randomise a stimulus paramater experiment wide (that is, done once, per experiment).  Eg. timeStart='100;200;300' && SHUFFLE_SOMETHING='timeStart,;' where the list of options in timeStart is split by ; (MUST be either ; or , BTW) and a random element is selected")
			setVarBase("string","required",NOT_REQUIRED,"specify the value of .result here that the stimulus must NOT be.  You can use REQUIRED in your IF statements.  If true, all stimuli do NOT equal this their required value.  If false, not all... .");
			setVarBase("int","rotate",0, "In degrees.  Not allowed to rotate text at the moment. You can specify rand(a:b) here");
			
			//if(list.@shuffle_something.toString().length!=0) StimModify.shuffleSomething(list.@shuffle_something,list);
			//if(list.@shuffle_somethings.toString().length!=0) StimModify.shuffleSomethings(list.@shuffle_somethings,list);
				
			XMLListObjectPropertyAssigner(list);
			
			
			this.peg=getVar("peg");
			pic.peg=peg;
			//trace("eeeee",peg);
			this.name=getVar("name");
			//pic.start=getVar("timeStart");
			//pic.end=getVar("timeEnd");
			if(getVar("showbox")=="true")OnScreenElements.showBox=true;
			
			percentageScreenSizeFrom=getVar("percentageScreenSizeFrom");
			
			pic.addEventListener(Event.ADDED_TO_STAGE,appearedOnScreen,false,0,true);
			pic.addEventListener(Event.REMOVED_FROM_STAGE,removedFromScreen,false,0,true);
			
			if(getVar("visible")==false)pic.visible=false;
								
			
			if (getVar("padding")!=0){
				if (getVar("padding_left")==0) setVarBase("int","padding_left",getVar("padding"));
				if (getVar("padding_right")==0) setVarBase("int","padding_right",getVar("padding"));
				if (getVar("padding_top")==0) setVarBase("int","padding_top",getVar("padding"));
				if (getVar("padding_bottom")==0) setVarBase("int","padding_bottom",getVar("padding"));
				
			}
			//stimEvents=new StimEvents(peg,getQualifiedClassName(this),true);
			
			wrongPropertyHelper();
		}
		
		
		private function wrongPropertyHelper():void
		{
			var cleanType:String;
			for each(var prop:Array in [['usePeg','usePegs'],['behavior','if'],['behaviour','if'],['ignoreData','hideResults'],['horizontalPosition0','horizontal'],['verticalPosition0','vertical']]){
				if(OnScreenElements.hasOwnProperty(prop[0])){
					cleanType=String(this);
					cleanType=cleanType.substr(8,cleanType.length-9);
					throw new Error("You have accidentally specified '"+prop[0]+"' for the '"+cleanType+"' stimulus with peg '"+peg+"'. You should use '"+prop[1]+"' instead.");
				}
			}
			
		}
		
		
		private function removeSpacesNotInsideQuotes(str:String):String{
			//trace(this,peg,str);
			if((str.split("'")as Array).length%2==1){
				
				var quot:Boolean=false;
				var char:String;
				var newStr:String="";
				for(var i:int=str.length-1;i>=0;i--){
					char=str.charAt(i);
					if(char==String.fromCharCode(39))quot=!quot;
					if(quot || char!=" ")newStr=char+newStr;
				}
				return newStr
			}
			else {
				//if(logger) logger.log("!Problem with logic ["+str+"] having an uneven number of single quotation marks [peg="+peg+"].");
				return "";
			}
		}
		
		
		public function appearedOnScreen(e:Event):void{
			pic.removeEventListener(Event.ADDED_TO_STAGE,appearedOnScreen);
			setRotation();
			sortOutShowBox();
		}
		
		public function removedFromScreen(e:Event):void{
			pic.removeEventListener(Event.REMOVED_FROM_STAGE,removedFromScreen);
		}
		
		public function sortOutShowBox():void{
			
			if (getVar("outline")!=0)makeBox(pic,getVar("outlineColour"),getVar("outline"),getVar("outlineAlpha"));
			if (getVar("showBox"))showBox();
		}
		
		
		public function storedData():Array {
			return objectData;
		}
		
		
		
		public function returnsDataQuery():Boolean {
			return false;
		}
		
		public function putInResults(event:String,data:String):void{
			var tempData:Array
			tempData = new Array();
			tempData.event=event; 
			tempData.data=data;
			objectData.push(tempData);
		}
		
		public function updateStoredVariablesEachTrial():Boolean {
			return false;
		}
		
		
		public function XMLListObjectPropertyAssigner(textinfo:XMLList):void {
					
			
			var attNamesList:XMLList=textinfo.@*;
			var tag:String
			var tagValue:String;
			
			for (var i:int=0; i<attNamesList.length(); i++) {
				tag=attNamesList[i].name();// id and color
				
/*				for each(var key:String in ['y','x']){
					if(tag==key && attNamesList[i].toString() == "" && OnScreenElements[tag]!=undefined) attNamesList[i] = OnScreenElements[tag];
				}*/
						
				tagValue=__correction(attNamesList[i].toString());
				
				
				//trace(tag,tagValue,3434334);
				//tagValue=suckOutPutInStoredVariables(tagValue);
				
				//var a:Array=tag.split('.');
				//trace(tag,OnScreenElements[tag],22);
				var message:String = new String;
				
				if (OnScreenElements[tag]!=undefined) {
					//if(this.toString()=="[object addShapeMatrix]"){
					//trace(OnScreenElements[a[0]],a,tagValue,typeof OnScreenElements[a[0]]);
					//}
					//					/trace(tag,tagValue,34343,OnScreenElements[tag]);
					OnScreenElements[tag]=returnType(typeof OnScreenElements[tag],tagValue,tag);
					
				}
				else {
					OnScreenElements[tag]=tagValue as String;
					//trace(tag,tagValue,222);
					message=". BTW, there are no default settings for this variable so the variable may be redundant.";
				}
				
				//if(logger)logger.log("["+attNamesList[i].name()+"="+tagValue+"]" +message);
			}
			
			//remove text2 text3 etc and append onto text [attribute agnostic]
			__appendMultiples(OnScreenElements);
			//
		}
		
		public function __correction(str:String):String
		{

			//var multTriFixedSym:String="~";
			//var multiObjFixedSym:String="|||"
			
			if (str.indexOf(multTriCorSym)!=-1)	str=codeRecycleFunctions.multipleTrialCorrection(str,multTriCorSym,duplicateTrialNumber);
			if (str.indexOf(multObjCorSym)!=-1)	str=codeRecycleFunctions.multipleTrialCorrection(str,multObjCorSym,iteration);
			//if (str.indexOf(multTriFixedSym)!=-1)	str=codeRecycleFunctions.multipleTrialCorrection(str,multTriFixedSym,trialWithinBlockPosition);
			//if (str.indexOf(multiObjFixedSym)!=-1)	str=codeRecycleFunctions.multipleTrialCorrection(str,multiObjFixedSym,iteration);	
			
			return str;
		}
		
		//unit test me
		/*var arr:Array = [];
		arr.a=1;
		arr.a1=2;
		arr.a2=3;
		__appendMultiples(arr);
		trace(arr.a=='123', arr.a1==undefined, arr.a2==undefined)
		arr.b=1;
		arr.b2=2;
		trace(arr.b=='1', arr.b2=='2')*/
		
		public function __appendMultiples(arr:Array):void
		{
			//concatenates up properties
			//below, searches for attribs appended with 0 or 1.  These are special you see as they imply an 'appendUp' attribute.
			var appendUpAttribs:Array;
			
			for (var prop:String in arr) {	
				if("1"== prop.charAt(prop.length-1) && isNaN(Number(prop.charAt(prop.length-2) ))){
					appendUpAttribs ||= [];
					if(appendUpAttribs.indexOf(prop)==-1){
						appendUpAttribs.push(prop.substr(0,prop.length-1));
					}
				}
			}
			
			if(appendUpAttribs){
				var i:int;
				var appendUpProp:String = '';
				var appendUpVal:String = '';
				for each (prop in appendUpAttribs){
					
					i=0;
					while(true){
						appendUpProp=prop;
						
						if(i!=0)appendUpProp+=i.toString();
						if(arr.hasOwnProperty(appendUpProp)==true){
							appendUpVal+=arr[appendUpProp];
							//if(i!=0) arr[appendUpProp] = null;
							i++;
						}
						else break;	
					}		
					arr[prop]=appendUpVal;
				}
			}
		}
		
		
		//removed as mucked up Text when there was a percentage sign in it.
		//dont see the purpose of this function!
		//AW NOW DO! useful for when there is a % sign in other variables. E.g. used heavily in addSlider
		private function sortOutPercentageSign(str:String,objType:String):String{
			
			if(objType.indexOf("padding_")!=-1){
				if (objType=="padding_left" && str.indexOf("%")!=-1){
					str=String(Number(str.replace("%",""))*returnStageWidth/100);
				}
				else if(objType=="padding_right" && str.indexOf("%")!=-1){
					str=String(Number(str.replace("%",""))*returnStageWidth/100);
				}
				else if(objType=="padding_top" && str.indexOf("%")!=-1){
					str=String(Number(str.replace("%",""))*returnStageHeight/100);
				}
				else if(objType=="padding_bottom"&& str.indexOf("%")!=-1){
					str=String(Number(str.replace("%",""))*returnStageHeight/100);
				}
			}
			return str;
		}
		
		
		private function returnType(type:String,value:String, objType:String):* {
			
			if(value.indexOf("%")!=-1)value=sortOutPercentageSign(value,objType);
			
			if(objType.toLowerCase().indexOf("colour")!=-1){
				var split:Array = value.split(",");
				for(var i:int=0;i<split.length;i++){
					split[i]=codeRecycleFunctions.getColour(split[i]).toString(); 
				}
				value = split.join(",");
			}
			
			switch (type.toLowerCase()){
				case "string" :
					return String(value);
				case "int" :
					if(value.toLowerCase().indexOf("rand")!=-1)return codeRecycleFunctions.getRand(value);
					return int(value);
				case "number" :
					if(value.toLowerCase().indexOf("rand")!=-1)return Number(codeRecycleFunctions.getRand(value));
					else return Number(value);
				case "boolean" :
					if(value.toLowerCase()=="true")return Boolean(true);
					else return Boolean(false);
				case "uint" :
					if(value.toLowerCase().indexOf("rand")!=-1)return uint(codeRecycleFunctions.getRand(value));
					else return uint(value);
				case "array" :
					return value as Array;
			}
			
			return value;
		}
		
		
		
		public function RunMe():uberSprite {
			return pic;
		}
		
		public function setUniversalVariables():void {		
			if(pic){
				sortOutScaling();
				sortOutWidthHeight();
				setContainerSize();	
				setPosPercent();
				sortOutPadding();
				if(getVar("opacity")!=1)pic.alpha=getVar("opacity");
			}
			
			if(getVar("mouseTransparent") as Boolean)mouseTransparent();
			
			
		}
		
		public function sortOutPadding():void{			
			var tempShift:uint=getVar("padding_left");
			pic.x=pic.x+tempShift;
			tempShift=getVar("padding_top");
			pic.y=pic.y+tempShift;
		}
		
		public function sortOutScaling():void{
			
			if (getVar("scale")!=1) {
				setVar("string", "scaleX", getVar("scale"));
				setVar("string", "scaleY", getVar("scale"));
			}
			doScaling(getVar("scaleX"),getVar("scaleY"));
		}
		
		public function doScaling(scaleX:Number,scaleY:Number):void{
			pic.scaleX=scaleX; pic.scaleY=scaleY;
		}
		
		private function sortOutWidthHeight():void{
			
			var staWidth:uint=returnStageWidth;
			var staHeight:uint=returnStageHeight;
			
			var hor:Number; var ver:Number;
			var tempStr:String = getVar("width");
	
			if (tempStr!="0" && tempStr!="aspectRatio"){
				if(tempStr.indexOf("%")!=-1) hor=staWidth*Number(tempStr.replace("%",""))/100;
				else hor=Number(tempStr);
			}
			
			tempStr = getVar("height");
			if (tempStr!="0" && tempStr!="aspectRatio"){
				if(tempStr.indexOf("%")!=-1) ver=staHeight*Number(tempStr.replace("%",""))/100;
				else ver=Number(tempStr);
			}
			
			if(getVar("width")=="aspectRatio" && getVar("height")!="aspectRatio"){
				hor=ver;
			}
				
			else if(getVar("height")=="aspectRatio" && getVar("width")!="aspectRatio"){
				ver=hor;
			}
			else if(getVar("height")=="aspectRatio" && getVar("width")=="aspectRatio"){
				throw new Error(getVar("height")+" you have specified both your width and height as 'aspectRatio' - you can only specify one as 'aspectRatio'");
			}
			//trace(3345,hor,ver,this)
			pic.width=hor;
			pic.height=ver;
			
		}
		
		
		public function setContainerSize():void{
			pic.myWidth=pic.width+getVar("padding_left")+getVar("padding_right");
			pic.myHeight=pic.height+getVar("padding_top")+getVar("padding_bottom");
		}
		
		public function setPosPercent():void {
			var tempPos:Number;
			
			switch (getVar("horizontal")) {
				case ("left") :
					horizontalCorrection=0;
					break;
				case ("right") :
					horizontalCorrection=1;
					break;
				default :
					horizontalCorrection=.5;
					break;
			}
			
			
			if (getVar("x").indexOf("%")!=-1) {
				pic.x=containerX+Number(getVar("x").replace("%",""))*.01*returnStageWidth-pic.myWidth*horizontalCorrection;
			}
			else {
				pic.x=containerX+Number(getVar("x"))-pic.myWidth*horizontalCorrection;
			}
			
			switch (getVar("vertical")) {
				case "top" :
					verticalCorrection=0;
					break;
				case "bottom" :
					verticalCorrection=1;
					break;
				default :
					verticalCorrection=.5;
					break;
			}
			
			if ((getVar("y") as String).indexOf("%")!=-1) {
				pic.y=containerY+(Number((getVar("y")as String).replace("%",""))*.01*returnStageHeight)-(pic.myHeight*verticalCorrection);	
			}
			else {
				pic.y=containerY+Number(getVar("y"))-(pic.myHeight);
			}
			
			pic.myX=pic.x;
			pic.myY=pic.y;
		}
		
		
		
		public function setRotation():void {
			var rotation:Number = getVar("rotate");
			
			pic.myX=pic.x;
			pic.myY=pic.y;
			
			if(rotation!=0){
				TweenPlugin.activate([TransformAroundCenterPlugin]);
				TweenMax.to(pic,0,{transformAroundCenter:{rotation:rotation}});
			}
		}
		
		
		
		
		public function getFromStoredVariables(str:String):String {
			var returnStr:String=new String  ;
			
			for (var i:uint=0; i<storedVariables.length; i++) {
				
				if (storedVariables[i][0]==str) {
					returnStr=storedVariables[i][1];
				}
			}
			for (i=0; i<temporaryStoredVariables.length; i++) {
				if (temporaryStoredVariables[i][0]==str) {
					returnStr=temporaryStoredVariables[i][1];
				}
			}
			
			if (returnStr=="") {
				//logger.log("no variable stored of this name: "+str);
			}
			
			return returnStr;
		}
		
		override public function kill():void {
			
			if(parentPic)parentPic=null;
			
			if(pic && pic.hasEventListener(Event.ADDED_TO_STAGE)) pic.removeEventListener(Event.ADDED_TO_STAGE,appearedOnScreen);
			if(pic && pic.hasEventListener(Event.REMOVED_FROM_STAGE)) pic.removeEventListener(Event.REMOVED_FROM_STAGE,removedFromScreen);
			
			if(myBoxLabel)myBoxLabel=null;
			
			
			var strayChild:*;
			if(pic){
				for(var i:int=0;i<pic.numChildren;i++){
					strayChild=pic.getChildAt(i);
					trace("!!!!!MEMORY LEAK!!!!! stray found:",strayChild,strayChild.parent);
					trace("in object:",this,peg);
					pic.removeChildAt(strayChild);
					strayChild=null;
				}
			}
			if(OnScreenElements){
				for(i=0;i<OnScreenElements.length;i++){
					OnScreenElements[i]=null;
				}
				OnScreenElements=null;
			}
			
			
			if(storedVariables){
				for(i=0;i<storedVariables.length;i++){
					storedVariables[i]=null;
				}
				storedVariables=null;
			}
			
			if(listOfDrivenEvents){
				for(i=0;i<temporaryStoredVariables.length;i++){
					temporaryStoredVariables[i]=null;
				}
				temporaryStoredVariables=null;
			}
			
			if(objectData){
				for(i=0;i<objectData.length;i++){
					objectData[i]=null;
				}
				objectData=null;
			}
			
			if(listOfDrivenEvents){
				for(i=0;i<listOfDrivenEvents.length;i++){
					listOfDrivenEvents[i]=null;
				}
				listOfDrivenEvents=null;
			}
			
			if(listOfStopEvents){
				for(i=0;i<listOfStopEvents.length;i++){
					listOfStopEvents[i]=null;
				}
				listOfStopEvents=null;
			}
			
			if(disallowedActions){
				for(i=0;i<disallowedActions.length;i++){
					disallowedActions[i]=null;
				}
				disallowedActions=null;
			}
			
			if(disallowedEvents){
				for(i=0;i<disallowedEvents.length;i++){
					disallowedEvents[i]=null;
				}
				disallowedEvents=null;
			}
			
			if(disallowedProps){
				for(i=0;i<disallowedProps.length;i++){
					disallowedProps[i]=null;
				}
				disallowedProps=null;
			}			
			
			driveEvent=null;
			super.kill();
			pic=null;
			
			//System.gc();
		}
		
		
		public function getClassName(o:Object):String{
			var fullClassName:String = getQualifiedClassName(o);
			return fullClassName.slice(fullClassName.lastIndexOf("::") + 1);
		}
		
		
		public function behav_getVar(variable:String):*{
			//trace("getVar:"+variable);
			if(this.hasOwnProperty(variable) && String(typeof((this[variable]))).toLocaleLowerCase()=="function") { //else if a special function set up/
				//trace(55,variable,this.hasOwnProperty(variable) , String(typeof((this[variable]))).toLocaleLowerCase()=="function");
				return this[variable]();
			}
				
			else if(this.OnScreenElements.hasOwnProperty(variable)){ //if saved as a property	
				return this.OnScreenElements[variable];
			}
			else {
				//if(logger)logger.log("!You asked me (peg="+peg+") for a variable's ("+variable+") value, but that variable does not exist");
				return "";
			}
		}
		
		public function behav_setVar(variable:String,what:*):void{
			//trace(111,variable,what,peg,this);
			if(what!=null){
				if(this.hasOwnProperty(variable) && String(typeof((this[variable]))).toLocaleLowerCase()=="function") { //else if a special function set up
					this[variable](what);
				}
					
				else if(this.OnScreenElements.indexOf(variable)!=-1){ //if saved as a property	
					this.OnScreenElements[variable]=what;
					//trace("in here",variable,what,peg);
				}
				else{
					//if (logger)logger.log("!You asked me (peg="+peg+") to set a variable's ("+variable+") value (to this: "+what+"), but that variable does not exist");	
				}
			}
			
		}
		
		
		public function giveBehavBoss(manageBehaviours:BehaviourBoss):void{
			this.manageBehaviours=manageBehaviours;
			//manageBehaviours.NOWbehaviours()
		}
		
		public function getValFromAction(txt:String):String{ //objects can be passed data regarding the OBJECT to the Behav this way.  E.g. the object may want to tell the data it is of a specific type.
			//how to use this function in other behavs: (see behavText for eg).
			/*			switch(getValFromAction((obj as object_baseClass).getVar("behaviours")){
			case "giveText":
			break;
			}*/
			var nam:String=getVar("peg")+"[";
			var pos:int=txt.indexOf(nam);
			if(pos!=-1){
				txt=txt.substr(pos+nam.length)
				pos=txt.indexOf("]");
				if(pos!=-1){
					txt=txt.substr(0,pos);
					return txt;
				}
			}
			return "";
		}
		
		
		
		/*		public function hack():void
		{
		trace("hack",peg);
		}*/
	}
}