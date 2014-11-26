
/**
 * @author  Devon O. Wolfgang
 * @date   29NOV06
 
 Changed by noponies 2008
 */
/**********************************************************************************
USEAGE
***********************************************************************************
 var cs:ContentScroller = new ContentScroller(yourContent:Sprite,maskHeight:int,maskWidth:int);

 eg;
 cs = new ContentScroller(container,400,200 );
	addChild(cs);
************************************************************************************
EVENTS
************************************************************************************
	And to dispatch an event to the scroller class
	
	dispatchEvent(new Event(ContentScroller.CONTENT_CHANGE, true));
***********************************************************************************/

package com.xperiment.stimuli.primitives{

	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.display.Stage;
	import com.xperiment.stimuli.primitives.shape;

	public class ContentScroller extends Sprite {
		//static const use for listening for content change events. On hearing this
		//event, the class checks to see if its scroll bar widgets are needed, if not
		//it turns them off
		public static  const CONTENT_CHANGE:String = "contentchange";
		
		private var stuffOnScreen:Array=new Array;
		
		private var _mask:Sprite;
		private var _content:Sprite;
		private var _dragger:Sprite;
		private var _sizer:Sprite;
		private var _locDragger:Sprite;
		private var _scrollerTrack:Sprite
		private var border:Sprite;
		private var _easeRate:Number = 2
		private var _direction:String = "vertical"
		private var maskWidth:int
		private var maskHeight:int
		private var scrollerOffset:int = 10
		
		//rollover colour changes for scroll widgets
		private var colorInfo:ColorTransform
		private var oldColor:ColorTransform
		private var overTint:int = 0xCCCCCC

		private var _scrollValue:Number;
		private var _orgY:Number;
		private var _orgX:Number;
		private var _ratio:Number;
		private var _ty:Number;
		
		private var minDragPointX:uint;
		private var minDragPointY:uint;
		private var maxDragX:uint=2000;
		private var maxDragY:uint=2000;
		
		private var wantBox:Boolean=true;
		private var obj:Object;

		public function ContentScroller(obj:Object) {
		this.obj=obj;

		wantBox=obj.wantBox;
		_content=obj.content;
		drawBorder(obj.maskWidth,obj.maskHeight);
		this.addChild(_content);
		stuffOnScreen.push(_content);
		
		//create the mask for the passed in content
		
		 _mask = drawRect(1, 1, 0x000000); 
         _mask.x = _content.x; 
         _mask.y = _content.y;
		 _mask.width = obj.maskWidth
		 _mask.height = obj.maskHeight
		 _content.mask = _mask;
		 		
		 		 
		 // create scrollbar sprite 
		
		 _dragger = drawRect(15, 45, 0x141414); 
		 _dragger.x = _mask.x+_mask.width+scrollerOffset; 
		 _dragger.y = _content.y;
		 

		 //create scroller track
		 _scrollerTrack = drawRect(15, _mask.height, 0xAAAAAA); 
         _scrollerTrack.x = _mask.x+_mask.width+scrollerOffset; 
         _scrollerTrack.y = _content.y; 
	
		 if(obj.mover){
	  // create scrollbar sprite 
			 _locDragger = drawRect(30, 30, 0x141414); 
			 _locDragger.x = -15;
			 _locDragger.y = -15; 
			 _content.addChild(_locDragger)
			  this.addChild(_locDragger);
		}
				
		// create sizer sprite 
		 if(obj.sizer){
		 _sizer = drawSizer(50, 10, 0x141414);
		 _sizer.rotation=45;
		 _sizer.x = _scrollerTrack.x-10;
		 _sizer.y = _scrollerTrack.y+_scrollerTrack.height-10; 
		 _content.addChild(_sizer);
		  this.addChild(_sizer);
		 }
		 
		 //add the scroller widgets to the display list
		 this.addChild(_mask)
		 this.addChild(_scrollerTrack)
		 this.addChild(_dragger)

		 stuffOnScreen.push(_mask);
		 stuffOnScreen.push(_scrollerTrack);
		 stuffOnScreen.push(_dragger);
		 if(_locDragger)stuffOnScreen.push(_locDragger);
		 if(_sizer)stuffOnScreen.push(_sizer);
		 
		 //access the color transform objects of the dragger
		colorInfo = _dragger.transform.colorTransform
		oldColor = _dragger.transform.colorTransform

		switch (_direction) {
				case "horizontal" :
					initHorizontal();
					break;
				case "vertical" :
					initVertical();
					break;
			}
		

		
		addListeners();
		if(obj.moveToBottom)toBottom();
		handleContentChange();
		
		
		}
				
		private function drawBorder(maskWidth:uint, maskHeight:uint):void{
			if (border)this.removeChild(border);
			border=new Sprite();
			if(obj.wantBox)border.graphics.lineStyle(5,0xFFF000,1);
			if(obj.background)border.graphics.beginFill(obj.background);
			else border.graphics.beginFill(0xFFFFFF);
			border.alpha=.90;
			border.graphics.drawRect(0, 0, maskWidth, maskHeight);
			border.graphics.endFill();
			this.addChildAt(border,0);
			stuffOnScreen.push(border);
		}
		
		
		private function drawSizer(w:Number, h:Number, col:int):Sprite{
			var s:Sprite = new Sprite;
			s.graphics.beginFill(col);
			s.graphics.drawRect(0,0,w,h);
			s.graphics.endFill();s.graphics.beginFill(col);
			s.graphics.drawCircle(w,h,w/2);
			s.graphics.endFill();
			s.rotation=45;
			return s;
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
		
		private function handleContentChange(event:Event = null):void {
			if (_direction == "vertical" && _content.height <= _mask.height+20) {
				_dragger.visible=false;
				_scrollerTrack.visible =false
			} else if (_direction == "horizontal" && _content.width <= _mask.width) {
				_dragger.visible=false;
				_scrollerTrack.visible =false
			} else {
				_dragger.visible=true;
				_scrollerTrack.visible = true
			}
			
		}
		
		//horizontal scrolling
		private function initHorizontal():void {
				_scrollValue=_mask.width - _dragger.width;
				_orgX=_dragger.x;
		}
		
		//vertical scrolling
		private function initVertical():void {
				_scrollValue=_mask.height - _dragger.height;
				_orgY=_dragger.y;
		}
		//add listeners
		private function addListeners():void {

			_dragger.addEventListener(MouseEvent.MOUSE_DOWN,onDraggerPress,false,0,true);
			_dragger.addEventListener(MouseEvent.MOUSE_UP,onDraggerUp);
			_dragger.buttonMode = true
			
			
			if(_locDragger){
			
				_locDragger.addEventListener(MouseEvent.MOUSE_DOWN,onLocDraggerPress,false,0,true);
				_locDragger.addEventListener(MouseEvent.MOUSE_UP, upLocDraggerPress)
				_locDragger.buttonMode = true
			}
			if(_sizer){
				_sizer.addEventListener(MouseEvent.MOUSE_DOWN,onSizerPress,false,0,true);
				_sizer.addEventListener(MouseEvent.MOUSE_UP, upSizerPress)
				_sizer.buttonMode = true
			}
		}
		

		
		private function onDraggerPress(me:MouseEvent):void {
			colorInfo.color = overTint;
    		// apply the change to the display object
    		_dragger.transform.colorTransform = colorInfo
			_ratio=_dragger.y - _orgY / _scrollValue;
			_ty=_orgY - _content.height - _mask.height * _ratio;
			
			
			
			_dragger.startDrag(false,new Rectangle(_scrollerTrack.x,_scrollerTrack.y,_scrollerTrack.width-_dragger.width,_scrollerTrack.height-_dragger.height));
			if (_direction == "vertical") {
				_dragger.addEventListener(MouseEvent.MOUSE_MOVE,onVerticalScroll,false,0,true);
				_dragger.stage.addEventListener(MouseEvent.MOUSE_MOVE,onVerticalScroll,false,0,true);
			} else if (_direction == "horizontal") {
				_dragger.addEventListener(MouseEvent.MOUSE_MOVE,onHorizontalScroll,false,0,true);
				_dragger.stage.addEventListener(MouseEvent.MOUSE_MOVE,onHorizontalScroll,false,0,true);
			}
		}
		private function onDraggerUp(me:MouseEvent):void {
			_dragger.transform.colorTransform = oldColor
			_dragger.stopDrag();
			_dragger.removeEventListener(MouseEvent.MOUSE_MOVE,onVerticalScroll);
			_dragger.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onVerticalScroll);
			_dragger.removeEventListener(MouseEvent.MOUSE_MOVE,onHorizontalScroll);
			_dragger.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onHorizontalScroll);
		}
		private function onVerticalScroll(me:MouseEvent):void {
			me.updateAfterEvent();
			if (! _content.willTrigger(Event.ENTER_FRAME)) {
				_content.addEventListener(Event.ENTER_FRAME,moveVertical,false,0,true);
			}
		}
		private function onHorizontalScroll(me:MouseEvent):void {
			me.updateAfterEvent();
			if (! _content.willTrigger(Event.ENTER_FRAME)) {
				_content.addEventListener(Event.ENTER_FRAME,moveHorizontal,false,0,true);
			}
		}
		
		
		private function moveVertical(e:Event):void {
			var ratio:Number = (_dragger.y - _orgY) / _scrollValue;
			var ty:Number=_orgY - (_content.height - _mask.height) * ratio;
			var dist:Number=ty - _content.y;
			var moveAmount:Number=dist / _easeRate;
			_content.y+= moveAmount;
			if (Math.abs(_content.y - ty) < 1) {
				_content.removeEventListener(Event.ENTER_FRAME,moveVertical);
				_content.y=ty;
			}
		}
		private function moveHorizontal(e:Event):void {
			 var ratio:Number = (_dragger.x - _orgX) / _scrollValue;
  			var tx:Number = _orgX - (_content.width - _mask.width) * ratio;
			var dist:Number=tx - _content.x;
			var moveAmount:Number=dist / _easeRate;
			_content.x+= moveAmount;
			if (Math.abs(_content.x - tx) < 1) {
				_content.removeEventListener(Event.ENTER_FRAME,moveHorizontal);
				_content.x=tx;
			}
		}
		
		private function upSizerPress(e:MouseEvent):void{
			trace(prevSizerPosx+" "+prevSizerPosy);
			trace(e.target.x+" "+e.target.y);
			_sizer.stopDrag();

			//_content.removeChild(_sizer);
			if(wantBox)drawBorder(e.target.x,e.target.y)
			_sizer.x-=15
			_sizer.y-=15;
			_mask.width=e.target.x;
			_mask.height=e.target.y;
			_scrollerTrack.x=e.target.x+scrollerOffset+_scrollerTrack.width;
			_scrollerTrack.height=e.target.y+scrollerOffset;
			_dragger.x=e.target.x+scrollerOffset+_scrollerTrack.width;
			_scrollValue=_mask.height - _dragger.height;
			toBottom();

			
			
			//_content.addChild(_sizer);
			_locDragger.transform.colorTransform = oldColor;
		}
		
		private var prevSizerPosx:int;
		private var prevSizerPosy:int;
			
		private function onSizerPress(e:MouseEvent):void {
			prevSizerPosx=_sizer.x;
			prevSizerPosy=_sizer.y;
			trace(prevSizerPosx);
			_sizer.startDrag(false,new Rectangle(+minDragPointX,minDragPointY,_content.width-+minDragPointX,_content.height-minDragPointY));
			colorInfo.color = overTint;
			_sizer.transform.colorTransform = colorInfo;
		}
		
		


		private function upLocDraggerPress(e:MouseEvent):void{
			_content.stopDrag();
			_locDragger.transform.colorTransform = oldColor;
		}
		

		private function onLocDraggerPress(e:MouseEvent):void {
			this.startDrag(false);
			colorInfo.color = overTint;
			_locDragger.transform.colorTransform = colorInfo;
		}

		
	
	public function toBottom():void{

			switch (_direction) {
				case "horizontal" :
					_dragger.x=_mask.width-_dragger.width;
					_ratio=_dragger.x - _orgX / _scrollValue;
					_ty=_orgX - _content.width - _mask.width * _ratio;
					_content.x=_orgX - (_content.width - _mask.width) * (_dragger.x - _orgX) / _scrollValue;
					break;
				case "vertical" :
					_dragger.y=_mask.height-_dragger.height;				
					_ratio=_dragger.y - _orgY / _scrollValue;
					_ty=_orgY - _content.height - _mask.height * _ratio;
					_content.y=_orgY - (_content.height - _mask.height) * (_dragger.y - _orgY) / _scrollValue;
					break;
			}
			_dragger.stopDrag();
		}
	
		public function kill():void{
			
			if(_dragger.hasEventListener(MouseEvent.MOUSE_DOWN))_dragger.removeEventListener(MouseEvent.MOUSE_DOWN,onDraggerPress);
			if(_dragger.hasEventListener(MouseEvent.MOUSE_UP))_dragger.removeEventListener(MouseEvent.MOUSE_UP,onDraggerUp);
			
			if(_locDragger && _locDragger.hasEventListener(MouseEvent.MOUSE_DOWN))_locDragger.removeEventListener(MouseEvent.MOUSE_DOWN,onLocDraggerPress);
			if(_locDragger && _locDragger.hasEventListener(MouseEvent.MOUSE_UP))_locDragger.removeEventListener(MouseEvent.MOUSE_UP, upLocDraggerPress)
			
			if(_sizer && _sizer.hasEventListener(MouseEvent.MOUSE_DOWN))_sizer.removeEventListener(MouseEvent.MOUSE_DOWN,onSizerPress);
			if(_sizer && _sizer.hasEventListener(MouseEvent.MOUSE_UP))_sizer.removeEventListener(MouseEvent.MOUSE_UP, upSizerPress);
			
			for (var i:uint=0;i<stuffOnScreen.length;i++){
				if(this.contains(stuffOnScreen[i]))this.removeChild(stuffOnScreen[i]);
			}

	}
	

		
	}
}