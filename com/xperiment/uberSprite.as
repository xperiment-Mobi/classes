package com.xperiment{
	
	import com.xperiment.events.StimulusEvent;
	
	import flash.display.Sprite;
	
	public class uberSprite extends Sprite{
		public var myX:int;
		public var myY:int;
		public var myHeight:int;
		public var myWidth:int;
		public var depth:int = 0;
		public var startTime:Number;
		public var endTime:Number;
		//public var boxStuff:Array;
		//public var info:String;
		//public var behavID:String;
		//public var startID:String;
		//public var stopID:String;
		//public var doID:String;
		public var peg:String;
		//public var actions:Array; //onShow:String(rotate[start],rt[start]), onClick:String([rotate[start],rt[start])
		//public var behavJustStopped:uberSprite;
		//public var id:String="";
		//public var deepID:String="";//for xperimentMaker
		public var start:uint;
		public var end:uint;
		//private var _myGraphics:Graphics;
		//public var scratchData:Array;
		public var ran:Boolean = false;
		public var horizontalCorrection:Number = 0;
		public var verticalCorrection:Number = 0;
		

		//public function get myGraphics():Graphics{return _myGraphics;}
		//public function set myGraphics(value:Graphics):void{_myGraphics = value;}

/*		public function onBefore():void{};
		public function onAfter():void{};*/
		
		//used to get private functions for FlexUnit testing
		public function getFunct(nam:String):Function{
			if(this.hasOwnProperty(nam) && this[nam] as Function) return this[nam];
			else return null;
		}
		
/*		public function addToBoxStuff(sha:Shape):void{
		if(!boxStuff)boxStuff = new Array;
			boxStuff.push(sha);
		}*/
		
		public function stimEvent(what:String):void{
			if(StimulusEvent.list.indexOf(what)==-1){
				throw new Error("unknown stimulus event!:"+what+" (available include: "+StimulusEvent.list.join()+")");
			}
			this.dispatchEvent(	new StimulusEvent(what)	);
		}
				
		public function kill():void{
			//if(boxStuff)boxStuff=null;
			//if(scratchData)scratchData=null;
		}

		public function uberSprite():void {
			super();
		}
		
		public function myUniqueActions(action:String):Function{return null;}
		public function myUniqueProps(property:String):Function{return null;}
		

		
	}
	
}
