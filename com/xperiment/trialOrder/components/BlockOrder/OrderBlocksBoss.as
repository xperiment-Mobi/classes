package com.xperiment.trialOrder.components.BlockOrder
{
	public class OrderBlocksBoss
	{
		

		public var trialBlocks:Array = [];
		

		public function kill():void{
			for(var i:int=0;i<trialBlocks.length;i++){
				trialBlocks[i].kill();
			}
		}
		
	
		public function giveBlock(trialBlock:TrialBlock):void
		{	
			trialBlocks.push(trialBlock);	
		}
		
		
		public function compose():Array
		{
			
			__combineIdentical();
			__removeEmpty();
			__doSort(trialBlocks);
			BlockDepthOrdering.DO(trialBlocks);
			__removeEmpty();
			
			
			return composition();
		}
		
	
		
		public function __doSort(trialBlocks:Array):void
		{
			trialBlocks.sort(__sortF);
			for(var i:int=0;i<trialBlocks.length;i++){
				if(trialBlocks[i].alive)	trialBlocks[i].doOrdering();
			}
		}
		
		public function __sortF(t2:TrialBlock, t1:TrialBlock):int{
			var i:int;
			var v1:int
			var v2:int;
			
			for(i=0; i<t1.blocksVect.length;i++){
				v1=t1.blocksVect[i];
				if(t2.blocksVect.length-1>=i)v2=t2.blocksVect[i];
				else v2=0;
				
				if(v1<v2) return 1;
				else if(v1>v2) return -1;
				else if(t1.blocksVect.length == t2.blocksVect.length && t2.blocksVect.length -1 == i){
					
					if(v1==v2) return 0;
					else return -1;
				}
				else if(t1.blocksVect.length < t2.blocksVect.length){
				}
			}
			return 1;
		}
		
		private function __removeEmpty():void
		{
			for(var i:int=trialBlocks.length-1;i>=0;i--){
				if(trialBlocks[i].alive==false)trialBlocks.splice(i,1);
			}
		}
		
		private function composition():Array
		{
			var trials:Array = [];
			var trialBlock:TrialBlock;
			for(var i:int=0;i<trialBlocks.length;i++){
				trials=trials.concat((trialBlocks[i] as TrialBlock).getTrials());
			}

			return trials;
		}
		
		
		public function __combineIdentical():void
		{
			var innerT:TrialBlock;
			var outerT:TrialBlock;
			
			var outer_i:int;
			var inner_i:int
	
			for(outer_i=0;outer_i<trialBlocks.length;outer_i++){
				outerT=trialBlocks[outer_i];

				for(inner_i=outer_i+1;inner_i<trialBlocks.length;inner_i++){
					
					innerT=trialBlocks[inner_i];
					if(innerT.alive == true){
		
						if(outerT.blocksIdent==innerT.blocksIdent && !innerT.forceBlockDepthPositions){
						
							if(!innerT.forceBlockPositions){
								outerT.addTrials(innerT.trials);
							}
							else{

								outerT.addForcedBlock(innerT.forceBlockPositions);
							}
							outerT.order=innerT.order;
							outerT.blockDepthOrder=innerT.blockDepthOrder;
							innerT.alive=false;
						}
						
					}
					
				}
			
			}
		}
	}
}