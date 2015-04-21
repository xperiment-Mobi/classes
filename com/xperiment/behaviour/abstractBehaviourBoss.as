package com.xperiment.behaviour
{
	
	import com.xperiment.BehavLogicAction.LogicActions;
	import com.xperiment.BehavLogicAction.PropValDict;
	import com.xperiment.events.StimulusEvent;
	import com.xperiment.stimuli.addButton;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trial.helpers.RequiredStimuli;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class abstractBehaviourBoss extends Sprite
	{
		private static const availMouseEvents:Vector.<String> = Vector.<String> (["click","mouseDown", "mouseClick","rightClick","rightDown","rightUp",
			"middleClick","middleDown","middleUp","mouseUp","mouseMove","mouseWheel","mouseOver","mouseOut","doubleClick","rollOut","rollOver"]);
		
		public static const availEvents:Vector.<String> = Vector.<String>([
			//detailed in StimulusEvent
			StimulusEvent.DO_AFTER_APPEARED,
			StimulusEvent.DO_BEFORE,
			StimulusEvent.DO_NOW,
			StimulusEvent.ON_FINISH
			]).concat(availMouseEvents);
		
		private var behavObjectsDict:Dictionary=new Dictionary; //[peg] = [obj1,obj2]
		//private var drivenStoppableObjs:Array=[];
		public var propValDict:PropValDict; //public for testing purposes only
		private var logicActions:LogicActions;
		private var listenerKillList:Vector.<Listener>;
		public var __doNowBehavs:Vector.<String>;
		private var behavObs_needStimuli:Vector.<behav_baseClass>;
		
		public var requiredStim:RequiredStimuli;
		
		public function abstractBehaviourBoss(){
			propValDict= new PropValDict();
			logicActions=new LogicActions(propValDict); //created afresh each Trial
		}
		
		public function kill():void{
			
			for each(var l:Listener in listenerKillList){
				l.killF();
				l.kill();
				l=null;
			}
			listenerKillList=null;
			
			propValDict.killPerTrial();
			
			logicActions.kill();
			//propValDict.printPropDict();
			
			for (var i:uint=0;i<behavObjectsDict.length;i++)behavObjectsDict[i]=null;
			behavObjectsDict=null;
		}	
		
		public function init():void{
			//TOPS=trialOnlyProperties
			//getExistingTOPS(propValDict.perTrialProps);
			
			
			if(requiredStim)requiredStim.compute(propValDict.bind,propValDict.updateVal);
			
			__linkTOPS();
			
			if(behavObs_needStimuli)getPegsForBehavStimuli();
			
			propValDict.giveTrialObjs(behavObjectsDict);
			
			if(__doNowBehavs)doNowBehavsF();
			
		}
		
		
		private function getPegsForBehavStimuli():void
		{
			var pegs:Array;
			var peg:String;
			var obj:object_baseClass;
			//for (var s:String in behavObjectsDict){
			//	trace(s,behavObjectsDict[s])
			//}
			for each(var behavStim:behav_baseClass in behavObs_needStimuli){
				pegs = (behavStim.OnScreenElements['usePegs'] as String).split(",");
		
					for each(peg in pegs){
						if(behavObjectsDict[peg]!=undefined){
							for each(obj in behavObjectsDict[peg]){
								behavStim.givenObjects(obj);
							}
						}
						else throw new Error("you asked to link behaviour '"+behavStim.peg+"' with peg '"+peg+"'.  No stimulus has this peg.");
					}
			}
		}
		
		private function doNowBehavsF():void{

			for(var i:int=0;i<__doNowBehavs.length;i++){
				propValDict.incrementPerTrial(__doNowBehavs[i],null);
				__doNowBehavs[i]=null;
			}
			__doNowBehavs=null;
		}
	
		public function __linkTOPS():void
		{

			//IMPORTANT. Goes through propDict 
			////TOPS=trialOnlyProperties
			var prop:String;
			var objsArr:Array;
			var i:int;

			//WEIRD ELSE ISSUE HERE
			for each(var pegProp:String in propValDict.propDict){
				//trace(111111,pegProp)
				/*possible values:
				E.action 	- 	a listener
				k 			-	across experiment var so IGNORE
				'sausage' 	-	throw error
				*/
				//trace(pegProp,222);

				var len:int=pegProp.split(".").length;
				
				
				if(pegProp.charAt(0)=="'" && pegProp.charAt(pegProp.length-1)=="'"){
					//do nothing as this is just a string
				}
				else if(!isNaN(Number(pegProp))){
					//do nothing as this is just a number with decimels
				}
				else if(len==2){
					
					objsArr=behavObjectsDict[pegProp.split(".")[0]]; //returns the list of objects with this peg.
					prop = pegProp.split(".")[1];
					
					if(objsArr) 
						for(i=0;i<objsArr.length;i++){	
							
							{	
								
								if(pegProp.indexOf("()")==-1 && pegProp.split(".").length==2){
							
									if(		__linkTOPSListeners(objsArr[i],prop,propValDict.incrementPerTrial,pegProp)==false)
									{
										
										
										if(		linkTOPSProps(objsArr[i],propValDict.bind,propValDict.updateVal,pegProp,prop)==false)
										{											
											throw 	new Error("Problem, '"+pegProp+"' never ever can happen!  You've specified an unknown event or unsettable object property.");
										}
									
									}
									else{
										//trace(2222,pegProp)
									}
							
								}
									
								
								else if(pegProp.indexOf("()")!=-1)
								{
									linkTOPSActions(objsArr[i],prop,propValDict.bind,pegProp);
								}
								else throw new Error("badly formed action [should end in () ] or listener [should have ONE . ]:"+pegProp);
							}		
						}
					
					else {
						throw new Error("You have not given any object this peg: "+pegProp.split(".")[0]+".  Nothing can be done with this action then: "+pegProp+".");
					}
					//trace("adding peg:",pegProp);
					propValDict.addTrialProps(pegProp); 
				}
					
				else if(len==1){
					//ignore this.  It is an 'across experiment' variable.
				}
					
				else if(len>2){
					throw new Error("Action specified with 2 dots.. can only have 1 dot.  e.g. banana.cli.  Was given: "+pegProp);
				}
					
				else if(pegProp.split("'").length==3 || !isNaN(Number(pegProp))){
					throw new Error("Found a bug: Should not be possible to receive strings or numbers here.  Was given: "+pegProp);
				}
					
				else{
					throw new Error("Found a bug: wrongly formatted action: "+pegProp);
				}	
			}
		}
		
		public function propWrapper(stim:object_baseClass, prop:String):Function{

			
			throw new Error("Problem trying to set/get a value '"+prop+"' on this object '"+stim.peg+"': property does not exist."); 
			return null;
		}
		
		//only public for testing purposes
		//final public function linkTOPSProps(stim:object_baseClass, what:String, bind:Function,updateVal:Function, prop:String):Boolean
		final public function linkTOPSProps(stim:object_baseClass, bind:Function,updateVal:Function,pegProp:String, prop:String):Boolean
		{
			/*
			unversal & special: timeStart, end, position, transparency, 
			think about: shadow?? Perhaps goes in linkTOPSActions 
			*/
			//trace(34,prop,pegProp)
			
			if(!(stim.disallowedProps && stim.disallowedProps.indexOf(prop)==-1)){
				//trace(123,stim,prop);
				////If BehaviourBoss finds the approp named function, passes it a function to call when the given behaviour occurs.
				
				
				var settingF:Function = stim.myUniqueProps(prop);
				//trace(prop,pegProp,22,settingF)
				if(settingF==null) settingF = 	propWrapper(stim,prop);
				
				
				if(settingF!=null){
					//removed mid April 2013 as it is unnessary to update props before they are even accessed
					//also will add the feature that props are updated only when they are required.
					//trace("here",settingF);
					updateVal(pegProp,settingF);
					bind(pegProp, settingF);}
				else 	throw new Error("Unknown property trying to be set for peg "+stim.peg+"': "+prop);		
				
			}
			else throw 	new Error("Forbidden setting'"+prop+"()"+"'  asked for on '"+stim.peg+"'!");
	
			return true;
			
		}
		
		private function linkTOPSActions(stim:object_baseClass, action:String, bind:Function,prop:String):Boolean
		{
			
			
			if(!(stim.disallowedActions && stim.disallowedActions.indexOf(action)==-1)){

				////If BehaviourBoss finds the approp named function, passes it a function to call when the given behaviour occurs.
				var actionF:Function;
				action=action.replace("()","");
				actionF = 	stim.myUniqueActions(action);
				if(actionF==null) 	actionF = 	actionWrapper(stim, action);
				
				
				//trace(stim,actionF,action)

				if(actionF!=null) 	bind(prop, actionF);
				
				//else 				throw new Error("Unknown action' for peg "+stim.peg+"': "+action);						
			}
			else throw 	new Error("Forbidden action '"+action+"()"+"'  asked for on '"+stim.peg+"'!");
			
			return true;
		}
		
		public function actionWrapper(stim:object_baseClass, action:String):Function{
			throw new Error('actionWrapper function in abstract class must be overridden');
			return null;}
		
		//gets called once for each discovered action
		public function __linkTOPSListeners(stim:object_baseClass, listenFor:String, incrementPerTrial:Function,prop:String):Boolean
		{
			
			//need to provide a custom event ability for individual stimuli, as done for actions (myUniqueactions)
			//trace(12345,stim, stim.pic, listenFor, incrementPerTrial,prop, stim.peg)
			var listenForBool:Boolean;
			
			if((listenForBool = (availEvents.indexOf(listenFor)!=-1)) || (stim.uniqueEvents && stim.uniqueEvents.hasOwnProperty(listenFor)!=-1)){
				
				if(!(stim.disallowedEvents && stim.disallowedEvents.indexOf(listenFor)==-1)){
					
					if(listenFor != StimulusEvent.DO_NOW){

						var listener:Listener = new Listener;
						
						listener.anonyF= function(e:Event):void{
							//trace(2222222,listenFor,stim.pic,e.currentTarget,prop);
							incrementPerTrial(prop);}//this function is called when the action happens
	
						if(stim is addButton && StimulusEvent.list.indexOf(listenFor)==-1){
							(stim as addButton).button.addEventListener(listenFor,listener.anonyF);
						}
						//DEDICATED StimBehav
						else{
							
							if(!listenForBool && stim.uniqueEvents && stim.uniqueEvents.hasOwnProperty(listenFor)==false){
								//trace(11)
								return false; //added Feb 2015
							}

							stim.pic.addEventListener(listenFor,listener.anonyF);
						}
						//}
				
						//this function returning a function allows variables from above to be passed 'in the future'
						//thus allowing the listener to be safely removed.
						listener.killF	= function():Function{return function():void{
		
							//tried to use an anonymous function to remove duplicity below but thought not worth effort as tricky
							if(stim is addButton)	(stim as addButton).button.removeEventListener(listenFor,listener.anonyF);
							else					stim.pic.removeEventListener(listenFor,listener.anonyF);
	
							trace("removed listener:",listener,"from",stim.peg);
						}};
						if(!listenerKillList)listenerKillList = new Vector.<Listener>;
						listenerKillList.push(listener);
						
						
					}
					else{
						__doNowBehavs ||= new Vector.<String>;
						
						
						__doNowBehavs.push(stim.peg+"."+listenFor);
					}
				}

				else throw 	new Error("Problem: "+listenFor+"' on '"+stim.peg+"' never happens!");
			}
			else return false; 
			
			return true;
			
		}		
		
		public function log(str:String):void{
			throw Error("log function should not be accessed from abstract class");
		}
		
		
		public function objectAdded(obj:object_baseClass):void {

			if(behavObjectsDict[obj.peg]==undefined) behavObjectsDict[obj.peg] = [];

			
			//identify behavObjs that request other objects
			if(obj is behav_baseClass && obj.OnScreenElements['usePegs']!=''){
				if(!behavObs_needStimuli)behavObs_needStimuli= new Vector.<behav_baseClass>;
				behavObs_needStimuli[behavObs_needStimuli.length]=obj as behav_baseClass;
			} 
			////////
			
			if(behavObjectsDict[obj.peg].indexOf(obj)==-1){//each object can only be added once :-)  
	
				behavObjectsDict[obj.peg].push(obj);
	
				var cmbndObjLogActs:String="";
				var str:String;
				
				str=obj.getVar("behaviours");
				
				//if(str.indexOf(TrialCommands.TRIAL)!=str = TrialCommands.parseBehav(str);

				
				if(str!=""){
					var list:Array
					if(str.split(":").length>1){
						list = BehaviourBossHelper.fixBehavCommaIssue(str,':');
					}
					else list = [str];


					for(var i:int = 0; i<list.length; i++){
						
						list[i]=behavToIf(obj.peg,list[i]);
					}
					cmbndObjLogActs+=list.join(',');
				}
				
				str=obj.getVar("if");

				if(str!=""){
					if(cmbndObjLogActs!="")cmbndObjLogActs+=",";
					cmbndObjLogActs+=str;
				}
				
				
				if(cmbndObjLogActs!=""){	
					//trace("from abstract behaviour boss 00000000000000000000000000000000000",obj.peg);
					logicActions.passLogicAction(BehaviourBossHelper.fixBehavCommaIssue(cmbndObjLogActs));
				}	
			}
		}
		
		
		private function behavToIf(behavPeg:String,behav:String):String{
			var behavArr:Array=behav.split(":");
			if(behavArr.length!=2)throw Error("problem with this logic:"+behav);
			
			if(behavArr[0].indexOf(".")!=-1)return behavArr[0]+"?"+behavArr[1];
			return behavPeg+"."+behavArr[0]+"?"+behavArr[1];
		}
		
		public function testFunct(nam:String):Function{
			if(this[nam]!=undefined)return this[nam];
			else return null
		}
		
	}
}