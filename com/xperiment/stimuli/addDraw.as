package  com.xperiment.stimuli{
	

	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.IResult;
	import com.xperiment.stimuli.primitives.SimpleDraw;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class addDraw extends object_baseClass implements IResult {
			
		var canvas:SimpleDraw
		
		override public function setVariables(list:XMLList):void {
			setVar("string","penColour",0xFFFFFF);
			setVar("string","backgroundColour",0x000000);
			setVar("int","thickness",2);
			setVar("boolean","continuous",false,"","if so, resets the drawing on each 'mouseUp");
			setVar("string","draw","","");
			
			super.setVariables(list);

		}
		
		override public function storedData():Array {
			var tempData:Object = {};
			tempData.event = 'pic';
			tempData.data = canvas.results();		
			objectData.push(tempData);
			return objectData;
		}
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('result')==false){
				uniqueProps.result= function():String{
					if(canvas){
						if(canvas.drawn()) return "'true'";
						else return "''"
					}
					return "";
				};
			}
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop];
			return super.myUniqueProps(prop);
		}
		
		override public function myUniqueActions(action:String):Function{
			if(!uniqueActions){
			
				uniqueActions = new Dictionary;
				uniqueActions.reset=function(contents:Array):void{
					if(canvas)	canvas.reset();
				}; 	
			}
	
			if(uniqueActions.hasOwnProperty(action)) return uniqueActions[action]
			
			return null;
		}
		
		
		override public function RunMe():uberSprite {
			super.setUniversalVariables();
			var _width:int=pic.width;
			var _height:int=pic.height;
			
			pic.scaleX=1;
			pic.scaleY=1;
			
	
			
			//super.pic.addChild(combined);
			
			
			return (super.pic);
		}
		

		override public function appearedOnScreen(e:Event):void
		{
			canvas = new SimpleDraw(this.myWidth,this.myHeight);
			canvas.penColour = int(getVar("penColour"));
			canvas.backgroundColour = int(getVar("backgroundColour"));
			canvas.thickness = getVar("thickness");
			canvas.continuous = getVar("continuous");
			canvas.doDraw = getVar("draw");
			
			pic.addChild(canvas);
			canvas.setup();
			
			super.appearedOnScreen(e);
		}	
		



		
		override public function kill():void{
			pic.removeChild(canvas);
			canvas.kill();
			super.kill();
			
		}
	}
}

