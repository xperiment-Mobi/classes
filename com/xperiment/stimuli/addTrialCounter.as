package  com.xperiment.stimuli{
	

	import com.bit101.components.Style;
	import com.xperiment.uberSprite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class addTrialCounter extends object_baseClass  {
		
		private var myBackground:Shape;
		private var myBar:Shape;
		private var combined:Sprite;
		private var bckground:Shape;
		private var text:TextField;
		

		private static var trials_i:int = 0;
	
		
		override public function setVariables(list:XMLList):void {
			setVar("number","backBarColour",0xFFFFFF);
			setVar("number","backBarLineColour",0xc5c5c7);
			setVar("number","backBarLineThickness",6);
			setVar("number","barColour",0x0738f2);
			setVar("number","trials",1);
			setVar("int","fontSize",15);
			setVar("int","fontColour",Style.LABEL_TEXT);
			super.setVariables(list);
			
			

		}
		
		
		
		private function finish(e:Event=null):void{
			if(pic.hasEventListener(Event.ADDED_TO_STAGE))pic.removeEventListener(Event.ADDED_TO_STAGE,finish);
			updateInfo("done");
			this.dispatchEvent(new Event("onFinish",true));
		}
		
		override public function RunMe():uberSprite {
			super.setUniversalVariables();
			var _width:int=pic.width;
			var _height:int=pic.height;
			
			pic.scaleX=1;
			pic.scaleY=1;
			
			trials_i++;
			
			combined= new Sprite;
			myBackground=new Shape  ;
			myBackground.graphics.beginFill(getVar("backBarColour"));
			myBackground.graphics.lineStyle(getVar("backBarLineThickness"),getVar("backBarLineColour"));
			myBackground.graphics.drawRect(0,0,this.myWidth,this.myHeight);
			myBackground.graphics.endFill();
			combined.addChild(myBackground);
			
			myBar=new Shape  ;
			myBar.graphics.beginFill(getVar("barColour"));
			myBar.graphics.drawRoundRect(2,2,this.myWidth/getVar("trials")*trials_i,this.myHeight,15,15);

			combined.addChild(myBar);
			

			
			
			createInfo();
			
			super.pic.addChild(combined);
			
			
			return (super.pic);
		}
		
	
		
		private function createInfo():void{
			
			text= new TextField;
			text.defaultTextFormat = new TextFormat(null, getVar("fontSize"),getVar("fontColour"));
			text.text = getText();
			text.autoSize=TextFieldAutoSize.CENTER
			
			
			bckground =new Shape  ;
			bckground.graphics.beginFill(getVar("backBarColour"));
			bckground.graphics.endFill();
			bckground.alpha=.5;

			
			combined.addChild(bckground);
			combined.addChild(text);
			
			text.x=combined.width*.5 - text.width*.5;
			text.y=combined.height*.5-text.height*.5;
			
		}	
		
		
		private function updateInfo(message:String):void{
			
			if(text)text.text(message);
		}
		
		
		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			
		}
		
		
		private function getText():String{
			return "trial " + trials_i.toString() + '/' + getVar("trials").toString();
		}
		

		
		override public function kill():void{
			
			if(combined){
				for(var i:int=0;i<combined.numChildren;i++){
					combined.removeChildAt(i);
				}
				pic.removeChild(combined)
			}
			bckground=null;
			
			text=null;
	
			myBackground=null;
			myBar=null;
			combined=null;
			
			super.kill();
			
		}
	}
}

