package com.xperiment.exptWideAction
{
	import flash.utils.ByteArray;

	public class ExptWideAction
	{
		
		private static var _instance:ExptWideAction;
		private var actions:Object = new Object;
			
		public function ExptWideAction(pvt:PrivateExptWideAction){
			PrivateExptWideAction.alert();
		}
		
		public static function getInstance():ExptWideAction
		{
			if(ExptWideAction._instance ==null){
				ExptWideAction._instance=new ExptWideAction(new PrivateExptWideAction());
			}
			return ExptWideAction._instance;
		}	

		public function pass(kinder:XML):Object
		{////where the exptWideAction value follows this pattern: id;property;action
			var info:Array = kinder.@exptWideAction.toString().split(";");
			if(checkExists(info[0]))return actions[info[0]];
			else if(info.length!=3){}// logger.log("you asked for an exptWideAction to happen on "+kinder.localName()+" but you formatted the action incorrectly: "+info +".  Should be of this format: id;property1,property2;action."
			else return processKinder(info,kinder);
			return {};
		}
		
		private function checkExists(id:String):Boolean{
			if(actions.hasOwnProperty(id)){ //check to see if this action has happened and the results of which have been stored already
				return true;
			}
			return false;
		}
		
		
		private function processKinder(info:Array, kinder:XML):Object
		{
			switch(info[2]){
				case "sharedRandomTrialOrder":
					return randomTrialOrder(info[0],info[1],kinder,true);
					break;
				case "randomTrialOrder":
					return randomTrialOrder(info[0],info[1],kinder,false);
					break;	
			}
			return {};
		}
		
		private function randomTrialOrder(id:String, str:String, kinder:XML,theSameOrder:Boolean):Object
		{
			var params:Array=str.split(",");
			var arrCollect:Object = new Object, tempArr:Array;
			for each(var paramNam:String in params){
				if(kinder.hasOwnProperty("@"+paramNam)){
					tempArr=kinder.@[paramNam].toString().split(";");
					arrCollect[paramNam]=tempArr;
				}
			}
			tempArr=null;
			
			if(subArrsSameLength(arrCollect)){
				arrCollect=randomizeMultipleArrays(arrCollect,true);
				actions[id]=new Object;
				for (paramNam in arrCollect){
				//kinder.@[paramNam]=arrCollect[paramNam].join(";");
				actions[id][paramNam]=arrCollect[paramNam].join(";");
				}
				return actions[id];
			}
			
			else return {};//logger.log("could not randomize these attributes "+str+" as they don't all have the same length");
			
			
	
		}
		
		private function subArrsSameLength(obj:Object):Boolean{
			
			var len:uint=0;
			for each(var arr:Array in obj){
				if(len==0)len=arr.length;
				else{
					if(len!=arr.length){
						return false;
						break;
					}
				}
			}
			
			return true;
		}
		
		
		private function randomizeMultipleArrays(origObj:Object,theSameOrder:Boolean):Object {
		//l=length arr=temp parameter array mixed=randomized array i=index
			
			var tempArr:Array;
			var mixed:Object=new Object;
			var j:uint;
			var len:uint;
			var randList:Array=new Array;
			for (var paramNam:String in origObj) {
				tempArr=new Array;
				len=origObj[paramNam].length;
				for (j = 0; j<len; j++) {
					if(randList.length-1<j)randList.push(int(Math.random()*(len-j)));
					else if(theSameOrder)randList[j]=int(Math.random()*(len-j));
					tempArr.push(origObj[paramNam].splice(randList[j],1));
				}
				mixed[paramNam]=tempArr;	
			}
			return mixed;
		}
		
		private function clone(source:Object):Array
		{
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return myBA.readObject() as Array;
		}

		
		public static function randomizeArray(arr1:Array):Array
		{
			//l=length arr=temp parameter array mixed=randomized array i=index
			var len:int = arr1.length;
			var arr:Array = arr1.slice();
			var mixed:Array = new Array(len);
			var i:int;
			for (i = 0; i<len; i++)
			{
				mixed[i] = arr.splice(int(Math.random() * (len - i)), 1)[0];
			}
			return mixed;
		}
	}
}