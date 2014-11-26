package com.xperiment.admin{

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.xperiment.stimuli.primitives.textScroll;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.xperiment.uberSprite;
	import flash.events.MouseEvent;
	import com.xperiment.stimuli.addShape;
	import com.xperiment.stimuli.addText;
	
	public class adminConsole extends admin_baseClass {

		public var textWindow:textScroll;
		public var stuffOnScreen:Array=new Array  ;
		public var combined:Sprite;
		public var myButton:Shape;
		public var trialObjs:Object
		
		override public function setVariables(list:XMLList):void {
			setVar("Number","buttonColour",0x626262);
			setVar("Number","buttonLineColour",0x422f54);
			setVar("int","buttonLineThickness",1);
			setVar("uint","textSize",16);
			setVar("Number","textColour",0xFFFFFF);
			super.setVariables(list);
			var num:Sprite;
			var tempTxt:addText;

			var obj:Object=new Object  ;
			obj.autoSize="left";
			combined=new Sprite  ;

			myButton=addShape.makeShape("square",getVar("buttonLineThickness"),getVar("buttonLineColour"),1,getVar("buttonColour"),10,10);
			stuffOnScreen.push(myButton);
			
			obj.text="console";
			obj.textSize=getVar("textSize");
			obj.colour=getVar("textColour");
			tempTxt=new addText  ;
			num=tempTxt.giveBasicStimulus(obj);

			myButton.width=num.width*1.1;
			myButton.height=num.height*2.5;

			combined.addChild(myButton);
			combined.addChild(num);
			addChild(combined);
			stuffOnScreen.push(combined);
			stuffOnScreen.push(num);
			stuffOnScreen.push(myButton);
			combined.addEventListener(MouseEvent.CLICK,selected);
		}
		
		override public function RunMe():uberSprite {
			setUniversalVariables();
			return (super.pic);
		}

		override public function nextStep(id:String=""):void{
			logger.startStream();
			var obj:Object = new Object;
			obj.txt=logger.give(true,true);
			textWindow= new textScroll(obj);
			this.addChild(textWindow);
			textWindow.x+=myButton.width*1.2;
			textWindow.y+=myButton.width*1.2;
			stuffOnScreen.push(textWindow);
			super.logger.addEventListener("logPing", update);
		}
		
		private function selected(e:MouseEvent):void {
			if(textWindow)textWindow.visible=!textWindow.visible;
			if(!textWindow)nextStep();
			
		}

		public function update(e:Event):void {
			textWindow.updateWindow(e.target.stream());
		}
		
		override public function setContainerSize():void {
			pic.myWidth=pic.width+getVar("padding-left")+getVar("padding-right");
			pic.myHeight=pic.height+getVar("padding-top")+getVar("padding-bottom")+getVar("distanceBetweenNames");
		}

		override public function setUpTrialSpecificVariables(trialObjs:Object):void {
			this.trialObjs=trialObjs;
			super.setUpTrialSpecificVariables(trialObjs);
		}
		
		override public function setUniversalVariables():void {
			sortOutScaling();
			sortOutWidthHeight();
			setContainerSize();
			setRotation();
			setPosPercent();
			sortOutPadding();
			if(getVar("opacity")!=1)pic.alpha=getVar("opacity");
		}
		
		override public function kill():void{
			super.logger.stopStream();
			if (logger.hasEventListener("logPing"))logger.removeEventListener("logPing", update);
			if(textWindow && this.contains(textWindow))this.removeChild(textWindow);
			if(textWindow){textWindow.kill();textWindow=null;}
			if(combined && this.contains(combined))this.removeChild(combined);
			combined=null;
			for (var i:uint=0;i<stuffOnScreen.length;i++){
				stuffOnScreen[i]=null;
			}
			
			stuffOnScreen=null;
			super.kill();
		}


	}
}