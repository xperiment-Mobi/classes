package com.xperiment.onScreenBoss
{
	import com.xperiment.uberSprite;

	public class OnScreenBoss_chromeBug extends OnScreenBoss
	{
		override protected function add(stim:uberSprite):void{
			this.stage.addChild(stim);
		}
		
		override protected function addAt(stim:uberSprite,depth:int):void{
			this.stage.addChildAt(stim,depth);	
		}
		
		override protected function remove(stim:uberSprite):void{
			if(stim.stage)	this.stage.removeChild(stim);
		}
		
		override protected function __getDepth(stimulus:uberSprite):int{
			
			var minDepthGap:int = MAX_CHILDREN;
			var atVal:int;
			var depthDif:int;
			var otherStimDepth:int;
			var stimDepth:int = stimulus.depth;
			//trace(123,stimDepth)
			loop: for(var i:int=0;i<_sortedDepths.length;i++){
				//trace(2222,_sortedDepths[i].uSprite.peg,_sortedDepths[i].uSprite.depth)
				if(this.stage.contains(_sortedDepths[i])){
					
					otherStimDepth=_sortedDepths[i].depth;
					
					depthDif = stimDepth - otherStimDepth;
					
					if(depthDif>=0){	
						minDepthGap=depthDif;
						atVal=this.stage.getChildIndex(_sortedDepths[i]);
					}
					else{
						break loop;
					}
				}
			}
			
			if(minDepthGap==MAX_CHILDREN){
				return 0;
			}
			else{
				return atVal+1
			}
			
			throw new Error();
			return null;;
		}
		
		override public function stopObj(stim:uberSprite):Boolean {
			var index:int;
			var stopped:Boolean=false;

			if(stim.stage){
				
				__removeFromScreen(stim);
				if(running){
					index=_endTimeSorted.indexOf(stim);		
					if (index!=-1){
						_endTimeSorted.splice(index,1);
					}
					
					index=_startTimeSorted.indexOf(stim);	
					if (index!=-1) _startTimeSorted.splice(index,1);
					
				}
				
				stopped=true;
			}
			
			
			if(stopped)sortSpritesTIME();
			
			return stopped; 
		}
	}
}