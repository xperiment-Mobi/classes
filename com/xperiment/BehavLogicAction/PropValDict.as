package com.xperiment.BehavLogicAction
{
	import flash.utils.Dictionary;
	
	public final class PropValDict
	{
		
		public static var exptProps:Dictionary = new Dictionary(false);
		
		public var updateFunctsDict:Dictionary;
		public var propDict:Dictionary;
		
		private var trial_behavObjectsDict:Dictionary;

		
		static public function addExptProps(prop:String, val:String):void{
			exptProps[prop]=val;
		}
		

		public function PropValDict():void{
			updateFunctsDict = new Dictionary(true);
			propDict = new Dictionary(true);
		
			for(var prop:String in exptProps){
				propDict[prop]=exptProps[prop];
			}
			
		}
		
		public function propVal(prop:String):*{
			//trace(prop,22,propDict[prop],propDict.hasOwnProperty(prop)==false);
			//if(propDict.hasOwnProperty(prop)==false)throw new Error('the property dictionary does not have this property!: '+prop);
			//trace(123,propDict,propDict[prop],prop);
			if(propDict[prop] is Function) return propDict[prop]();
			return propDict[prop];
		}

		
		////////////////////////////////////////
		////////////////////////////////////////
		//Per Trial Functions
		
		
		private function updateExptProps():void
		{	
			for(var prop:String in exptProps){
				if(propDict.hasOwnProperty(prop)){
					exptProps[prop]=propDict[prop];
				}	
			}
		}	
		

		public function kill():void{
			killPerTrial();
			killExptProps();
		}
		
		
		////////////property functions
		public function killPerTrial():void{

			updateExptProps();
			trial_behavObjectsDict=null;
			
			
			for(var prop:String in propDict){
				removeProp(prop);	
			}
			propDict=null;
						
			if(updateFunctsDict){
				for(var i:int;i<updateFunctsDict.length;i++){
					updateFunctsDict[i]=null;
				}
				updateFunctsDict=null;
			}
		}
			
		
		public function printPropDict():void{
			trace("----debug command");
			for(var s:String in propDict){
				trace("-",s,propDict[s],propDict[s]);
			}
		}
		
		public function killExptProps():void{
			while(exptProps.length>0){
				removeProp(exptProps.shift());
			}
			exptProps = new Dictionary;	
		}
		
		public function addTrialProps(prop:String):void{
			//trace(4444444444,2222222,3333333,prop)
			
			if(propDict.hasOwnProperty(prop) == false) propDict[prop]=prop; // else, add to Experiment wide variables.
		}
		
		
/*		
		private function exptPropsVals():Array{
			var arr:Array = [];
			
			for(var name:String in exptProps){
				arr.push(new ExptPropsVals(name,exptProps[name]));
			}
			return arr;
		}*/
		
		//sets up perTrialProp if necessary else increments it by 1
		public function incrementPerTrial(action:String,contents:Array=null):void{
			if(propDict){
				if(propDict[action] !=undefined){
	
					if(propDict[action]==action){ //that is, if the setting has not been made before, it equals itself 
						updateVal(action,"1",contents);
					}
					else{
						updateVal(action,int(propDict[action])+1,contents);
					}
					
				}
				else throw Error("An action occured that was not specified in your script: "+action);
			}
			//trace(action,":"+propDict[action]);
		}
		
		public function updateDictsTrialVars(rawProp:String,funct:Function):void{
			bind(rawProp,funct);
		}
		
		
		////////////command functions
		public function addCommand(command:String):void{
			bind(command,null);
		}
		
		
		//
		////////////////////////////////////////
		////////////////////////////////////////
		
		public function removeProp(prop:String):void{
			//deleted wrapper 4.1.2013 as uncalled actions threw an error 	if(propDict.hasOwnProperty(prop)){
			//or called actions threw an error								if(propDict[prop]==null || propDict[prop] as String){
			delete propDict[prop];
			if(updateFunctsDict && updateFunctsDict[prop]){
				for(var i:int=0;i<(updateFunctsDict[prop] as Array).length;i++){
					updateFunctsDict[prop][i]=null;
				}
				delete updateFunctsDict[prop];

			}
		}
		
		public function removeAction(action:String):void{
			throw new Error("unknown error");
		}
		
		
		public function setDicts(where:*,what:*):void{
			if(updateFunctsDict[what] == undefined){
				updateFunctsDict[what] = new Array;
				propDict[what]=what;
			}
			updateFunctsDict[what].push(where);
		}
		
		
		//thos function is passed around other classes and used to collect functions
		public function bind(rawProp:String,funct:Function):void{

			//trace('eeeeeeeeeeeeeeeeee',rawProp,funct);
				
			
			//if new, create approprite slot in updateFunctsDict
			if(updateFunctsDict[rawProp] == undefined) updateFunctsDict[rawProp]=[];
			
			//trace(111111,rawProp,funct);
			if(funct!=null){	
				updateFunctsDict[rawProp].push(funct);
			
				
			}
			else{
				//throw new Error('devel error'); //used in unit testing
			}
		
			addTrialProps(rawProp);
		}
		
		//only used in unit testing it seems
		public function __bindAction(action:String, funct:Function):void
		{
			if(updateFunctsDict[action] != undefined)bind(action, funct);
			else throw new Error ("A response action has been provided for an action that has been specified no where (must be a bug)")
		}
		
		
		private function updatePropEveryWhere(prop:String,contents:Array=null):void
		{
			//if(prop=="results.angle")trace('update everywhereeee', prop, contents,prop.indexOf('.text'),updateFunctsDict[prop].length,propDict[prop] is Function,222);

			
			if(prop && updateFunctsDict && updateFunctsDict[prop]!=undefined && updateFunctsDict[prop]!= null && (updateFunctsDict[prop] is Array) ){
				//trace(111,updateFunctsDict[prop] as Array,prop,updateFunctsDict);
				
				/////////////////////////////////////////
				//determine the value of the property first
				var val:String;	
				if(propDict[prop] is Function) val =propDict[prop]();
				else{
					val= propDict[prop];
				}
	
				//trace(1111111111,prop,val,propDict[prop] is Function);//should be a function
				
				//below looks to see if a text value is being updated.  If so, removes the quotation marks
				//if(prop.indexOf('.text')!=-1){
				//	val = val.substr(1,val.length-2);
				//}
				//trace("in hereeeeeeeeeeeeee",prop,val,(updateFunctsDict[prop] as Array).length);
				/////////////////////////////////////////
				/////////////////////////////////////////
				
				var f:Function;
			//trace(123,(updateFunctsDict[prop] as Array).length)
				for(var i:int=0;i<(updateFunctsDict[prop] as Array).length;i++){
	
					//note have to use logDict.propDict[prop] NOT val as ony the former has been typecasted.
					
					f=updateFunctsDict[prop][i] as Function;

					if(f){
						if(f.length==0)f();
						else if(f.length==1){
							passContents(f,contents);
						}
						else if(f.length==2){
							//trace(111111,prop,val);
							f(prop,val);
						}
						else{
							f(prop,val,contents);
						}
					}
					else{
						trace("f destroyed");
					}
					
/*					if(		//if returns false, remove from array.
						//Note, CANNOT assign to Bool first as Bool=undefined is false (killing this logic);
						f(prop,val) //run the update function		
						== false)	updateFunctsDict[prop].splice(i,1);*/
				
					if(updateFunctsDict==null)break; //critical piece of code!  many days debugging to find this solution.
				}
			}
			else throw Error("Error trying to update a property ("+prop+"): it was not set before.");
		}
		
		private function passContents(f:Function, contents:Array):void
		{
			var objContents:Array = [];
			if(contents!=null){
				for each(var peg:String in contents){
					if(!trial_behavObjectsDict)trial_behavObjectsDict = new Dictionary;
					if(trial_behavObjectsDict[peg]!=undefined){
						for(var i:int=0;i<trial_behavObjectsDict[peg].length;i++){
							objContents.push(trial_behavObjectsDict[peg][i]);
						}
					}
				}
			}
			if(f)	f(objContents);
		}		
		
		
		public function updateVal(prop:String, val:*, contents:Array=null):void
		{
			
			//trace('updateeeee',prop,val,contents);
			if(propDict[prop]!=undefined && val!=null){
				//trace(prop,val,222,prop,val,val is Function)
				

				
				if(val is Function){
					//trace(11111121)
					propDict[prop]=val;
				}
				else {
					var value:* =val;
				
					if(!isNaN(Number(value))){
						//trace("in here")
						propDict[prop]=Number(value);
						
					}
						//only do the second comparison if there is indeed evidence for true or false
					else if(["true","false"].indexOf(value.toLowerCase().split("'").join())!=-1){
						if("true"==value.toLowerCase().split("'").join())	propDict[prop]=true;
						else propDict[prop]=false;
					}
					else {
						//trace("99999",prop,val)
						propDict[prop]=value;
					}
				}
				
				updatePropEveryWhere(prop,contents);
			}
			else{
				if(val==null){
					//used in unit testing
					//trace('tried updating with a Null value!',prop);
				}
			}
		}
		
		

		public function giveTrialObjs(behavObjectsDict:Dictionary):void
		{			
			this.trial_behavObjectsDict=behavObjectsDict;
		}
		

	}
}