package com.xperiment.behaviour {
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.stimuli.primitives.IResult;
	
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class behavAssignRank extends behav_baseClass implements IResult{

		private var ranks:Array = [];
		private var stimRanks:Vector.<StimRank> = new Vector.<StimRank>;
		private var finished:Boolean = false;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","fontColour","black");
			setVar("int","fontSize",50);
			setVar("number","xPos","70","the pixel at which within the original image the label is placed");
			setVar("number","yPos","70","the pixel at which within the original image the label is placed");
			setVar("boolean","lockAfterFinish",true);
			super.setVariables(list);
		}
		
		
		override public function returnsDataQuery():Boolean{
			
			if(getVar("hideResults")!='true'){
				//trace(1111)
				return true;
			}
			return false;
		}
		
		
		override public function storedData():Array {
			
			
			
			for each(var rank:StimRank in stimRanks){
				objectData.push({event:peg+"_"+rank.stim.peg,data:rank.rank.num});
			}
			return objectData;
		}

		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			
			if(uniqueProps.hasOwnProperty('completed')==false){
				uniqueProps.completed= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) {
					
					}
					return (ranks.length==0).toString();
				}; 	
			}
			
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		
		override public function nextStep(id:String=""):void{
			
			var count:int=1;
			Rank.size = getVar("fontSize");
			Rank.col  = codeRecycleFunctions.getColour(getVar("fontColour"));
			Rank.xPos = getVar("xPos");
			Rank.yPos = getVar("yPos");
			var stimRank:StimRank;
			for each(var stim:object_baseClass in behavObjects){
				ranks[ranks.length] = new Rank(count);
				count++;
				stimRank = new StimRank;
				stimRank.stim = stim;
				stimRanks[stimRanks.length] = stimRank;
				stim.addEventListener(MouseEvent.CLICK,clickedL);
			}
		}
		
		protected function clickedL(e:MouseEvent):void
		{
			if(finished==false){
				//get StimRank
				var stimRank:StimRank;
				for(var i:int;i<stimRanks.length;i++){
					if(stimRanks[i].stim == e.target)	stimRank=stimRanks[i];
				}
		
				if(!stimRank)return;
				
				if(!stimRank.rank){
					
					if(ranks.length>0){
		
						stimRank.rank=ranks.shift();
						stimRank.add();
						if(ranks.length==0){
							behaviourFinished();
							if(getVar("lockAfterFinish")==true)	finished=true;
						}
					}
				}
				else{
					ranks.push(stimRank.rank);
					stimRank.remove();
				}
				
				ranks.sortOn("num",Array.NUMERIC);
			}
			
		}
		
		override public function kill():void{
			for each(var stim:object_baseClass in behavObjects){
				stim.removeEventListener(MouseEvent.CLICK,clickedL);
			}
			
			for each(var rank:StimRank in stimRanks){
				rank.kill();
				rank=null;
			}
			
			ranks=null;
		}
			
	}
}
import com.xperiment.stimuli.object_baseClass;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class Rank extends Sprite{
	
	public static var size:int;
	public static var col:int;
	public var num:int;
	public static var xPos:int;
	public static var yPos:int;
	
	public function Rank(num:int):void{
		this.num = num;
		var txt:TextField = new TextField;
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.defaultTextFormat = new TextFormat(null,size,col);
		txt.text=num.toString();
		this.addChild(txt);
		
	}

}

class StimRank {
	public var stim:object_baseClass;
	public var rank:Rank;
	
	public function remove():void{
		if(stim.contains(rank)){
			stim.removeChild(rank);
			rank=null;
		}
	}
	
	public function add():void{

		rank.x=Rank.xPos;
		rank.y=Rank.yPos;
		
		stim.addChild(rank);
		
	}
	
	public function kill():void
	{
		remove();
		stim=null;
		rank=null;
	}}