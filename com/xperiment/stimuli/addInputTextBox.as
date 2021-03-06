﻿
package  com.xperiment.stimuli{

	import com.bit101.components.Style;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.addText;
	import com.xperiment.stimuli.primitives.IResult;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;


	public class addInputTextBox extends addText implements IResult, Imockable {

		private var replaceOld:Array;
		private var replaceNew:Array;
		private var correct:Array;
		
		override public function kill():void {
			if(pic.hasEventListener(MouseEvent.MOUSE_DOWN))pic.addEventListener(MouseEvent.MOUSE_DOWN,emptyL);
			super.kill();
		}
		
		public function mock():void{
			text(String(int(Math.random()*1000)));
		}
		
		override public function storedData():Array {
			var tempData:Array = new Array();
			if(getVar("peg")=="")tempData.event="InputTextBox";
			else tempData.event=getVar("peg");
			tempData.data=basicText.text();
			
			if(tempData.data==getVar("text"))tempData.data="unmodified";
			
			
			super.objectData.push(tempData);
			return objectData;
		}

		override public function returnsDataQuery():Boolean {
			return true;
		}
		

		
		override public function myUniqueProps(prop:String):Function{

			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('correct')==false){
				
				uniqueProps.correct= function():String{
					//AW Note that text is NOT set if what and to and null. 
					var result:String = '';
					return checkCorrect();
				}	
			}
			if(uniqueProps.hasOwnProperty('result')==false){
				
				uniqueProps.result= function():String{
					//AW Note that text is NOT set if what and to and null. 
					var result:String = '';
					if(basicText.myText.text==getVar("text"))return "''";
					return codeRecycleFunctions.addQuots(basicText.myText.text);
				}	
			}	

			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		private function checkCorrect():String
		{
			var correct:Array = getVar("correct").split(",");
			if(correct.indexOf(basicText.text())!=-1)return 'true';
			
			return 'false';
		}
		
		
		override public function setVariables(list:XMLList):void {
			
			if(!list.hasOwnProperty('@numLines'))list.@numLines=true;
			if(!list.hasOwnProperty('@text'))list.@text='';
			if(!list.hasOwnProperty('@border'))list.@border=1;
			if(!list.hasOwnProperty('@background'))list.@background=Style.BACKGROUND
			if(!list.hasOwnProperty('@wordWrap'))list.@wordWrap=true;
			if(!list.hasOwnProperty('@multiLine'))list.@multiLine=false;
		
			list.@editable=setEditable();
			list.@selectable=true;
			
			if(!list.hasOwnProperty('@maxChars'))list.@maxChars = 1000;
			if(!list.hasOwnProperty('@password'))list.@password = false;
			if(!list.hasOwnProperty('@restrict'))list.@restrict = "";
			if(!list.hasOwnProperty('@hideResults'))list.@hideResults = false;
			if(!list.hasOwnProperty('@emptyWhenClicked'))list.@emptyWhenClicked = true;
			if(!list.hasOwnProperty('@editable'))list.@editable = true;
			if(!list.hasOwnProperty('@correct'))list.@correct = "";
			if(!list.hasOwnProperty('@replace'))list.@replace =  "";
			
			if(getVar("replace")!=""){
				replaceOld=new Array;
				replaceNew=new Array;
				var arr:Array=(getVar("replace") as String).split(",");
				var sub:Array;
				for each(var str:String in arr){
					sub=str.split("-");
					replaceOld.push(uint(sub[0]));
					replaceNew.push(uint(sub[1]));
				}			
			}
			
			super.setVariables(list);

			if(OnScreenElements.hasOwnProperty('emptyWhenClicked') && OnScreenElements.emptyWhenClicked=='true'){
				pic.addEventListener(MouseEvent.MOUSE_DOWN,emptyL);
			}
			
		}
		
		
		
		protected function setEditable():Boolean{
			return true;
		}
	

		protected function emptyL(event:MouseEvent):void
		{
			//trace(11)
			basicText.text('');
			
		}
		
		override public function mouseTransparent():void{
			//basicText.myText.mouseEnabled = false;
			super.mouseTransparent();
		}


	}
}