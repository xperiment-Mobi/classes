package com.xperiment.behaviour{
	import com.greensock.TweenMax;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	
	public class behavBevel extends behav_baseClass {
		
		public static const RAD_TO_DEG:Number = 57.295779513082325225835265587527; // 180.0 / PI;
		private var angle:Number;
		private var point:Point;
		private var distance:Number;
		private var tweens:Object = {};
		private var numberSelectable:uint;
		
		override public function setVariables(list:XMLList):void {

			setVar("int","startOppacity",1);
			setVar("int","angle",45);
			setVar("int","distance",10);
			setVar("int","blur",5);
			setVar("int","numberSelectable",1);
			setVar("boolean","forceDeselect",true);
			setVar("boolean","saveWhichSelected",true);
			setVar("boolean","reverseBevel",false);
			super.setVariables(list);
			numberSelectable=getVar("numberSelectable") as uint;
		}	
		
		override public function givenObjects(obj:uberSprite):void{	
			tweens[obj.peg]='';
			super.givenObjects(obj);
		}
		
		override public function returnsDataQuery():Boolean {
			return getVar("saveWhichSelected") as Boolean;
		}
		
		
		
		override public function storedData():Array {
			var tempData:Array = [];	
		
			if(peg && peg!="")tempData.event=peg;
			else tempData.event="bevelled"
			tempData.data=results();
			
			super.objectData.push(tempData);
			return objectData;
		}
		
		override public function nextStep(id:String=""):void
		{
			for each(var stim:uberSprite in behavObjects){
				thisShadow(stim);
			}
			super.nextStep();
		}
		
		private function results():String{
			var selected:Array=[];
			for (var peg:String in tweens){
				if(tweens[peg]!=undefined && tweens[peg]!=null){
					selected.push(peg)
				}
			}

			return selected.join(",");
		}
		
		override public function myUniqueActions(action:String):Function{
			if(!uniqueActions){
				uniqueActions = new Dictionary;
				uniqueActions.toggle=function(contents:Array):void{doShadow(contents[0]);}; 	
			}
			if(uniqueActions.hasOwnProperty(action)) return uniqueActions[action]
			
			return null;
		}
	

		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('result')==false){
				uniqueProps.result=function():String{
					return codeRecycleFunctions.addQuots(results()); 
				};
			}
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		private function doShadow(pic:uberSprite):void{

				if(!pic)throw new Error("error in Bevel: you MUST provide the stimulus you want to bevel.  eg. this.click?bev.toggle(this)");
				if(tweens[pic.peg]==""  || tweens[pic.peg]==undefined)	{
					var count:int = 0;
					for(var tween:String in tweens){
						if(tweens[tween]!=undefined && pic!=tweens[tween]){
							if(numberSelectable==1){
								tweens[tween].reverse();
								tweens[tween]=undefined;
							}
							else count++
						}	
					}
					if(count<numberSelectable)thisShadow(pic);	
				}
				else{
					thisShadowRemove(pic);
				}	
			
		}
		

		
		private function thisShadowRemove(origObj:uberSprite):void
		{
			var tween:TweenMax=tweens[origObj.peg];
			tween.reverse()
			tweens[origObj.peg]=undefined;
		}		
	
		private function shadow():void{
			for each(var us:uberSprite in behavObjects){
				thisShadow(us);
			}
		}
		
		private function thisShadow(us:uberSprite):void{

				
			var myTween:TweenMax;
			
			var filters:Array = [
				{dropShadowFilter:{color:0x000000, alpha:0, blurX:0, blurY:0, angle:90, distance:0, inner:true}},
				{glowFilter:{alpha:0, blurX:0, blurY:0, strength:5}}
								];
			
			if(getVar("reverseBevel"))filters=filters.reverse();
			
			for(var filter_i:int=0;filter_i<filters.length;filter_i++){
				TweenMax.set(us, filters[filter_i]);
			}
			
			//var myTween:TweenMax=TweenMax.to(us, 1, {bevelFilter:{blurX:50, blurY:50, distance:distance, angle:angle, strength:10}});
			
			myTween=TweenMax.to(us, 0.1, {dropShadowFilter:{color:0x000000, alpha:1, blurX:10, blurY:10, angle:90, distance:10, inner:true},glowFilter:{alpha:1, blurX:30, blurY:30,strength:5}});
			tweens[us.peg]=myTween;

			checkQuota();
			
		}
		
		private function checkQuota():void
		{
			var count:int = getVar("numberSelectable");
			for(var p:String in tweens){
				if(tweens[p]!=undefined) count--;
				
			}

			if(count<=0){
				this.dispatchEvent(new Event(StimulusEvent.ON_FINISH));
			}
		}
		
	}
}
