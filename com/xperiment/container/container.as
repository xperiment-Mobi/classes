package com.xperiment.container{
	import com.graphics.pattern.Pattern;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.object_baseClass;

	
	import flash.display.Shape;

	import flash.utils.getQualifiedClassName;
	
	public class container extends object_baseClass {
		//identical to parent but:
			//no click behaviours
			//does not return results.
			//timeStart=0;
			//timeEnd=999999999;
			
			public var containerDetails:Object;
			public var containedChildren:Array = new Array;
			public var containedChildrenOrder:Array = new Array;

			
		override public function setVariables(list:XMLList):void {
			//identical to parent but removed click behaviours
			pic=this;
			setVar("boolean","continuouslyShown",true);
			setVar("string","behaviours","");
			setVar("number","timeStart",0);
			setVar("number","timeEnd",0);
			setVar("string","width","0");
			setVar("string","height","0");
			setVar("string","id","");
			setVar("uint","numberOfTrialsInThisBlock",0);
			setVar("string","behaviours","");
			setVar("string","behaviourID","");
			setVar("boolean","showBox",false);
			setVar("string","horizontal","middle");
			setVar("string","vertical","middle");
			setVar("String","x","0");
			setVar("String","y","0");
			setVar("String","percentageScreenSizeFrom","both");
			setVar("uint","numInContainer",0);
			XMLListObjectPropertyAssigner(list);
						
			percentageScreenSizeFrom=getVar("percentageScreenSizeFrom");		
			
			sortOutContainerWidthHeight();
			setContainerPosPercent();
			setContainerInfo();
			sortOutShowBox();
			sortOutPadding()
			
			//setContainerSize();
		}
		
		

		
		
		
		public function passChildObject(myObj:*):void{
			containedChildren.push(myObj);
		}

		public function returnContainerInfo():Object{
			return containerDetails;
		}
			
		public function setContainerInfo():void{
			containerDetails=new Object;
			containerDetails.x=getVar("x");
			containerDetails.y=getVar("y");
			containerDetails.myWidth=getVar("width");
			containerDetails.myHeight=getVar("height");
			containerDetails.nextObjX=containerDetails.x;
			containerDetails.nextObjY=containerDetails.y;
			
		}
		
		
		override public function showBox():void{
			drawMovePoint(containerDetails.x-1,containerDetails.y+1,0x46d1ff);
			
			var myObj:Object = new Object();
			myObj.width=containerDetails.myWidth+1;myObj.height=containerDetails.myHeight-1;
			myObj.size=10;myObj.alpha=.1;
			var hashPattern:Shape = Pattern.myPattern(myObj);
			theStage.addChildAt(hashPattern,theStage.numChildren-1);
			hashPattern.x=containerDetails.x;hashPattern.y=containerDetails.y;
			outLineBoxes.push(hashPattern);
			myObj=null;			
		}
		
		

		
		public function setContainerPosPercent():void {
			var tempPos:int;
			
			
			pic.myWidth=getVar("width");
			pic.myHeight=getVar("height");
			
			if((getVar("x") as String).indexOf("%")!=-1){
				tempPos=int((getVar("x") as String).replace("%",""));
				switch(getVar("horizontal")){
					case ("left"):
						setVar("int","x",containerX+(tempPos*.01*returnStageWidth));break;
					case ("right"):
						setVar("int","x",containerX+(tempPos*.01*returnStageWidth)-(pic.myWidth));break;
					default:
						setVar("int","x",containerX+(tempPos*.01*returnStageWidth)-(pic.myWidth/2));
						trace("sss:"+getVar("horizontal")+ " "+pic.myWidth);
				}
			}
			else {
				tempPos=containerX+int(getVar("x"));
				
				switch(getVar("horizontal")){
					case ("left"):
						setVar("int","x",tempPos);break;
					case ("right"):
						setVar("int","x",tempPos-(pic.myWidth));break;
					default:
						setVar("int","x",tempPos-(pic.myWidth/2));

				}
			}
						
			if((getVar("y") as String).indexOf("%")!=-1){
				tempPos=int((getVar("y") as String).replace("%",""));
				switch(getVar("vertical")){
					case "top":
						setVar("int","y",containerY+(tempPos*.01*returnStageHeight));break;
					case "bottom":
						setVar("int","y",containerY+(tempPos*.01*returnStageHeight)-(pic.myHeight));break;
					default:
						setVar("int","y",containerY+(tempPos*.01*returnStageHeight)-(pic.myHeight/2));break;
					
				}
			}
			else  {
				tempPos=containerY+int(getVar("y"));
				switch(getVar("vertical")){
					case ("top"):
						setVar("int","y",tempPos);break;
					case ("bottom"):
						setVar("int","y",tempPos-(pic.myHeight));break;
					default:
						setVar("int","y",tempPos-(pic.myHeight/2));
				}
			}
			//logger.log("containerX sorted");
		}
	
		
		public function sortOutContainerWidthHeight():void{
			var staWidth:uint=returnStageWidth;
			var staHeight:uint=returnStageHeight;
			
			if(getVar("width")=="aspectRatio" && getVar("height")!="aspectRatio"){
				setVar("string","width",getVar("height"));
				staHeight=returnStageWidth;
			}
			
			else if(getVar("height")=="aspectRatio" && getVar("width")!="aspectRatio"){
				setVar("string","height",getVar("width"));
				staWidth=returnStageHeight;
			}
			else if(getVar("height")=="aspectRatio" && getVar("width")=="aspectRatio"){
					//logger.log(getVar("height")+" you have specified both your width and height as 'aspectRatio' - you can only specify one as 'aspectRatio'");
			}
				
			var tempStr:String = getVar("width");
			if (tempStr!="0"){
				if(tempStr.indexOf("%")!=-1) setVar("int","width",staWidth*int(tempStr.replace("%",""))/100);
				else setVar("int","width",int(tempStr));
			}
			tempStr = getVar("height");
			if (tempStr!="0"){
				if(tempStr.indexOf("%")!=-1) setVar("int","height",staHeight*int(tempStr.replace("%",""))/100);
				else setVar("int","height",int(tempStr));
			}
		}
			
		
		override public function storedData():Array {return new Array;}
	

		override public function RunMe():uberSprite {
			return pic;
		}

		
		override public function kill():void {
			
			for (var i:uint;i<containerDetails.length;i++){
				containerDetails[i]=null;
			}	
			containedChildren=null;
			containedChildrenOrder=null;
			super.kill();
		}
			
	}
}