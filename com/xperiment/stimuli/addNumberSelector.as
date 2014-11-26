package  com.xperiment.stimuli{

	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.BasicText;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class addNumberSelector extends object_baseClass {
		private var shapes:Array;
		private var num:Sprite;
		private var container:Sprite;
		private var obj:Object= new Object;
		private var selectedNumber:uint=0;
		private var myList:Array;

		override public function setVariables(list:XMLList):void {
			
			setVar("string","list","a,b,c,d,e,f,g","list[,][string][x]");
			setVar("number","triangleColour",0xffe6e6);
			setVar("uint","textSize",50);
			setVar("int","lineThickness",.1);
			setVar("number","lineColour",0x000000);
			setVar("uint","triangleWidth",70);
			setVar("uint","triangleHeight",50);
			setVar("int","triangleDistFromBox",-5);
			setVar("uint","triangleSeperation",5);
			setVar("number","transparency",0.7);
			setVar("uint","textBoxWidth",200);
			setVar("uint","textBoxHeight",100);
			setVar("number","textBoxColour",0xFFFFFF);
			super.setVariables(list);
			myList=(getVar("list") as String).split(",");
			make();

		}
		
		override public function storedData():Array {
			var tempData:Array = new Array();
			tempData.event=String(getVar("id"));
			tempData.data=selectedNumber;
			super.objectData.push(tempData);
			return objectData;
		}
		
	
		
		private function make():void {
			container = new Sprite;
			shapes = new Array;
			
			var shape:Shape;
			shape=makeSquare(getVar("lineThickness"),getVar("lineColour"),getVar("transparency"), 
							   getVar("textBoxColour"), getVar("textBoxWidth"), getVar("textBoxHeight"));			
			shape.x=0;
			shape.y=+getVar("triangleDistFromBox")+getVar("textBoxHeight")/2;
			pic.addChild(shape);
			shapes.push(shape);
			
			shape=new Shape;
			shape=makeTriangle(getVar("lineThickness"),getVar("lineColour"),getVar("transparency"), 
							   getVar("triangleColour"), getVar("triangleWidth"), -getVar("triangleHeight"));
			shape.x=getVar("textBoxWidth")/2-getVar("triangleWidth")/2;
			shape.y=+getVar("textBoxHeight")/2;
			container.addChild(shape);
			shapes.push(shape);
			
			shape=new Shape;
			shape=makeTriangle(getVar("lineThickness"),getVar("lineColour"),getVar("transparency"), 
							   getVar("triangleColour"), getVar("triangleWidth"), getVar("triangleHeight"));
			shape.x=getVar("textBoxWidth")/2-getVar("triangleWidth")/2;
			shape.y=getVar("textBoxHeight")+getVar("triangleDistFromBox")*2+getVar("textBoxHeight")/2;

			container.addChild(shape);
			shapes.push(shape);

			container.addEventListener(MouseEvent.CLICK, selected,false,0,true);
			
			
			
			//obj.backgroundColor=0x00FFFF as Number
			obj.autoSize="left" as String;
			obj.textSize=getVar("textSize");
			addNumber(myList[selectedNumber]);
			container.addChild(num);
			
			container.x=0;
			container.y=0;
			
			super.pic.addChild(container);
		}
		
		private function addNumber(str:String):void{
			obj.text=str;
			var tempTxt:BasicText = new BasicText();
			num=tempTxt.giveBasicStimulus(obj);
			num.y=getVar("triangleHeight")+getVar("textBoxHeight")/2+getVar("triangleDistFromBox")-num.height/2;
			num.x=getVar("textBoxWidth")/2-num.width/2;
		}


		override public function setContainerSize():void {
			
			pic.myWidth=getVar("textBoxWidth")+getVar("padding-left")+getVar("padding-right");;
			pic.myHeight=container.height+getVar("padding-top")+getVar("padding-bottom");
		}

		private function makeTriangle(lineThickness:uint, lineColour:Number, transparency:Number, colour:Number, width:uint,height:int):Shape {
			var sha:Shape=new Shape  ;
			sha.graphics.lineStyle(lineThickness,lineColour,transparency);
			sha.graphics.beginFill(colour,1);
			sha.graphics.moveTo(0,0);
			sha.graphics.lineTo(width,0);
			sha.graphics.lineTo(Math.round(width)*.5,height);
			sha.graphics.lineTo(0,0);
			sha.graphics.endFill();
					
			return sha;
		}

		private function makeSquare(lineThickness:uint, lineColour:Number, transparency:Number, colour:Number, width:uint,height:int):Shape {
			var sha:Shape=new Shape  ;
			sha.graphics.lineStyle(lineThickness,lineColour,transparency);
			sha.graphics.beginFill(colour,1);
			sha.graphics.moveTo(0,0);
			sha.graphics.lineTo(width,0);
			sha.graphics.lineTo(width,height);
			sha.graphics.lineTo(0,height);
			sha.graphics.lineTo(0,0);
			sha.graphics.endFill();
					
			return sha;
		}

		override public function returnsDataQuery():Boolean {
			return true;
		}


		private function selected(e:MouseEvent):void {
			if (container.getChildAt(0).hitTestPoint(pic.x+mouseX,pic.y+mouseY)) {
				escalateNumber(1);
			}
			if (container.getChildAt(1).hitTestPoint(pic.x+mouseX,pic.y+mouseY)) {
				escalateNumber(-1);
			}
		}
		
		private function escalateNumber(up:int):void{
			if(up==-1 && selectedNumber==0)selectedNumber=myList.length-1;
			else{
				selectedNumber+=up;
				selectedNumber=selectedNumber % myList.length;
			}
			container.removeChild(num);
			addNumber(myList[selectedNumber]);
			addNumber(String(myList[selectedNumber]));
			container.addChild(num);
		
		}
		
		override public function RunMe():uberSprite {
			setUniversalVariables();			
			return (super.pic);
		}

		override public function kill():void {
			pic.removeChild(container);
			for (var i:uint=0;i<shapes.length;i++){
				shapes[i]=null;
			}
			shapes=null;
			super.kill();
		}
	}
}