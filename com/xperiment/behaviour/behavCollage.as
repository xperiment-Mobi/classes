package com.xperiment.behaviour
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.trial.Trial;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class behavCollage extends behav_baseClass
	{
		private var area:Rectangle;
		private var areaPeg:String;
		private var heightDivisions:Number;
		private var widthDivisions:Number;
		private var jitter:Boolean;
		
		
		override public function setVariables(list:XMLList):void {
			setVar("string","area",'',"specify the stimulus's peg which will be used as the area in which to drop other stimuli. Leave blank to use the whole screen");
			setVar("number", "widthDivisions", 5);
			setVar("number","heightDivisions",4);
			setVar("boolean","auto",false,"figures out widthDivisions and heightDivisions based on the number of stimuli automatically (can lead to overlap if too many stimuli).");
			setVar("boolean","showBoxes",false);
			setVar("boolean","jitter",false);
			super.setVariables(list);

			jitter = getVar("jitter");
			areaPeg= getVar("area");
			widthDivisions=getVar("widthDivisions");
			heightDivisions=getVar("heightDivisions");
		}
		
		
		
		
		override public function nextStep(id:String=""):void
		{
			var stim:uberSprite;
			var count:int = givenObjects.length;
			

			if(areaPeg!=""){
				for(var i:int=0;i<behavObjects.length;i++){
					stim = behavObjects[i];
					if(stim.peg==areaPeg){
						area = new Rectangle(stim.x,stim.y,stim.myWidth,stim.myHeight);
						behavObjects.splice(i,1);
						break;
					}
				}
			}
			
			if(!area)	area = new Rectangle(0,0,Trial.ACTUAL_STAGE_WIDTH,Trial.ACTUAL_STAGE_HEIGHT);
			
			if(getVar("auto")==true){
				var obj:Object = getSmallestDimensions(behavObjects.length);
				widthDivisions = obj.n1
				heightDivisions = obj.n2
			}
			
			var boxWidth:Number = boxWidth = area.width/widthDivisions;
			var boxHeight:Number = boxHeight = area.height/heightDivisions;
			
			

			
			var box:Rectangle;
			var boxes:Array = new Array;
			var showBoxes:Boolean = getVar("showBoxes");


			
			
			for(i=0;i<widthDivisions;i++){
				for(var j:int=0;j<heightDivisions;j++){
					box = new Rectangle(area.x+i*boxWidth,area.y+j*boxHeight,boxWidth,boxHeight);
					boxes[boxes.length] = box;
				
					if(showBoxes){
						var b:Sprite = new Sprite;
						b.graphics.beginFill(0xffffff*Math.random(),.5);
						b.graphics.drawRect(box.x,box.y,box.width,box.height);
						theStage.addChild(b);
					}
				}
			}

			if(boxes.length<behavObjects.length)throw new Error("Problem with 'behavCollage' in that the number of 'boxes' to put images into is fewer than the number of images. Please increase widthDivisions and/or heightDivisions values.");
			
			boxes = codeRecycleFunctions.arrayShuffle(boxes);
			

			for each(stim in behavObjects){
				box=boxes.shift();
				
				if(jitter){					
					stim.x=box.x+(box.width-stim.myWidth)*Math.random();;
					stim.y=box.y+(box.height-stim.myHeight)*Math.random();;		
				}
				else{
					stim.x=box.x+box.width*.5-stim.myWidth*.5;
					stim.y=box.y+box.height*.5-stim.myHeight*.5;
				}
			}
			
			super.nextStep();
		}
		
		private function getSmallestDimensions(n:Number):Object{
			var bestNum1:Number;
			var bestNum2:Number;
			var dist:Number = int.MAX_VALUE;
			var tempDist:Number;
			
			var numDist:Number = int.MAX_VALUE;
			
			for(var num1:int=2;num1<n*.5+1;num1++){
				for(var num2:int=2;num2<n*.5+1;num2++){
					if(num1*num2>=n){
						tempDist = n - num1*num2;
						if(tempDist<=dist){
							if(Math.abs(num1-num2)<numDist){
								numDist=Math.abs(num1-num2);
								dist=tempDist;
								bestNum1=num1;
								bestNum2=num2;
							}
						}
					}
				}
			}

			if(!bestNum1){
				bestNum2=bestNum1=int(n*.5);
				if(Math.random()>.5)bestNum2++;
				else bestNum1++;
			}
			
			if(Math.random()>.5) return {n1:bestNum2, n2:bestNum1}
			return {n1:bestNum1, n2:bestNum2}
		}
	}
}