package com.xperiment.behaviour{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.Imockable;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trial.Trial;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class behavDrag extends behav_baseClass implements Imockable{
		public var movingBlock:uberSprite;
		public var hasMoved:Array = new Array;
		private var angle:Number;
		private var restrictToScreen:Boolean = true;
		private var box:uberSprite;
		private var origLocat:Point;

		
		public function mock():void{
			for each(var stim:uberSprite in behavObjects){
				if(box){
					stim.x=box.x+(box.width-stim.width)*Math.random();
					stim.y=box.y+(box.height-stim.height)*Math.random();
				}
				else{
					stim.x=(Trial.ACTUAL_STAGE_WIDTH-stim.width)*Math.random();
					stim.y=(Trial.ACTUAL_STAGE_HEIGHT-stim.height)*Math.random();
				}
			}
		}
		//public static var hack:Array = new Array;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","save","","x or y or xy");
			setVar("string","saveProperty","","you can use an stimulus's property (if it does NOT have the property, 0-x [in order they were given in usePegs] will be used as a failsafe)");
			setVar("boolean","restrictToScreen",true);
			setVar("string","box","");
			super.setVariables(list);

			if(getVar("restrictToScreen") == false )restrictToScreen=false;
		}	
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('allDragged')==false){
				uniqueProps.allDragged= function():String{
					return allMoved().toString();
				}; 	
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		private function allMoved():Boolean
		{
			for each(var bool:Boolean in hasMoved){
				if(bool == false) return false;
			}
			
			if(box){
				for each(var stim:uberSprite in behavObjects){
					if(box.hitTestObject(stim) == false)return false;
				}
			}
			
			
			return true;
		}
		
		override public function returnsDataQuery():Boolean {
			if(getVar("save")!=""){
				return true;
			}
			return false;
		}
		
		override public function storedData():Array {

			var stim:object_baseClass;
			var sav:String = getVar("save");
			var nam:String;
			
			for(var i:int=0;i<behavObjects.length;i++){
			stim = behavObjects[i];
			
				var prop:String = getVar("saveProperty");

				if(prop=="") nam= stim.peg;
				else{
					nam=stim.getVar(prop);
					if(nam=="")nam = "stim"+i.toString();
				}
				//trace(123,nam)
				if(!box){
					if(sav.indexOf("x")!=-1)	objectData.push({event:nam+".x",data:int(stim.x)});
					if(sav.indexOf("y")!=-1)	objectData.push({event:nam+".y",data:int(stim.y)});
				}
				else{
					if(sav.indexOf("x")!=-1){
						var pos:Number=codeRecycleFunctions.roundToPrecision((stim.x-box.x)/(box.width-stim.width)*100,2);
						objectData.push({event:nam+".x",data:pos});
					}
					if(sav.indexOf("y")!=-1){
						pos=codeRecycleFunctions.roundToPrecision((stim.y-box.y)/(box.height-stim.height)*100,2);
						objectData.push({event:nam+".y",data:pos});
					}
				}
				
				//if(stim.getVar("background")!=""&& stim.peg!="Black")hack.push({colour:stim.getVar("background"),x:stim.x,name:stim.peg})
			}
			
			//hack.sortOn("x",Array.NUMERIC);

			
			return super.objectData;
		}
		

		
		override public function givenObjects(obj:uberSprite):void{
			if(obj.peg != getVar("box")){
				hasMoved[obj.peg]=false;
				super.givenObjects(obj);
			}
			else box = obj;
		}
		
		override public function nextStep(id:String=""):void{
			this.ran=true;
			for each(var stimulus:uberSprite in behavObjects){
				if(stimulus.peg != getVar("box"))stimulus.addEventListener(MouseEvent.MOUSE_DOWN, startBlockMove,false,0,true);
			}
		}
		
		public function startBlockMove(e:MouseEvent):void {
			origLocat = new Point(e.target.x, e.target.y);
			
			super.theStage.addEventListener(MouseEvent.MOUSE_UP, stopMotion,false,0,true);
			
			movingBlock=uberSprite(e.currentTarget.pic);
			movingBlock.parent.setChildIndex(movingBlock,movingBlock.parent.numChildren-1);
			
			hasMoved[movingBlock.peg]=true;
			
			movingBlock.startDrag();
		}
		
		


		public function stopMotion(evt:MouseEvent):void {
			
			if(movingBlock){
				
				movingBlock.stopDrag();
				
				if(restrictToScreen){
					if(movingBlock.x<0)movingBlock.x=0;
					else if(movingBlock.x+movingBlock.width>theStage.stageWidth)movingBlock.x=theStage.stageWidth-movingBlock.width;
					if(movingBlock.y<0)movingBlock.y=0;
					else if(movingBlock.y+movingBlock.height>theStage.stageHeight)movingBlock.y=theStage.stageHeight-movingBlock.height;
				}
				
				if(box){
					//logic from here http://forums.adobe.com/thread/778273
					if(box.getBounds(theStage).containsRect(movingBlock.getBounds(theStage)) == false){
						movingBlock.x=origLocat.x;
						movingBlock.y=origLocat.y;		
					}
				}	
			}
					
			origLocat = null;
			movingBlock = null;
		}
		
		override public function kill():void{
			super.theStage.removeEventListener(MouseEvent.MOUSE_UP, stopMotion);
			for each(var stim:object_baseClass in behavObjects){
				stim.removeEventListener(MouseEvent.MOUSE_DOWN,stopMotion);
			}
			box=null;
			hasMoved=null;
			super.kill();
		}

	}

}