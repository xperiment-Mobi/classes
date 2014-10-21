package com.stimuli.primitives{

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.display.Stage;


	public class moveBarSizer extends Sprite {
		//static const use for listening for content change events. On hearing this
		//event, the class checks to see if its scroll bar widgets are needed, if not
		//it turns them off
		public static  const CONTENT_CHANGE:String = "contentchange";
		
		private var _content:Sprite;
		private var _locDragger:Sprite;
		private var _sizer:Sprite;
		private var scrollerOffset:int = 10

		//rollover colour changes for scroll widgets
		private var colorInfo:ColorTransform
		private var oldColor:ColorTransform
		private var overTint:int = 0xCCCCCC
		
		private var minDragPointX:uint;
		private var minDragPointY:uint;
		private var maxDragX:uint=2000;
		private var maxDragY:uint=2000;

		public function moveBar(content:Sprite,width:uint,height:uint) {
			minDragPointX=width-50;
			minDragPointY=height-50;
			
			_content=content;
			
			
			 // create scrollbar sprite 
			 _locDragger = drawRect(30, 30, 0x141414); 
			 _locDragger.x = -15;
			 _locDragger.y = -15; 
			 _content.addChild(_locDragger)
					
			// create sizer sprite 
			 _sizer = drawRect(50, 10, 0x141414);
			 _sizer.rotation=45;
			 _sizer.x = width-15;
			 _sizer.y = height-15; 
			 _content.addChild(_sizer);
			 
			 //access the color transform objects of the dragger
			colorInfo = _locDragger.transform.colorTransform
			oldColor = _locDragger.transform.colorTransform
	
			addListeners();
		}
		
		//Rectangle// widgets drawing function
		private function drawRect(w:Number, h:Number, col:int):Sprite {
			var s:Sprite = new Sprite;
			if(col!=-1)s.graphics.beginFill(col);
			s.graphics.drawRect(0, 0, w, h);
			s.graphics.endFill();
			return s;
		}
	
		
		//Test content dimensions against mask dimensions. If content height or width is less than the mask height or width
		//then we don't need to scroll anything and so the scroller widgets can be hidden. You can of course do something else
		//with the widgets, like disable them and change their alpha etc
		
		
	
		private function addListeners():void {
			_locDragger.addEventListener(MouseEvent.MOUSE_DOWN,onDraggerPress,false,0,true);
			_locDragger.addEventListener(MouseEvent.MOUSE_UP, upDraggerPress)
			_locDragger.buttonMode = true
			//listen for content changes
			_sizer.addEventListener(MouseEvent.MOUSE_DOWN,onSizerPress,false,0,true);
			_sizer.addEventListener(MouseEvent.MOUSE_UP, upSizerPress)
			_sizer.buttonMode = true
			
		}
		
				
		private function upSizerPress(e:MouseEvent):void{
			trace(_content.width+" "+_content.height);
			_sizer.stopDrag();
			_sizer.x=_content.width-15
			_sizer.y=_content.height-15;
			//_content.removeChild(_sizer);
			_content.width+=e.target.x;
			_content.height+=e.target.y;
			
			
			//_content.addChild(_sizer);
			_locDragger.transform.colorTransform = oldColor;
		}
		
		private function onSizerPress(e:MouseEvent):void {
			_sizer.startDrag(false,new Rectangle(_content.x+minDragPointX,_content.y+minDragPointY,maxDragX,maxDragY));
			colorInfo.color = overTint;
			_sizer.transform.colorTransform = colorInfo;
		}
		
		


		private function upDraggerPress(e:MouseEvent):void{
			_content.stopDrag();
			_locDragger.transform.colorTransform = oldColor;
		}
		

		private function onDraggerPress(e:MouseEvent):void {
			_content.startDrag(false);
			colorInfo.color = overTint;
			_locDragger.transform.colorTransform = colorInfo;
		}

		
		
		
		
	}
}