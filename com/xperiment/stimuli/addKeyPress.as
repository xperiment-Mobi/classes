package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;
	
	import flash.events.KeyboardEvent;

	public class addKeyPress extends object_baseClass
	{
		override public function returnsDataQuery():Boolean {return true;}
		
		private var _keyPressed:String="";
			
			override public function setVariables(list:XMLList):void {
				setVar("int","key","",'Prefix c if you want to use an ascii key code.'); // use codes from here: http://www.asciitable.com/
				setVar("string","state","DOWN");//up or down 
				
				super.setVariables(list);
			}
				
			override public function RunMe():uberSprite {
				var state:String=(getVar("state")as String).toUpperCase();
				if(state=="DOWN")theStage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressed,false,0,true);
				else if(state=="UP")theStage.addEventListener(KeyboardEvent.KEY_UP,keyPressed,false,0,true);
				//else logger.log("!! You haev asked for an 'addKeyPress' but not correctly specified 'state' - can either be UP or DOWN");
				
				super.setUniversalVariables();
				return (pic);
			}
			
			
			
			protected function keyPressed(e:KeyboardEvent):void
			{
				_keyPressed = String(e.keyCode);
				//trace(e.type, e.keyCode, String.fromCharCode(e.keyCode));
			}
			
			private function myScore():String {return _keyPressed;}
			
			
			override public function storedData():Array {
				
				var tempData:Array=new Array  ;
				tempData.event="keyPress-"+getVar("id");
				tempData.data=myScore();
				
				super.objectData.push(tempData);
				return objectData;
				}

			
			override public function kill():void {
				if(theStage.hasEventListener(KeyboardEvent.KEY_DOWN)) theStage.removeEventListener(KeyboardEvent.KEY_DOWN,keyPressed);
				if(theStage.hasEventListener(KeyboardEvent.KEY_UP)) theStage.removeEventListener(KeyboardEvent.KEY_UP,keyPressed);
				super.kill();
			
		}
	}
}