package com.xperiment.stimuli
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.Results.Results;
	import com.xperiment.StringStuff.StringProcessing;
	import com.xperiment.stimuli.primitives.MultipleChoice;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.xperiment.stimuli.primitives.BasicText;
	
	public class addQAs extends object_baseClass
	{
		
		private var results:Results;
		private var template:Object
		private var items:Array;
		private var templateStr:String;
		private var title:String;
		private var overlay:Sprite;
		private var questionLabels:Array;
		
		override public function setVariables(list:XMLList):void {
			
			setVar("string","list","");//list name
			setVar("string","item",""); //starts from 1,2,3,4 etc; position in the list
			setVar("string","titleformating","b,l");
			setVar("boolean","randomizeQs",true);
			setVar("string","saveWhat","frequencies,numCorrect,questionLabelsScores");
			
			setVar("string","cr","correct");
			setVar("boolean","oneAfterTheOther",false);
			setVar("boolean","hideOnceAnswered",false);
			super.setVariables(list);
			
		}
		
		
		
		override public function RunMe():uberSprite {
			results = Results.getInstance();
			templateStr = results.getStoredVariable(getVar("list")+"<~~TEMPLATE~~>");
			var pos:int;
			
			var template:Object;
			pos=templateStr.indexOf(":");
			//As:addMultipleChoice:Yes,No
			
			if(templateStr.length>5 && templateStr.substr(0,3)=="As:"){  //first checks that As is at the start
				templateStr=templateStr.substr(3);
				//trace(templateStr);
				pos=templateStr.indexOf(":"); //then checks to see if there is another seperator
				if(pos!=-1){//if so, creates the template
					template=StringProcessing.StringToObject(templateStr);
				}
				else template={};
			}
			
			var itemsStr:String=results.getStoredVariable(getVar("list")+getVar("item"));
			var itemsArr:Array=itemsStr.split(String.fromCharCode(10));
			
			//trace(getVar("item"),itemsStr);
			
			items=[];
			var obj:Object;
			var str:String;
			
			
			//////////////RANDOMISE Qs
			//////////////
			var QsArr:Array=[];
			var posArr:Array=[];
			if(getVar("randomizeQs") as Boolean ==true || getVar("randomiseQs")=="true"){
				for(var i:uint=0;i<itemsArr.length;i++){
					if(String(itemsArr[i]).substr(0,2)=="Q:"){
						QsArr.push(itemsArr[i]);
						posArr.push(i);
					}
				}
			}
			posArr=codeRecycleFunctions.arrayShuffle(posArr);
			
			for(i=0;i<posArr.length;i++){
				itemsArr[posArr[i]]=QsArr.shift();						
			}
			//////////////
			//////////////
			
			
			for (i=0;i<itemsArr.length;i++){
				
				if(String(itemsArr[i]).substr(0,2)=="T:"){
					obj=new Object;
					obj.type="text";
					obj.text=String(itemsArr[i]).substr(2);
					var arr1:Array=(getVar("titleformating") as String).split(",");
					
					for(var j:uint=0;j<arr1.length;j++){
						obj.text="<"+arr1[j]+">"+obj.text+"</"+arr1[j]+">";
					}
					
					items.push(obj);
				}
				else if(String(itemsArr[i]).substr(0,2)=="Q:"){ 
					str=String(itemsArr[i]).substr(2);
					
					obj=new Object;
					obj.type="question";
					obj.text=str;
					obj.answeredWith="";
					
					if(i<itemsArr.length-2 && (itemsArr[i+1] as String).substr(0,2)=="A:"){ //if an 'A:' follows on, use it's info for the answer, else use defaults.
						str=(itemsArr[i+1]);
						str=str.substr(2);
						pos=str.indexOf(":");
						
						if(pos!=-1){
							obj.answerType=str.substr(0,pos);
							obj.answers=str.substr(pos+1);
							items.push(obj);
						}
					}
					else if(template){ //ok, use defaults
						obj.answerType=template.answerType;
						obj.PossibleAnswers=template.PossibleAnswers;
						//trace(template.PossibleAnswers,22);
						obj.scores=template.scores;
						if(template.questionLabels !=undefined)questionLabels=template.questionLabels; 
						items.push(obj);
						
					}
					
					//no answers, not added (except for Text T);
				}
				else if(String(itemsArr[i]).substr(0,5)=="TYPE:"){ 
					str=String(itemsArr[i]).substr(5);
					//trace("---",str,itemsArr[i]);
					setVar("string","type",str);
				}
				
			}
			
			var objWidth:Number;
			var objHeight:Number;
			var count:uint=0;
			for each(obj in items){
				count++;
			}
			
			pic.graphics.drawRect(0,0,1,1);
			
			
			super.setUniversalVariables();
			pic.scaleX=1;
			pic.scaleY=1;
			overlay=new Sprite;
			
			
			objWidth=pic.myWidth;
			objHeight=pic.myHeight/(count);
			var paramObj:Object;
			
			
			
			count=0;
			var qCount:uint=0;
			var ans:Array;
			for each(obj in items){
				switch(obj.type){
					case "text":
						paramObj=new Object;
						paramObj.text=obj.text;
						paramObj.wordWrap="true";
						paramObj.autoSize="false"
						paramObj.width=objWidth*.9
						
						var tempTxt:BasicText = new BasicText();
						obj.sprite=tempTxt.giveBasicStimulus(paramObj) as Sprite;
						obj.sprite.y=count*objHeight
						obj.sprite.width=objWidth;
						
						overlay.addChild(obj.sprite);
						break;
					
					case "question"://paramObj.text == the question
						//make the multiple choice
						paramObj=new Object;
						paramObj.labels=obj.answers;
						paramObj.width=objWidth/4;
						paramObj.height=objHeight*.5;
						paramObj.seperation="horizontal";
						paramObj.distanceApart=2;
						ans=obj.scores;
						paramObj.scores=ans[qCount%ans.length];
						paramObj.PossibleAnswers=obj.PossibleAnswers;
						if(questionLabels)paramObj.questionLabel=questionLabels[qCount%questionLabels.length];
						//trace(11,paramObj.scores)
						obj.sprite = new MultipleChoice(paramObj,theStage);
						//(obj.sprite as Sprite).graphics.beginFill(0x334455,.5);
						//(obj.sprite as Sprite).graphics.drawRect(0,0,(obj.sprite as Sprite).width,(obj.sprite as Sprite).height);
						obj.sprite.y=count*objHeight;  //note that /4. Relates to paramObj.width BUT as their are 2 objects * 2...
						obj.sprite.x=objWidth-obj.sprite.width; //note that /4. Relates to paramObj.height
						//obj.sprite.graphics.beginFill(0x004433,.4);
						//obj.sprite.graphics.drawRect(0,0,obj.sprite.width,obj.sprite.height);
						overlay.addChild(obj.sprite);
						
						//make the question
						paramObj=new Object;
						paramObj.text=obj.text;
						//paramObj.align="center";
						paramObj.autoSize="left"
						paramObj.wordWrap="true";
						tempTxt = new BasicText();
						obj.txtSprite=tempTxt.giveBasicStimulus(paramObj) as Sprite;
						obj.txtSprite.y=obj.sprite.y//-(obj.txtSprite.height-obj.sprite.height)*.25
						obj.txtSprite.width=objWidth-obj.sprite.width;
						
						if((getVar("oneAfterTheOther") as Boolean) && qCount!=0){
							vis(obj,false);
							
						}
						qCount++;
						
						obj.txtSprite.x=0;
						
						overlay.addChild(obj.txtSprite);
						
						break;
				}
				
				count++;
			}
			pic.scaleX=1;
			pic.scaleY=1;
			overlay.addEventListener(MouseEvent.CLICK,answered);
			pic.addChild(overlay);
			return pic;
		}
		
		private function vis(obj:Object,isVis:Boolean):void{
			(obj.sprite as Sprite).visible=isVis;
			(obj.txtSprite as Sprite).visible=isVis;
		}
		
		public function answered(e:MouseEvent):void{
			var allAnswered:Boolean=true;
			for each(var obj:Object in items){
				if(obj.sprite && String(obj.sprite)=="[object MultipleChoice]" && (obj.sprite as MultipleChoice).hasOwnProperty("ActualAnswer")){
					if((obj.sprite as MultipleChoice).ActualAnswer==""){
						allAnswered=false; 
						if(getVar("hideOnceAnswered") as Boolean) vis(obj,true);
						break;
					}
					else if(getVar("hideOnceAnswered") as Boolean) vis(obj,false);
				}
			}
			
			//hideOnceAnswered
			//AW JAN FIX
			pic.dispatchEvent(new Event("answer"));
			//manageBehaviours.doEvents(this,actions["answer"],"answer");
			
			////AW JAN FIX
			if(allAnswered){
				pic.dispatchEvent(new Event("allAnswered"));
			//	manageBehaviours.doEvents(this,actions["allAnswered"],"allAnswered");
			}
		}
		
		override public function storedData():Array {
			
			var tempData:Array = new Array();	
			for each(var saveWhat:String in (getVar("saveWhat") as String).split(",")){
				switch(saveWhat){
					case "frequencies":
						var baseID:String;
						if(getVar("id")!="")baseID=getVar("peg");
						else baseID = "QAFreq"
						var multChoice:MultipleChoice;
						var answers:Object;
						var i:uint;
						var lab:String;
						for each(var obj:Object in items){
						if(obj.sprite){
							multChoice=obj.sprite as MultipleChoice;
						}
						//below looks through each object and takes out unknown labels and adds to answers.
						if(multChoice && multChoice.hasOwnProperty("ActualAnswer")){
							if(!answers)answers={};
							for(i=0;i<multChoice.PossibleAnswers.length;i++){
								lab=multChoice.PossibleAnswers[i];
								if(answers[lab]==undefined)answers[lab]=0;	
							}
							if(answers[multChoice.ActualAnswer]!=undefined)answers[multChoice.ActualAnswer]+=multChoice.score();
							else{
								if(answers["noAnswer"]==undefined)answers["noAnswer"]=0;
								answers["noAnswer"]++;
							}
							
						}
						multChoice=null;
					}
						
						
						for (var s:String in answers){
							tempData=new Array();
							tempData.event=escape(baseID+"-"+s);
							tempData.data=String(answers[s]);
							super.objectData.push(tempData);
							
							//trace(1,tempData.event,tempData.data);
						}		
						break;
					case ("numCorrect"):
						var ans:uint=0;
						tempData=new Array();
						for each(obj in items){
						if(obj.sprite){
							multChoice=obj.sprite as MultipleChoice;
						}
						if(multChoice && multChoice.hasOwnProperty("ActualAnswer")){
							ans+=multChoice.score();
							
						}
						multChoice=null;
					}
						if(getVar("id")!="")baseID=getVar("peg");
						else baseID = "QAnumCorrect"
						tempData.event=baseID;
						tempData.data=ans;
						super.objectData.push(tempData);
						//trace(2,tempData.event,tempData.data);
						break;
					
					case "questionLabelsScores":
						if(questionLabels){
							answers=[];
							for(i=0;i<questionLabels.length;i++)answers[questionLabels[i]]=0;
							
							for each(obj in items){
								if(obj.sprite){
									multChoice=obj.sprite as MultipleChoice;
								}
								
								if(multChoice){
									//trace("banna",multChoice.questionLabel)
									
									answers[multChoice.questionLabel]+=multChoice.score();
									
								}
							}
						}
						
						for (s in answers){
							tempData=new Array();
							tempData.event=escape(baseID+"-"+s);
							tempData.data=String(answers[s]);
							super.objectData.push(tempData);
							
							//trace(1,tempData.event,tempData.data);
						}		
						
						
						/*			for(i=0;i<questionLabels.length;i++){
						
						}*/
						
						break;
				}
				
				
				
			}
			
			var str:String=getVar("type");
			if(str!=""){
				tempData=new Array();
				tempData.event="type"
				tempData.data=str;
				super.objectData.push(tempData);
			}
			
			return objectData;
		}
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		override public function kill():void {
			overlay.removeEventListener(MouseEvent.CLICK,answered);
			
			super.kill();
		}
	}
}