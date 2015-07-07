package  com.xperiment.stimuli{

	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.MultipleChoice;
	import com.xperiment.stimuli.primitives.MultipleChoiceGrid;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import com.xperiment.stimuli.primitives.IResult;

	
	public class addMultipleChoice extends object_baseClass implements Imockable, IResult {

		private var multipleChoice:MultipleChoice;
		
		override public function setVariables(list:XMLList):void {			
			setVar("string","seperation","vertical");//vertical, horizontal
			setVar("number","distanceApart",1);
			setVar("string","labels","label1,label2,labels3","string,string...string");
			setVar("uint","fontSize",20);
			setVar("boolean","hideText",false);
			setVar("string","randomPositions","");
			setVar("boolean","saveLabelNumber","","","if this is specified, returns the label number, not it's label");
			setVar("boolean","selectMultiple",false);
			setVar("string","grid","","",'the x by y grid; note you can have an incomplete grid');
			setVar("string","useKeys",'',"comma seperated. Prefix c if you want to use an ascii key code.");
			super.setVariables(list);
			
		}
		
		public function mock():void{
			multipleChoice.mock();
		}

		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('result')==false){
				uniqueProps.result= function():String{
					//AW Note that text is NOT set if what and to and null. 
					//trace(123,"'"+multipleChoice.getData()+"'");
					//trace(111,multipleChoice.getData());
					return "'"+multipleChoice.getData()+"'";
				};
				
			}
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
	
		override public function storedData():Array {
			var tempData:Array = new Array();
			tempData=new Array();
			if(peg!="")tempData.event=peg;
			else tempData.event=multipleChoice;
			
			var data:String;
			if(getVar("saveLabelNumber")=='')	data = multipleChoice.getData();
			else								data = multipleChoice.getWhichSelected().toString();
			
			tempData.data= data;
			super.objectData.push(tempData);
			return objectData;
		}
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		override public function RunMe():uberSprite {
			pic.graphics.drawRect(0,0,1,1);
			setUniversalVariables();
			
			var params:Object = {selectMultiple:getVar("selectMultiple"),randomPositions:getVar("randomPositions"),hideText:getVar("hideText"),fontSize:getVar("fontSize"),distanceApart:getVar("distanceApart"),
				width:pic.width,height:pic.height,PossibleAnswers:(getVar("labels") as String).split(","),seperation:getVar("seperation"),grid:getVar("grid"),useKeys:getVar("useKeys")};
			
			if(getVar("grid")=='')	multipleChoice = new MultipleChoice(params,theStage)
			else 					multipleChoice = new MultipleChoiceGrid(params,theStage)
			
			this.name="multipleChoiceAction";
			pic.scaleX=1;
			pic.scaleY=1;
			pic.addChild(multipleChoice);
			multipleChoice.x=pic.width*.5-multipleChoice.width*.5;
			multipleChoice.y=pic.height*.5-multipleChoice.height*.5;
			//overlay.scaleX=pic.width/overlay.width;
			//overlay.scaleY=pic.height/overlay.height;
			//pic.addChild(overlay);
			return pic;
		}
		
		override public function appearedOnScreen(e:Event):void{
			if(getVar("useKeys")!="")multipleChoice.init();
			super.appearedOnScreen(e);
		}
		
		override public function kill():void {

			multipleChoice.kill();
			pic.removeChild(multipleChoice);
			multipleChoice=null;
			super.kill();
		}
	}
}