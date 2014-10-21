package com.xperiment.trialOrder.components.DepthNode
{
	public class DepthNodeBoss extends DepthNode
	{

		public static var SEPERATER:String = " ";
		private var active:Boolean = true;
		
		public function DepthNodeBoss(str:String)
		{
			if(str=="")active=false;
			else{
				var commands:Array = str.split(SEPERATER);
				
				var arr:Array;
				var depths:Array;
				var value:String;
				
				for(var i:int=0;i<commands.length;i++){
					arr=String(commands[i]).split("=");
					if(arr.length!=2)throw new Error("you have specifed a trial depth wrong:"+commands[i]+". Must be of the format 10=random or 10.1=random or *.1=random or 10.*=random.");
					depths = arr[0].split(",");
					value  = arr[1];
					init(depths, value);
					
				}
			}
		}
	
		public function retrieve(str:String):String
		{
			if(active)	return __retrieve(str.split(" "));
			else return DepthNode.UNKNOWN;;
		}
		
		public function IsWildCard(str:String):Boolean
		{
			if(active)	return __isWildCard(str.split(" "));
			else return DepthNode.UNKNOWN;;
		}
		

	}
}