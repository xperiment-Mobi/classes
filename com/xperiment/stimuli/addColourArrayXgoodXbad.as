package  com.xperiment.stimuli{
	import flash.display.*;
	import flash.events.*;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addColourArray;
	public class addColourArrayXgoodXbad extends addColourArray {


		override public function storedData():Array {
			var tempData:Array = new Array();
			tempData.event=String("goodColours");
			var tempGoodResults:String = new String;
			var tempBadResults:String = new String;
			var tempString:String;
			
			for (var i:uint = 0; i<colourArray.length; i++){
				tempString=(super.colourArray[i]).name.split("~")[1];
				if (tempString =="up")
				{tempGoodResults = tempGoodResults + " "+colourArray[i].name.split("~")[0];}
				if (tempString =="down")
				{tempBadResults = tempBadResults + " "+colourArray[i].name.split("~")[0];}
			}
			tempData.data=tempGoodResults;			
			super.objectData.push(tempData);
			
			tempData = new Array();
			tempData.event=String("badColours");
			tempData.data=tempBadResults;			
			super.objectData.push(tempData);
			
			return objectData;
		}

		override public function setVariables(list:XMLList):void {
			setVar("uint","numColoursToSelect",3);
			setVar("string","whatToDo","size","size||upDown");
			setVar("uint","depth",20);
			super.setVariables(list);
		}

		private var poppedUp:uint=0;
		private var poppedDown:uint=0;

		override public function handleMouseOVER(evt:MouseEvent):void {
		}
		override public function handleMouseOUT(evt:MouseEvent):void {
		}

		override public function handleMouseCLICK(evt:MouseEvent):void {
			switch (takeOutParameter(evt)) {
				case "~blank" :
					if (poppedUp<3) {
						updateParameter(evt,"~up");
						poppedUp++;
						bigger(evt);
					}
					else if (poppedDown<3){
						updateParameter(evt,"~down");
						poppedDown++;
						smaller(evt);
					}
					
					break;
				case "~up" :
					if (poppedDown<3) {
						updateParameter(evt,"~down");
						poppedDown++;
						poppedUp--;
						smaller(evt);
						smaller(evt);
					}
					else {
						updateParameter(evt,"");
						poppedUp--;
						smaller(evt);
					}

					break;
				case "~down" :
					updateParameter(evt,"");
					poppedDown--;
					bigger(evt);
					break;
			}
			
			if (poppedUp==3 && poppedDown ==3  && getVar("behaviours")!=""){
				this.dispatchEvent(new Event("behaviourFinished",true));
			}
		}



		private function bigger(evt:MouseEvent):void {
			var num:uint=getVar("rows")*getVar("columns");
			this.setChildIndex(Sprite(evt.currentTarget), num-1);

			switch (getVar("whatToDo")) {
				case "size" :
					evt.currentTarget.width=evt.currentTarget.width+getVar("growthFactor");
					evt.currentTarget.height=evt.currentTarget.height+getVar("growthFactor");
					evt.currentTarget.y=evt.currentTarget.y-(getVar("growthFactor")/2);
					evt.currentTarget.x=evt.currentTarget.x-(getVar("growthFactor")/2);
					break;
				case "upDown" :
					evt.currentTarget.y=evt.currentTarget.y-(getVar("growthFactor")/2);
					evt.currentTarget.x=evt.currentTarget.x-(getVar("growthFactor")/2);
					break;


			}
		}

		private function smaller(evt:MouseEvent):void {
			switch (getVar("whatToDo")) {
				case "size" :
					evt.currentTarget.width=evt.currentTarget.width-getVar("growthFactor");
					evt.currentTarget.height=evt.currentTarget.height-getVar("growthFactor");
					evt.currentTarget.y=evt.currentTarget.y+(getVar("growthFactor")/2);
					evt.currentTarget.x=evt.currentTarget.x+(getVar("growthFactor")/2);
					break;
				case "upDown" :
					var num:uint=getVar("rows")*getVar("columns");
					this.setChildIndex(uberSprite(evt.currentTarget), 0);
					evt.currentTarget.y=evt.currentTarget.y+(getVar("growthFactor")/2);
					evt.currentTarget.x=evt.currentTarget.x+(getVar("growthFactor")/2);
					break;

			}
		}


		private function takeOutParameter(evt:MouseEvent):String {
			var temp:String="blank";

			if (evt.currentTarget.name.indexOf("~")!=-1) {
				temp=evt.currentTarget.name.split("~")[1];
			}
			return "~"+temp;
		}

		private function updateParameter(evt:MouseEvent,txt:String):void {
			evt.currentTarget.name = String((evt.currentTarget.name.split("~"))[0])+txt;
		}

	}
}