package com.xperiment.container{


	public class containerVertical extends container {
		public var split:Array;
		
		override public function setVariables(list:XMLList):void {
			setVar("boolean","resetOtherAxisPositions",false);
			setVar("string","split","");
			super.setVariables(list);
			if(getVar("split")!="")sortOutSplits();
		}
		
		public function sortOutSplits():void{
			split=getVar("split").split(",");
			for(var i:uint=0;i<split.length;i++){
				if(split[i].substr("%")!=-1){
					logger.log(split[i]);
					split[i]=int(split[i].replace("%",""))*containerDetails.myHeight/100;
				}
			}
		}

		override public function passChildObject(myObj:*):void {
			if(getVar("resetOtherAxisPositions"))myObj.x=containerDetails.x+myObj.x-myObj.myX;
			
			if(getVar("split")==""){
				myObj.y=(myObj.y-myObj.myY)+containerDetails.nextObjY;
				containerDetails.nextObjY+=myObj.myHeight;
			}
			else{
				myObj.y=split[containedChildren.length % split.length];
			}
			containedChildren.push(myObj);
			
		}
	}
}