package com.xperiment.behaviour
{
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addText;
	import com.xperiment.stimuli.object_baseClass;

	public class behavSearch extends behav_baseClass
	{
		
		private var textObjs:Array=new Array;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","words",""); //words seperated by a comma
			setVar("string","suffixes","");
			setVar("string","prefixes","");
			setVar("boolean","tally",false);
			setVar("boolean","onWordListToo",false);
			setVar("string","codeStart","");
			setVar("string","seperator",",");
			setVar("string","codeEnd","");
			setVar("string","codeSave","");
			setVar("string","groupedTally","");
			setVar("string","prefixesWhenNotFound","");
			setVar("string","suffixesWhenNotFound","");
			setVar("string","correctList","");
			setVar("string","foundList","");
			setVar("boolean","changeText",false);
			setVar("boolean","storeIfNotFound",false);
			super.setVariables(list);
		}
				
		override public function givenObjects(obj:uberSprite):void{	
			//trace(222222222666,obj);
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
			//else if(logger)logger.log("! you have passed behavTextHighlight (peg="+getVar("peg")+") a non Text object... (of type "+String(obj).replace("object ","").replace("[","").replace("]","")+").");
		}
		
		override public function nextStep(id:String=""):void {	
			
			var txt:String;
			var wordList:Array=(getVar("words") as String).split(getVar("seperator"));
			wordList=wordList.filter(
				function(item:String,index:int,array:Array):Boolean{
					return item!="";
				}
			);
			//trace(peg,2222,getVar("words"),wordList);
			//if(getVar("codeStart")!="")doCodeStart();
			//trace(wordList,22);

			var suffixes:Array=(getVar("suffixes")as String).split(",");
			var prefixes:Array=(getVar("prefixes")as String).split(",");
			var otherSuffixes:Array = getVar("suffixesWhenNotFound").split(",");
			var otherPrefixes:Array = getVar("prefixesWhenNotFound").split(",");
			//trace(otherSuffixes,"    ",otherPrefixes,getVar("suffixesWhenNotFound"));
			var regexp:RegExp;
			var tally:uint;
			var rollingTally:Array;
			var updatedTxt:String;
			var foundList:Array = new Array;

			for each(var obj:object_baseClass in behavObjects){ //filter can be applied to more than one object at a time.

				rollingTally=new Array;
				tally=0;
				if(obj.hasOwnProperty("myText")){
					txt=(obj as addText).text();
					updatedTxt=txt;
					for(var i:uint=0;i<wordList.length;i++){

						regexp=new RegExp(wordList[i],"/b");
						//nb below. txt is compared to addText.text later on so cannot be updated like so: txt=txt.replace(bla, text);
						//trace(222,wordList[i],"::",txt,txt.indexOf(wordList[i]));
						
						//if(txt.indexOf(wordList[i])!=-1)trace(5,wordList[i],updatedTxt);
						//updatedTxt=txt.replace(regexp,prefixes[i%prefixes.length]+wordList[i]+suffixes[i%prefixes.length]);
						//updatedTxt=txt.replace(regexp,prefixes[i%prefixes.length]+wordList[i]+suffixes[i%prefixes.length]);
						//trace(4,wordList[i],updatedTxt);
						
						if(txt.indexOf(wordList[i])!=-1){
							tally++;
							rollingTally.push(true);
							foundList.push(prefixes[i%prefixes.length]+wordList[i]+suffixes[i%suffixes.length]);
							if(OnScreenElements.correctList=="")OnScreenElements.correctList=wordList[i];
							else OnScreenElements.correctList+=","+wordList[i];
							//trace(peg,222,OnScreenElements.correctList)
						}
						else {
							//foundList.push(otherPrefixes[i%otherPrefixes.length]+wordList[i]+otherSuffixes[i%otherSuffixes.length]);
							if(getVar("storeIfNotFound")){
								rollingTally.push(otherPrefixes[i%otherPrefixes.length]+wordList[i]+otherSuffixes[i%otherSuffixes.length]);
								foundList.push(otherPrefixes[i%otherPrefixes.length]+wordList[i]+otherSuffixes[i%otherSuffixes.length]);
							}
						}
						txt=updatedTxt;
					}
					
					if(getVar("changeText") as Boolean)(obj as addText).text(updatedTxt);
					//trace("updated:",foundList);
					
					OnScreenElements.foundList=foundList.join(getVar("seperator"));
			//trace("foundList::"+OnScreenElements.foundList);
			

					if(getVar("codeSave")!="" && rollingTally && getVar("groupedTally")!=""){
						var divisionList:Array=(getVar("groupedTally") as String).split(",");
						//var divisionList:Array=["0-5","6-10","11-15"];
						//trace("in here",divisionList);
						var data:Array=new Array;
						for (i=0;i<divisionList.length;i++)data.push(0);
						var min:Number;
						var max:Number;
						var split:Array;
						for(i=0;i<rollingTally.length;i++){
							for(var j:uint=0;j<divisionList.length;j++){
								split=divisionList[j].split("-");
								if(split.length==2 && !isNaN(Number(split[0])) && !isNaN(Number(split[1]))){
									min=Number(split[0]);
									max=Number(split[1]);
								
									if(i>=min && i<=max && rollingTally[i]==true)data[j]++;
								}
								else{
									data[j]="Prob with your division list: should be e.g.0-5,6-10,11-15"
								}
							}
						}
						
						for(j=0;j<data.length;j++){
							putInResults(getVar("peg")+"G"+divisionList[j],data[j]);
							//trace(333,getVar("peg")+"G"+divisionList[j],data[j]);
						}
					}
					if(getVar("tally") as Boolean)putInResults(getVar("peg"),String(tally));	
				}
			}
			
			this.behaviourFinished();
		}
		
		
		override public function storedData():Array {
			
			
			//putInResults(event:String,data:String)
			
			return objectData;
		}
		
		override public function returnsDataQuery():Boolean {
			if(getVar("codeSave")!="") return true;
			else return false;
		}
		
		
		/*private function doCodeStart():void
		{
			var protoWord:String=getVar("codeStart");
			//trace("in herer");
			for each(var obj:object_baseClass in behavObjects){
				if(obj.hasOwnProperty("myText")){
					//trace("in here");
					(obj as addText).text((obj as addText).myText.htmlText+"<BR>"+protoWord);
				}
			}
		
		}*/
	}
}