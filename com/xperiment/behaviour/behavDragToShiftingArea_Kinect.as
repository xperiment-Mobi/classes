package com.xperiment.behaviour{
	import com.xperiment.uberSprite;
	import com.virtualMouse.Mouses;
	import com.virtualMouse.VirtualMouse;
	import com.virtualMouse.VirtualMouseEvent;
	import com.virtualMouse.VirtualMouseMouseEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class behavDragToShiftingArea_Kinect extends behav_baseClass {
		private var startingPt:Point=new Point  ;
		private var DropZones:Array = new Array;
		private var DropZonesOccupied:Array = new Array;
		private var shiftX:int;
		private var shiftY:int;
		private var currentMovingBlockNumber:uint=9999;
		private var movingBlock:uberSprite;
		private var scores:Array=new Array;
		private var objectsSelected:Array;
		private var duration:Number;
		private var myMouses:Array;
		private var vMouse:VirtualMouse;
		private var currentMouse:uint;
		private var myTimer:Timer;
		private var myDelayTimer:Timer;
		private const timerWait:uint=500;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","areaName","");
			setVar("string","areaDropZonesX","33,66");
			setVar("string","areaDropZonesY","");
			setVar("string","arrangement","anywhere");
			setVar("boolean","lockInPlaceOncePlaced",false);
			setVar("boolean","snapBackToOriginalLocation",false);
			setVar("boolean","showDropZones",false);
			setVar("string","snapToDropZones","middle");
			setVar("string","whichImageHideAfter",""); //either 'selected', 'unselected', ''.
			setVar("uint","actionsAfterHowManyFilled",0);
			setVar("boolean","rt",false);
			super.setVariables(list);
			setVar("uint","hideResults",false);
	
			if(theStage){
			
				var myVirtualMouses:Sprite=theStage.getChildByName("myVirtualMouses") as Sprite;
				
				myMouses = new Array;
				for (var m:uint=0;m<myVirtualMouses.numChildren;m++){
					myMouses.push(myVirtualMouses.getChildAt(m) as Mouses);
				}
			}
			
		}
		
		override public function returnsDataQuery():Boolean {
			if (getVar("hideResults")) return false;	
			else return true;
		}
		
		public function filled():void {
			
			if (getVar("rt")){
				var d:Date = new Date;
				duration = d.getTime() + duration;
			}
			calculateScores();
			//behaviourFinished(this);
			
			
			
			for (var i:uint=0; i<behavObjects.length; i++) {
				if (super.behavObjects[i].pic&&super.behavObjects[i].pic.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					super.behavObjects[i].pic.removeEventListener(MouseEvent.MOUSE_DOWN, startBlockMove);
				}
			}			
			if (getVar("whichImageHideAfter")!="") whichImageHideAfter();
		}
		
		override public function nextStep(id:String=""):void {
			if (getVar("rt")){
				var d:Date=new Date();
				duration=-d.getTime();
			}
			super.runBehav(id);
		}
		
		private function calculateScores():void {
			objectsSelected=new Array();
			//scores: where -1 means that that object is not selected.
			for (var i:uint=0;i<scores.length;i++){ 
				if(scores[i]==0){
					objectsSelected.push(behavObjects[i].name); //will need updated for when there are more than 1 dropBox.
				}
			}
		}
		
		override public function storedData():Array {
			if (!objectsSelected) calculateScores();
			var tempData:Array
			for (var i:uint=0;i<objectsSelected.length;i++){
				tempData = new Array();
				tempData.event=String("DragToShiftingArea-"+getVar("behaviourID	")); 
				tempData.data=objectsSelected[i]+"-InBox"+i;
				super.objectData.push(tempData);
			}
			
			if(getVar("rt")){
				tempData = new Array();
				tempData.event=String("DragToShiftingArea_rt"); 
				if(duration<=0)tempData.data="";
				else tempData.data=duration;
				super.objectData.push(tempData);
			}
			//trace("eee:"+tempData.event+" "+tempData.data);
			
			return objectData;
		}
		
		private function whichImageHideAfter():void{
			var selected:Array=new Array();
			for (var i:uint=0; i<behavObjects.length;i++){
				for (var j:uint=0;j<objectsSelected.length;j++){
					if(behavObjects[i].name==objectsSelected[j])selected.push(i);
				}
			}
			
			switch(getVar("whichImageHideAfter")){
				case "selected":
					for (i=0; i<selected.length;i++)behavObjects[selected[i]].pic.visible=false;
					break;
				case "unselected":
					for (i=0; i<behavObjects.length;i++){					
						if(selected.indexOf(i)==-1)behavObjects[i].pic.visible=false;
					}
					break;
			}
		}	
		
		private function moveBlock(e:TimerEvent):void {
			movingBlock.x=myMouses[currentMouse].x-(movingBlock.width*.5);
			movingBlock.y=myMouses[currentMouse].y-(movingBlock.height*.5);
			snapInPlace();
			if(myMouses[currentMouse].x<0 || myMouses[currentMouse].x>theStage.stageWidth) stopMotion();
		}
		
		
		public function stopMotion():void {
			resetMouses();

			theStage.removeEventListener(MouseEvent.MOUSE_MOVE, moveBlock);
			movingBlock=null;
		}
		
		private function resetMouses():void
		{
			myTimer.stop();
			myMouses[0].startClick();
			myMouses[1].startClick();
			
		}		
		
		
		public function startBlockMove(e:VirtualMouseMouseEvent):void {
			myMouses[0].stopClick();
			myMouses[1].stopClick();
			whichMouseUsed(e.currentTarget.pic);
			movingBlock=uberSprite(e.currentTarget.pic);
			movingBlock.parent.setChildIndex(movingBlock,movingBlock.parent.numChildren-1);

			myTimer=new Timer(20);
			myTimer.addEventListener(TimerEvent.TIMER,moveBlock);
			startingPt.x=movingBlock.x;
			startingPt.y=movingBlock.y;
			for (var i:uint=0; i<behavObjects.length; i++) {
				if (behavObjects[i].pic==movingBlock) {
					currentMovingBlockNumber=i;
					break;
				}
			}
			myTimer.start();
			
		}
		
		private function whichMouseUsed(target:uberSprite):void{
			//for (var m:uint=0;m<myMouses.length;m++){
			//if(myMouses.
			//}
			var closest:Number=Math.sqrt(Math.pow(myMouses[0].x-target.x,2)+Math.pow(myMouses[0].y-target.y,2));
			if(Math.sqrt(Math.pow(myMouses[1].x-target.x,2)+Math.pow(myMouses[1].y-target.y,2))<closest)currentMouse=1; 
			else currentMouse=0;
		}
		
		override public function givenObjects(obj:uberSprite):void {
			if (alive==true) {
				if ((obj.name as String).indexOf(getVar("areaNamePrefix"))==-1) {//if obj is of type dropZone (specified via 'areaNamePrefix') then do dropzone stuff.
					obj.addEventListener(MouseEvent.MOUSE_DOWN, startBlockMove,false,0,true);
				}
				else {
					DropZones.push(obj);
					DropZonesOccupied.push(null);
				}
			}
			super.givenObjects(obj);
		}		
		
		private function snapInPlace():void {
			if (scores[currentMovingBlockNumber]!=-1) {
				DropZonesOccupied[scores[currentMovingBlockNumber]]=false;
			}
			
			var inDZ:Boolean=false;
			for (var i:uint=0; i<DropZones.length; i++) {
				
				if (DropZones[i].hitTestPoint(movingBlock.x+(movingBlock.width*.5),movingBlock.y+(movingBlock.height*.5))) {
					inDZ=true;
					shiftX=DropZones[0].width-movingBlock.width;
					shiftY=DropZones[0].height-movingBlock.height;
					
					if (getVar("snapToDropZones")=="left") {
						shiftX=0;
						shiftY=0;
					}
					if (getVar("snapToDropZones")=="middle") {
						shiftX*=0.5;
						shiftY*=0.5;
					}
					
					if (DropZonesOccupied[i]) {
						DropZonesOccupiedSortThis(i);
					}
					
					movingBlock.x=DropZones[i].x+shiftX;
					movingBlock.y=DropZones[i].y+shiftY;
					resetMouses();
					
					
					DropZonesOccupied[i]=true;
					scores[currentMovingBlockNumber]=i;
					
					if (getVar("lockInPlaceOncePlaced")) {
						movingBlock.removeEventListener(MouseEvent.MOUSE_DOWN, startBlockMove);
					}
				}
			}
			
			//below, a test to see if the dropZones are full enough to emit a reponse (if required ;)
			if (getVar("actionsAfterHowManyFilled")!=0 && countBooleanContents(DropZonesOccupied,true)==getVar("actionsAfterHowManyFilled")) {
				filled();
			}
			
			
		}
		
		private function countBooleanContents(arr:Array, boo:Boolean):uint {
			var count:uint=0;
			for (var i:uint=0; i< arr.length; i++) {
				if (arr[i]==boo) {
					count++;
				}
			}
			return count;
		}
		
		private function DropZonesOccupiedSortThis(pos:uint):void {
			var countBefore:uint=0;
			var countAfter:uint=0;
			var direction:int=-1;//where -1=left;
			
			for (var i:uint=0; i<DropZones.length; i++) {
				if (DropZonesOccupied[i]==false) {
					if (i<pos) {
						countBefore++;
					}
					else {
						countAfter++;
					}
				}
			}
			//logger.log("countBefore:"+countBefore+" "+"countAfter:"+countAfter);
			if (countBefore!=0 && countAfter!=0 && movingBlock.x+(movingBlock.width/2)<DropZones[pos].x+(DropZones[pos].width/2)) {
				direction=1;//what happens if y axis??
			}
			else if (countBefore!=0&& countAfter==0) {
				direction=-1;
			}
			else if (countAfter!=0 && countBefore==0) {
				direction=1;
			}
			else {
				if (Math.random()<.5) {
					direction=1;
				}
			}
			
			var upto:uint;
			
			if (direction==1) {
				for (upto=pos; upto<DropZones.length; upto++) {
					if (DropZonesOccupied[upto]==false) {
						break;
					}
				}
				for (upto; upto>pos; upto--) {
					shiftPositionsSub(upto,-1);
				}
			}
			else if (direction==-1) {
				for (upto=pos; upto>0; upto--) {
					if (DropZonesOccupied[upto]==false) {
						break;
					}
				}
				for (upto; upto<pos; upto++) {
					shiftPositionsSub(upto,1);
				}
			}
		}
		
		private function shiftPositionsSub(num:uint, cha:int):void {
			var tempArr:Array;
			
			DropZonesOccupied[num]=true;
			DropZonesOccupied[num+cha]=false;
			tempArr=identifyBehavObjectFromPos(new Point(DropZones[num+cha].x,DropZones[num+cha].y));
			var myuberSprite:uberSprite=tempArr.pic;
			myuberSprite.x=DropZones[num].x+shiftX;
			myuberSprite.y=DropZones[num].y+shiftY;
			tempArr.position=num;
		}
		
		
		
		private function identifyBehavObjectFromPos(p:Point):Array {
			var tempArr:Array=new Array  ;
			var myuberSprite:uberSprite=new uberSprite  ;
			for (var i:uint=0; i<behavObjects.length; i++) {
				myuberSprite=behavObjects[i].pic;
				if (myuberSprite.x-shiftX==p.x&&myuberSprite.y-shiftY==p.y) {
					tempArr=behavObjects[i];
					break;
				}
			}
			return tempArr;
		}
		
		
		override public function kill():void {
			startingPt=null;
			DropZonesOccupied=null;
			movingBlock=null;
			
			for (var i:uint=0; i<behavObjects.length; i++) {
				if (super.behavObjects[i].pic&&super.behavObjects[i].pic.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					super.behavObjects[i].pic.removeEventListener(MouseEvent.MOUSE_DOWN, startBlockMove);
				}
			}
			if (DropZones) {
				for (i=0; i<DropZones.length-1; i++) {
					theStage.removeChild(DropZones[i]);
				}
			}
			DropZones=null;
			super.kill();
		}
	}
}