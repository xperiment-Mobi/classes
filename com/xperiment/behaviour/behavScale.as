package com.xperiment.behaviour {
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.Imockable;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;


	public class behavScale extends behav_baseClass implements Imockable{
		private var scale:Number;
		private var _min:Number;
		private var _length:Number;
		private var startingSize:Object;
		
		override public function kill():void{
			startingSize = null;
			super.kill();
		}
		
		public function mock():void{
			scale = 5 * Math.random();
		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			/*if(uniqueProps.hasOwnProperty('item')==false){
				uniqueProps.item= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) {
						return scale(to).toString();
					}
					return pos.toString();
				}; 	
			}*/
			
			if(uniqueProps.hasOwnProperty('itemFromPercent')==false){
				uniqueProps.itemFromPercent= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) {
						return scaleFromPercent(to).toString();
					}
					return getPercentScale.toString();
				}; 	
			}
			
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}

		private function scaleFromPercent(to:String):int
		{
			scale = _min + (Number(to)*.01 * _length);
			
			var bounds:Rectangle;
			
			for each(var stim:uberSprite in behavObjects){
				scaleStim(stim,scale,startingSize[stim]);
			}
			
			
			return scale*100;
		}		
		
		private function scaleStim(stim:uberSprite, scale:Number, bounds:Rectangle):void
		{


			stim.x = stim.myX + stim.myWidth*.5 -stim.myWidth*scale*.5;
			stim.y = stim.myY + stim.myHeight*.5 -stim.myHeight*scale*.5;
			
			stim.width = bounds.width * scale;
			stim.height = bounds.height * scale;

		}
		
		private function getPercentScale():int{
			return scale*100;
		}
		
		
		
		override public function setVariables(list:XMLList):void {
			setVar("number","min",.1,"");
			setVar("number","max",3,"");
			setVar("number","startScale",1);
			
				
			super.setVariables(list);
			
			_min = getVar("min");
			_length = getVar("max") - _min;
			
		}
		
		
		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			
			startingSize = {};
			
			for each(var stim:uberSprite in behavObjects){
				stim.scaleX = stim.scaleY = getVar("startScale");
				startingSize[stim] = stim.getBounds(stim.parent);
			}
			
			
		}
		
		override public function storedData():Array {
			var tempData:Array = new Array();
			tempData.event=peg;
			tempData.data=codeRecycleFunctions.roundToPrecision(scale,2).toString();
			super.objectData.push(tempData);
			return objectData;
		}


		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		
		
	}
}