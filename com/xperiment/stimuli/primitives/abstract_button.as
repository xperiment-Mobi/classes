package com.xperiment.stimuli.primitives
{

	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.Dictionary;
	
	public class abstract_button extends object_baseClass
	{
		public static var buttonGroup:Object;
		public static var buttonGroupDataSaved:Object;
		public var buttonGroupOnlyOneSelected:*;
		public var buttonCount:uint=0;
		
		
		
		override public function setVariables(list:XMLList):void {
		
			setVar("string","buttonGroup","");
			setVar("boolean","buttonGroupOnlyOneSelected",true);
			setVar("string","answer","","returns true or false");
			super.setVariables(list);
			
			if(getVar("buttonGroup")!=""){
				
				buttonGroup ||={};
				buttonGroup[getVar("buttonGroup")] ||= [];
				buttonGroupDataSaved ||={};
				buttonGroupDataSaved[getVar("buttonGroup")] = false;
				buttonGroup[getVar("buttonGroup")].push(this);
				buttonGroupOnlyOneSelected = getVar("buttonGroupOnlyOneSelected");
			}
			
		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('answer')==false){
				uniqueProps.answer= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) OnScreenElements.answer = codeRecycleFunctions.removeQuots(to);
					
					if(selectedIsCorrect())	return 'true';
					else return 'false';
				}; 	
			}
			
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			
			return super.myUniqueProps(prop);
		}
		
		
		public function buttonGroupComposeResult():void{
			if(getVar("buttonGroup")!=""){

				if(getVar("answer")==""){
					var clicked:Array=composeDataArray();
					if(clicked.length>0){
						objectData.push({event:getVar("buttonGroup"),data:clicked.join(",")});
					}
				}
				else if(buttonGroup[getVar("buttonGroup")]){	
					
					objectData.push({event:'answer',data:selectedIsCorrect()});
					buttonGroup[getVar("buttonGroup")]=null;
				}
			}

		}
		
		public function selectedIsCorrect():Boolean{
			var answer:String = getVar("answer");

			for each(var b:abstract_button in buttonGroup[getVar("buttonGroup")]){
			
				if(b.buttonCount>0 && b.peg==answer)return true;
			}
			return false;
		}
		
		public function currentlySelected():String{
		
			for each(var b:abstract_button in buttonGroup[getVar("buttonGroup")]){
				if(b.buttonCount>0)return b.peg;
			}
			
			return '';
		}
		
		public function composeDataArray():Array{
			if(buttonGroupDataSaved[getVar("buttonGroup")]==false){
			buttonGroupDataSaved[getVar("buttonGroup")]=true;
			var clicked:Array=[];
			for each(var b:abstract_button in buttonGroup[getVar("buttonGroup")]){
				if(b.buttonCount>0)clicked.push(b.peg);
			}
			return clicked;
			}
			else return [];
		}
		
		
		
		public function __deselectOthersInButtonGroup():void
		{
			throw new Error("override svp");
		}
		
		public override function kill():void{
			if(buttonGroup && buttonGroup[getVar("buttonGroup")]){
				buttonGroup[getVar("buttonGroup")]=null;
				buttonGroupDataSaved[getVar("buttonGroup")]=null;
			}			
			
			super.kill();
		}
		
		
	}
}