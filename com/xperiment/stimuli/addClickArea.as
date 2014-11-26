package com.xperiment.stimuli
{
	import com.bit101.components.Style;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.abstract_button;	
	import flash.events.MouseEvent;


	public class addClickArea extends abstract_button
	{
		
		public var selected:Boolean=false;
		private var myAlpha:Number;
		private var fill:Boolean;
		private var lineThickness:Number;
		
		override public function selectedIsCorrect():Boolean{
			var answer:String = getVar("answer");
			
			for each(var b:abstract_button in buttonGroup[getVar("buttonGroup")]){
				if(b.buttonCount>0 && b.peg==answer)return true;
			}
			return false;
		}
		
		override public function returnsDataQuery():Boolean{
			if(getVar("hideResults")!='true'){
				return true;
			}
			return false;
		}
		
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList):void {
			setVar("number","alpha",.8);
			setVar("boolean","fill",true);
			setVar("int","lineThickness",3);
			setVar("int","colourSelected",Style.BUTTON_DOWN);
			
			super.setVariables(list);			
			
			this.fill=getVar("fill");
			this.myAlpha=getVar("alpha");
			this.lineThickness=getVar("lineThickness");
			
		}
		
		override public function storedData():Array {
			var tempData:Array = new Array();
			if(!buttonGroup){
				if(getVar("whichPressed")!=''){
					if(buttonCount>0)	objectData.push({event:getVar("whichPressed"),data:peg});
				}
				if(buttonCount>0){
					objectData.push({event:peg,data:buttonCount});
				}
			}
			else buttonGroupComposeResult();
			
			return objectData;
		}
		
		private function composeDataArray():Array{
			var clicked:Array=[];
			for each(var b:addButton in buttonGroup[getVar("buttonGroup")]){
				if(b.buttonCount>0)clicked.push(b.peg);
			}
			return clicked;
		}
		
		override public function RunMe():uberSprite {
			pic.graphics.beginFill(0x000000,0);
			pic.graphics.drawRect(0,0,1,1);
			
			super.setUniversalVariables();
			pic.scaleX=1;
			pic.scaleY=1;
			make(Style.BUTTON_FACE);
			pic.alpha=0;
			pic.mouseEnabled=true;
			pic.buttonMode=true;
			listeners(true);
			
			return pic;
		}
		
		override public function __deselectOthersInButtonGroup():void
		{
			for each(var b:addClickArea in buttonGroup[getVar("buttonGroup")]){
				if(b!=this){
					b.buttonCount=0;
					b.selected=false;
					b.pic.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
				}
			}
		}
		
		private function listeners(ON:Boolean):void{
			var f:Function;
			if(ON)	f=pic.addEventListener;
			else	f=pic.removeEventListener;
			
			f(MouseEvent.MOUSE_OVER,MouseListener);
			f(MouseEvent.MOUSE_OUT,MouseListener);
			f(MouseEvent.MOUSE_DOWN,MouseListener);
			f(MouseEvent.MOUSE_UP,MouseListener);
			f(MouseEvent.CLICK,MouseListener);
			f(MouseEvent.RELEASE_OUTSIDE,MouseListener);
		}
		
		protected function MouseListener(e:MouseEvent):void
		{
			var col:int=-1;

			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					col=getVar("colourSelected");
					break;
				case MouseEvent.CLICK:
					selected=!selected;
					if(selected==true){
						
						buttonCount++;
						if(buttonGroup && buttonGroupOnlyOneSelected)__deselectOthersInButtonGroup();
					}
				case MouseEvent.MOUSE_UP:
				case MouseEvent.MOUSE_OVER:
					if(selected==false)	col=Style.LIST_SELECTED;
					else col=getVar("colourSelected");
					break;
				case MouseEvent.RELEASE_OUTSIDE:
				case MouseEvent.MOUSE_OUT:
					if(selected==false)	pic.alpha=0;
		
					break;
			}
			
			if(col!=-1)make(col);
			
		}
		
		
		private function make(col:int):void
		{
			pic.graphics.clear();
			pic.alpha=myAlpha;
			if(fill==true)	pic.graphics.beginFill(col,myAlpha);
			else			pic.graphics.beginFill(col,0);
			pic.graphics.lineStyle(lineThickness,col,1);
			pic.graphics.drawRect(0,0,pic.myWidth,pic.myHeight);
		}
		
		override public function kill():void{
			listeners(false);
			super.kill();
		}
	}
}