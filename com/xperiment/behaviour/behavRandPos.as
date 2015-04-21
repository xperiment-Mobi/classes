package com.xperiment.behaviour
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;

	public class behavRandPos extends behav_baseClass
	{
		protected var box:uberSprite;
		private var noBoxYetArr:Array;
		private var placed:Vector.<uberSprite> = new Vector.<uberSprite>;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","box","");
			super.setVariables(list);
			
		}
		
		override public function givenObjects(obj:uberSprite):void{
			if(obj.peg == getVar("box")){
				box = obj;
				boxGiven();
				trace(113)
			}
			
			else super.givenObjects(obj);
		}
		
	

		override public function nextStep(id:String=""):void
		{
			for(var i:int=0;i<100;i++){
				if(place()) break;
			}
			
			super.nextStep();
		}
		
		private function place():Boolean
		{
			
			codeRecycleFunctions.arrayShuffle(behavObjects);
			
			
			
			for each(var stim:uberSprite in behavObjects){
				
				for(var i:int=0;i<100;i++){
					if(randPos(stim, placed)) break;
				}
				placed.push(stim);
			}
		
			return true;
		}		
		
		private function randPos(stim:uberSprite,placed:Vector.<uberSprite>):Boolean{
			
			if(!box){
				noBoxYetArr ||=[];
				noBoxYetArr.push(stim)
				return false;
			}
		
			
			stim.x = box.x + (box.width - stim.width) * Math.random();
			stim.y = box.y + (box.height - stim.height) * Math.random();
			
			for each(var placedStim:uberSprite in placed){
				if(placedStim.hitTestObject(stim)){
					return false;
				}
			}
			
			return true;
		}
		
		private function boxGiven():void
		{			
			if(noBoxYetArr){
				trace(11)
				var index:int;
				for(var i:int=0;i<noBoxYetArr.length;i++){
					index = placed.indexOf(noBoxYetArr[i]);
					if(index!=-1){
						placed.splice(index,1);
					}
				}
				
				while(noBoxYetArr.length>0){
					randPos(noBoxYetArr[0],placed);
				}	
			}
			
		}	
		
		override public function kill():void{
			
			placed=null;
			noBoxYetArr=null;
			box=null;
			super.kill();
		}
		
		
	}
}