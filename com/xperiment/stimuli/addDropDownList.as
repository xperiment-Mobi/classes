package com.xperiment.stimuli{
	import flash.display.*;
	import flash.events.Event;
	import com.xperiment.uberSprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.xperiment.stimuli.addShape;
	import com.xperiment.stimuli.primitives.BasicText;
	
	public class addDropDownList extends object_baseClass {
		private var conditionList:Array;
		private var container:Sprite;
		private var textOnScreen:Array=new Array;
		private var buttons:Array = new Array;
		private var sure:Array;
		private var prevSelected:int=-1;
		private var mySelected:int=-1;
		private var background:Shape;
		
		override public function setVariables(list:XMLList):void {
			setVar("uint","distanceBetweenNames",40);
			setVar("string","align","centre","left||centre||right");
			setVar("Number","titleButtonColour",0x6262F2);
			setVar("Number","titleButtonLineColour",0x422ff4);
			setVar("Number","backgroundColour",0x000555);
			setVar("Number","backgroundGirth",5);
			setVar("Number","backgroundTransparency",.3,"0-1");
			setVar("Number","buttonColour",0x626262);
			setVar("Number","buttonLineColour",0x422f54);
			setVar("string","title","{b}add a title svp{/b}");
			setVar("string","list","a,b,c,d,e","string,string,string...");
			setVar("number","buttonLineThickness",0);
			setVar("uint","textSize",16);
			setVar("Number","textColour",0xFFFFFF);
			super.setVariables(list);
			setVar("int","scale",1);

		}
		
		override public function RunMe():uberSprite {
						
			conditionList=(getVar("list") as String).split(",");
			
			conditionList.unshift(getVar("title"));
			
		
			var txt:Sprite;
			var tempTxt:BasicText;
			var obj:Object=new Object;
			obj.autoSize="left";
			container=new Sprite;
			var subcontainer:Sprite;
			var tempShape:Shape;
			var maxButtonWidth:int=0;
			var maxButtonHeight:int=0;
			sure = new Array;
	
			for (var i:uint=0; i<conditionList.length; i++) {
				subcontainer = new Sprite;
				if (i==0)tempShape=addShape.makeShape("square",getVar("buttonLineThickness"),getVar("titleButtonLineColour"),1,getVar("titleButtonColour"),10,10)
				else tempShape=addShape.makeShape("square",getVar("buttonLineThickness"),getVar("buttonLineColour"),1,getVar("buttonColour"),10,10)
				
				obj.text=conditionList[i];
				obj.textSize=getVar("textSize");
				obj.colour=getVar("textColour");
				tempTxt = new BasicText();
				txt=tempTxt.giveBasicStimulus(obj);
				
				buttons.push(tempShape);
				subcontainer.addChild(tempShape);
				textOnScreen.push(txt);
				subcontainer.addChild(txt);
				container.addChild(subcontainer);
				if (txt.width>maxButtonWidth)maxButtonWidth=txt.width;
				if (txt.height>maxButtonHeight)maxButtonHeight=txt.height;

				tempShape.y=getVar("distanceBetweenNames")*i;
				txt.y=getVar("distanceBetweenNames")*i;
				
				if(i>0){tempShape.visible=false; txt.visible=false;}

			}
			
			maxButtonWidth*=1.4;maxButtonHeight*=1.4;
			
			for (i=0;i<buttons.length;i++){
				buttons[i].width=maxButtonWidth;
				buttons[i].height=maxButtonHeight;
				
				 textOnScreen[i].y+=(buttons[i].height-textOnScreen[i].height)/2;
				 
				switch(getVar("align")){
					   case "centre":
					   	 textOnScreen[i].x+=(buttons[i].width-textOnScreen[i].width)/2;
					     break;
					   case "right":
						 textOnScreen[i].x+=(buttons[i].width-textOnScreen[i].width);
					  	 break;
					   }
			}
			
			container.addEventListener(MouseEvent.CLICK, selected,false,0,true);
			
			if(getVar("backgroundColour")!=-1){
				background=addShape.makeShape("square",0,0,getVar("backgroundTransparency"),getVar("backgroundColour"),container.width+getVar("backgroundGirth")*2,container.height+getVar("backgroundGirth")*2,false);
				background.visible=false;
				background.x-=+getVar("backgroundGirth")-getVar("backgroundGirth");
				background.y-=+getVar("backgroundGirth")-getVar("backgroundGirth");
				pic.addChild(background);
			}
			
			container.x+=getVar("backgroundGirth");
			container.y+=getVar("backgroundGirth");
			pic.addChild(container);
			
			setUniversalVariables();	
			return (super.pic);
		}
		
		private function updateTitle(num:uint):void{
			prevSelected=mySelected;
			mySelected=num;
			if(mySelected!=prevSelected){
				if(textOnScreen[0].visible)textOnScreen[0].visible=false;
				if (prevSelected!=-1){
					textOnScreen[prevSelected].y+=getVar("distanceBetweenNames")*prevSelected;
				
				}
				textOnScreen[mySelected].y-=getVar("distanceBetweenNames")*mySelected;
			
			}
			
		}
		
		private function flipAlpha():void{
			for (var i:uint=1; i<conditionList.length; i++) {
				if(i!=mySelected)textOnScreen[i].visible=!textOnScreen[i].visible;
				buttons[i].visible=!buttons[i].visible;
				if(background)background.visible=!background.visible;
			}
		}
		
		private function selected(e:MouseEvent):void {
			for (var i:uint=0; i<container.numChildren; i++) {
				if (container.getChildAt(i).hitTestPoint(pic.x+mouseX,pic.y+mouseY)) {
					if (i==0)flipAlpha();
					else updateTitle(i);
				}
			}
		}
		
		private function nextStep(selected:uint):void{
			pic.dispatchEvent(new Event("betweenSJsTrialEvent",true));
		}
		
		
		private function Alpha(arr:Array,n:uint,pos:int):void{
			for (var i:uint; i<arr.length; i++){
				if(n!=2){
					arr[i].alpha=n;
					if(pos!=9999)arr[i].y=pos;
					}
				else if(arr[i].alpha==1) arr[i].alpha = 0;
				else arr[i].alpha = 1;
				
			}
		}

		override public function kill():void {
			container.removeEventListener(MouseEvent.CLICK,selected);
			pic.removeChild(container);
			
			if(getVar("backgroundColour")!=-1){pic.removeChild(background); background=null;}
			
			for (var i:uint=0; i<container.numChildren; i++) {
				container.removeChildAt(i);
			}
			for (i=0; i<buttons.length; i++) {
				buttons[i]=null;
			}
			for (i=0; i<textOnScreen.length; i++) {
				textOnScreen[i]=null;
			}				
			
			container=null;
			buttons=null;
			textOnScreen=null;
			conditionList=null;
			sure=null;

			super.kill();
		}
	}
}