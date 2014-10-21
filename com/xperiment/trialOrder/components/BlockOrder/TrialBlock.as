package com.xperiment.trialOrder.components.BlockOrder
{
	import com.xperiment.codeRecycleFunctions;

	public class TrialBlock
	{
		public var numTrials:int;
		public var trials:Array = [];

		public var blocksIdent:String = new String;
		public var blocksVect:Vector.<int> = new Vector.<int>;
		public var order:String;
		public var blockDepthOrder:String;
		public var blockDepthOrderings:Array;
		public var alive:Boolean = true;
		
		public var forcePositionInBlock:String = '';
		public var forcePositionInBlockDepth:String = '';
		
		//used for trial creation
		public var blockPosition:int;
		public var names:Array = [];
		
		public var preterminedSortOnOrder:int; //used for SortOn, in another class
		

		static public var RANDOM:String='RANDOM';
		static public var FIXED:String = 'FIXED';
		static public var REVERSE:String='REVERSE';
		static public var PREDETERMINED:String='PREDETERMINED';
		public static var DEFAULT_DEPTH_ORDER:String = FIXED;
		
		public var forceBlockPositions:Array;
		public var forceBlockDepthPositions:Array;
		
		
		public var currentDepthID:int;
		
		public function kill():void{
			trials=null;
			blocksIdent=null;
			this.alive=false;
		}
		
		public function giveParents():String{
			currentDepthID=int(blocksVect[blocksVect.length-1]);
			return blocksVect.join(" ");
		}
		
		public function giveOnlyParents():String{
			
			var onlyParents:Array = [];
			
			for(var i:int=0;i<blocksVect.length-1;i++){
			onlyParents.push(String(blocksVect[i]));
			}
			return onlyParents.join(" ");
		}
		
		public function trimBlocksVect():void{
			blocksVect.pop();
			blocksIdent=blocksVect.join(",");
		}
		
		
		public function getTrials():Array{
			return trials;	
		}
		

		public function do_forcePositionInBlockDepth():void{
			if(forceBlockDepthPositions){
				SlotInForcePositions.DO(trials,forceBlockDepthPositions);
				forceBlockDepthPositions=null;
			}
		}
		
		
		public function doOrdering():void{
			
			if(order=='' || order=='RANDOM')trials = codeRecycleFunctions.arrayShuffle(trials);
			else if(order=="FIXED"){
				//do nothing}
			}
			else if(order=="REVERSED" || order=="REVERSE") trials = trials.reverse();
			else throw new Error("You have specifed trial order wrongly: "+order+" (should be either fixed, random, reversed or left blank).");

			
			if(forceBlockPositions){
				SlotInForcePositions.DO(trials,forceBlockPositions);
			}
		}
		
		public function setup(trial:XML,counter:int,blockPosition:int,composeTrial:Function):void{
			this.blockPosition = blockPosition;

			//have to get myTrials as SetForced manipulates the trialsArray
			var myTrials:Array = setTrials(trial.@trials.toString(),counter);
			if(trials.length>0){
				setBlock(trial.@block.toString());
				__setNames(trial.@trialName.toString());
				setForced(trial.@forcePositionInBlock.toString(),trial.@forceBlockDepthPositions.toString());
				order = correctOrder(trial.@order.toString(),'order');
				
				sortDepthOrder(trial.@blockOrder.toString());

				var runTrial:Boolean = true;
				if(trial.@runTrial.toString()=="false")runTrial=false;
				
				var info:Object = {};
				info.TRIAL_ID = blockPosition;
				info.runTrial= runTrial;
				info.bind_id=trial.@__BIND.toXMLString();

				
				for(var t:int=0;t<myTrials.length;t++){
					info.trialBlockPositionStart = t;
					info.order = myTrials[t];
					info.trialNames= names[t];
					composeTrial(info);
				}
			}
		}
		
		private function setForced(forcedBlock:String,forcedDepth:String):void
		{
			
			if(forcedBlock!="" && forcedDepth!="")throw new Error('you cannot set both forcePositionInBlock and forceBlockDepthPositions in the same trial!')
			if(forcedBlock.concat(forcedDepth).indexOf(";")!=-1)throw new Error("you currently cannot use the ';' symbol in forcePositionInBlock and forceBlockDepthPositions");
			
				
			if(forcedBlock!=''){
				addForced(trials, forcedBlock,'block');
				trials=[];
				return;
			}
			forcePositionInBlockDepth=forcedDepth;
			if(forcedDepth!=''){
				addForced(trials, forcedDepth,'depth');
				trials=[];
			}
		}
		
		public function sortDepthOrder(ord:String):void{

			blockDepthOrder = ord;
			if(blockDepthOrder.indexOf(",")!=-1){
				
				blockDepthOrderings = blockDepthOrder.split(",");
			
				for(var i:int=0;i<blockDepthOrderings.length;i++){
					blockDepthOrderings[i]=correctOrder(blockDepthOrderings[i],'blockDepthOrder');
				}

				blockDepthOrder = DEFAULT_DEPTH_ORDER;
				
			}
			
			else blockDepthOrder = correctOrder(blockDepthOrder,'blockDepthOrder'); 

		
		}
		
		
		
		private function correctOrder(ord:String,what:String):String{
			var ordUpdated:String;
			ordUpdated=ord.toUpperCase();
			
			if(ordUpdated=='REVERSED')ordUpdated=REVERSE;
			else if(ordUpdated==''){
				if(what=='order')ordUpdated=RANDOM;
				else if(what=='blockDepthOrder')ordUpdated=DEFAULT_DEPTH_ORDER;
				else throw new Error();
			}
			else if([REVERSE, RANDOM, FIXED].indexOf(ordUpdated)==-1)throw new Error('you have specifed the '+what+' of a block in an unknown way:'+ord);

			return ordUpdated;
		}
		
		
		//unitTestMeSVP
		/*trace(test(3,"a;b;c","a;b;c")==true);
		trace(test(4,"a;b;c","a1;b1;c1;a2")==true);
		trace(test(9,"a;b;c","a1;b1;c1;a2;b2;c2;a3;b3;c3")==true);
		trace(names)
		
		function test(trialNum:int,namesStr:String, ansStr:String):Boolean{
			trials = [];
			for(var i:int=0;i<trialNum;i++){
				trials.push(true);
			}
			
			__setNames(namesStr);
			
			var ans:Array=ansStr.split(";");
			for(var i:int=0;i<ans.length;i++){
				if(ans[i]!=names[i])return false;
			}
			return true;
		}*/
		
		
		public function __setNames(namesStr:String):void
		{
			names=[];
			var origNames:Array=namesStr.split(";");
			var iteration:int=0;
			
			for(var i:int=names.length-1;i<trials.length;i++){
				
				names[i]=origNames[i%origNames.length];
				//trace(12121,names)
				if(origNames.length<trials.length){
					iteration = (i / origNames.length);
					names[i]+=iteration+1;
				}	
			}
		}
		
		

		
		public function setTrials(t:String,counter:int):Array
		{
			if(t=='')numTrials=1;
			else if(!isNaN(Number(t)))numTrials=int(t);
			else throw new Error("you have set number of trials to a non numeric value of "+t);
			
			for(var i:int=0;i<numTrials;i++){
				trials[trials.length]=counter+i;
			}
			
			return trials.slice();
		}
		
		public function addTrials(arr:Array):void{
			for(var i:int=0;i<arr.length;i++){
				trials.push(arr[i]);
			}
		}
		
		public function setBlock(str:String):void{

			if(str == '')throw new Error('you MUST set the block of each of your trials');
			blocksIdent=str;
			var arr:Array=str.split(",");
			for(var i:int=0;i<arr.length;i++){
				blocksVect.push(arr[i]);
			}
		}
		
	
		public function addForced(trials:Array, forcePosition:String,type:String):void
		{
			//trace(trials,forcePosition,type,22)
			if(trials.length>0){
				if(type=='block'){
					forceBlockPositions ||=[];
					forceBlockPositions.push({trials:trials,forcePosition:forcePosition});
				}
				else if(type=='depth'){ 
					forceBlockDepthPositions ||=[];
					forceBlockDepthPositions.push({trials:trials,forcePosition:forcePosition});
				}
				else throw new Error();
			}
		}
		
		public function pass_forcePositionInBlockDepth(arr:Array):void{
			forceBlockDepthPositions ||= [];
			forceBlockDepthPositions = forceBlockDepthPositions.concat(arr);
		}
		
		public function getMaxTrial():int
		{
			if(!forceBlockPositions && !forceBlockDepthPositions)	return trials[trials.length-1];

			var myTrials:Array;
			
			if(forceBlockDepthPositions)	myTrials = forceBlockDepthPositions[0].trials
			else							myTrials = forceBlockPositions[0].trials
		
			return myTrials[myTrials.length-1];
		}
		
		public function addForcedBlock(further_forceBlockPositions:Array):void
		{
			forceBlockPositions ||=[];
			for(var i:int=0;i<further_forceBlockPositions.length;i++){
				forceBlockPositions.push(further_forceBlockPositions[i]);
			}
			
		}
	}
}