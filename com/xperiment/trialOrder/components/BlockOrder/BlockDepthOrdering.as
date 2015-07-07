package com.xperiment.trialOrder.components.BlockOrder
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.trialOrder.components.DepthNode.DepthNode;
	import com.xperiment.trialOrder.components.DepthNode.DepthNodeBoss;

	public class BlockDepthOrdering
	{
		private static var __depthOrders:Vector.<String>;
		private static var __depthNodes:DepthNodeBoss;
		
		public static function DO(trialBlocks:Array):void
		{
			
			__depthNodes = new DepthNodeBoss(ExptWideSpecs.IS("blockDepthOrder"));
			
			//__computeOrders(trialBlocks);
			
			//generated outside of orderDepths as orderDepths is iterative, calling tiself
			var deepestDepth:int = getDeepest(trialBlocks)
			
			__orderDepths(trialBlocks,deepestDepth);
			
			__depthNodes.kill();
			__depthNodes=null;
			
		}
		
		private static function getDeepest(trialBlocks:Array):int
		{
			var max:int=0;
			
			for(var i:int=0;i<trialBlocks.length;i++){
				if(trialBlocks[i].blocksVect.length -1 > max) max= trialBlocks[i].blocksVect.length - 1;
			}
			
			return max;
		}		

		
		public static function __orderDepths(trialBlocks:Array,deepestDepth:int):void
		{

		
			var atDepth:Array=[];
			var remainder:Array=[];

			//gather all the trials at each depth
			for(var i:int=0;i<trialBlocks.length;i++){
				if(trialBlocks[i].alive && trialBlocks[i].blocksVect.length-1==deepestDepth){
					atDepth.push(trialBlocks[i]);	
				}
			}

			if(atDepth.length>=0){
				groupThenDoOrder(atDepth,deepestDepth);
				
			}

			deepestDepth--;
			if(deepestDepth>=0){	
				__orderDepths(trialBlocks,deepestDepth);
			}
		}		
		
		private static function groupThenDoOrder(atDepth:Array,deepestDepth:int):void
		{
			var parentsArr:Object = {};
			
			var trialBlock:TrialBlock;
			var parents:String;
			
			var isWildCard:Boolean;
			
			for(var i:int=0;i<atDepth.length;i++){
				trialBlock=atDepth[i];
				parents=trialBlock.giveParents();
			
				isWildCard = __depthNodes.IsWildCard(parents);
				if(isWildCard){
					parents=trialBlock.giveOnlyParents();
					parents+=" *";
					
				}
				
				parentsArr[parents] ||= [];
				parentsArr[parents].push(atDepth[i]);
			}
			
			var depthLookup:String;
			for(var parent:String in parentsArr){

				var sortType:String = __depthNodes.retrieve(parent);
				if(sortType==DepthNode.UNKNOWN)sortType = TrialBlock.DEFAULT_DEPTH_ORDER;
				
				doOrder(parentsArr[parent],sortType);
			}
								
			for(i=0;i<atDepth.length;i++){
				atDepth[i].trimBlocksVect();
			}
		}
		
		
		private static function doOrder(atDepth_trialBlocks:Array, sortType:String):void
		{			

			atDepth_trialBlocks.sortOn('currentDepthID', Array.NUMERIC);
	
			switch(sortType.toUpperCase()){
				case TrialBlock.FIXED:
					break;
				
				case TrialBlock.RANDOM:
					codeRecycleFunctions.arrayShuffle(atDepth_trialBlocks);
					break;
				
				case TrialBlock.REVERSE:
					atDepth_trialBlocks=atDepth_trialBlocks.reverse();
					break;
				case TrialBlock.PSEUDO:
					//atDepth_trialBlocks=Pseudo.DO(atDepth_trialBlocks);
					//codeRecycleFunctions.arrayShuffle(atDepth_trialBlocks);
					throw new Error("not implemented");
					break;
				
				default: 
					
					if(sortType.indexOf(TrialBlock.PREDETERMINED)!=-1){
						var newOrder:Array = sortType.split(TrialBlock.PREDETERMINED)[1].split(",");
						
						if(newOrder.length!=atDepth_trialBlocks.length)throw new Error("Error! You have specified a predetermined trial Ordering that does not have the same number of trials as the trials you wish to order: "+newOrder.join(","));
						for(var i:int = 0;i<atDepth_trialBlocks.length;i++){
							(atDepth_trialBlocks[i] as TrialBlock).preterminedSortOnOrder = int(newOrder[i]);
						}
						atDepth_trialBlocks.sortOn("preterminedSortOnOrder",Array.NUMERIC);
					}
					else throw new Error();
			}
/*				trace("-----");
			for(var i:int=0;i<atDepth_trialBlocks.length;i++){
				trace(atDepth_trialBlocks[i].trials)
				
			}*/
			
			__flatten(atDepth_trialBlocks);
		}		
		

		
		public static function __flatten(atDepth_trialBlocks:Array):void
		{

			for(var i:int=1;i<atDepth_trialBlocks.length;i++){

				atDepth_trialBlocks[0].addTrials(atDepth_trialBlocks[i].getTrials());
				
				if(atDepth_trialBlocks[i].forcePositionInBlockDepth!=''){
					atDepth_trialBlocks[0].pass_forcePositionInBlockDepth(atDepth_trialBlocks[i].forceBlockDepthPositions);
				}
				
				
				atDepth_trialBlocks[i].alive=false;
			}
			

			atDepth_trialBlocks[0].do_forcePositionInBlockDepth();

		}		
		
		public static function __compileDepthOrders():void{
			var rawDepthOrders:Array = ExptWideSpecs.IS("blockDepthOrder").split(",");
			
			var depthSettings:Object;
			for(var i:int=0;i<rawDepthOrders.length;i++){
				__processDepth(rawDepthOrders[i],depthSettings);
			}
		}
		
		public static function __processDepth(depth:String,depthSettings:Object):void{
			
		}
		
		public static function __computeOrders(trialBlocks:Array):void
		{
			
			__depthOrders=new Vector.<String>;
			
			var depth:int;
			
			var bulkDepthsSet:Array;
			
			for(var i:int=0;i<trialBlocks.length;i++){
				bulkDepthsSet=[];
				depth=trialBlocks[i].blocksVect.length-1;

				
				if(__depthOrders.length<depth)			addDepths(__depthOrders,depth - __depthOrders.length)
				__depthOrders[depth]=trialBlocks[i].blockDepthOrder;
			
				
				if(trialBlocks[i].blockDepthOrderings){
					bulkDepthsSet.push(trialBlocks[i].blockDepthOrderings);
				}
			}			
			
			if(bulkDepthsSet.length>0){
				
				if(__depthOrders.length<bulkDepthsSet.length)addDepths(__depthOrders,bulkDepthsSet.length - __depthOrders.length)
				
				for(i=0;i<bulkDepthsSet.length;i++){
					__depthOrders[i]=bulkDepthsSet[i];
				}
			}

		}
		
		
		private static function addDepths(__depthOrders:Vector.<String>, more:int):void
		{
			for(var i:int=0;i<more;i++){
				__depthOrders[__depthOrders.length]='';
			}
		}
	}
}
/*
import com.xperiment.codeRecycleFunctions;
import com.xperiment.trialOrder.components.BlockOrder.TrialBlock;

class Pseudo{
	
	
	public static function DO(atDepth_trialBlocks:Array):Array
	{
		var levels:Array = [];
		var level:PseudoLevel;
		
		
		var longestTrials:int = 0;

		
		for(var i:int = 0;i<atDepth_trialBlocks.length;i++){	
			level = new PseudoLevel(atDepth_trialBlocks[i] as TrialBlock);
			level.compute();
			levels.push(level);
			
			if(level.trials.length > longestTrials){
				longestTrials = level.trials.length;
			}
		}
		
		
		for(i=0;i<longestTrials;i++){
			checkIfSame(i,levels);
		}
		
		trace("---");
		var str:String = '';
		for each(level in levels){
			str += ",,,"+level.getPure().join(",");
		}
		trace(str);
		
		return atDepth_trialBlocks;
	}
	
	private static function checkIfSame(i:int, levels:Array, attempt:int=0):Boolean
	{
		var str:String;
		var matching:Object = {};
		var matched:Boolean = false;

		for each(var level:PseudoLevel in levels){
			str = level.get_i(i).toString();
			if(matching.hasOwnProperty(str)){
				matching[str].push(level);
				matched=true;
			}
			else matching[str] = [level];
		}
		
		if(matched==false) return true;
		
		var val:int;
		for each(level in levels){
			val = level.take_i(i);
			level.randomlyPop(i,val);
		}
		
		
		if(attempt>10){
			i = 0;
			attempt=0;
		}
		attempt++;

		for each(var levelsArr:Array in matching){
			if(levelsArr.length>1){
				return checkIfSame(i,levelsArr,attempt);
			}
		}
			
		return true;
	}
}

class PseudoLevel{
	
	public var trialBlock:TrialBlock
	public var trials:Array;
	private var start:int;
	
	public function PseudoLevel(t:TrialBlock){
		this.trialBlock = t;
		this.trials = trialBlock.getTrials();
		//test();
	}
	
	public function get_i(i:int):int{
		if(trials.length<i) return null;
		return trials[i]-start;
	}
	
	public function take_i(i:int):int{
		if(trials.length<i) return null;
		return trials.splice(i,1);
	}
	
	public function getPure():Array{
		var arr:Array = [];
		for(var i:int=0;i<trials.length;i++){
			arr.push(trials[i]-start);
		}
		
		return arr;
	}
	
	private function test():void
	{
		
		//trials =[1,2,3,4];
		//trace(111, take_i(1),"           ",trials);
		//for(var i:int=0;i<20;i++){
			//trace(	randomlyPop([1,3,4,5],1,2)	);
		//}
	}
	
	public function compute():void
	{
		orderTrials();
		
	}
	
	private function orderTrials():void
	{
		start = Math.min.apply(null, trials);
	}
	
	public function randomlyPop(position:int,val:int):void{
		//position ++;
		var range:int = trials.length-position;
		trials.splice(	position + randVal(range) , 0, val);
	}
	
	private function randVal(range:int):int
	{
		//returns 1 to range
		return Math.random()*range + 1;
	}}*/