package com.xperiment.behaviour{
	
	//note: each object MUST have unique peg

	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.display.Sprite;


	
	
	
	public class BehaviourBoss extends abstractBehaviourBoss {
		
		public static var permittedActions:Vector.<String> = new <String>['start','stop','kill','hide','invisible', 'reveal', 'unhide','show','togglevisible'];
		public static var permittedEditableProps:Vector.<String> = new <String>[];
		
		private var currentDisplay:OnScreenBoss;
		public var bossSprite:Sprite; //note, only ONE other class accesses this: behavShake. 
		
		private var anonymousPegs:uint=0;
		
		override public function kill():void{
			//actionListeners(false);
			currentDisplay = null
			bossSprite = null;
			super.kill();
		}
		
		public function BehaviourBoss(bossSprite:Sprite,currentDisplay:OnScreenBoss){
			this.currentDisplay=currentDisplay;
			this.bossSprite=bossSprite;
			//actionListeners(true);
			super();
		}
		

		
		

		
		override public function actionWrapper(stim:object_baseClass, action:String):Function
		{
			
			if(permittedActions.indexOf(action)!=-1){
			
				switch(action){
					case "start":			return function(peg:String):void{currentDisplay.runDrivenEvent(stim.peg, stim.getVar("delay"),stim.getVar("duration"));}; break;
					
					case "finish":
					case "stop"	:			return function(peg:String):void{
																if(stim is behav_baseClass)(stim as behav_baseClass).stopBehaviour(stim);
																if(currentDisplay)currentDisplay.stopPeg(stim.peg);}; 	break;
					
					case "kill"	:			return function(peg:String):void{
																if(stim is behav_baseClass)(stim as behav_baseClass).stopBehaviour(stim);
																if(currentDisplay)currentDisplay.killPeg(stim.peg);}; 	break;
					
					case "hide":
					case "invisible":		return function(peg:String):void{stim.visible=false;};					break;
					
					case "visible":
					case "reveal":
					case "unhide":
					case "show":			return function(peg:String):void{stim.pic.visible=true;};					break;
					
					case "togglevisible": 	return function(peg:String):void{stim.pic.visible=!stim.pic.visible;};		break;
				}
			}
				
			return null;
		}
		
		override public function propWrapper(stim:object_baseClass, prop:String):Function
		{
			//trace("33333:",prop,stim.OnScreenElements.hasOwnProperty(prop),["timeStart","timeEnd","duration"].indexOf(prop)!=-1);			
			
			if(["timeStart","timeEnd","duration"].indexOf(prop)!=-1)return timeSetter(stim,prop);
			else if(["x","y"].indexOf(prop)!=-1)return codeRecycleFunctions.posSetterGetter(stim,prop);

			else if(stim.OnScreenElements.hasOwnProperty(prop)){
				
				return setValue(stim, prop);			
			}
			super.propWrapper(stim,prop); //if this happens, Error
			return null;
		}
		
		private function setValue(stim:object_baseClass, prop:String):Function{
			//trace(111,prop,typeof(stim.OnScreenElements[prop]))
			switch(typeof(stim.OnScreenElements[prop])){
				
				case "boolean":
				case "string": 	return function(what:String=null,to:String=null):String{
											if(what!=null)stim.OnScreenElements[correctForDotNotation(what)]=codeRecycleFunctions.removeQuots(to);
											//trace(stim.peg,22222)
											return codeRecycleFunctions.addQuots(stim.OnScreenElements[correctForDotNotation(prop)]);
										}
					break;
				
				case "uint":
				case "int":
				case "number": 	return function(what:String=null,to:* =null):String{
											if(what!=null)stim.OnScreenElements[what]=to;
											return stim.OnScreenElements[prop];						
										}
					break;
				
			}		
			return null;
		}

		
		private function correctForDotNotation(what):String{
			if(what.indexOf(".")!=-1) return what.split(".")[1]
			return what;
		}
		
		private function timeSetter(stim:object_baseClass, prop:String):Function
		{	
			var setF:Function = function(prop:*):Function{
				switch(prop){
					case "timeStart": 	return function(what:String, to:Number):void{
						currentDisplay.setTimes(stim,to,-1,-1);}; 
						break;
					case "timeEnd":		return function(what:String, to:Number):void{
						currentDisplay.setTimes(stim,-1,to,-1);}; 
						break;
					case "duration":	return function(what:String, to:Number):void{
						currentDisplay.setTimes(stim,-1,-1,to);
					}; break;			
				}
				return null	;	
			}
			
			var functional:Function = setF(prop);
			
			return function(what:* =null,to:* =null):Number{
				if(what){
					if(!isNaN(Number(to)))functional(what,to);
					else throw new Error("Problem in changing timing value '"+what+"': you must provide a number, not this: '"+to+"'"); 
				}
				if(prop =="timeStart")		return stim.startTime;
				else if(prop=="timeEnd")	return stim.endTime; 
				else if(prop=="duration") 	return	stim.getVar("duration");
				return 0;
			}
		}
		

		
		
		
		public function anonPeg():String{
			anonymousPegs++;
			return "noPeg"+anonymousPegs;
		}
		
		//from Trial.  Critical interface
		public function passObject(tempObj:object_baseClass):void{
			
			
			//trace(tempObj.peg,33,tempObj.OnScreenElements.behaviours)
			//fix 'this.' issue
			if(tempObj.peg=='' || tempObj.peg==null){
				tempObj.peg="noPeg"+anonymousPegs++;
				tempObj.OnScreenElements.peg=tempObj.peg;
			}
			
			if(tempObj.OnScreenElements.hasOwnProperty('behaviours')){
				//trace(11111,tempObj.OnScreenElements.behaviours)
				tempObj.OnScreenElements.behaviours=tempObj.OnScreenElements.behaviours.split("this").join(tempObj.peg);
			}
			
			if(tempObj.OnScreenElements.hasOwnProperty('if')){
				tempObj.OnScreenElements['if']=tempObj.OnScreenElements['if'].split("this").join(tempObj.peg);
			}
			
			objectAdded(tempObj);
		}
		
		
		
		

	}
}