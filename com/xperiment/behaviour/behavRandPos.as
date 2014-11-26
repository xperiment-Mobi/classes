package com.xperiment.behaviour
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;

	public class behavRandPos extends behav_baseClass
	{
		protected var box:uberSprite;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","box","");
			super.setVariables(list);
			
		}
		
		override public function givenObjects(obj:uberSprite):void{
			if(obj.peg == getVar("box")){
				box = obj;
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
			
			var placed:Vector.<uberSprite> = new Vector.<uberSprite>;
			
			for each(var stim:uberSprite in behavObjects){
				
				for(var i:int=0;i<100;i++){
					if(randPos(stim, placed)) break;
				}
				placed.push(stim);
			}
			
			placed=null;
			
			return true;
		}		
		
		private function randPos(stim:uberSprite,placed:Vector.<uberSprite>):Boolean{

			stim.x = box.x + (box.width - stim.width) * Math.random();
			stim.y = box.y + (box.height - stim.height) * Math.random();
			
			for each(var placedStim:uberSprite in placed){
				if(placedStim.hitTestObject(stim)){
					return false;
				}
			}
			
			return true;
		}
		
		override public function kill():void{
			box=null;
			super.kill();
		}
		
		
	}
}