package com.xperiment.messages
{
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.stimuli.primitives.BasicButton;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class XperimentMessage extends Sprite
	{
		private static var messages:Vector.<TextField>;
		private static var button:BasicButton;
		
		public static function message(theStage:Stage, str:String,resetButton:Boolean=true):void
		{
			if(!messages){
				messages = new Vector.<TextField>;
				addText(theStage,"A low level error has occured. If you are not the person who made the experiment, please report this bug to bug@xperiment.mobi, telling us the name of the experiment. We apologise for your inconvenience and thankyou in advance for letting us know about this bug.",25);
			}
			
			addText(theStage,str);
			
			
			if(resetButton && !button && ExternalInterface.available==false){
				button = new BasicButton;
				button.label.text="reset"
				button.myWidth=theStage.stageWidth*.5;
				button.myHeight=theStage.stageHeight*.1;
				button.label.fontSize=20;
				button.init();
				
				theStage.addChild(button);
				button.x=theStage.stageWidth*.25;
				button.y=theStage.stageHeight*.9-button.height;
				
				button.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void{
					button.removeEventListener(MouseEvent.CLICK,arguments.callee);
					
					for(var i:int=0;i<messages.length;i++){
						if(theStage.contains(messages[i]))theStage.removeChild(messages[i]);
						messages[i]=null;
					}
					messages=null;
					theStage.removeChild(button);
					button.kill();
					theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.FINISH_STUDY,'true'));
				});
				
			}
		}
		
		
		
		private static function addText(theStage:Stage, str:String,size:int=12):void{
			var maxY:int=0;
			var h:int;
			for(var i:int=0;i<messages.length;i++){
				h=messages[i].y+messages[i].height;
				if(h>maxY)maxY=h;
			}
			
			var txt:TextField=new TextField;
			theStage.color=0x000000;
			
			txt.textColor=0xffffff;
			txt.text=str;
			txt.selectable=true;
			txt.name='xptMessage'
			theStage.addChild(txt);
			txt.width=theStage.stageWidth;
			txt.height=theStage.stageHeight;
			
			var format:TextFormat = new TextFormat();
			format.size = size;
			txt.setTextFormat(format);
			txt.autoSize=TextFieldAutoSize.LEFT;
			txt.wordWrap=true;
			txt.y=maxY+txt.height*.5;
			
			messages.push(txt);
		}
		
		public static function clear(theStage:Stage):void
		{
			if(messages){
				for(var i:int=0;i<messages.length;i++){
					if(theStage.contains(messages[i]))theStage.removeChild(messages[i]);
					messages[i]=null;
				}
			}
			messages=null;
		}
	}
}