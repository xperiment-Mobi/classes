package com.xperiment.container{

	public class containerHorizontal extends containerVertical {

		override public function passChildObject(myObj:*):void {
			if (getVar("resetOtherAxisPositions")) {
				myObj.y=containerDetails.y+myObj.y-myObj.myY;
			}
			
			if(getVar("split")==""){
				myObj.x=(myObj.x-myObj.myX)+containerDetails.nextObjX;
				containerDetails.nextObjX+=myObj.myWidth;
			}
			else{
				myObj.x=split[containedChildren.length % split.length];
			}
			containedChildren.push(myObj);
		}

		override public function sortOutSplits():void {
			split=getVar("split").split(",");
			for (var i:uint=0; i<split.length; i++) {
				if (split[i].substr("%")!=-1) {
					split[i]=int(split[i].replace("%",""))*containerDetails.myWidth/100;
				}
			}
		}
		
		
		
	}
}