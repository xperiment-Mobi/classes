package com.xperiment.stimuli.primitives
{
	import com.bit101.components.Style;	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BasicButton extends BasicComponent
	{
		public var label:BasicLabel = new BasicLabel();

		protected var _back:Sprite;
		protected var _face:Sprite;
		protected var _over:Boolean = false;
		protected var _down:Boolean = false;
		protected var _selected:Boolean = false;
		protected var _toggle:Boolean = false;
		
		public function kill():void{
			listeners(false);
		}


		
		///////////////////AW ADDED
		public function listeners(on:Boolean):void{
			var f:Function;
			if(on)	f=this.addEventListener;
			else	f=this.removeEventListener;
			
			f(MouseEvent.MOUSE_UP, onMouseGoUp);
			f(MouseEvent.ROLL_OUT, onMouseOut);
			f(MouseEvent.MOUSE_OVER,onMouseOver);
			f(MouseEvent.MOUSE_DOWN,onMouseGoDown);
		
		}
		//////////////////////////
		

		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		public function init():void
		{
			drawBack();
			addChild(_back);
			label.myWidth=this.myWidth;
			label.myHeight=this.myHeight;
			sortLabel();
			drawFace();
			
			
			listeners(true);
			
			this.buttonMode=true;
		}
		
		private function sortLabel():void
		{
			label.init();
			//label.selectable=false;
			addChild(label);
			sortLabelPosition(label);
			//label.x-=10;

		}
	
		
		private function drawBack():void
		{
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			_back.mouseEnabled = false;
		
			_back.graphics.clear();
			_back.graphics.beginFill(Style.BACKGROUND);
			_back.graphics.drawRect(0, 0, myWidth, myHeight);
			_back.graphics.endFill();
			
		}
		
		/**
		 * Draws the face of the button, color based on state.
		 */
		protected function drawFace():void
		{
			if(_face)this.removeChild(_face);
			
			_face = new Sprite();
		
			_face.mouseEnabled = false;
			_face.filters = [getShadow(1)];
			_face.x = 1;
			_face.y = 1;
			;
			
			_face.graphics.clear();
			if(_down)
			{
				_face.graphics.beginFill(Style.BUTTON_DOWN);
			}
			else
			{
				_face.graphics.beginFill(Style.BUTTON_FACE);
			}
			_face.graphics.drawRect(0, 0, myWidth - 2, myHeight - 2);
			_face.graphics.endFill();
			
			addChildAt(_face,1);

			
		}
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		

		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseOver handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			if(!_down)
			{
				_face.filters = [getShadow(1)];
			}
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoDown(event:MouseEvent):void
		{
			_down = true;
			drawFace();
			_face.filters = [getShadow(1, true)];
			if(stage)stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		/**
		 * Internal mouseUp handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoUp(event:MouseEvent):void
		{
			if(_toggle  && _over)
			{
				_selected = !_selected;
			}
			_down = _selected;
			drawFace();
			_face.filters = [getShadow(1, _selected)];
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the label text shown on this Pushbutton.
		 */

		
		public function set selected(value:Boolean):void
		{
			if(!_toggle)
			{
				value = false;
			}
			
			_selected = value;
			_down = _selected;
			_face.filters = [getShadow(1, _selected)];
			drawFace();
		}
		
		public function get selected():Boolean{return _selected;}
		public function set toggle(value:Boolean):void{_toggle = value;}
		public function get toggle():Boolean
		{return _toggle;}
	
	}
}