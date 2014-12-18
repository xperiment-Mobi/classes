package com.xperiment.trial
{
	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.stimuli.object_baseClass;

	public class TrialHelper
	{
		private static var UP:String = '^';
		private static var DOWN:String = 'v';
		
		static public function computeLayerOrder(stimuli:Vector.<object_baseClass>):void
		{
		    
			var depthNoSet:Vector.<object_baseClass> = new Vector.<object_baseClass>;
			var depthSet:Vector.<object_baseClass> = new Vector.<object_baseClass>;
			var depthRelSet:Vector.<object_baseClass> = new Vector.<object_baseClass>;
			
			var depth:String;
			for (var i:int =0;i< stimuli.length; i++){
				depth=stimuli[i].getVar("depth").toLowerCase();
				
				if(depth==" ")depth=""
				if(depth!=""){
					if(depth=='top')		stimuli[i].depth=OnScreenBoss.TOP;
					
					else if(depth=='bottom')stimuli[i].depth=OnScreenBoss.BOTTOM;
					
					else if(depth.indexOf(UP)==-1 && depth.indexOf(DOWN)==-1){
						stimuli[i].depth=int(depth);
						depthSet[depthSet.length]=stimuli[i];	
					}
					else{
						stimuli[i].depth=i;
						depthRelSet[depthRelSet.length]=stimuli[i];
					}
						
				}
				else{
					stimuli[i].depth=i;
					depthNoSet[depthNoSet.length]=stimuli[i];
				}
				//trace("____________",stimuli[i],depth,stimuli[i].depth)
			}
			
			if(depthSet.length>0)__computeDepths(depthSet,depthNoSet);
			//if(depthRelSet.length>0)__computeRelDepths(depthRelSet,stimuli);
			
			//for(i=0;i<stimuli.length;i++){
			//	trace(stimuli[i].peg,stimuli[i].depth);
			//}
			
		}
		
	/*	public static function __computeRelDepths(depthRelSet:Vector.<object_baseClass>, stimuli:Vector.<object_baseClass>):void
		{
			var newDepths:Array = [];
			
			var i:int;
			var depth:int;
			var stim:object_baseClass;
			
			for(i=0;i<stimuli.length;i++){
				stim=stimuli[i];
				if(stim.depth>=0 && depthRelSet.indexOf(stim)==-1){
					newDepths.push(stim);
				}
			}
			newDepths = newDepths.sortOn('depth');
			
			for(i=0;i<depthRelSet.length;i++){
				stim=depthRelSet[i];
				stim.depth = stim.depth+__calcChange(stim.getVar('depth'));
			}
			
			slotInDepths(newDepths,depthRelSet);

		}		
		
		public static function __calcChange(str:String):int{
			var total:int=0;

			for(var i:int=0;i<str.length;i++){
				if(str.charAt(i)==UP)total++;
				else if(str.charAt(i)==DOWN)total--;
			}
			
			return total;
		}
		*/
		
		public static function __computeDepths(depthSet:Vector.<object_baseClass>, depthNotSet:Vector.<object_baseClass>):void
		{
			var newDepths:Array = [];
			
			for(var i:int=0;i<depthNotSet.length;i++){
				newDepths.push(depthNotSet[i]);
			}
			
			
			slotInDepths(newDepths,depthSet);
		}	
		
		private static function slotInDepths(newDepths:Array, depthSet:Vector.<object_baseClass>):void
		{
			var depth:int;
			var stim:object_baseClass;
			var i:int;
			
			for(i=0;i<depthSet.length;i++){
				
				stim=depthSet[i];
				depth=stim.depth;
				//trace(stim.peg,depth)
				
				if(depth==0) newDepths.unshift(stim);
				else if(depth>newDepths.length-1){
					addBlanks(newDepths,depth-newDepths.length);
					newDepths.push(stim);
				}
				else if(depth>0){
					newDepths.splice(depth,0,stim);
				}
				else if(depth<0){
					newDepths.unshift(stim);
				}
				
			}
			
			depth=0;
			
			for(i=0;i<newDepths.length;i++){
				if(newDepths[i]){
					newDepths[i].depth=depth;
					depth++;
				}
			}
		}		
		

		
		private static function addBlanks(newDepths:Array, num:int):void
		{
			for(var i:int=0;i<num;i++){
				newDepths[newDepths.length]=null;
			}
		}		

		

		
		/*
		If the order is given as -1, makes the stimulus 1 object closer to front, if +1, makes farther.
		If val is specified as 0, is at front.  If specified as 10000 (etc) is at back
		*/
	/*	public static function __computeOrdering(depth:Array):void
		{
			var stim:Object;
			var forcedDepth:String;
			
			
			for(var i:int=0;i<depth.length;i++){
				stim=depth[i];
				forcedDepth=stim.forcedOrder.toLowerCase();
				if(forcedDepth==' ')forcedDepth=''
				if(forcedDepth!=''){

					
					if(forcedDepth.charAt(0)=='^')		stim.translat=Number(forcedDepth.substr(1));
					else if(forcedDepth.charAt(0)=='v')	stim.translat=Number("-"+forcedDepth.substr(1));
						
					else if(!isNaN(Number(forcedDepth))){
						//stim.translat=Number(forcedDepth)-stim.naturalDepth;
						//trace(111,stim.nam,stim.translat)
						//if(forcedDepth=="0")forcedDepth=stim.naturalDepth;
						//else throw new Error("you have incorrectly specified a stimulus "+stim.stimulus+" depth (you MUST use a ^ or v sign): "+stim.translat);
					}
					else throw new Error('cannot specify the order of a stimulus with this info: '+forcedDepth);
				}
			}
			
			__reComputeOrdering(depth);
		}
		
		
		public static function __reComputeOrdering(depth:Array):void{
			var stim:Object;
			var translat:int;
			uber:for(var i:int=0;i<depth.length;i++){
				if(depth[i].hasOwnProperty('translat')){
					trace(depth[i].translat,223)
					stim = depth[i];
					translat=stim.translat;
					
					delete stim.translat
					depth.splice(i,1);
					depth.splice(i+translat,0,stim);
					break uber;
				}
			}
			if(i<depth.length){
				__reComputeOrdering(depth);
			}
			
		}*/
		
	}
}