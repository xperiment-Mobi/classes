package com.xperiment.stimuli.primitives.windows
{
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	
	
	public class WindowPrimitive extends Sprite
	{
		public var myWindow:Window;
		protected var params:Object;
		protected var txt:String;
		public var closeButton:PushButton;
		public var headerTxt:TextField;
		protected var textArea:TextArea;
		protected var bigClose:TextField;
		
		public var button3:PushButton;
		public var button2:PushButton;
		
		public function updateText(str:String):void{
			textArea.text=str;
		}
		
		public function updateHeader(str:String):void{
			headerTxt.htmlText=str;
		}
		
		public function WindowPrimitive(obj:Object)
		{
			//this.addChild(parent);

			params=obj;
			setVar("title","");
			myWindow=new Window(this,0,0,obj.title);
			this.addChild(myWindow);
			myWindow.title=params.title;
			myWindow.hasCloseButton=true;
			
			myWindow.width=int(obj.width);
			myWindow.height=int(obj.height);
			
		}
		
		
		
		private function setVar(nam:String,dat:String):void{
			if(params[nam]==undefined)params[nam]=dat;
			
		}
		
		
		public function setheaderText(header:String):void
		{
			headerTxt.text=header;
		}
		
		
		
		public function addMessage(header:String,str:String):void{
			headerTxt=new TextField;
			headerTxt.textColor=Style.LABEL_TEXT;
			headerTxt.wordWrap=true;
			headerTxt.width=myWindow.width*.8;
			headerTxt.x=myWindow.width*.1;
			headerTxt.htmlText=header;
			
			if(params.hasOwnProperty('headerSize')){
				var tf:TextFormat = new TextFormat;
				tf.size=params['headerSize'];
				headerTxt.setTextFormat(tf);
				headerTxt.defaultTextFormat=tf;
				
			}
			headerTxt.autoSize=TextFieldAutoSize.LEFT;
			myWindow.addChild(headerTxt);
			
			txt=str;
		
			textArea=new TextArea;

			textArea.wordWrap=true;
			textArea.fontSize=12;
			textArea.width=myWindow.width*.8;
			textArea.editable=false;
			
			textArea.x=myWindow.width*.1;
			
			textArea.text=str;
			textArea.selectable=true;
			
			setupButtons();
			
			if(params.textAreaVisible !=undefined && params.textAreaVisible==false)textArea.visible=false;
			else myWindow.addChild(textArea);
			
			headerTxt.y=closeButton.height+60;
			textArea.y=headerTxt.y+headerTxt.height+30;
			
			textArea.height=myWindow.height-textArea.y-30;
		}
		
		protected function setupButtons():void
		{
			if(params.hasOwnProperty('closButtonText')==false)params.closButtonText = "close when ready";
			closeButton = new PushButton(myWindow,0,0,params.closButtonText);
			closeButton.addEventListener(MouseEvent.CLICK,close ,false,0,true);
			closeButton.width=200;
			closeButton.wordWrap=true;
			closeButton.height=200;
			closeButton.y=30;
			
			closeButton.x=myWindow.width*.5-closeButton.width*.5;
			
		}
		
		protected function testIfInclude(param:String):Boolean
		{
			if(params.hasOwnProperty(param))return params[param]
			return true;
		}
		
		
		protected function close(e:MouseEvent):void
		{
			myWindow.dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function kill():void{
			if(button3)button3.removeEventListener(MouseEvent.CLICK,params.sendButtonListener);
			if(button2)button2.removeEventListener(MouseEvent.CLICK,params.pushButtonListener);
			
			closeButton.removeEventListener(MouseEvent.CLICK,close);
			params.closButtonListener=null;
			this.dispatchEvent(new Event(Event.CLOSE));
			if(myWindow)myWindow.removeChildren();
			headerTxt=null;
			textArea=null;
			myWindow = null;
		}
		

	}
}