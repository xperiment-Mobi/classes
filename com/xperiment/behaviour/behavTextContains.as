package com.xperiment.behaviour
{
	import com.uberSprite;
	import com.xperiment.stimuli.addText;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.getDefinitionByName;
	
	public class behavTextContains extends behav_baseClass
	{
		
		private var textObjs:Array=new Array;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","words",""); //words seperated by a comma
			setVar("string","tally","0");
			super.setVariables(list);
		}
		
		override public function givenObjects(obj:uberSprite):void{	
			if(String(obj).indexOf("Text")){
				//trace(getValFromAction((obj as object_baseClass).getVar("behaviours")),22);
				switch(getValFromAction((obj as object_baseClass).getVar("behaviours"))){
					case "giveText":
						textObjs.push(obj  as object_baseClass);
						break;
					
					default:
						super.givenObjects(obj); //only accept Text stimuli
						break;
				}		
			}
			else if(logger)logger.log("! you have passed behavTextHighlight (peg="+getVar("peg")+") a non Text object... (of type "+String(obj).replace("object ","").replace("[","").replace("]","")+").");
		}
		
		override public function nextStep(id:String=""):void {	
			
			var txt:String;
			var wordList:Array=(getVar("words") as String).split(getVar("seperator"));
			wordList=wordList.filter(
				function(item:String,index:int,array:Array):Boolean{
					return item!="";
				}
			);
			
			for each(var obj:object_baseClass in behavObjects){ //filter can be applied to more than one object at a time.
				
				var tally:int=0;
				if(obj.hasOwnProperty("myText")){
					txt=(obj as addText).myText.text;
					for(var i:uint=0;i<wordList.length;i++){			
						if(txt.indexOf(wordList[i])!=1)tally++;
					}	
					OnScreenElements.tally=String(tally);
					this.behaviourFinished();
				}
			}
		}
		
		override public function storedData():Array {
			var tempData:Array
			tempData = new Array();
			if(peg!="")tempData.event=peg;
			else tempData.event="tally";
			tempData.data=String(getVar("tally"));
			super.objectData.push(tempData);
			
			return objectData;
		}
		
		override public function returnsDataQuery():Boolean {
			if(getVar("codeSave")!="") return true;
			else return false;
		}
		
	}
}