package com.xperiment.Logic.components
{
	import flash.utils.Dictionary;

	public class LogicDictionaries implements ILogicDictionaries
	{
		
		public var updateFunctsDict:Dictionary;
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
					if("true"== val.toLowerCase().split("'").join())	propDict[prop]=true;
					else propDict[prop]=false;
				}
					
				else propDict[prop]=val;
				
				for(var i:uint=0;i<(updateFunctsDict[prop] as Array).length;i++){
					//note have to use logDict.propDict[prop] NOT val as ony the former has been typecasted.
					(updateFunctsDict[prop][i] as Function)(prop,propDict[prop])
				}
			}
		}
		
		public function removeProp(prop:String):void{
			if(propDict[prop]!=undefined)			delete propDict[prop];
			if(updateFunctsDict[prop]!=undefined)	delete updateFunctsDict[prop];
		}
		
		
		public function kill():void{
			
			for (var val:String in updateFunctsDict){
				updateFunctsDict[updateFunctsDict]=null;
			}
			updateFunctsDict=null;
			for (val in propDict){
				propDict=null;
			}
		
			
		}
	}
}