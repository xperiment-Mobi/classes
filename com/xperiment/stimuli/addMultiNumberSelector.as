package com.xperiment.stimuli {

	import com.bit101.components.Style;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.stimuli.primitives.IResult;
	import com.xperiment.stimuli.primitives.numberSelector;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	
	public class addMultiNumberSelector extends object_baseClass implements Imockable, IResult {
		private var selectors:Vector.<numberSelector> = new Vector.<numberSelector>;
		private var myInfo:Object;
		
		public function mock():void{
			var clicks:int;
			var i:int;
			for each(var sel:numberSelector in selectors){
				clicks = Math.random()*15;
				for(i=0;i<clicks;i++){	
					sel.selector.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
				}
			}
		}
		
		override public function setVariables(list:XMLList):void {
			
			setVar("uint","selectors",2,"if you specify a startingVal with more digits that 2, more selectors will be added.");
			setVar("string","list","0,1,2,3,4,5,6,7,8,9","int,int...int");
			setVar("number","triangleColour",Style.BUTTON_FACE);
			setVar("number","lineAlpha",Style.borderAlpha);
			setVar("uint","fontSize",50);
			setVar("string","fontColour",Style.LABEL_TEXT);
			setVar("int","lineThickness",Style.borderWidth);
			setVar("number","lineColour",Style.borderColour);
			setVar("number","lineColour",Style.borderAlpha);
			setVar("uint","triangleWidth",100);
			setVar("uint","triangleHeight",50);
			setVar("int","triangleDistFromBox",0);
			setVar("uint","triangleSeperation",5);
			setVar("number","textBoxColour",Style.BUTTON_FACE);
			setVar("string","startingVal","22");

			
			super.setVariables(list);
			OnScreenElements.selectors = OnScreenElements.startingVal.length;
			

		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('result')==false){
				uniqueProps.result= function():String{
									//AW Note that text is NOT set if what and to and null. 
									
									return "'"+selected()+"'";
								};
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		
		
		private function make():void {
		
			var sel:numberSelector;
			OnScreenElements.textBoxWidth=pic.myWidth/getVar("selectors");
			OnScreenElements.textBoxHeight=pic.myHeight;
			for(var i:uint=0;i<getVar("selectors");i++){
				OnScreenElements.xOffset=i*getVar("textBoxWidth");
				OnScreenElements.startVal=(getVar("startingVal") as String).substr(i,1);
				sel=new numberSelector();
				sel.run(OnScreenElements);
				sel.x=i*sel.width;
				selectors.push(sel);
				pic.addChild(sel);
			}
			
		}
		
		override public function storedData():Array {
			super.objectData.push({event:peg,data:selected()});
			return objectData;
		}
		
		private function selected():String{
			var str:String = '';
			var temp:String;
			for(var i:uint=0;i<selectors.length;i++){
				temp = selectors[i].giveData();
				
				if(str!="" || temp!="0") 	str+=String(selectors[i].giveData());
				
			}
			if(str=='')str="0";
			return str;
		}
	

		override public function returnsDataQuery():Boolean {
			return true;
		}

		
		override public function RunMe():uberSprite {
			setUniversalVariables();	
			pic.scaleX=pic.scaleY=1;
			make();
			return (super.pic);
		}

		override public function kill():void {
			for (var i:uint=0;i<selectors.length;i++){
				pic.removeChild(selectors[i]);
				selectors[i].kill();
				selectors[i]=null;
			}
			selectors=null;

			super.kill();
		}
	}
}