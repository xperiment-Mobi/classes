/**
 * ComboBox.as
 * Keith Peters
 * version 0.9.10
 * 
 * A button that exposes a list of choices and displays the chosen item. 
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

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	

	public class BasicComboBox extends BasicComponent
	{
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		
		private var _defaultLabel:String = ""; //needs to have getters and setters hence private
		public var dropDownButton:BasicButton;
		protected var _items:Array;
		public var labelButton:BasicButton;
		public var list:BasicList = new BasicList;
		protected var _numVisibleItems:int = 6;
		protected var _open:Boolean = false;
		protected var _openPosition:String = BOTTOM;
		protected var _stage:Stage;
		public var fontSize:uint=12;;
		public var label:String='';
		
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this List.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultLabel The label to show when no item is selected.
		 * @param items An array of items to display in the list. Either strings or objects with label property.
		 */
		
		public function kill():void{
			Listeners(false);
		}

		
		private function Listeners(yes:Boolean):void{
			var f:Function;
			if(yes) f=this.addEventListener;
			else	f=this.removeEventListener;
			

		}
		
		public function init():void
		{
	
			list.autoHideScrollBar = true;
			list.addEventListener(Event.SELECT, onSelect);
			
			labelButton.label.text='';
			labelButton.label.fontSize=fontSize;
			dropDownButton.label.text="+";
			dropDownButton.label.fontSize=fontSize;
			
			setLabelButtonLabel();
			
			Listeners(true);
		}
		
		/**
		 * Determines what to use for the main button label and sets it.
		 */
		protected function setLabelButtonLabel():void
		{
			if(selectedItem == null)labelButton.label.text = _defaultLabel;
			
			else if(selectedItem is String)labelButton.label.text = selectedItem as String;
			
			else if(selectedItem.hasOwnProperty("label") && selectedItem.label is String)labelButton.label.text = selectedItem.label;
			
			else labelButton.label.text = selectedItem.toString();
		
		}
			
		
		
		/**
		 * Removes the list from the stage.
		 */
		protected function removeList():void
		{
			list.visible=false;
			dropDownButton.label.text = "+";			
		}
		

		

		
		
		/**
		 * Adds an item to the list.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 */
		public function addItem(item:Object):void
		{
			list.addItem(item);
		}
		
		/**
		 * Adds an item to the list at the specified index.
		 * @param item The item to add. Can be a string or an object containing a string property named label.
		 * @param index The index at which to add the item.
		 */
		public function addItemAt(item:Object, index:int):void{list.addItemAt(item, index);}
		public function removeItem(item:Object):void{list.removeItem(item);}
		public function removeItemAt(index:int):void{list.removeItemAt(index);}
		public function removeAll():void{list.removeAll();}
	
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when one of the top buttons is pressed. Either opens or closes the list.
		 */
		protected function onDropDown(event:MouseEvent):void
		{
			_open = !_open;
			if(_open)
			{
				list.visible=true;
				_stage.addEventListener(MouseEvent.CLICK, onStageClick);
				dropDownButton.label.text = "-";
			}
			else
			{
				removeList();
			}
		}
		
		/**
		 * Called when the mouse is clicked somewhere outside of the combo box when the list is open. Closes the list.
		 */
		protected function onStageClick(event:MouseEvent):void
		{
			// ignore clicks within buttons or list
			if(event.target == dropDownButton || event.target == labelButton) return;
			if(new Rectangle(list.x, list.y, list.width, list.height).contains(event.stageX, event.stageY)) return;
			_open = false;
			removeList();
		}
		
		/**
		 * Called when an item in the list is selected. Displays that item in the label button.
		 */
		protected function onSelect(event:Event):void
		{
			_open = false;
			dropDownButton.label.text = "+";
			if(stage != null && stage.contains(list))
			{
				stage.removeChild(list);
			}
			setLabelButtonLabel();
			dispatchEvent(event);
		}
		

		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the index of the selected list item.
		 */
		public function set selectedIndex(value:int):void
		{
			list.selectedIndex = value;
			setLabelButtonLabel();
		}
		
		public function get selectedIndex():int
		{
			return list.selectedIndex;
		}
		
		/**
		 * Sets / gets the item in the list, if it exists.
		 */
		public function set selectedItem(item:Object):void
		{
			list.selectedItem = item;
			setLabelButtonLabel();
		}
		public function get selectedItem():Object
		{
			return list.selectedItem;
		}
		
		/**
		 * Sets/gets the default background color of list items.
		 */
		public function set defaultColor(value:uint):void
		{
			list.defaultColor = value;
		}
		public function get defaultColor():uint
		{
			return list.defaultColor;
		}
		
		/**
		 * Sets/gets the selected background color of list items.
		 */
		public function set selectedColor(value:uint):void
		{
			list.selectedColor = value;
		}
		public function get selectedColor():uint
		{
			return list.selectedColor;
		}
		
		/**
		 * Sets/gets the rollover background color of list items.
		 */
		public function set rolloverColor(value:uint):void
		{
			list.rolloverColor = value;
		}
		public function get rolloverColor():uint
		{
			return list.rolloverColor;
		}
		
		/**
		 * Sets the height of each list item.
		 */
		public function set listItemHeight(value:Number):void
		{
			list.listItemHeight = value;
		}
		public function get listItemHeight():Number
		{
			return list.listItemHeight;
		}

		/**
		 * Sets / gets the position the list will open on: top or bottom.
		 */
		public function set openPosition(value:String):void
		{
			_openPosition = value;
		}
		public function get openPosition():String
		{
			return _openPosition;
		}

		/**
		 * Sets / gets the label that will be shown if no item is selected.
		 */
		public function set defaultLabel(value:String):void
		{
			_defaultLabel = value;
			setLabelButtonLabel();
		}
		public function get defaultLabel():String
		{
			return _defaultLabel;
		}

		/**
		 * Sets / gets the number of visible items in the drop down list. i.e. the height of the list.
		 */
		public function set numVisibleItems(value:int):void
		{
			_numVisibleItems = value;
		}
		public function get numVisibleItems():int
		{
			return _numVisibleItems;
		}

		/**
		 * Sets / gets the list of items to be shown.
		 */
		public function set items(value:Array):void
		{
			list.items = value;
		}
		public function get items():Array
		{
			return list.items;
		}
		
		/**
		 * Sets / gets the class used to render list items. Must extend ListItem.
		 */
		public function set listItemClass(value:Class):void
		{
			list.listItemClass = value;
		}
		public function get listItemClass():Class
		{
			return list.listItemClass;
		}
		
		
		/**
		 * Sets / gets the color for alternate rows if alternateRows is set to true.
		 */
		public function set alternateColor(value:uint):void
		{
			list.alternateColor = value;
		}
		public function get alternateColor():uint
		{
			return list.alternateColor;
		}
		
		/**
		 * Sets / gets whether or not every other row will be colored with the alternate color.
		 */
		public function set alternateRows(value:Boolean):void
		{
			list.alternateRows = value;
		}
		public function get alternateRows():Boolean
		{
			return list.alternateRows;
		}

        /**
         * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
         */
        public function set autoHideScrollBar(value:Boolean):void
        {
            list.autoHideScrollBar = value;
        }
        public function get autoHideScrollBar():Boolean
        {
            return list.autoHideScrollBar;
        }
		
		/**
		 * Gets whether or not the combo box is currently open.
		 */
		public function get isOpen():Boolean
		{
			return _open;
		}
	}
}