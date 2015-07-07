
package  com.xperiment.stimuli{


	import com.bit101.components.Style;
	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class addSequentialCounter extends object_baseClass {

		private var myTextFormat:TextFormat=new TextFormat  ;
		private var myText:TextField=new TextField  ;
		
		private var countDown:Boolean=false;
		private var currentVal:Number;
		private var rootSquareTimePeriod:Number;
		private var myTimer:Timer;

		override public function kill():void{
			myTimer.removeEventListener(TimerEvent.TIMER,timerHandler);
			myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,completeHandler);
			
			myTimer.stop();
		}
		
		override public function setVariables(list:XMLList):void {

			setVar("string","text","");
			setVar("number","colour",Style.LABEL_TEXT);
			setVar("uint","size",40);
			//setVar("string","alignment","LEFT","");
			setVar("number","backgroundColor","");
			setVar("number","borderColor","");
			setVar("boolean","multiLine","false");
			setVar("uint","textSize",120);
			setVar("boolean","selectable",false);
			setVar("boolean","wordWrap",false);
			setVar("uint","widthTextBox",0);
			setVar("uint","heightTextBox",0);
			setVar("number","steps",10);
			setVar("number","startVal",0);
			setVar("number","endVal",10000);
			setVar("number","divideNumberBy",1000);
			setVar("string","endMessage","fin!");
			super.setVariables(list);
		}


		private function timerHandler(e:TimerEvent):void {
			if (countDown) {
				currentVal=currentVal-(rootSquareTimePeriod/getVar("steps"));
				myText.htmlText=String((currentVal/getVar("divideNumberBy")));
			}
			else {
				currentVal=currentVal+(rootSquareTimePeriod/getVar("steps"));
				myText.htmlText=String((currentVal/getVar("divideNumberBy")));
			}

		}

		private function completeHandler(e:TimerEvent):void {
			myText.htmlText=getVar("endMessage");
			this.dispatchEvent(new StimulusEvent(StimulusEvent.ON_FINISH));
		}

		


		override public function RunMe():uberSprite {
			myTextFormat.color=getVar("colour");
			myTextFormat.size=getVar("size");

			myText.defaultTextFormat=myTextFormat;
			
			myText.htmlText=String((getVar("startVal")/getVar("divideNumberBy")));
			rootSquareTimePeriod=Math.sqrt(Math.pow((getVar("endVal")-getVar("startVal")),2));
			myText.autoSize=TextFieldAutoSize.CENTER;

			if ((getVar("startVal")>getVar("endVal"))) {
				countDown=true;
				currentVal=getVar("startVal");
			}
			else {
				currentVal=getVar("startVal");
			}
			
			pic.width=myText.width;
			pic.height=myText.height;
			myText.x=pic.x;
			myText.y=pic.y;
			super.pic.addChild(myText);
			
			myTimer=new Timer((rootSquareTimePeriod/getVar("steps")),getVar("steps"));


			myTimer.addEventListener(TimerEvent.TIMER,timerHandler);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE,completeHandler);
			
			super.setUniversalVariables();
			
			return super.pic;

		}


		override public function appearedOnScreen(e:Event):void {
			myTimer.start();
			super.appearedOnScreen(e);
		}





	}






}