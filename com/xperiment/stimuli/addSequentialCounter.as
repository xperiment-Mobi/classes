
package  com.xperiment.stimuli{


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
			setVar("number","colour",0x000000);
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
			setVar("number","startValue",0);
			setVar("number","endValue",10000);
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
			
			myText.htmlText=String((getVar("startValue")/getVar("divideNumberBy")));
			rootSquareTimePeriod=Math.sqrt(Math.pow((getVar("endValue")-getVar("startValue")),2));
			myText.autoSize=TextFieldAutoSize.CENTER;

			if ((getVar("startValue")>getVar("endValue"))) {
				countDown=true;
				currentVal=getVar("startValue");
			}
			else {
				currentVal=getVar("startValue");
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