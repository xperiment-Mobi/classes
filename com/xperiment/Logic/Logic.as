package com.xperiment.Logic
{
	import com.xperiment.Logic.components.LogicDictionaries;
	import com.xperiment.Logic.components.LogicLevel;


	public class Logic
	{
		
		private var horizontalLogics:Array = [];
		private var logDict:LogicDictionaries;
		private var logicLevels:LogicLevel;
		
		
		public function kill():void{
			for(var i:uint=0;i<horizontalLogics.length;i++){
				if(horizontalLogics[i].hasOwnProperty("kill")) horizontalLogics[i].kill();
				else horizontalLogics[i]=null;
			}
			
			logDict.kill();
			logDict=null;
		}
		
		public function Logic(logic:String,logDict:LogicDictionaries=null)
		{
			//go through whole logics hierachy and get update functions
			logDict==null	?	this.logDict= new LogicDictionaries 	: this.logDict=logDict;
			logicLevels= new LogicLevel(logic,this.logDict);
		}
		
		public function assignProp(prop:String, val:*):void{
			//kept for test purposes
			logDict.assignProp(prop,val);
		}
		
		public function eval():Boolean{
			return logicLevels.eval();
		}
		
		//where set bool to true if you want the original
		public function reconstruct(orig:Boolean=true):String{
			return logicLevels.reconstruct(orig);
		}
		
		
		

	}
}