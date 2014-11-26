package com.xperiment.stimuli
{
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class addFrameRate extends object_baseClass
	{

		
		private static var originalFrameRate:int;
		private var frames:int= 0;
		private var curTimer:int;
		private var prevTimer:int;
		private var t:TextField;
		
		
		override public function kill():void{
			if(t){
				theStage.stage.removeEventListener(Event.ENTER_FRAME,performFrameTest);
				theStage.removeChild(t);
				t=null;
			}
		}
		
		override public function setVariables(list:XMLList):void {
			
			setVar("int","value",0);
			setVar("boolean","show",false);
			
			super.setVariables(list);
			
			
			if(int(getVar("value"))!=0){
				originalFrameRate=theStage.frameRate;
				theStage.stage.frameRate=int(getVar("value"));			
			}
			
			if(getVar("show")){
				t = new TextField;
				t.background = true;
				t.backgroundColor=0xffffff;
				t.textColor=0x000000;
				t.height=20;
				t.text="FPS: "+theStage.stage.frameRate;
				theStage.addChild(t);
				t.x=0;
				t.y=0;
				theStage.stage.addEventListener(Event.ENTER_FRAME,performFrameTest);
			}
		}
		
		
		
		
		private function performFrameTest(e:Event):void {
			frames+=1;
			curTimer=getTimer();
			if(curTimer-prevTimer>=1000){
				t.text = "FPS: "+ Math.round(frames*1000/(curTimer-prevTimer)).toString();
				prevTimer=curTimer;
				frames=0;
			}
		}
		
		override public function myUniqueProps(prop:String):Function{			
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('value')==false){
				uniqueProps.value= function(what:String=null,to:String=null):String{
					
					if(what) theStage.stage.frameRate=int(to);
					return to.toString();
				};
			}
			if(uniqueProps.hasOwnProperty('original')==false){
				uniqueProps.original= function(what:String=null,to:String=null):String{
					
					if(what) originalFrameRate=int(to);
					return originalFrameRate.toString();
				}; 	
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
	}
}