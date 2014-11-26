/**
 * ListItem.as
 * Keith Peters
 * version 0.9.10
 * 
 * A single item in a list. 
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


package com.xperiment.stimuli.primitives
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class BasicListItem extends BasicComponent
	{
		protected var _data:Object;
		public var label:BasicLabel = new BasicLabel;
		protected var _defaultColor:uint = 0xffffff;
		protected var _selectedColor:uint = 0xdddddd;
		protected var _rolloverColor:uint = 0xeeeeee;
		protected var _selected:Boolean;
		protected var _mouseOver:Boolean = false;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ListItem.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param data The string to display as a label or object with a label property.
		 */
		
		public function kill():void{
			listeners(false);
			
			label=null;
		}
		
		public function BasicListItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object = null)
		{
			_data = data;
		}
		
		/**
		 * Initilizes the component.
		 */
		public function init() : void
		{
			this.addChild(label);
			draw();
			sortLabelPosition(label,this);
			listeners(true);
			
		}
		
		private function listeners(yes:Boolean):void
		{
			var f:Function;
			if(yes)f=this.addEventListener;
			else f=this.removeEventListener;
			
			f(MouseEvent.MOUSE_OVER,onMouseOver);
			f(MouseEvent.MOUSE_OUT,onMouseOut);
		}		
	
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		public  function draw() : void
		{
			
			this.graphics.clear();
			
			if(_selected)
			{
				graphics.beginFill(_selectedColor);
			}
			else if(_mouseOver)
			{
				graphics.beginFill(_rolloverColor);
			}
			else
			{
				graphics.beginFill(_defaultColor);
			}
			graphics.drawRect(0, 0, myWidth, myHeight);
			graphics.endFill();
		}
		
		
		
		

		protected function onMouseOver(event:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_mouseOver = true;
		}
		
		protected function onMouseOut(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			_mouseOver = false;
		}
		
		
	
		public function set data(value:Object):void{_data = value;}
		public function get data():Object{return _data;}
		public function set selected(value:Boolean):void{_selected = value;}
		public function get selected():Boolean{return _selected;}
		public function set defaultColor(value:uint):void{_defaultColor = value;}
		public function get defaultColor():uint{return _defaultColor;}
		public function set selectedColor(value:uint):void{_selectedColor = value;}
		public function get selectedColor():uint{return _selectedColor;}
		public function set rolloverColor(value:uint):void{_rolloverColor = value;}
		public function get rolloverColor():uint{return _rolloverColor;}
		
	}
}