package com.xperiment.trialOrder.components.DepthNode
{
	import com.xperiment.trialOrder.components.BlockOrder.TrialBlock;

	public class DepthNode
	{
		public var value:String;
		public var children:Object = {};
		public static var UNKNOWN:String = 'unknown';
		public static var WILDCARD:String = "*";
		
	
		public function init(depths:Array,value:String):void{

			if(depths.length==0 || value==''){
				throw new Error("devel err");
			}
			
			var depth:String = depths.shift()
			children[depth] ||= new DepthNode();
			if(depths.length==0)(children[depth] as DepthNode).value = clean(value.toUpperCase());
			
			if(depths.length>0)	(children[depth] as DepthNode).init(depths,value);	
		
		}
		

		public function __retrieve(depths:Array):String{

			if(depths.length==0){
				if(value)	return value;
				else return UNKNOWN;
			}

			var depth:String = depths.shift();
			
			if(children.hasOwnProperty(depth))return (children[depth] as DepthNode).__retrieve(depths);

			if(depths.length==0 && children.hasOwnProperty(WILDCARD))return (children[WILDCARD] as DepthNode).value;
			
			if(children.hasOwnProperty(WILDCARD))return (children[WILDCARD] as DepthNode).__retrieve(depths);
			return UNKNOWN;
		}
		
		public function __isWildCard(depths:Array):Boolean
		{
			if(depths.length==0){
				return false;
			}
			
			var depth:String = depths.shift();
			
			if(children.hasOwnProperty(depth))return (children[depth] as DepthNode).__isWildCard(depths);
			
			if(depths.length==0 && children.hasOwnProperty(WILDCARD))return true;
			
			if(children.hasOwnProperty(WILDCARD))return (children[WILDCARD] as DepthNode).__isWildCard(depths);
			return false;
		}
		
		
		public function kill():void{
			for (var key:String in children){
				(children[key] as DepthNode).kill();
				children[key]=null;
			}
			children=null;
		}
		
		private function clean(value:String):String
		{
			if([TrialBlock.FIXED,TrialBlock.RANDOM,TrialBlock.REVERSE, TrialBlock.PSEUDO,TrialBlock.PREDETERMINED].indexOf(value)!=-1) return value;
			else{
				var split:Array=value.split(",");
				for(var i:int=0;i<split.length;i++){
					if(isNaN(Number(split[i])))throw new Error("you have specified an unknown type of trial ordering (you must numerically specify prespecified trial orderings, seperated by commas): "+value);
				}
				return TrialBlock.PREDETERMINED+value;
			}
			throw new Error("you have specified an unknown type of trial ordering: "+value);
			return '';
		}
		
		//testing
		
		public function __combinedKinderCount():int {
			var i:int=0;
			
			for each(var child:DepthNode in children){
				i+=child.__combinedKinderCount();
			}
			

			return i+__kinderCount();
		}
		
		public function __kinderCount():int{
			var i:int=0;
			for(var key:String in children){
				i++;
			}
			return i;
		}
	}
}