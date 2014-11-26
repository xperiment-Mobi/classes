package  com.xperiment.stimuli{
	import flash.display.*;
	import flash.events.*;
	import com.xperiment.uberSprite;

	public class addColourArray extends object_baseClass {


		override public function storedData():Array {
			var tempData:Array = new Array();
			tempData.event=String("colour");
			tempData.data=clickedColour;
			super.objectData.push(tempData);
			return objectData;
		}
		
		override public function returnsDataQuery():Boolean {
			return true;
		}


		override public function setVariables(list:XMLList):void{

			setVar("number","colour",0x2147AB);
			setVar("number","lineColour",0x2147AB);
			setVar("uint","singlePatchWidth",69);
			setVar("uint","singlePatchHeight",48);
			setVar("uint","lineThickness",0);
			setVar("uint","spaceBetweenRows",0);
			setVar("uint","spaceBetweenColumns",0);
			//setVar("string","shape","rectangle","rectangle");//not used
			setVar("uint","rows",4);
			setVar("uint","columns",9);
			setVar("number","growthFactor","18");
			setVar("string","colours","0xd12e59&&0x8e4d9d&&0x77a4db");
			setVar("boolean","randomizeColours",true);
			super.setVariables(list);


		}

		private var coloursForArray:Array=new Array;
		public var colourArray:Array=new Array  ;


		override public function RunMe():uberSprite {
			var tempRow:uint;
			var tempColumn:uint;
			var columnCounter:uint;
			var rowCounter:uint;

			coloursForArray=(getVar("colours")as String).split("&&");

			if (getVar("randomizeColours")) {
				coloursForArray=shuffleArray(coloursForArray);
			}

			var col:Number=new Number  ;
			var counter:uint=0;
			for (columnCounter=0; columnCounter<getVar("rows"); columnCounter++) {
				for (rowCounter=0; rowCounter<getVar("columns"); rowCounter++) {
					//var myShape:Shape=setupObject(getVar("singlePatchWidth"),getVar("singlePatchHeight"),getVar("colour"),getVar("lineThickness"),getVar("lineColour"));

					if (coloursForArray.length>counter) {
						col=Number(coloursForArray[counter]);

					}
					else {
						col=0xFFFFFF;
					}

					var myShape:Sprite=setupObject(getVar("singlePatchWidth"),getVar("singlePatchHeight"),col,getVar("lineThickness"),getVar("lineColour"));
					myShape.name=coloursForArray[counter];
					tempColumn=columnCounter*getVar("singlePatchWidth")+getVar("spaceBetweenColumns")*columnCounter;
					tempRow=rowCounter*getVar("singlePatchHeight")+getVar("spaceBetweenRows")*rowCounter;
					colourArray.push(myShape);


					myShape.addEventListener(MouseEvent.MOUSE_OVER,handleMouseOVER);
					myShape.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOUT);
					myShape.addEventListener(MouseEvent.CLICK,handleMouseCLICK);

					this.addChild(myShape);

					myShape.x=tempColumn;
					myShape.y=tempRow;
					counter++;
				}
			}

			setUniversalVariables();
			return pic;
		}

		public function setupObject(width:uint,height:uint,colour:uint,lineThickness:uint,lineColour:Number):Sprite {
			var myShape:Shape=new Shape  ;
			myShape.graphics.beginFill(colour);
			//myShape.graphics.lineStyle(lineThickness,lineColour);
			myShape.graphics.drawRect(0,0,width,height);
			myShape.graphics.endFill();

			var spr:Sprite=new Sprite  ;
			spr.addChild(myShape);

			return spr;
		}

		private var popUp:Boolean=true;
		private	var clickedColour:String="noneClicked!";

		public function handleMouseOVER(evt:MouseEvent):void {
			if (popUp) {
				var num:uint=getVar("rows")*getVar("columns");

				this.setChildIndex(Sprite(evt.currentTarget), num-1);
				evt.currentTarget.width=evt.currentTarget.width+getVar("growthFactor");
				evt.currentTarget.height=evt.currentTarget.height+getVar("growthFactor");
				evt.currentTarget.y=evt.currentTarget.y-(getVar("growthFactor")/2);
				evt.currentTarget.x=evt.currentTarget.x-(getVar("growthFactor")/2);
			}
		}

		public function handleMouseCLICK(evt:MouseEvent):void {
			var num:uint=getVar("rows")*getVar("columns");

			if (popUp) {
				popUp=false;
				clickedColour=evt.currentTarget.name;
				//logger.log(clickedColour);
			}
			else if (popUp==false && this.getChildIndex(Sprite(evt.currentTarget))==num-1) {
				popUp=true;

			}




		}


		public function handleMouseOUT(evt:MouseEvent):void {
			if (popUp) {
				evt.currentTarget.width=evt.currentTarget.width-getVar("growthFactor");
				evt.currentTarget.height=evt.currentTarget.height-getVar("growthFactor");
				evt.currentTarget.y=evt.currentTarget.y+(getVar("growthFactor")/2);
				evt.currentTarget.x=evt.currentTarget.x+(getVar("growthFactor")/2);
			}
		}
		private static function shuffleArray(a:Array):Array {
			var a2:Array=[];
			while (a.length>0) {
				a2.push(a.splice(Math.round(Math.random()*a.length-1),1)[0]);
			}
			return a2;
		}



	}
}