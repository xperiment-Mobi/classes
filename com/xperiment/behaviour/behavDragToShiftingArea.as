package com.xperiment.behaviour{
	import com.xperiment.uberSprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.filters.GlowFilter;

	public class behavDragToShiftingArea extends behav_baseClass {
		private var startingPt:Point=new Point  ;
		private var DropZones:Array = new Array;
		private var DropZonesOccupied:Array = new Array;
		private var currentMovingBlockNumber:uint=9999;
		private var movingBlock:uberSprite;
		private var objectsSelected:Array;
		private var inDZ:Boolean=false;
		private var myDelayTimer:Timer;
		private const timerWait:uint=500;
		private var dragableObjects:Array = new Array;
		private var draggedObjsList:Array;

		override public function setVariables(list:XMLList):void {
			setVar("boolean","lockInPlaceOncePlaced",false);
			setVar("boolean","snapBackToOriginalLocation",false);
			setVar("boolean","showDropZones",false);
			setVar("string","snapToDropZones","middle");
			setVar("string","whichImageHideAfter",""); //either 'selected', 'unselected', ''.
			setVar("uint","actionsAfterHowManyFilled",1);
			setVar("string","dragPegs","");
			setVar("string","indicator","");
			setVar("boolean","useNamesInResults",false);
			super.setVariables(list);
			if(list.@hideResults.toString()!="true")OnScreenElements.hideResults=false;
			
			draggedObjsList = getVar("dragPegs").split(",");
		}

		override public function returnsDataQuery():Boolean {
			 return true;
		}

		public function filled():void {

			calcReturnData();
			//trace("finished");
			behaviourFinished();

			if(behavObjects){
				for (var i:uint=0; i<behavObjects.length; i++) {
					if (super.behavObjects[i].pic && super.behavObjects[i].pic.hasEventListener(MouseEvent.MOUSE_DOWN)) {
						super.behavObjects[i].pic.removeEventListener(MouseEvent.MOUSE_DOWN, startBlockMove);
					}
				}
			}
			if (getVar("whichImageHideAfter")!="") whichImageHideAfter();
		}
		
		private function calcReturnData():void
		{	
			var tempData:Array;
			for (var i:uint=0;i<DropZonesOccupied.length;i++){
			
				if(DropZonesOccupied[i]!=null){
					
					tempData = new Array();
					tempData.data=DropZones[i].peg;
					//trace(111,DropZonesOccupied[i].peg,DropZones[i].peg)
					
					if(dragableObjects.length>1)tempData.event=DropZones[i].peg;
					else tempData.event=peg;
				
					super.objectData.push(tempData);
				}
			}
			
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


		public function startBlockMove(e:MouseEvent):void {
			movingBlock=uberSprite(e.currentTarget.pic);
		
			movingBlock.parent.setChildIndex(movingBlock,movingBlock.parent.numChildren-1);
			startingPt.x=movingBlock.x;
			startingPt.y=movingBlock.y;
			movingBlock.startDrag();
			for (var i:uint=0; i<behavObjects.length; i++) {
				if (behavObjects[i].pic==movingBlock) {
					currentMovingBlockNumber=i;
					break;
				}
			}
			
			if(DropZonesOccupied.indexOf(movingBlock)!=-1){
				DropZonesOccupied[DropZonesOccupied.indexOf(movingBlock)]=null;
				myDelayTimer=new Timer(timerWait,1);
				myDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,stopTimer,false,0,true);
				

				myDelayTimer.start();
			}
			
			theStage.addEventListener(MouseEvent.MOUSE_UP, stopMotion,false,0,true);
			theStage.addEventListener(MouseEvent.MOUSE_MOVE, moveL,false,0,true);
		}
		
		protected function stopTimer(e:TimerEvent):void{myDelayTimer=null;e.target.removeEventListener(TimerEvent.TIMER_COMPLETE,stopTimer);}
		
		override public function givenObjects(obj:uberSprite):void {

			if (draggedObjsList.indexOf(obj.peg)!=-1) {//if obj is of type dropZone (specified via 'areaNamePrefix') then do dropzone stuff.
				dragableObjects.push(obj);
				obj.addEventListener(MouseEvent.MOUSE_DOWN, startBlockMove,false,0,true);
			}
			else {
				DropZones.push(obj);
				DropZonesOccupied.push(null);
			}
			
			super.givenObjects(obj);
		}

	

		public function stopMotion(e:MouseEvent):void {
			
			if(myDelayTimer){
				snapInPlace();
			}
			
			theStage.removeEventListener(MouseEvent.MOUSE_MOVE, moveL);
			movingBlock.stopDrag();
			if (inDZ==false && getVar("snapBackToOriginalLocation")) {
				movingBlock.x=startingPt.x;
				movingBlock.y=startingPt.y;
			}						
			
			movingBlock=null;
			//below, a test to see if the dropZones are full enough to emit a reponse (if required ;)
			if (getVar("actionsAfterHowManyFilled")!=0 && countBooleanContents(DropZonesOccupied)==getVar("actionsAfterHowManyFilled")) {
				filled();
			}
	
			theStage.removeEventListener(MouseEvent.MOUSE_UP, stopMotion);
			theStage.removeEventListener(MouseEvent.MOUSE_MOVE, moveL);
		}

		private function moveL(e:MouseEvent):void {
			movingBlock.filters = null;
			if(myDelayTimer==null){
				if(snapInPlace())stopMotion(e);
			}
		}
		
		private function snapInPlace():Boolean
		{
			for (var i:uint=0; i<DropZones.length; i++) {
				
				if (!DropZonesOccupied[i] && DropZones[i].hitTestPoint(movingBlock.x+(movingBlock.width*.5),movingBlock.y+(movingBlock.height*.5))) {
					inDZ=true;
					
					movingBlock.x=DropZones[i].x+(DropZones[i].myWidth-movingBlock.myWidth)*.5;
					movingBlock.y=DropZones[i].y+(DropZones[i].myHeight-movingBlock.myHeight)*.5;
					
					if(getVar("indicator")!=""){
						
						var indicator:Array=(getVar("indicator") as String).split(",");
						if(indicator.length==2){
							movingBlock.filters = [new GlowFilter(0xFF6699, .75, 12, 12, 2, 2, false, false)];
						}
					}
					
					DropZonesOccupied[i]=movingBlock;
					
					if (getVar("lockInPlaceOncePlaced")) {
						movingBlock.removeEventListener(MouseEvent.MOUSE_DOWN, startBlockMove);
					}
					return true;
				}
			}
			return false;
		}
		
		private function countBooleanContents(arr:Array):uint {
			var count:uint=0;
			for (var i:uint=0; i< arr.length; i++) {
				if (arr[i]!=null) {
					count++;
				}
			}
			return count;
		}



		override public function kill():void {
			if(myDelayTimer){
				myDelayTimer.stop(); 
				myDelayTimer=null;
			}
			
			
			
			startingPt=null;
			movingBlock=null;
			if(theStage)super.theStage.removeEventListener(MouseEvent.MOUSE_UP, stopMotion);
			if(theStage && theStage.hasEventListener(MouseEvent.MOUSE_MOVE))theStage.removeEventListener(MouseEvent.MOUSE_MOVE, moveL);
			
			dragableObjects=null;
			
			for (var i:uint=0; i<behavObjects.length; i++) {
				if (super.behavObjects[i].pic&&super.behavObjects[i].pic.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					super.behavObjects[i].pic.removeEventListener(MouseEvent.MOUSE_DOWN, startBlockMove);
				}
				while(behavObjects[i].numChildren>0){
					behavObjects[i].removeChildAt(0);
				}
				
				behavObjects[i]=null;
			}
			
			if(objectsSelected){
				for(i=0;i<objectsSelected.length;i++){
					objectsSelected[i]=null;
				}
			objectsSelected=null;
			}
					

			for (i=0; i<DropZones.length-1; i++) {DropZones[i]=null;}
			DropZones=null;
			
			for (i=0; i<DropZonesOccupied.length-1; i++) {DropZonesOccupied[i]=null;}
			DropZonesOccupied=null;
			
			draggedObjsList=null;
			
			super.kill();
		}
	}
}