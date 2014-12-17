package com.xperiment.stimuli{

	import com.bit101.components.Style;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.events.GotoTrialEvent;
	import com.xperiment.stimuli.primitives.BasicButton;
	import com.xperiment.stimuli.primitives.IResult;
	import com.xperiment.stimuli.primitives.KeyPress;
	import com.xperiment.stimuli.primitives.abstract_button;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	
	
	public class addButton extends abstract_button implements Imockable, IButton, IResult{
		
		public var button:BasicButton;
		private var mouseDown4BehavBoss:Function;
		private var key:KeyPress;
		
		override public function returnsDataQuery():Boolean{

			if(getVar("hideResults")!='true'){
				//trace(1111)
				return true;
			}
			return false;
		}
		
		override public function __deselectOthersInButtonGroup():void
		{
			for each(var b:addButton in buttonGroup[getVar("buttonGroup")]){
				b.buttonCount=0;
				b.button.selected=false;
			}
		}
				
		
		public function mock():void{
		
			var t:Timer = new Timer(50,0);
			t.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
				e.target.removeEventListener(e.type,arguments.callee);
				t.stop();
				if(button){
					button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			});
			t.start();
		}
		
		override public function storedData():Array {

			var tempData:Array = new Array();
			if(!buttonGroup){
				if(getVar("whichPressed")!=''){
					if(buttonCount>0)	objectData.push({event:getVar("whichPressed"),data:peg});
				}
				if(buttonCount>0){
					objectData.push({event:peg,data:buttonCount});
				}
			}
			else buttonGroupComposeResult();
						
			return objectData;
		}
		


		override public function myUniqueProps(prop:String):Function{			
			if(!uniqueProps){
				uniqueProps=new Dictionary;
				uniqueProps.text= function(what:String=null,to:String=null):String{
					
										if(what) button.label.text= codeRecycleFunctions.removeQuots(to);
										return codeRecycleFunctions.addQuots(button.label.text);
									}; 			
				uniqueProps.enabled=function(what:String=null,to:String=null):String{
										if(what) button.enabled=Boolean(to);
										return button.enabled.toString();
									};	
				uniqueProps.pressed=function(what:String=null,to:String=null):String{
					if(what) buttonCount=int(to);
					return buttonCount.toString();
				};
				uniqueProps.result= function():String{
					//AW Note that text is NOT set if what and to and null. 
					//trace(123,"'"+multipleChoice.getData()+"'");
					return "'"+composeDataArray().toString()+"'";
				};

			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		public function mouseDown(md:Function):void{mouseDown4BehavBoss=md;}
		////
		////
		
		override public function setUpTrialSpecificVariables(trialObjs:Object):void {
			super.setUpTrialSpecificVariables(trialObjs);
		}
		
		
		
		override public function setVariables(list:XMLList):void {
			setVar("string","text","next");
			setVar("string","goto", "nextTrial");
			setVar("number","alpha",.9,"0-1");
			setVar("int","fontSize",-1);
			setVar("uint","width",80);
			setVar("uint","height",22);
			setVar("boolean","enabled",true);
			setVar("boolean","sticky",false);
			setVar("string","whichPressed",'');
			setVar("string","key","",'Prefix c if you want to use an ascii key code, which you can get from http://www.asciitable.com/. Else just enter the key. Or enter ← → ↑ ↓ for cursor keys.'); 	// use codes from here: http://www.asciitable.com/  
										//or figure out codes by pressing from here http://www.kirupa.com/developer/as3/using_keyboard_as3.htm

			super.setVariables(list);
			
			if(getVar("fontSize")==-1){
				OnScreenElements.fontSize=Style.fontSize;
			}

			
			if(getVar("behaviours")!="")setVar("string","goto","")
		}
		
		override public function RunMe():uberSprite {

			
			
			if(theStage)theStage.focus=pic;
			
			
			super.setUniversalVariables();
			
			pic.scaleX=1;
			pic.scaleY=1;
			
			this.button=new BasicButton();
			if(getVar("enabled") == false){
				button.enabled=false;
			}
			button.label.text=getVar("text");
			if(getVar("sticky"))button.toggle=true;
			button.name="buttonAction";
			button.myWidth=pic.myWidth;
			button.myHeight=pic.myHeight;
			button.label.fontSize=getVar("fontSize");
			button.init();

			pic.addChild(button);
			button.x=0
			button.y=0;
			
			events(true);

			
			return (pic);
		}
		

		
		override public function appearedOnScreen(e:Event):void{
			if(key){
				key.init();
			}
			super.appearedOnScreen(e);
		}
		


		
		override public function kill():void {
			
			if(key)key.kill();
			mouseDown4BehavBoss=null;
			removeEvents();
			if(button && pic.contains(button))pic.removeChild(button);
			if(button)button.kill();
			button=null;
			super.kill();
		}
		
		override public function events(active:Boolean):void
		{
			if(active)addListeners();
			else removeEvents();
		}
		
		private function removeEvents():void
		{
			if(button && button.hasEventListener(MouseEvent.MOUSE_DOWN))this.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDown);

		}
		
		private function addListeners():void
		{
			
			
			if(!(getVar("disableMouse") as Boolean))button.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown,false,0,true);
			
			if(getVar("key")!="" && theStage){
				key = new KeyPress(getVar("key"),theStage,this,button);			
			}
		}
		
		public function MouseDown(e:MouseEvent):void {
			//needed for key presses
			if(button && button.enabled){
				if(mouseDown4BehavBoss!=null)mouseDown4BehavBoss();
				
				e.stopPropagation();
				var tempData:Array = new Array;
				var s:String= '';
				if(getVar("hideResults").toLowerCase !="true"){
					//trace(getVar("hideResults"),222);
					__logButtonPress();
				}
				
				checkIfGoto();
			}
		}
		
		public function __logButtonPress():void{
			if(buttonGroup && buttonGroupOnlyOneSelected)__deselectOthersInButtonGroup();
			buttonCount++;
		}
		
		private function checkIfGoto():void
		{
			var _goto:String = getVar("goto");
			if (_goto!="" && theStage) {
				events(false);
				if(_goto.toLowerCase()=="next")_goto=GotoTrialEvent.NEXT_TRIAL;
				else if(_goto.toLowerCase()=="prev")_goto=GotoTrialEvent.PREV_TRIAL;
				var goEvent:GotoTrialEvent = new GotoTrialEvent(GotoTrialEvent.TRIAL_PING_FROM_OBJECT,_goto);				
				parentPic.dispatchEvent(goEvent);
			}
		}
		
	}
}

