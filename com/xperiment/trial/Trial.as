package com.xperiment.trial {

	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.MockResults.MockResults;
	import com.xperiment.behaviour.BehaviourBoss;
	import com.xperiment.container.container;
	import com.xperiment.events.GotoTrialEvent;
	import com.xperiment.exptWideAction.ExptWideAction;
	import com.xperiment.interfaces.IGiveScript;
	import com.xperiment.interfaces.IgiveTrialInfo;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.preloader.IPreloadStimuli;
	import com.xperiment.stimuli.IStimulus;
	import com.xperiment.stimuli.IgivePreloader;
	import com.xperiment.stimuli.IneedCurrentDisplay;
	import com.xperiment.stimuli.IneedPokeAtStart;
	import com.xperiment.stimuli.StimulusFactory;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.stimuli.helpers.StimModify;
	import com.xperiment.stimuli.primitives.IResult;
	import com.xperiment.trial.Scroll.IScroll;
	import com.xperiment.trial.Scroll.ScrollTrial;
	import com.xperiment.trial.helpers.EndOfTrial_feedbackBoss;
	import com.xperiment.trial.helpers.RequiredStimuli;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.utils.Timer;

	public class Trial extends AbstractTrial {
		
		public static var language:String = "";
		public static var P2P_NO_WAIT:Boolean = true;
		public static var preloader:IPreloadStimuli;
		static public var theStage:Stage;
		static public var RETURN_STAGE_HEIGHT:int;
		static public var RETURN_STAGE_WIDTH:int;
		public static var ACTUAL_STAGE_WIDTH:int;
		public static var ACTUAL_STAGE_HEIGHT:int;
		static public var HORIZONTAL_ADJUST:Number = 0;
		static public var VERTICAL_ADJUST:Number = 0;
		static public var ZOOM_X:Number = 1;
		static public var ZOOM_Y:Number = 1;
		
		public var trialOrderScheme:String;
		public var trialInfo:Object;
		public var runTrial:Boolean=true; 
		public var ITItimer:Timer;
		public var fixedLocation:String="999";
		public var OnScreenElements:Vector.<object_baseClass>;	
		public var trialData:XML=new XML  ;
		public var CurrentDisplay:OnScreenBoss;
		public var Order:uint=new uint  ;
		public var trialLabel:String=new String;
		public var trialNumber:uint;
		public var autoStart:Boolean=true;
		public var trialBlockPositionStart:uint;
		public var trialProtocolList:XML;
		public var ITI:int=-1;
		public var exptScript:XML; //                  DUPLICATED ABOVE WITH TRIALPROT...
		public var pic:Sprite = new Sprite;
		public var numTrials:int = 1;
		
		private var hideResults:Boolean = false;
		private var requiredStim:RequiredStimuli;
		private var myContainers:Array;
		private var exptWideAction:ExptWideAction;
		private var scroll:IScroll;
		private var CallAtStart:Vector.<Function>;
		private var behaviours:String;
		private var nextEventEvoked:Boolean;
		private var endOfTrialStim:Vector.<uberSprite>;
		
		
		
		public function passExptScriptXML(trialProtocolList:XML):void{
			this.trialProtocolList=trialProtocolList;
		}
		
		public function setup(info:Object):void {		
			trialInfo=info;
			info.storageFolder=ExptWideSpecs.IS("saveToPortableDevice");		
			this.ITI=ExptWideSpecs.IS("ITI");
			
			trialNumber=info.order;
			runTrial=info.runTrial;

			//trace(info.TRIAL_ID)
			TRIAL_ID=info.TRIAL_ID;
		
			
			trialBlockPositionStart=info.trialBlockPositionStart;
			//trace(trialBlockPositionStart,222,TRIAL_ID);
			//duplicateTrialNumber=info.duplicateTrialNumber;
			
			trialLabel=info.trialNames;
	
		}

		///////////////////////////////////////////////
		
		public function elementSetup(stim:XML,inContainer:container):void {

			var stimParams:XML;
	
			for each(var kinder:XML in stim.*) {
				//HERE, add if objectType="con"
				// take out the code below and put into a seperate function :)  Allows the container to do stuff. 
				//If container, setup container, THEN cycle through elements in container, passing them the container:Sprite as well as the stage. 
				//note, this will have to be iterative ... containers within containers...
				// prob will need newfunction(a,b,c,etc,)
				var isSuitableToCheckForChildren:Boolean=false;
				var lowerLevelContainer:container;
				var kinderNam:String=kinder.name().toString();


				var iterations:uint;
				
				switch (kinderNam.substr(0,3)){
						
					case("con"):
						if(!myContainers)myContainers=new Array;
						kinder.@numInContainer=countChildren(kinder);
						lowerLevelContainer=composeObject(kinder, 1,inContainer,false,stimParams.text());
						myContainers.push(lowerLevelContainer); //put this array in kill();
						isSuitableToCheckForChildren=true;
						break;
					default:
						iterations=1;	
						var howMany:String =howMany=codeRecycleFunctions.multipleTrialCorrection(kinder.attribute("howMany"),";",trialBlockPositionStart);
						if (howMany.length!=0) iterations=int(howMany);
						
						stimParams=kinder.copy();
						
						StimModify.process(XMLList(stimParams));
						

						for (var i:int=1;i<=iterations;i++){
							composeObject(stimParams, i-1,inContainer,false,stimParams.text());
						}

						break;	
				}
			}
			
			//permuteLinkedPositions();
		}
		
		/*private function permuteLinkedPositions():void
		{
			var linkedPosElement:Array = [];
			var xStr:String;
			var yStr:String;
			for each(var stim:IStimulus in OnScreenElements){
				xStr=stim.getVar("x");
				yStr=stim.getVar("y");
				
			}
		}		*/
		
		private function countChildren(kinder:XML):uint{
			var count:uint=0;
			var howMany:String;
			var nam:String;
			for (var i:uint=0;i<kinder.children().length();i++){
				howMany=kinder.children()[i].@howMany;
				nam=kinder.children()[i].name().toString().substr(0,3);
				if(nam=="add" || nam=="con"){
					if (howMany.length==0 && howMany!="0") count++;
					else if (uint(howMany)>0) count+=uint(howMany)
				}
			}
			return count;
		}
		
		public var TRIAL_ID:int;
		
		//seperated for overwriting reasons (in TrialAndroid etc);
		
		public function stimulusFactory(name:String):IStimulus{
			return StimulusFactory.Stimulus(name);
		}
		
		public function composeObject(kinder:XML, iteration:uint,inContainer:container, saveParams:Boolean=false,xmlVal:String=''):container {
			
			
			//using the 'present' attribute (where 0 means 'do not show');
			var present:String = codeRecycleFunctions.multipleTrialCorrection(kinder.@present,";",trialBlockPositionStart);
			var makeStimulus:Boolean=["0","false"].indexOf(present)==-1;
			
			var freshStim:IStimulus = stimulusFactory(kinder.name());
		
			if(makeStimulus && freshStim){
				{
					(freshStim as object_baseClass).xmlVal=xmlVal;
					OnScreenElements[OnScreenElements.length]=freshStim;
	
					var TrialVarObj:Object=new Object  ;
					TrialVarObj.theStage=theStage;
					TrialVarObj.name=kinder.name();
					
					if(inContainer==null){
						TrialVarObj.h=RETURN_STAGE_HEIGHT;
						TrialVarObj.w=RETURN_STAGE_WIDTH;
						TrialVarObj.containerX=0;
						TrialVarObj.containerY=0;
					}
					else{
						var fromContainer:Object = inContainer.returnContainerInfo();
						TrialVarObj.h=fromContainer.myHeight;
						TrialVarObj.w=fromContainer.myWidth;
						TrialVarObj.containerX=fromContainer.x;
						TrialVarObj.containerY=fromContainer.y;
					}
					
					// 12.9.2012 decided to give behaviourBoss to everything
					freshStim.giveBehavBoss(manageBehaviours);
					
					if(freshStim is IGiveScript)(freshStim as IGiveScript).giveExptScript(exptScript);
					if(freshStim is IgiveTrialInfo)(freshStim as IgiveTrialInfo).giveTrialInfo(trialInfo);
					if(freshStim is IneedCurrentDisplay)(freshStim as IneedCurrentDisplay).passOnScreenBoss(CurrentDisplay);
					if(freshStim is IgivePreloader)(freshStim as IgivePreloader).passPreloader(preloader);
					if(freshStim is IneedPokeAtStart){
						CallAtStart ||= new Vector.<Function>;
						CallAtStart.push((freshStim as IneedPokeAtStart).pokeOnStart);
					}

					TrialVarObj.i=iteration;
					TrialVarObj.perSize=ExptWideSpecs.IS("percentageFromWidthOrHeightOrBoth") as String;
					TrialVarObj.trialBlockPositionStart=trialBlockPositionStart;
					TrialVarObj.parent=pic;
					TrialVarObj.order=trialInfo.order;
					TrialVarObj.numTrials=numTrials;
					
					freshStim.setUpTrialSpecificVariables(TrialVarObj);	
					
					
					(freshStim as object_baseClass).duplicateTrialNumber = trialBlockPositionStart;
					
					if(kinder.@depth.toString()==""){
						kinder.@depth=(OnScreenElements.length-1).toString();
					}
					
					freshStim.setVariables(XMLList(kinder));
				

					if (String(kinder.@showBox).length!=0 && kinder.@showBox=="true" && (String(kinder.attribute("showBox")).length==0 || kinder.attribute("showBox")=="false")){
						kinder.@showBox="true";
					}
					
					//behaviours=codeRecycleFunctions.multipleTrialCorrection(kinder.attribute("behaviours"),"---",iteration);
					
					if(inContainer!=null)inContainer.passChildObject((freshStim as object_baseClass).pic);
					
					
					/////////////timing stuff
					/////////////created the timing object var for unit testing
					var duration:String = freshStim.getVar("duration")
					if(duration!="") duration = codeRecycleFunctions.multipleTrialCorrection(duration,"---",iteration);
					
					if(freshStim.getVar("timeStart").indexOf("end")!=-1){
						endOfTrialStim ||= new Vector.<uberSprite>;
						endOfTrialStim.push(freshStim);
					}
						
					sortoutTiming(freshStim.getVar("timeStart"), freshStim.getVar("timeEnd"),duration,freshStim.getVar("peg"),freshStim as uberSprite);

					CurrentDisplay.addtoTimeLine(freshStim as uberSprite);
	
					manageBehaviours.passObject(freshStim as object_baseClass);

					/////////////
					/////////////
					
					if(freshStim.getVar("required")!=object_baseClass.NOT_REQUIRED){
						if(freshStim is IResult){
							requiredStim ||= new RequiredStimuli;
							requiredStim.add(freshStim);
						}
						
						else if((freshStim as object_baseClass).OnScreenElements.hasOwnProperty("required")){
							throw new Error("'required' is not available for this type of stimulus '"+String(freshStim).replace("[object ","").replace("]","")+"'.");
						}
						
					}
					if(saveParams)(freshStim as object_baseClass).stimXML = kinder;
					freshStim.RunMe();
				}
			}

			if(String(kinder.name()).substr(0,3)=="con")return freshStim as container;
			else return inContainer;
		}
		

		
		public function compileOutputForTrial():XML {
			
			var t:String = trialLabel;
			if(trialLabel!="")t+="|";
			
			var trialName:String = t+"b"+TRIAL_ID+"i"+trialBlockPositionStart;
			
			trialData = <trialData name={trialName} ></trialData>;
			var stimulusData:Array;


			if(ExptWideSpecs.IS("trialOrder"))	trialData['trialOrder']=Order;
			if(ExptWideSpecs.IS("trialTime"))	trialData['trialTime']=codeRecycleFunctions.roundToPrecision(ExptWideSpecs.getDuration(),2);

			var eventName:String;
			
			for each(var stimulus:object_baseClass in OnScreenElements) {

				if(stimulus.getVar("hideResults")!='true' && stimulus.ran==true ){ 

	
					if(stimulus.returnsDataQuery()){
						
						stimulusData=stimulus.storedData();					
					
						for each(var result:Object in stimulusData) {
							//trace(stimulus,234)
							if(result.hasOwnProperty('event')){
								
								eventName=__clean(result.event, " ", "_");
								
								var temp_EventName:String = eventName;
								var count:int=1;
								
								while(trialData.hasOwnProperty(temp_EventName)){
									temp_EventName=eventName+count.toString();
									count++;
								}
								eventName=temp_EventName;
								
								//trace(eventName,2)
								if(!isNaN(Number(eventName.charAt(0))))eventName="_"+eventName;
								trialData[eventName]=cleanData(result.data);
							}
							else{
								//'no data recorded'
							}
						}		
					}
				}	
			}
			
			
			return trialData;

		}
		
		private function cleanData(data:String):String{
			data= __clean(data, "'", "’");
			data= __clean(data, "\"", "”");
			return data;
		}
		
		public function __clean(data:String, what:String, to:String):String{
			return data.split(what).join(to);
		}
		
		
		////////////////////////////////////////////////////////////////////////
		//GENERIC VARIABLES AND FUNCTIONS
		////////////////////////////////////////////////////////////////////////
		

		public function instantiateVars():void
		{
			
			if(theStage && pic){
				theStage.addChild(pic);
			}			
		
			//if(ZOOM_X!=1){
				pic.scaleX=ZOOM_X;
				pic.x=HORIZONTAL_ADJUST;
			//}
			//if(ZOOM_Y!=1){
				pic.scaleY=ZOOM_Y;
				pic.y=VERTICAL_ADJUST;	
			//}
			
			OnScreenElements=new Vector.<object_baseClass>;
		}
		

		public function prepare(Ord:uint,trial:XML,params:Object=null):void {
			pic ||= new Sprite;
			Order=Ord;
			if(trial.hasOwnProperty('@trials'))	numTrials=trial.@trials;
		
			for each(var prop:Array in [['ignoreData','hideResults']]){
				if(trial.hasOwnProperty("@"+prop[0])){
					
					throw new Error("You accidentally specified '"+prop[0]+"' for a trial. You should instead use '"+prop[1]+"'.");
				}
			}
			
			function checkAndSet(what:String,IS:Boolean=true,variable:String=''):void{
				if(variable=='')variable=what;
				if(trial.hasOwnProperty('@'+what) && trial.@[what].toString()==IS.toString())	this[variable]=true;
			}
			
			if(trial.hasOwnProperty('@ITI'))				ITI=int(trial.@ITI);
			if(trial.hasOwnProperty('@background'))			sortbackground(trial.@background);
			if(trial.hasOwnProperty('@trialOrderScheme'))	trialOrderScheme=trial.@trialOrderScheme;
			
			checkAndSet('hideResults');
			checkAndSet('reportOrder');
			checkAndSet('trickleToCloud');
			checkAndSet('run',true);
			
			var con_b:container;
			instantiateVars();
			
			CurrentDisplay = getOnScreenBoss(params); // slight bodge to allow for stuff to be added when sorting out a multiExperiment Trial.
			pic.addChild(CurrentDisplay);
				
			manageBehaviours=manageBehavioursGet();
			
			elementSetup(XML(<objects>{trial.children()}</objects>),con_b);

			if(trialInfo.ITI){
				var eventName:String;
				eventName=codeRecycleFunctions.multipleTrialCorrection(trialInfo.ITI,"~",Order-trialBlockPositionStart);//n.b. the left objects formula is identical to 'trialWithinBlockPosition' in objectBaseClass.
				ITI=int(codeRecycleFunctions.multipleTrialCorrection(eventName,";",trialBlockPositionStart));
			}
			
			if(trial.hasOwnProperty('@scroll') 	&& trial.@scroll==true) scroll=giveScrollTrial();
			

			manageBehaviours.requiredStim = requiredStim;
			
			manageBehaviours.init();
			
			TrialHelper.computeLayerOrder(OnScreenElements);
			
			if(ExptWideSpecs.IS("mock")==true)MockResults.giveStimuli(OnScreenElements);
			
			if(ITI!=0){
				ITItimer=new Timer(ITI);
				ITItimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void{
					ITItimer.stop();
					ITItimer.removeEventListener(TimerEvent.TIMER,arguments.callee);
					if(P2P_NO_WAIT)run();
				});
				ITItimer.start();
			}
			else{
				if(P2P_NO_WAIT)run();
			}

		}

		public function getOnScreenBoss(params:Object):OnScreenBoss{
			var o:OnScreenBoss = new OnScreenBoss;
			if(params && params.timing) o.params(params.timing);
			return o;
		}
		
		public function manageBehavioursGet():BehaviourBoss{
			return new BehaviourBoss(pic,CurrentDisplay);
		}
		
		public function giveScrollTrial():IScroll
		{
			return new ScrollTrial(true);
		}
		
		private function sortbackground(colour:String):void
		{
			var c:int = codeRecycleFunctions.getColour(colour);
			pic.graphics.beginFill(codeRecycleFunctions.getColour(colour),1);
			pic.graphics.drawRect(0,0,RETURN_STAGE_WIDTH,RETURN_STAGE_HEIGHT);
			pic.graphics.endFill();
		}	

		
		public function giveTrialData():XML{
			if(hideResults==true)return null;
			trace("---trialData---");
			trace(trialData);
			trace("---");
			
			return trialData;
		}
		

		public function run():void {

			if(pic){
			
				pic.addEventListener(GotoTrialEvent.TRIAL_PING_FROM_OBJECT,gotoTrial,false,0,false);//note false here for weak refs.  NEEDED.  If the SJ is on a trial long enough, the eventlistener will just be cleaned up...
				nextEventEvoked=false;			


				CurrentDisplay.commenceDisplay(autoStart);
				if(CallAtStart){
					while(CallAtStart.length>0){
						CallAtStart[0]();
						CallAtStart.shift();
					}
					CallAtStart=null;
				}
				
			
				
		
				if(ExptWideSpecs.IS("mock")==true)MockResults.start();
				
				if(scroll){
					var max_Height:Number=0;
					var current_Height:Number;
					
					for each(var stim:object_baseClass in OnScreenElements){
						current_Height=stim.myHeight+stim.myWidth;
						if(max_Height<current_Height)max_Height=current_Height;
					}
					scroll.init(pic,max_Height);
				}	
			}

			/*var s:Sprite= new Sprite;
			s.graphics.beginFill(0xFFFFFF);
			s.graphics.drawRect(200,200,200,200);*/
			
		}
		
		protected function gotoTrial(e:GotoTrialEvent):void
		{			
			if(pic)pic.removeEventListener(GotoTrialEvent.RUNNER_PING_FROM_TRIAL,gotoTrial);
			if(!endOfTrialStim) nextEvent(e.action);
			else{
				CurrentDisplay.stopAll();
				EndOfTrial_feedbackBoss.DO(endOfTrialStim,CurrentDisplay, 
						function():void{
							nextEvent(e.action); //small wrapper as need to pass e.action
						}
				);
				
			}
		}

		
		private function nextEvent(action:String):void{
			if(hideResults==false)compileOutputForTrial();
			//trace(trialData);
			generalCleanUp();	
			
			if(!nextEventEvoked){
				if(theStage){
					theStage.dispatchEvent(new GotoTrialEvent(GotoTrialEvent.RUNNER_PING_FROM_TRIAL,action));
				}
				
			}
			nextEventEvoked=true;
		}
		
		
		public function addOnScrEle(nam:String, obj:*, ... rest):void {
			if (rest.length==1) {
				OnScreenElements[nam]=rest[0];
			}
		}
		
		public function generalCleanUp():void {

			if(scroll)scroll.kill();
			
			pic.removeEventListener(GotoTrialEvent.TRIAL_PING_FROM_OBJECT,gotoTrial);
			
			if(requiredStim){
				requiredStim.kill();
				requiredStim=null;
			}
			
			if(manageBehaviours){
				manageBehaviours.kill();
				manageBehaviours=null;
			}
			
			if (CurrentDisplay){
				pic.removeChild(CurrentDisplay);
				CurrentDisplay.cleanUpScreen();
				
				CurrentDisplay=null;
			}
			
			
			if(OnScreenElements){
				for (var i:uint=0; i<OnScreenElements.length; i++) {
					OnScreenElements[i].kill();
					OnScreenElements[i]=null;
				}
				OnScreenElements=null;
			}
			

			
			if(myContainers){
				for(i=0;i<myContainers.length;i++){	
					myContainers[i].kill();
					myContainers[i]=null;
				}
				myContainers=null;
			}
			

			//varsStoredEachTrial=null;

			if(theStage!=null  && pic!=null && theStage.contains(pic)){
				theStage.removeChild(pic);
			}
			
			
			var strayChildren:Array = [];;
			
			for(i=0;i<pic.numChildren;i++){
				strayChildren.push(pic.getChildAt(i));
			}
			
			if(strayChildren.length>0) throw new Error("devel error, memory leak, strays found: "+strayChildren.concat(","));
			strayChildren=null;
			

			pic=null;
			System.pauseForGCIfCollectionImminent();

			
		}
		public function pause(ON:Boolean):void
		{
			CurrentDisplay.hardPause(ON);
			
		}
	}	
}