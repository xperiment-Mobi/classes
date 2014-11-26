package com.xperiment.LogicIf
{
	import com.xperiment.Logic.components.ILogicDictionaries;
	import com.xperiment.Logic.components.LogicDictionaries;
	
	import flash.utils.Dictionary;
	
	public class VariableDictionaries extends LogicDictionaries implements ILogicDictionaries
	{
		
		private var perTrialProps:Vector.<String> = new Vector.<String>;;
		
/*		public function assignPerTrailProp(pegWhatHappened:String):void{
			perTrialProps.push(pegWhatHappened);
			assignProp(pegWhatHappened,0);
		}*/
		
		public function killPerTrialProps():void{
			while(perTrialProps.length>0){
				super.removeProp(perTrialProps.shift());
			}
			perTrialProps = null;
		}
		
		//sets up perTrialProp if necessary else increments it by 1
		public function incrementPerTrialProp(pegWhatHappened:String):void{
			if(propDict[pegWhatHappened] ==undefined){
				perTrialProps.push(pegWhatHappened);
				assignProp(pegWhatHappened,0);
			}
			else assignProp(pegWhatHappened,propDict[pegWhatHappened]+1);
		}

/*		public var updateFunctsDict:Dictionary;
		public var propDict:Dictionary;
		
		
		public function LogicDictionaries(){
			updateFunctsDict=	new Dictionary(true);
			propDict=			new Dictionary(true);
		}
		
		public function updateDicts(rawProp:String,funct:Function):void{
			if(updateFunctsDict[rawProp] == undefined) updateFunctsDict[rawProp]=new Array;
			updateFunctsDict[rawProp].push(funct);
			if(propDict[rawProp] == undefined) propDict[rawProp]=rawProp;
		}
		
		public function assignProp(prop:String, val:*):void{
		if(propDict[prop]!=undefined){
		if(!isNaN(Number(val)))propDict[prop]=Number(val);
		
		//only do the second comparison if there is indeed evidence for true or false
		else if(["true","false"].indexOf(val.toLowerCase().split("'").join())!=-1){
		if("true"==val.toLowerCase().split("'").join())	propDict[prop]=true;
		else propDict[prop]=false;
		}
		
		else propDict[prop]=val;
		
		for(var i:uint=0;i<(updateFunctsDict[prop] as Array).length;i++){
		//note have to use logDict.propDict[prop] NOT val as ony the former has been typecasted.
		(updateFunctsDict[prop][i] as Function)(prop,propDict[prop])
		}
		}
		}
		
		
		public function kill():void{
			
			for (var val:String in updateFunctsDict){
				updateFunctsDict[updateFunctsDict]=null;
			}
			updateFunctsDict=null;
			for (val in propDict){
				propDict=null;
			}
			
			
		}*/
	}
}