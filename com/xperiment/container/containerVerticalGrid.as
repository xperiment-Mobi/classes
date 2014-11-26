package com.xperiment.container{
	import flash.display.*;
	import com.xperiment.codeRecycleFunctions;
	import flash.display.Shape;


	public class containerVerticalGrid extends containerVertical {

		public var gridDimensionsX:Array;
		public var gridDimensionsY:Array;
		public var backgroundOfGrid:Array;
		public var splitV:Array;
		public var splitH:Array;

		override public function setVariables(list:XMLList):void {
			setVar("string","rowColours","0x000FFF+0x111555");
			setVar("string","rowColourTransparencies",".4");
			setVar("string","columnColours","0x000FFF+0x111555");
			setVar("string","columnColourTransparencies",".4");
			setVar("string","splitY","");//MUST BE FROM SMALLEST TO LARGEST
			setVar("string","splitX","");//MUST BE FROM SMALLEST TO LARGEST
			setVar("boolean","fillContainerWidth",false);
			setVar("boolean","fillContainerHeight",false);
			setVar("uint","rows",0);//defunct here, but containerVerticalgrid inherits
			setVar("uint","columns",0);
			setVar("string","alignContentsHorizontally","centre");
			setVar("string","alignContentsVertically","centre");
			super.setVariables(list);
			trace(1223);
		}

		override public function passChildObject(myObj:*):void {
			containedChildren.push(myObj);
			if (containedChildren.length==getVar("numInContainer")) {
				sortOutMultisplits();
				sortOutGridDimensions();
				sortOutPositions();
				sortOutShading();
			}
		}

		public function sortOutPositions():void {
			var currentRow:uint;
			var currentColumn:uint;
			var verticalAlignAdjust:int=0;
			var horizontalAlignAdjust:int=0;
			for (var i:uint; i<containedChildren.length; i++) {

				currentRow=getA(i);
				currentColumn=getB(i);
				switch (containedChildren[i].getVar("containerCell-verticalAlign")) {
					case "left" :
						//nothing to do. verticalAlignAdjust = 0 from previously.
						break;

					case "right" :
						verticalAlignAdjust=gridDimensionsY[currentRow+1]-gridDimensionsY[currentRow]-containedChildren[i].myHeight;
						break;

					default :
						verticalAlignAdjust=(gridDimensionsY[currentRow+1]-gridDimensionsY[currentRow]-containedChildren[i].myHeight)*.5;

				}

				switch (containedChildren[i].getVar("containerCell-horizontalAlign")) {
					case "left" :
						//nothing to do. horizontalAlignAdjust = 0 from previously.
						break;

					case "right" :
						horizontalAlignAdjust=gridDimensionsX[currentRow+1]-gridDimensionsX[currentRow]-containedChildren[i].myWidth;
						break;

					default :
						horizontalAlignAdjust=(gridDimensionsX[currentColumn+1]-gridDimensionsX[currentColumn]-containedChildren[i].myWidth)*.5;
				}

				containedChildren[i].x=containedChildren[i].x-containedChildren[i].myX+gridDimensionsX[currentColumn]+containerDetails.x+horizontalAlignAdjust;
				containedChildren[i].y=containedChildren[i].y-containedChildren[i].myY+gridDimensionsY[currentRow]+containerDetails.y+verticalAlignAdjust;
			}
			
			//if(getVar("alignContentsHorizontally")!="" || getVar("alignContentsVertically")!="")sortOutMaxWidthHeight();
			
		}

/*			public function sortOutMaxWidthHeight(){
			var maxW:int=0;
			var maxH:int=0;
			var minW:int=0;
			var minH:int=0;
		
			for (var i:uint=0;i<containedChildren.length;i++){
				if(containedChildren[i].x+containedChildren[i].width>maxW)maxW=containedChildren[i].x+containedChildren[i].width;
				if(containedChildren[i].y+containedChildren[i].height>maxH)maxW=containedChildren[i].y+containedChildren[i].height;
				if(containedChildren[i].x<minW)minW=containedChildren[i].x;
				if(containedChildren[i].y<minH)minW=containedChildren[i].y;
			}
			//containerDetails.myWidth=maxW-minW;
			//containerDetails.myHeight=maxH-minH;
			maxW-=minW;
			maxH-=minH;
			
			maxW=containerDetails.myWidth-maxW;
			maxH=containerDetails.myHeight-maxH;
			
			trace("fffffSssss:"+maxW+" "+containerDetails.myWidth);
			
			switch(getVar("alignContentsHorizontally")){
				case "centre":
					maxW=maxW/2;
					trace("eeeeeee");
					break;
				case "right":
					break;
				default:
					maxW=0;
			}
			switch(getVar("alignContentsVertically")){
				case "centre":
					maxH=maxH/2;
					break;
				case "bottom":
					break;
				default:
					maxH=0;
			}
			
			trace("ffssss:"+maxW+" "+maxH);
			
			for (i=0;i<containedChildren.length;i++){
				if(getVar("alignContentsHorizontally")!="")containedChildren[i].x+=maxW;
			 	if(getVar("alignContentsVertically")!="")containedChildren[i].y+=maxH;
			}
		}*/


		public function sortOutGridDimensions():void {
			gridDimensionsX=new Array  ;
			gridDimensionsY=new Array  ;

			for (var i:uint=0; i<getVar("rows"); i++) {
				gridDimensionsY.push(0);
			}
			for (i=0; i<getVar("columns"); i++) {
				gridDimensionsX.push(0);
			}

			
			lovelySizing((getVar("splitX")==""),(getVar("splitY")==""));
			splitSizing((getVar("splitX")!=""),(getVar("splitY")!=""));
			sortOutAddToPrev();

			if (splitH) {
				gridDimensionsY.push(containerDetails.myHeight);
			}
			if (splitV) {
				gridDimensionsX.push(containerDetails.myWidth);
			}
		}
		
		public function lovelySizing(x:Boolean, y:Boolean):void {
			var currentValueX:uint;
			var currentValueY:uint;
			var currentRow:uint;
			var currentColumn:uint;

			for (var i:uint=0; i<containedChildren.length; i++) {
				if (x) {
					currentValueX=containedChildren[i].myWidth;
					currentColumn=getB(i);
					if (gridDimensionsX[currentColumn]<currentValueX) {
						gridDimensionsX[currentColumn]=currentValueX;
					}
				}
				if (y) {
					currentValueY=containedChildren[i].myHeight;
					currentRow=getA(i);
					if (gridDimensionsY[currentRow]<currentValueY) {
						gridDimensionsY[currentRow]=currentValueY;
					}
				}
			}		
		}

		public function splitSizing(x:Boolean, y:Boolean):void {
			if (x) {
				for (i=0; i<gridDimensionsX.length; i++) {
					gridDimensionsX[i]=splitV[i%splitV.length];
				}
			}
			if (y) {
				for (var i:uint=0; i<gridDimensionsY.length; i++) {
					gridDimensionsY[i]=splitH[i%splitH.length];
				}
			}
		}


		public function getA(i:uint):uint {
			return i%getVar("rows");
		}

		public function getB(i:uint):uint {
			return ((i-(i%getVar("rows")))/getVar("rows"));
		}

		private function addBar(i:uint,currentColour:Number,currentTrans:Number,x:int,y:int,wid:int,hei:int):Shape {
			var bar:Shape=new Shape  ;
			bar.graphics.beginFill(currentColour,1);
			bar.alpha=currentTrans;
			bar.graphics.drawRect(x,y,wid,hei);
			addChild(bar);
			backgroundOfGrid.push(bar);
			return bar;
		}

		public function sortOutShading():void {
			var bar:Shape;
			var currentColour:Number;
			var currentTrans:Number;
			var colourStr:String;
			var alphaStr:String;
			var i:uint;
			var splitsCorrection:uint=0;
			colourStr=getVar("rowColours");
			backgroundOfGrid=new Array  ;
			if (colourStr.length!=0) {
				alphaStr=getVar("rowColourTransparencies");
				for (i=0; i<gridDimensionsY.length-1; i++) {
					currentColour=Number(colourStr.split("+")[i%colourStr.split("+").length]);
					currentTrans=Number(alphaStr.split("+")[i%alphaStr.split("+").length]);
					addBar(i,currentColour,currentTrans,
					   containerDetails.x,
					   containerDetails.y+gridDimensionsY[i],
					   gridDimensionsX[gridDimensionsX.length-1],
					   gridDimensionsY[i+1]-gridDimensionsY[i]);
				}

			}

			colourStr=getVar("columnColours");
			if (colourStr.length!=0) {
				if (! backgroundOfGrid) {
					backgroundOfGrid=new Array  ;
				}
				alphaStr=getVar("columnColourTransparencies");
				for (i=0; i<gridDimensionsX.length-1; i++) {
					currentColour=Number(colourStr.split("+")[i%colourStr.split("+").length]);
					currentTrans=Number(alphaStr.split("+")[i%alphaStr.split("+").length]);
					addBar(i,currentColour,currentTrans,
					   containerDetails.x+gridDimensionsX[i],
					   containerDetails.y,
					   gridDimensionsX[i+1]-gridDimensionsX[i],
					   gridDimensionsY[gridDimensionsY.length-1]);
				}
			}
		}

		public function splitVCorrection():int{
			return 0;
		}
		
		public function splitHCorrection():int{
			return -1;
		}

		public function sortOutMultisplits():void {

			if ((getVar("splitY")!="")) {
				splitH=sortOutMultisplitsSub(getVar("splitY"),containerDetails.myHeight);
				splitH.unshift(0);
				splitH.push(containerDetails.myHeight);
				setVar("uint","rows",splitH.length+splitHCorrection());

			}
			if ((getVar("splitX")!="")) {
				splitV=sortOutMultisplitsSub(getVar("splitX"),containerDetails.myWidth);
				splitV.unshift(0);
				splitV.push(containerDetails.myWidth);
				setVar("uint","columns",splitV.length+splitVCorrection());
			}

			if (getVar("rows")!=0 && getVar("columns")!=0) {
				//all is good
			}
			else if (getVar("rows")==0 && getVar("columns")!=0) {
				setVar("uint","rows",Math.ceil(containedChildren.length/(getVar("columns")-1)));

			}
			else if (getVar("columns")==0 && getVar("rows")!=0) {
				setVar("uint","columns",Math.ceil(containedChildren.length/(getVar("rows")-1)));
			}
			else {
				setVar("uint","columns",4);
				setVar("uint","rows",4);
				logger.log("PROBLEM!!! --- specify at least ONE of the following or chaos will ensue!: the number of 'rows' or 'columns' OR  'splitX' or splitY'.");
			}
		}

		private function sortOutMultisplitsSub(str:String,num:int):Array {
			var returnArr:Array=str.split(",");
			for (var i:uint=0; i<returnArr.length; i++) {
				if (returnArr[i].substr("%")!=-1) {
					returnArr[i]=int(returnArr[i].replace("%",""))*num/100;
				}
			}
			return returnArr;
		}

		override public function kill():void {
			for (var i:uint=0; i<backgroundOfGrid.length; i++) {
				if (this.contains(backgroundOfGrid[i])) {
					this.removeChild(backgroundOfGrid[i]);
				}
				backgroundOfGrid[i]=null;
			}
			backgroundOfGrid=null;
			gridDimensionsX=null;
			gridDimensionsY=null;
			super.kill();
		}

		public function sortOutAddToPrev():void {
			if ((getVar("splitX")=="")) {
				for (var i:uint=1; i<gridDimensionsX.length; i++) {
					gridDimensionsX[i]=gridDimensionsX[i]+gridDimensionsX[i-1];
				}
				gridDimensionsX.unshift(0);
				gridDimensionsX.push(gridDimensionsX[gridDimensionsX.length-1]);
				
				if(getVar("fillContainerWidth")){
				var ratio:Number = Number(containerDetails.myWidth) / codeRecycleFunctions.biggestInArray(gridDimensionsX);
					if(ratio>1){
						for (i=1;i<gridDimensionsX.length;i++){
							gridDimensionsX[i]=gridDimensionsX[i]*ratio;
						}
					}
				}
			}

			if ((getVar("splitY")=="")) {
				for (i=1; i<gridDimensionsY.length; i++) {
					gridDimensionsY[i]=gridDimensionsY[i]+gridDimensionsY[i-1];
				}
				gridDimensionsY.unshift(0);
				gridDimensionsY.push(gridDimensionsY[gridDimensionsY.length-1]);
			
				if(getVar("fillContainerHeight")){
					ratio = containerDetails.myHeight / codeRecycleFunctions.biggestInArray(gridDimensionsY);
					if(ratio>1){
						for (i=1;i<gridDimensionsY.length;i++){
							gridDimensionsY[i]=gridDimensionsY[i]*ratio;
						}
					}
				}
			}
		}
	}
}