package com.xperiment.stimuli
{
	import com.bit101.components.PushButton;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Dictionary;

	public class addTouchScreen extends object_baseClass
	{
		public var buttonCount:uint=1;
		public var button:PushButton;
		private var mouseDown4BehavBoss:Function;
		private var startTime:Number;
		private var develMode:Boolean;
		////BehaviourBoss Events links.
		////If BehaviourBoss finds the approp named function, passes it a function to call when the
		////given behaviour occurs.
		////
		private var touchData:TextField;
		private var dataFormat:Boolean = true;
		
		

		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('text')==false){
				uniqueProps.text= function(what:String=null,to:String=null):String{
					if(what) button.label=to;
					return button.label;
				}; 	
			}

			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
	
		
		override public function setVariables(list:XMLList):void {
			setVar("int","backgroundColour",0x000fff);
			setVar("boolean","showData",false);
			setVar("string","dataFormat", 'screenPixels'); //screenPixels, boxPixels
			super.setVariables(list);
			
			if(getVar('dataFormat')=='boxPixels') dataFormat=false;
		}
		
		override public function RunMe():uberSprite {
			pic.graphics.beginFill(0x000666);
			pic.graphics.drawRect(0,0,100,100);
			startTime=(new Date).valueOf();	
	

			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			pic.addEventListener(TouchEvent.TOUCH_BEGIN,touched)
				
			//development stuff			
			if(ExptWideSpecs.IS("isDebugger")){
				develMode=true;
				eventAction(MouseEvent.MOUSE_DOWN,pic);	
			}
			
			if(getVar('showData') as Boolean){
				touchData = new TextField;
				touchData.width=pic.width;
				touchData.height=pic.height;
				touchData.x=pic.x;
				touchData.y=pic.y;
				
				touchData.selectable=false;
				touchData.textColor=0xFFFFFF;

				
				touchData.text='x:\ny:\ntime:\npressure:';
				pic.addChild(touchData);
			}

			theStage.addEventListener(TouchEvent.TOUCH_BEGIN,touched)

			super.setUniversalVariables();
			
			return pic;
		}
		
		private function touched(e:TouchEvent):void{
			if(pic)pic.addEventListener(TouchEvent.TOUCH_MOVE,touchMove)
		}
		
		protected function touchMove(e:TouchEvent):void
		{
			if(touchData){
				if(dataFormat)	printTouch(e.stageX, e.stageY,(new Date).valueOf()-startTime,e.pressure);
				else 			printTouch(e.localX*pic.scaleX, e.localY*pic.scaleY,(new Date).valueOf()-startTime,e.pressure);
			}	
		}
	
		
		private function printTouch(sx:Number, sy:Number, time:Number, pressure:Number):void
		{
			touchData.text='x:' + sx +'\ny: '+ sy +'\ntime: '+ String(time) +'\npressure: '+ pressure.toString();
			trace('x:' + sx +'\ny: '+ sy +'\ntime: '+ String(time) +'\npressure: '+ pressure.toString())
		}
		
			

		
		override public function kill():void {
			
			if(touchData){
				pic.removeChild(touchData);
				touchData=null;
			}
		
			if(pic){
				pic.removeEventListener(TouchEvent.TOUCH_BEGIN,touched);
				if(pic.hasEventListener(TouchEvent.TOUCH_MOVE))pic.removeEventListener(TouchEvent.TOUCH_BEGIN,touched);
				if(develMode){
					eventAction(MouseEvent.MOUSE_DOWN,pic,true);
					eventAction(MouseEvent.MOUSE_UP,theStage,true);
					eventAction(MouseEvent.MOUSE_MOVE,pic,true);				
				}
			}
			super.kill();
		}
		
		
		
		
		///////////////////////////development stuff
		
		
		private function eventAction(action:String, what:*, remove:Boolean=false):void{
			
			var funct:Function;
			switch(action){
				case MouseEvent.MOUSE_DOWN: funct= mouseDown; break;
				case MouseEvent.MOUSE_UP:	funct= mouseUp; break;
				case MouseEvent.MOUSE_MOVE:	funct= mouseMove; break;
			}

			
			if(remove && Boolean(funct)){
				if(what.hasEventListener(action))what.removeEventListener(action,funct);
			}
			else if (Boolean(funct)){
				if(!what.hasEventListener(action))what.addEventListener(action,funct);
			}
			else throw new Error("unexpected event in addTouchScreen");
			
		}
		
		protected function mouseUp(e:MouseEvent):void
		{
			eventAction(MouseEvent.MOUSE_UP,theStage,true);
			eventAction(MouseEvent.MOUSE_MOVE,pic,true);	
			
		}
		
		protected function mouseDown(e:MouseEvent):void
		{
			eventAction(MouseEvent.MOUSE_UP,theStage);
			eventAction(MouseEvent.MOUSE_MOVE,pic);	
		}
		
		protected function mouseMove(e:MouseEvent):void
		{
			trace(touchData);
			if(touchData){
				if(dataFormat)	{
					printTouch(e.stageX, e.stageY,(new Date).valueOf()-startTime,1);
				}
				else 			{
					printTouch(e.stageX-pic.x, e.stageY-pic.y,(new Date).valueOf()-startTime,1);
				}
			}	
		}
		
		
	}
}