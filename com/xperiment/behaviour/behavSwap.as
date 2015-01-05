package com.xperiment.behaviour {
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;


	public class behavSwap extends behav_baseClass{
		private var flipped:Boolean=false;
		private var origPos:Array = [];
		private var newPos:Array = [];
		private var positions:Object = {};
		
		override public function setVariables(list:XMLList):void {
			setVar("string","doOnce",'false');
			setVar("string","how","random, flipped");
			super.setVariables(list);
		}
		
		
		override public function returnsDataQuery():Boolean{
			
			if(getVar("hideResults")!='true'){
				//trace(1111)
				return true;
			}
			return false;
		}
		
		
		override public function storedData():Array {
			for(var key:String in positions){
				objectData.push({event:peg+"_"+key,data:positions[key]});
			}
			return objectData;
		}


		private function flip():void{

			var tempPoint:Object;
			
			for(var i:int=0;i<behavObjects.length;i++){
				tempPoint={x:behavObjects[i].myX+behavObjects[i].myWidth*.5,y:behavObjects[i].myY+behavObjects[i].myHeight*.5,origX:behavObjects[i].myX,origY:behavObjects[i].myY};
				origPos.push(tempPoint);
			}
			
			var keepInMemory:String = '';
			if(getVar("doOnce").toLowerCase()=='true')keepInMemory=peg;

			switch(getVar("how").toLowerCase()){
				case "flipped":
					for(i=origPos.length-1;i>=0;i--){
						newPos.push(origPos[i]);
					}
					break;
				
				case "random":
				default:
					newPos = codeRecycleFunctions.arrayShuffle(origPos,keepInMemory);

					break;
	
			}
			
			
			
			for(i=0;i<behavObjects.length;i++){

				behavObjects[i].x=newPos[i].x-behavObjects[i].myWidth*.5-behavObjects[i].myX+behavObjects[i].x;
				behavObjects[i].y=newPos[i].y-behavObjects[i].myHeight*.5-behavObjects[i].myY+behavObjects[i].y;
				
				behavObjects[i].OnScreenElements['x']=String(newPos[i].origX);
				behavObjects[i].OnScreenElements['y']=String(newPos[i].origY);
				
				behavObjects[i].myX = newPos[i].origX;
				behavObjects[i].myY = newPos[i].origY;

				trace(behavObjects[i].myX , behavObjects[i].myY,7)

				positions[behavObjects[i].peg]="x:"+behavObjects[i].myX+" y:"+behavObjects[i].myY;
			}
			
		}
		
		override public function nextStep(id:String=""):void{
			flip();
		}
		
		override public function stopBehaviour(obj:uberSprite):void{

			for(var i:int=0;i<behavObjects.length;i++){
				behavObjects[i].x=origPos[i].x;
				behavObjects[i].y=origPos[i].y;
				
				behavObjects[i].OnScreenElements['x']=String(origPos[i].x);
				behavObjects[i].OnScreenElements['y']=String(origPos[i].y);
			}
		}
			
	}
}