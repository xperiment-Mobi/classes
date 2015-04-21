package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	public class addKeyPress extends object_baseClass
	{

		
		private var keys:Array;
		private var _keyPressed:String="";
			
			override public function setVariables(list:XMLList):void {
				setVar("int","key","",'you can add multiple keys here (no space)'); // use codes from here: http://www.asciitable.com/
				setVar("boolean","ascii",false,"","seperate ASCII values with a space");
				setVar("string","state","DOWN");//up or down 
				setVar("string","state","DOWN");//up or down 
				super.setVariables(list);
			}
				

			
			private function genKeys(ascii:Boolean, myKeys:String):void
			{
				if(ascii){		
					keys = myKeys.split(" ");
					for(var i:int=0;i<keys.length;i++){
						keys[i] = String.fromCharCode(	int(keys[i])	);
					}
				}
				else{
					keys = myKeys.split("");

				}
			}			
			
			
			override public function appearedOnScreen(e:Event):void{
				super.appearedOnScreen(e);
				var state:String=(getVar("state")as String).toUpperCase();
				
				if(state=="DOWN")theStage.addEventListener(KeyboardEvent.KEY_DOWN,keyPressed,false,0,true);
				else if(state=="UP")theStage.addEventListener(KeyboardEvent.KEY_UP,keyPressed,false,0,true);
				//else logger.log("!! You haev asked for an 'addKeyPress' but not correctly specified 'state' - can either be UP or DOWN");
			
				genKeys(getVar("ascii"),getVar("key"));
				
			}
			
			protected function keyPressed(e:KeyboardEvent):void
			{	
				_keyPressed = String.fromCharCode(e.keyCode);
	
				if(keys.indexOf(_keyPressed)!=-1){
					this.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				
				
				
			}
			override public function returnsDataQuery():Boolean{
				if(getVar("hideResults")!='true'){
					//trace(1111)
					return true;
				}
				return false;
			}
			
			
			private function myScore():String {return _keyPressed;}
			
			
			override public function storedData():Array {
				var tempData:Array=new Array  ;
				tempData.event=peg;
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