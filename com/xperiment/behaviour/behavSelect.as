package com.xperiment.behaviour {

	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;


public class behavSelect extends behav_baseClass{

		private var bg:object_baseClass;
		private var effect : GlowFilter = new GlowFilter;
		private var list:Array = [];

		override public function setVariables(list:XMLList):void {
			setVar("string","background",'','','');
			setVar("string","shape","triangle","currently only triangle and diamond supported");
			setVar("number", "fillParentRatio",1, "", "");
			setVar("string","hide","","");
			super.setVariables(list);
			setUniversalVariables();
	
		}


		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			for each(var stim:uberSprite in behavObjects){
				list.push(stim.peg);
			}
			listeners(true);	
		}
		
		private function listeners(ON:Boolean):void
		{
			
			
				if(ON){
					theStage.addEventListener(MouseEvent.CLICK, clickL);
				}
				else{
					theStage.removeEventListener(MouseEvent.CLICK, clickL);

				}
				
			
		}
		
		override public function returnsDataQuery():Boolean{
			return true;
		}
		
		
		protected function clickL(e:MouseEvent):void
		{
			
			var objects:Array = theStage.getObjectsUnderPoint (new Point(theStage.mouseX,theStage.mouseY)); 
			
			for (var i:int = 0; i< objects.length; i++)
			{
				if(objects[i] is uberSprite) check(objects[i] as uberSprite);
			}
			
			function check(stim:uberSprite):void{
				if(list.indexOf(stim.peg)!=-1) {					
					objectData.push({event:peg,data:stim.peg});
					behaviourFinished();
				}
			}
		}
		
		override public function kill():void{
			listeners(false);

			super.kill();
		}


			
	}
}
