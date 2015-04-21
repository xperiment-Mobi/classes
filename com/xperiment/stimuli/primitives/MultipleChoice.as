package com.xperiment.stimuli.primitives
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.IButton;
	import com.xperiment.stimuli.Imockable;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	public class MultipleChoice extends Sprite implements Imockable, IButton
	{
		private var buttons:Array;
		private var hideText:Boolean;
		private var fontSize:int;
		private var wordWrap:Boolean;
		private var selectMultiple:Boolean;
		
		public var scores:Array=[];
		public var ActualAnswer:String="";
		public var PossibleAnswers:Array =[];
		public var questionLabel:String;
		private var keys:Array;
		private var theStage:Stage;
		
		
		public function getData():String
		{
			var returnable:Array = [];
			
			for(var i:uint=0;i<buttons.length;i++){

				if((buttons[i] as BasicButton).selected){
					returnable.push( (buttons[i] as BasicButton).name);
				}
			}	
			return returnable.join(",");;
		}
		
		
		public function getWhichSelected():int
		{
			var returnable:Array = [];
			for(var i:uint=0;i<buttons.length;i++){
				if((buttons[i] as BasicButton).selected){
					return i;
				}
			}
			
			return -1;
		}
		
		public function mock():void
		{
			
			var b:Array = [];
			for (var i:int; i<buttons.length;i++){b.push(i);}

			var rand_index:int = codeRecycleFunctions.arrayShuffle(buttons)[0];
			buttons[rand_index].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		public function MultipleChoice(params:Object,theStage:Stage)
		{
			this.theStage=theStage;
			if(params.useKeys!="")keys=[];
			sortParams(params);
			generateChoices(params);
		}
		
		public function generateChoices(params:Object):void
		{

			var distApart:Number=params.distanceApart as Number;
			
			var number:uint=PossibleAnswers.length;
			
			var keys:Array
			if(params.useKeys!=""){
				keys = params.useKeys.split(",");
			}

			
			var origWidth:Number=params.width;
			var origHeight:Number=params.height;
			
	
						
			//this.graphics.beginFill(0x006644,.5);
			//this.graphics.drawRect(0,0,origWidth,origHeight);
			
			var button:BasicButton;
			
			var buttonWidth:Number	= origWidth/number-(distApart*(number-1));
			var buttonHeight:Number	= origHeight/number-(distApart*(number-1));
			
			var key:String;
			
			for(var i:int=0;i<number;i++){
				
				if(keys){
					key=keys[i%keys.length]
					if(key.length==0)key=null;
				}
				
				button=__getButton(PossibleAnswers[i%PossibleAnswers.length],key);
				
				if(params.seperation=="horizontal"){
					button.myWidth=buttonWidth;
					button.myHeight=origHeight;
					button.x=(origWidth/number*i)+i*distApart;
				}
				else{
					button.myWidth=origWidth;
					button.myHeight=buttonHeight;
					button.y=(origHeight/number*i)+i*distApart;	
				}	
				
				button.init();
			}
		}
		
		public function __getButton(nam:String,key:String):BasicButton
		{
			var button:BasicButton = new BasicButton();
	
			if(keys){
				keys.push(new KeyPress(key,theStage,this,button));
			}
				
			nam=nam.replace(new RegExp("{","g"), "<");
			nam=nam.replace(new RegExp("}","g"), ">");
			
			if(hideText == false)	button.label.htmlText=nam;
			else button.label.htmlText='';
			
			button.label.fontSize=fontSize;
			button.label.wordWrap=wordWrap;
			
			button.addEventListener(MouseEvent.CLICK,mouseClicked);
			button.toggle=true;
			button.name=nam;
			
			
			buttons.push(button);
			
			this.addChild(button);
			return button;
		}
		
		private function sortParams(params:Object):void
		{
			if(params.distanceApart==undefined)	params.distanceApart=10;
			if(params.width==undefined)			params.width=200;
			if(params.height==undefined)		params.height=200;
			if(params.seperation==undefined)	params.seperation="vertical";
			if(params.fontSize==undefined)		params.fontSize=20;
			if(params.multiline==undefined)		params.multiline=true;
			if(params.selectMultiple==undefined)params.selectMultiple=false;
			
			if(params.scores==undefined)		params.scores=1; else if (params.scores as Array) scores=params.scores;
			if(params.questionLabel)questionLabel=params.questionLabel;
			if(params.hideText==undefined)		params.hideText=false;
			if(params.wordWrap==undefined)		params.wordWrap=true;
			if(params.PossibleAnswers==undefined)PossibleAnswers=["label1","label2","label3"]; 
			if(params.randomPositions==undefined)params.randomPositions='';
			if(params.useKeys==undefined)		params.useKeys='';
			else if(params.PossibleAnswers is Array) PossibleAnswers=params.PossibleAnswers;
			

			/*
			scores can either be an array OR a number: e.g. scores:3 or [0,0,1,1]
			if a number, that number refers to the correct answer in the params.PossibleAnswers Array, assigning that score a 1 and all others 0
			*/
			//trace(params.PossibleAnswers)
			
			if(params.scores as Number){
				var temp:Number=params.scores;
				//trace("in here",params.scores);
				for (var i:uint=0;i<PossibleAnswers.length;i++)scores.push(0);
				if(temp-1<=scores.length)scores[temp-1]=1;
			}
			
			if(params.randomPositions!='')randomisePositions(params.randomPositions);
			
			hideText = params.hideText
			fontSize = params.fontSize
			wordWrap = params.wordWrap
			selectMultiple = params.selectMultiple;
			
			params.number=PossibleAnswers.length;
			buttons = [];
			
		}
		
		private function randomisePositions(info:String):void
		{
			info=info.split(" ").join();
			var list:Array = info.split(",");
			var i:int;

			for(i=list.length-1; i>=0;i--){
				if(list[i].indexOf("-")!=-1){
					var seperated:Array = list[i].split("-");
					var first:int=Number(seperated[0]);
					var second:int=Number(seperated[1]);
					
					for(var j:int=first;j<=second;j++){
						list.push(j-1);
					}
					list.splice(i,1);
				}
			}
			
			var infoNames:Array = [];
			
			for(i=0;i<list.length;i++){
				if(list[i]>PossibleAnswers.length-1)throw new Error("you have asked to randomize multiple choice buttons that do not exist:"+info);
				if(isNaN(int(infoNames[i])))throw new Error("in a MultipleChoice stimulus, you have specified a non-numercial 'choice' to be randomised:"+infoNames[i]);
				list[i]=int(list[i]);
				infoNames.push(PossibleAnswers[list[i]]);
			}


			infoNames = codeRecycleFunctions.arrayShuffle(infoNames);
			
			
			for(i=0;i<infoNames.length;i++){
				PossibleAnswers[list[i]]=infoNames[i];
			}
		}
		
		public function score():Number{
			var pos:uint=PossibleAnswers.indexOf(ActualAnswer)
			//trace(pos,ActualAnswer,PossibleAnswers[pos], scores[pos]);
			return scores[pos];
		}
		
		protected function mouseClicked(e:MouseEvent):void
		{
			var wasSelected:Boolean = !((e.target as BasicButton).selected);

			if(wasSelected || selectMultiple==false){
				ActualAnswer=(e.target as BasicButton).name;
				//trace(ActualAnswer,score(),2222,PossibleAnswers,"scores:",scores);
				
				if(selectMultiple==false){
					for(var i:uint=0;i<buttons.length;i++){
						if(buttons[i] as BasicButton!=e.target as BasicButton){
							(buttons[i] as BasicButton).selected=false;
						}
					}
				}
			}
		}
		
		public function kill():void{
			if(keys){
				for(var i:uint=0;i<keys.length;i++){
					(keys[i] as KeyPress).kill();
				}
			}
			for(i=0;i<buttons.length;i++){
				buttons[i].removeEventListener(MouseEvent.CLICK,mouseClicked);
				this.removeChild(buttons[i]);
				buttons[i] = null;
			}
			buttons=null;
		}
		
		public function __logButtonPress():void{};
		

		public function init():void
		{
			for(var i:uint=0;i<keys.length;i++){
				(keys[i] as KeyPress).init();
			}
			
		}
	}
}