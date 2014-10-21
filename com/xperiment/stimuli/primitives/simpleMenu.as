package com.xperiment.stimuli.primitives{

	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.xperiment.codeRecycleFunctions;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.xperiment.stimuli.primitives.shape;
	import flash.events.EventDispatcher;
	import com.xperiment.stimuli.addText;
	import com.xperiment.stimuli.addShape;

	public class simpleMenu extends Sprite {
		private var container:Sprite=new Sprite  ;
		private var stuffOnScreen:Array=new Array  ;
		private var buttons:Array=new Array  ;
		private var sure:Array;
		private var selectedItem:int=-1;
		private var conditionList:Array=new Array  ;
		private var info:Object;
		private var maxButtonWidth:int=0;
		private var maxButtonHeight:int=0;
		private var listOfItemsToAddToConditionList:Array=["back","begin"];
		private var buttonCount:uint=0;

		public function nextStep():int {
			return selectedItem;
		}
		
		public function giveButtonWidth():uint{
			return maxButtonWidth;
		}

		public function simpleMenu(info:Object):void {

			this.info=info;
			conditionList=info.conditionList;

			if (! info.verticalSeperation) {
				info.verticalSeperation=1.4;
			}

			for (var i:uint=conditionList[info]; i<conditionList.length; i++) {
				makeButton(conditionList[i],info.textSize,info.textColour,info.buttonLineThickness,info.buttonLineColour,info.buttonColour,true);
				for (var j:uint=0; j<listOfItemsToAddToConditionList.length; j++) {
					makeButton(listOfItemsToAddToConditionList[j],info.textSize,info.textColour,info.buttonLineThickness,info.buttonLineColour,info.buttonColour,false);
				}

			}

			maxButtonWidth*=1.1;
			maxButtonHeight*=2.5;

			for (i=0; i<buttons.length; i++) {
				buttons[i].width=maxButtonWidth;
				buttons[i].height=maxButtonHeight;
			}

			var dif:uint=conditionList.length-listOfItemsToAddToConditionList.length;

			for (i=0; i<buttons.length; i++) {

				buttons[i].x+=i%(listOfItemsToAddToConditionList.length+1)*maxButtonWidth;
				stuffOnScreen[i].x=buttons[i].x;
				buttons[i].y+=(i-i%(listOfItemsToAddToConditionList.length+1))/(listOfItemsToAddToConditionList.length+1)*maxButtonHeight*info.verticalSeperation;
				stuffOnScreen[i].y=buttons[i].y;
				//sure.push(subcontainer);
			}
			
			container.addEventListener(MouseEvent.CLICK,selected);
			container.x+=info.buttonLineThickness*2.5*1.4;
			container.y+=info.buttonLineThickness*2*1.4;
			this.addChild(container);

			
		}




		private function selected(e:MouseEvent):void {
			for (var i:uint=0; i<container.numChildren; i++) {
				if (container.getChildAt(i).hitTestPoint(this.parent.x+mouseX,this.parent.y+mouseY)) {
					var opt:uint=i%(listOfItemsToAddToConditionList.length+1);
					var justSelected:uint=(i-i%(listOfItemsToAddToConditionList.length+1))/(listOfItemsToAddToConditionList.length+1);

					if (opt==listOfItemsToAddToConditionList.length) {
						this.dispatchEvent(new Event("nextStep"));
						
						break;
					}
					else {

						hideAll();

						if (selectedItem!=justSelected || buttonCount%2==1  ) {
							Show((justSelected*(listOfItemsToAddToConditionList.length+1))+1);
							selectedItem=justSelected;
							buttonCount=0;
						}
						else{
							buttonCount++;
						}
					}

				}


			}
		}

		private function Show(num:uint):void {
			for (var j:uint=0; j<listOfItemsToAddToConditionList.length; j++) {
				stuffOnScreen[num+j].visible=! stuffOnScreen[num+j].visible;
				buttons[num+j].visible=! buttons[num+j].visible;
			}
		}

		private function hideAll():void {
			for (var i:uint=0; i<conditionList.length; i++) {
				for (var j:uint=1; j<listOfItemsToAddToConditionList.length+1; j++) {
					stuffOnScreen[(i*(listOfItemsToAddToConditionList.length+1))+j].visible=false;
					buttons[(i*(listOfItemsToAddToConditionList.length+1))+j].visible=false;
				}
			}
		}




		public function kill():void {
			container.removeEventListener(MouseEvent.CLICK,selected);
			for (var i:uint=0; i<container.numChildren; i++) {
				container.removeChildAt(i);
			}
			for (i=0; i<buttons.length; i++) {
				buttons[i]=null;
			}

			for (i=0; i<stuffOnScreen.length; i++) {
				stuffOnScreen[i]=null;
			}

			buttons=null;
			container=null;
			stuffOnScreen=null;
			conditionList=null;
			sure=null;
		}

		private function makeButton(info:String,size:uint,col:Number,thick:uint,bLCol:Number,bCol:Number,vis:Boolean):void {
			var num:Sprite;
			var tempTxt:addText;
			var obj:Object=new Object  ;
			obj.autoSize="left";
			var subcontainer:Sprite;
			var tempShape:Shape;
			sure=new Array  ;

			subcontainer=new Sprite  ;
			tempShape=addShape.makeShape("square",thick,bLCol,1,bCol,10,10);
			tempShape.visible=vis;

			obj.text=info;
			obj.textSize=size;
			obj.colour=col;
			tempTxt=new addText  ;
			num=tempTxt.giveBasicStimulus(obj);
			num.visible=vis;

			buttons.push(tempShape);
			subcontainer.addChild(tempShape);
			stuffOnScreen.push(num);
			subcontainer.addChild(num);
			container.addChild(subcontainer);

			if (num.width>maxButtonWidth) {
				maxButtonWidth=num.width;
			}
			if (num.height>maxButtonHeight) {
				maxButtonHeight=num.height;
			}
		}


	}
}