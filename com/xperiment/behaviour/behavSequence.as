package com.xperiment.behaviour {
	import com.xperiment.stimuli.Imockable;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.Dictionary;


	public class behavSequence extends behav_baseClass implements Imockable{
		private var pos:int = -1;
		private var actionStim:Dictionary;
		
		override public function kill():void{
			actionStim=null;
			super.kill();
		}
		
		public function mock():void{
			pos = int(behavObjects.length * Math.random())-1
		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('item')==false){
				uniqueProps.item= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) {
						return show(to).toString();
					}
					return pos.toString();
				}; 	
			}
			
			if(uniqueProps.hasOwnProperty('itemFromPercent')==false){
				uniqueProps.itemFromPercent= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what) {
						return showFromPercent(to).toString();
					}
					return (pos/behavObjects.length*100).toString();
				}; 	
			}
			
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		private function showFromPercent(to:String):int
		{
			var fromPer:uint = Number(to)*.01 * (behavObjects.length-1);
			show_i(fromPer);
			return pos;
		}		
		
		override public function setVariables(list:XMLList):void {
			setVar("string","sortBy",'peg','this must be numeric. You can define whatever variable you want in the stimuli for this.  eg. mySortOn="1"');
			setVar("string","how","random, flipped");
			setVar("string","show","","the first stimuli to show");
			super.setVariables(list);
		}
		
		
		override public function storedData():Array {
			var tempData:Array = new Array();
			tempData.event=peg;
			tempData.data=pos.toString();
			super.objectData.push(tempData);
			return objectData;
		}


		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		
		override public function nextStep(id:String=""):void{
			sort();
			hideAll();
			show(getVar("show"));
		}
		
		private function show(toShow:String):int
		{
			if(toShow=='random' || toShow=='') show_i((behavObjects.length-1)*Math.random());
			if(toShow!=''){
				if(toShow.toLowerCase()=='max')show_i((behavObjects.length-1));
				else if(toShow.toLowerCase()=='min')show_i(0);
				else show_i(int(toShow));
			}
			
			for(var i:int=0;i<behavObjects.length;i++){
				if(behavObjects[i]==actionStim[toShow]){
					pos=i;
					break;
				}
			}	
			return pos;
		}
		
		private function show_i(toShow:uint):int
		{
			if(behavObjects[toShow]==undefined) throw new Error("you have asked to show a non existing stimulus in a behavSequence: "+toShow);
			if(pos!=-1)behavObjects[pos].visible=false;
	
			behavObjects[toShow].visible=true;
			pos=toShow;
			return pos;
		}
		
		private function hideAll():void
		{
			for(var i:int=0;i<behavObjects.length;i++){
				behavObjects[i].visible = false;
			}
		}
		
		private function sort():void
		{
			var sortByProp:String = getVar("sortBy");
			
			var propA:Number;
			var propB:Number;
			
			function sortF(a:object_baseClass, b:object_baseClass):int{
				get_and_check(a);
				
				propA = get_and_check(a);
				propB = get_and_check(b);
				
				if(propA < propB) return -1;
				else if(propA > propB) return 1;
				return 0;
			}
			
			function get_and_check(stim:object_baseClass):Number{
				var prop:String = stim.getVar(sortByProp);
				if(isNaN(Number(prop)))	throw new Error('you have defined either a non numerical, or no, value for sortBy in this stimulus: ' +stim.peg)
				return Number(prop);
			}
			
			behavObjects.sort(sortF);
			
			actionStim = new Dictionary;
			for(var i:int=0;i<behavObjects.length;i++){
				actionStim[behavObjects[i].getVar(sortByProp)] = behavObjects[i];
			}
			this.OnScreenElements.x=(behavObjects[0] as object_baseClass).OnScreenElements.x;
			this.OnScreenElements.y=(behavObjects[0] as object_baseClass).OnScreenElements.y;
		}	
		
		
		
			
	}
}