package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;
	import com.xperiment.behaviour.behav_baseClass;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	
	public class behavDragTolineScale extends behav_baseClass
	{

		private var movingBlock:uberSprite;
		private var _ls:addSlider;
		private var pointers:Object = {};
		private var pointer:Shape;
		
		
		override public function setVariables(list:XMLList):void {
			setVar("string","lineScalePeg","");
			setVar("string","orientateToPointY","");
			setVar("string", "horizontalPivotPoint","");
			setVar("string", "verticalPivotPoint","");
			
			super.setVariables(list);
		}	
		
		override public function nextStep(id:String=""):void{
			if(_ls)_ls.overrideResults=results;
		}
		
		private function results():Array{
			var data:Array = [];
			
			var tempData:Array;
			
			
			for each(var peg:String in pointers){
				pointer = pointers[peg];
				tempData=[];
				tempData.event=peg; 
				tempData.data=calcPercentPos(peg);
				data.push(tempData);
			}
				
			return data;
		}
		

		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('done')==false){

				uniqueProps.done= function():int{
					var count:int =0;
					for (var peg:String in pointers){
						count++;
					}
					
					return count;
				};
	
				
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		override public function givenObjects(obj:uberSprite):void{

			if(obj.peg!=getVar("lineScalePeg"))obj.addEventListener(MouseEvent.MOUSE_DOWN, startBlockMove,false,0,true);
			else{
				
				if(obj is addSlider){
					_ls = obj as addSlider
						
					_ls.disable();
						
					lineY=_ls.pic.y+_ls.overlay.y+_ls.overlay.height*.5-_ls.getVar("tagLength")*.5;
					pointerSize=_ls.getVar("pointerSize");
					pointerOutLine=_ls.getVar("triangleLineColour");
					pointerFill=_ls.getVar("sliderColour");
					pointerThickness=_ls.getVar("lineThickness");
				}
				else throw new Error("in behavDragTolineScale (peg="+peg+"), you have not specified a line scale for lineScalePeg.  You specified '"+obj.peg+"' as a line Scale which it is not.");
			}
			
			
			super.givenObjects(obj);
		}
		
		public function startBlockMove(e:MouseEvent):void {
		
			
			theStage.addEventListener(MouseEvent.MOUSE_UP, stopMotion,false,0,true);
			theStage.addEventListener(MouseEvent.MOUSE_MOVE, move,false,0,true);
			
			movingBlock=uberSprite(e.currentTarget.pic);
			movingBlock.parent.setChildIndex(movingBlock,movingBlock.parent.numChildren-1);

			if(pointers[movingBlock.peg]==undefined){
				pointers[movingBlock.peg] = new Shape;
				
				
			
				theStage.addChild(pointers[movingBlock.peg]);
			}
			pointer = pointers[movingBlock.peg];
			
			var rect:Rectangle = new Rectangle(_ls.x-movingBlock.width+pointerSize,0,_ls.pic.myWidth+movingBlock.width-pointerSize*2,theStage.height);
			movingBlock.startDrag(false,rect);
			
			
		}
		
		
		private var blockY:int;
		private var lineX:int;
		private var lineY:Number;
		private var pointerSize:Number;
		private var pointerFill:Number;
		private var pointerOutLine:Number;
		private var pointerThickness:Number;
		
		public function move(e:MouseEvent):void {
			
			if(movingBlock.myWidth*.5+movingBlock.x<_ls.pic.x) lineX=_ls.x;
			else if(movingBlock.myWidth*.5+movingBlock.x>_ls.pic.x+_ls.myWidth) lineX=_ls.myWidth+_ls.x;
			else lineX = movingBlock.myWidth*.5+movingBlock.x
			
			if(movingBlock.y+movingBlock.myHeight<lineY)blockY=movingBlock.y+movingBlock.height+5;
			else if(movingBlock.y<lineY )blockY=movingBlock.y+movingBlock.height*.5-5;
			else blockY=movingBlock.y-5;
			

			pointer.graphics.clear()
			pointer.graphics.beginFill(pointerFill);
			pointer.graphics.lineStyle(pointerThickness,pointerOutLine);

			pointer.graphics.moveTo(lineX,lineY);
			pointer.graphics.lineTo(lineX-pointerSize*.5,blockY);
			pointer.graphics.lineTo(lineX+pointerSize*.5,blockY);
			pointer.graphics.lineTo(lineX,lineY);

		}
		
		private function calcPercentPos(peg:String):Number{
			
			for each(movingBlock in behavObjects){
				if(movingBlock.peg==peg)break;
			}
			
			if(movingBlock.myWidth*.5+movingBlock.x<_ls.pic.x) lineX=_ls.x;
			else if(movingBlock.myWidth*.5+movingBlock.x>_ls.pic.x+_ls.myWidth) lineX=_ls.myWidth+_ls.x;
			else lineX = movingBlock.myWidth*.5+movingBlock.x
			
			return (lineX-_ls.x)	/	_ls.myWidth *	100;
		}
		
		public function stopMotion(evt:MouseEvent):void {
			theStage.removeEventListener(MouseEvent.MOUSE_MOVE, move);
			theStage.removeEventListener(MouseEvent.MOUSE_UP, stopMotion);
			if(movingBlock)movingBlock.stopDrag();
			movingBlock = null;
			pointer=null;
		}
		
		override public function kill():void{
		
			for each(var pic:uberSprite in behavObjects){
				if(pic.hasEventListener(MouseEvent.MOUSE_DOWN))pic.addEventListener(MouseEvent.MOUSE_DOWN, startBlockMove,false,0,true);
			}
			
			for each(pointer in pointers){
				theStage.removeChild(pointer);
				pointer=null;
			}
			pointers = null;
			
			super.kill();
		}
		
		
		
		
	}
}