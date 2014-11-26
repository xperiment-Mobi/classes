/**
 * <p>Original Author: Daniel Freeman</p>
 *
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS' OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */

package com.danielfreeman.extendedMadness {
	
	import com.danielfreeman.extendedMadness.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import com.danielfreeman.madcomponents.*;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import flash.display.GradientType;

/**
 * ScrollTouchGrids component
 * <pre>
 * &lt;dataGrid
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    widths = "p,q,r..."
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    editable = "true|false"
 *    widths = "i(%),j(%),k(%)…"
 *    multiline = "true|false"
 *    titleBarColour = "#rrggbb"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    border = "true|false"
 *    autoLayout = "true|false"
 *    tapToScale = "NUMBER"
 *    auto = "true|false"
 *    fixedColumns = "n"
 *    fixedColumnsColours = "#rrggbb, #rrggbb, ..."
 *    slideFixedColumns = "true|false"
 *    alignGridWidths = "true|false"
 *    showPressed = "true|false"
 *    editButton = "true|false"
 *    editButtonColour = "#rrggbb"
 *    longClickEnabled = "true|false"
 *    <title>
 *    <font>
 *    <headerFont>
 *    <model>
 *    <widths> (depreciated)
 * /&gt;
 * </pre>
 */
	public class UIScrollTouchGrids extends UIScrollDataGrids {
		
		public static const EDIT_BUTTON_MOUSE_DOWN:String = "editButtonMouseDown";
		public static const EDIT_BUTTON_MOUSE_UP:String = "editButtonMouseUp";
		public static const EDIT_BUTTON_LONG_CLICK:String = "editButtonLongClick";
		public static const EDIT_BUTTON_LONG_CLICK_END:String = "editButtonLongClickEnd";
		public static const ROW_SELECTED:String = "rowSelected";
		public static const HEADER_DOWN:String = "headerDown";
		public static const HEADER_CLICKED:String = "headerClicked";
		
		protected static const ROW_SELECT_COLOUR:uint = 0xAAAAFF;
		protected static const EDIT_BUTTON_COLOUR:uint = 0xCC9966;
		protected static const ROW_SELECT_LIMIT:Number = 64.0;
		protected static const BUTTON_WIDTH:Number = 40.0;
		protected static const BUTTON_HEIGHT:Number = 36.0;
		protected static const SENSOR:Number = 20.0;
		protected static const ARROW:Number = 10.0;
		protected static const CURVE:Number = 5.0;
		protected static const RADIUS:Number = 12.0;
		protected static const ALPHA:Number = 0.5;
		protected static const ROW_BORDER:Number = 6.0;
		protected static const DELTAY_THRESHOLD:Number = 128.0;
		protected static const SMALL_Y_THRESHOLD:Number = 16.0;
		protected static const BUTTON_MOVE_THRESHOLD:Number = 20.0;
		
		protected var _clickDelay:Timer = new Timer(150, 1);
		protected var _slideTimer:Timer = new Timer(50, STEPS);
		protected var _rowSelectColour:uint = ROW_SELECT_COLOUR;
		protected var _highlightedRowIndex:int = -1;
		protected var _highlightedDataGrid:UIFastDataGrid = null;
		protected var _originalNoScroll:Boolean;
		protected var _clickedRowIndex:int;
		protected var _lastMousePoint:Point = new Point(0,0);
		protected var _mouseDistance:Number = 0;
		protected var _mouseDistanceX:Number = 0;
		protected var _mouseDistanceY:Number = 0;
		protected var _rowSelect:Boolean = false;
		protected var _showPressed:Boolean;
		protected var _temporaryRowHighlight:Shape;
		protected var _editButton:Sprite = null;
		protected var _editButtonColour:uint = EDIT_BUTTON_COLOUR;
		protected var _deltaEditButtonX:Number;
		protected var _editButtonMouseDown:Boolean = false;
		protected var _alt:Boolean;
		protected var _editButtonMoved:Boolean = false;
		protected var _editButtonLayer:Sprite;
		protected var _headerClicked:Boolean;
		protected var _timer:Timer = new Timer(400, 1);
		protected var _longClickDispatched:Boolean = false;

		
		public function UIScrollTouchGrids(screen : Sprite, xml : XML, attributes : Attributes) {
			_alt = xml.@alt == "true";
			_showPressed = xml.@showPressed == "true";
			addChild(_temporaryRowHighlight = new Shape());
			_temporaryRowHighlight.blendMode = BlendMode.MULTIPLY; //DARKEN;
			addChild(_editButtonLayer = new Sprite());
			super(screen, xml, attributes);
			setChildIndex(_temporaryRowHighlight, getChildIndex(_titleSlider) - 1);
			setChildIndex(_editButtonLayer, numChildren - 1);
			_clickDelay.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			_slideTimer.addEventListener(TimerEvent.TIMER, slideMovement);
			_originalNoScroll = _noScroll;
			if (xml.@editButtonColour.length() > 0) {
				_editButtonColour = UI.toColourValue(xml.@editButtonColour);
			}
			if (xml.@editButton == "true") {
				createEditButton();
			}
			_scrollBarThreshold = Number.POSITIVE_INFINITY;
			if (xml.@longClickEnabled == "true") {
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, longClick);
			}
		}
		
/**
 * Render an edit button
 */
		protected function createEditButton():void {
			_editButtonLayer.addChild(_editButton = new Sprite());
			makeEditButton();
			_editButton.visible = false;
			_editButton.addEventListener(MouseEvent.MOUSE_DOWN, editButtonMouseDown);
		}
	
/**
 * Switch edit button on or off
 */
		public function set editButton(value:Boolean):void {
			if (!value && _editButton && _titleSlider.contains(_editButton)) {
				_titleSlider.removeChild(_editButton);
				_editButton.removeEventListener(MouseEvent.MOUSE_DOWN, editButtonMouseDown);
				_editButton = null;
			}
			else if (value && !_editButton) {
				createEditButton();
			}
		}
		
/**
 * Edit button long click handler
 */
		protected function longClick(event:Event):void {
			if (!_editButtonMoved) {
				dispatchEvent(new Event(EDIT_BUTTON_LONG_CLICK));
				_longClickDispatched = true;
			}
		}
		
/**
 * Edit button mousedown handler
 */
		protected function editButtonMouseDown(event:Event):void {
			
			stage.addEventListener(MouseEvent.MOUSE_UP, editButtonMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, editButtonMouseMove);
			_editButtonMouseDown = true;
			_editButtonMoved = false;
			_lastMousePoint.y = mouseY;
			_mouseDistanceY = 0;
			dispatchEvent(new Event(EDIT_BUTTON_MOUSE_DOWN));
			_longClickDispatched = false;
			_timer.reset();
			_timer.start();
		}
		
/**
 * Edit button movement handler
 */
		protected function editButtonMouseMove(event:Event):void {
			if (!_longClickDispatched) {
				_mouseDistanceY +=  Math.abs(_lastMousePoint.y - mouseY);
				_lastMousePoint.y = mouseY;
				if (_mouseDistanceY > BUTTON_MOVE_THRESHOLD && rowSelectHandler()) {
					setHighlightRow(true);
					_editButtonMoved = true;
					dispatchRowSelected();
				}
			}
		}
		
/**
 * Edit button mouseup handler
 */
		protected function editButtonMouseUp(event:Event):void {
			_timer.stop();
			stage.removeEventListener(MouseEvent.MOUSE_UP, editButtonMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, editButtonMouseMove);
			_editButtonMouseDown = false;
			if (_longClickDispatched) {
				dispatchEvent(new Event(EDIT_BUTTON_LONG_CLICK_END));
			}
			else if (_editButtonMoved) {
				dispatchEvent(new Event(ROW_SELECTED));
			}
			else {
				dispatchEvent(new Event(EDIT_BUTTON_MOUSE_UP));
			}
		}

/**
 * Animate the edit button onto, or off the screen
 */
		public function slideEditButton(direction:Boolean = true):void {
			if (!_editButton) {
				return;
			}
			if (!_slideTimer.running) {
				_editButton.x = !direction ? _attributes.width - _editButton.width : _attributes.width;
			}
			var fromX:Number = _slideTimer.running ? _editButton.x : _attributes.width;
			var toX:Number = _attributes.width - _editButton.width;
			_deltaEditButtonX = (direction ? 1.0 : -1.0) * (toX - fromX) / STEPS;
			_slideTimer.stop();
			_slideTimer.reset();
			_slideTimer.start();
		}
		
		
		protected function slideMovement(event:Event):void {
			_editButton.x += _deltaEditButtonX;
		}
		
/**
 * Set the selection colour
 */
		public function set rowSelectColour(value:uint):void {
			_rowSelectColour = value;
		}
		
/**
 * Enable or disable scrolling
 */
		override public function set scrollEnabled(value:Boolean):void {
			super.scrollEnabled = value;
			_originalNoScroll = _noScroll;
		}
		
/**
 * Convert y coordinate to the grid at that position
 */
		protected function yToDataGrid(y:Number):UIFastDataGrid {
			var index:int = 0;
			while (index + 1 < _dataGrids.length && _dataGrids[index + 1].includeInLayout && y > _dataGrids[index + 1].y) {
				index ++;
			}
			return index >= 0 ? _dataGrids[index] : null;
		}
		
		
		protected function temporaryRowHighlightDraw(highlightedDataGrid:UIFastDataGrid, highlightedRowIndex:int, colour:uint = uint.MAX_VALUE):void {
			if (highlightedRowIndex >= 0 && highlightedRowIndex < highlightedDataGrid.tableCells.length) {
				_temporaryRowHighlight.visible = true;
				_temporaryRowHighlight.graphics.clear();
				var firstCell:UICell = highlightedDataGrid.tableCells[highlightedRowIndex][0];	
				_temporaryRowHighlight.graphics.beginFill(colour < uint.MAX_VALUE ? colour : _rowSelectColour); //, ALPHA);
			//	_temporaryRowHighlight.graphics.lineStyle(ROW_BORDER,_rowSelectColour);
			//	_temporaryRowHighlight.graphics.drawRect(_titleSlider.x, _titleSlider.y + highlightedDataGrid.y + firstCell.y, _slider.getBounds(_slider).right, firstCell.height);
				_temporaryRowHighlight.graphics.drawRect(0, highlightedDataGrid.y + firstCell.y, stage.stageWidth * UI.scale, firstCell.height);
				_temporaryRowHighlight.graphics.endFill();
			}
		}
		
		
		protected function temporaryRowHighlight():void {
			var highlightedDataGrid:UIFastDataGrid = yToDataGrid(_slider.mouseY);
			var highlightedRowIndex:int = highlightedDataGrid ? highlightedDataGrid.yToRow(highlightedDataGrid.mouseY) : -1;
			temporaryRowHighlightDraw(highlightedDataGrid, highlightedRowIndex);
		}
		
		
		override protected function set sliderX(value:Number):void {
			super.sliderX = value;
		}
		
		
		override public function set sliderY(value:Number):void {
			super.sliderY = value;
			_editButtonLayer.y = _temporaryRowHighlight.y = value;
			 
		}
		
		
		protected function temporaryRowClear():void {
			_temporaryRowHighlight.visible = false;		
			if (_editButton) {
				_editButton.visible = false;
			}
		}
		
/**
 * Render edit button shape
 */
		protected function buttonShape(x:Number, y:Number, buttonWidth:Number, height:Number):void {
			var quotient:Number = (ARROW-CURVE)/ARROW;
			_editButton.graphics.moveTo(x, y + BUTTON_HEIGHT/2);
			_editButton.graphics.lineTo(x+quotient*ARROW, y+(1-quotient)*BUTTON_HEIGHT/2);
			_editButton.graphics.curveTo(x+ARROW, y, x+(ARROW+CURVE), y);
			_editButton.graphics.lineTo(x+buttonWidth, y);
			_editButton.graphics.lineTo(x+buttonWidth, y+height);			
			_editButton.graphics.lineTo(x+(ARROW+CURVE), y+height);
			_editButton.graphics.curveTo(x+ARROW, y+height, x+quotient*ARROW, y+height-(1-quotient)*BUTTON_HEIGHT/2);
			_editButton.graphics.lineTo(x, y + BUTTON_HEIGHT/2);
			_editButton.buttonMode = _editButton.useHandCursor = true;
		}
		
/**
 * Render edit button
 */
		protected function makeEditButton():void {
			_editButton.graphics.clear();
			var matr:Matrix=new Matrix();
			_editButton.graphics.beginFill(0, 0);
			_editButton.graphics.drawRect(0, 0, BUTTON_WIDTH, 2 * SENSOR + BUTTON_HEIGHT);
			matr.createGradientBox(BUTTON_WIDTH, BUTTON_HEIGHT, Math.PI/2, 0, SENSOR);
			_editButton.graphics.beginFill(Colour.darken(_editButtonColour));
			buttonShape(0.0, SENSOR, BUTTON_WIDTH, BUTTON_HEIGHT);
			_editButton.graphics.endFill();
			_editButton.graphics.beginGradientFill(GradientType.LINEAR, [Colour.lighten(_editButtonColour),Colour.darken(_editButtonColour),Colour.darken(_editButtonColour)], [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			buttonShape(1.0, 1.0 + SENSOR, BUTTON_WIDTH-1, BUTTON_HEIGHT-1.5);
			_editButton.graphics.endFill();
			_editButton.graphics.beginGradientFill(GradientType.LINEAR, [Colour.darken(_editButtonColour),Colour.darken(_editButtonColour),Colour.lighten(_editButtonColour)], [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			_editButton.graphics.drawCircle((BUTTON_WIDTH + CURVE) / 2, SENSOR + BUTTON_HEIGHT / 2, RADIUS);
			_editButton.graphics.endFill();
		}
		
		
		public function clearHighlightRow():void {
			temporaryRowClear();
		}		
		
		protected function setHighlightRow(slidein:Boolean = false):void {
			if (_highlightedDataGrid && _highlightedRowIndex >= 0 && _highlightedRowIndex < _highlightedDataGrid.tableCells.length) {
				if (_editButton && (!_highlightedDataGrid.hasHeader || _highlightedRowIndex > 0)) {
					var firstCell:UICell = _highlightedDataGrid.tableCells[_highlightedRowIndex][0];
					_editButton.x = _attributes.width - (slidein ? _editButton.width : 0);
					_editButton.y = _highlightedDataGrid.y + firstCell.y + firstCell.height / 2 - _editButton.height / 2;
					_editButton.visible = true;
				}
			}
		}
		
		
		protected function abortRowSelection():void {
			_noScroll = _originalNoScroll;
			showScrollBar();
		}
		
		
		override protected function mouseMove(event:TimerEvent):void {
			if (_editButtonMouseDown) {
				return;
			}
			var deltaMoveX:Number = Math.abs(_lastMousePoint.x - mouseX);
			var deltaMoveY:Number = Math.abs(_lastMousePoint.y - mouseY);
			_mouseDistance += deltaMoveX + deltaMoveY;
			_mouseDistanceX += deltaMoveX;
			_mouseDistanceY += deltaMoveY;
			_lastMousePoint.x = mouseX;
			_lastMousePoint.y = mouseY;
			
			if (_mouseDistance > BUTTON_MOVE_THRESHOLD) {
				_headerClicked = false;
			}

			super.mouseMove(event);
			if (_rowSelect) {
				if (_alt) {
					if (deltaMoveX > ROW_SELECT_LIMIT || deltaMoveY > DELTAY_THRESHOLD || (_mouseDistanceX > _mouseDistanceY && _mouseDistanceX > THRESHOLD)) {
						abortRowSelection();
					}
					else {
						rowSelectHandler();
					}
				}
				else {
					if (deltaMoveX > ROW_SELECT_LIMIT || _mouseDistanceY > SMALL_Y_THRESHOLD) {
						refreshHighlight();
						abortRowSelection();
						_rowSelect = false;
					}
				}
			}
		}
		
		
		protected function rowSelectHandler():Boolean {
			var highlightedDataGrid:UIFastDataGrid = yToDataGrid(_slider.mouseY);
			var highlightedRowIndex:int = highlightedDataGrid ? highlightedDataGrid.yToRow(highlightedDataGrid.mouseY) : -1;
			if (highlightedRowIndex >= 0 && (highlightedDataGrid != _highlightedDataGrid || highlightedRowIndex != _highlightedRowIndex)) {
				temporaryRowHighlightDraw(highlightedDataGrid, highlightedRowIndex);
				_highlightedDataGrid = highlightedDataGrid;
				_highlightedRowIndex = highlightedRowIndex;		
				return true;
			}
			else {
				return false;
			}
		}
		
/**
 * Mouse down handler
 */
		override protected function mouseDown(event:MouseEvent):void {
			if (event.target.name == HEADER_NAME) {
				_headerClicked = true;
				_rowSelect = false;
				super.mouseDown(event);
				dispatchEvent(new Event(HEADER_DOWN));
			}
			else if (event.target != _editButton) {
				_headerClicked = false;
				super.mouseDown(event);
				_rowSelect = false;
				_clickDelay.reset();
				_clickDelay.start();
				temporaryRowHighlight();
			}
			_lastMousePoint.x = mouseX;
			_lastMousePoint.y = mouseY;
			_mouseDistance = 0;
			_mouseDistanceX = 0;
			_mouseDistanceY = 0;
		}
		
		
		protected function dispatchRowSelected():void {
			if (_highlightedDataGrid) {
				_clickedRowIndex = _highlightedRowIndex;
				_dataGrid = _highlightedDataGrid;
				if (!_editButtonMouseDown) {
					dispatchEvent(new Event(ROW_SELECTED));
				}
			}
		}
		
		
		override protected function mouseUp(event:MouseEvent):void {
			if (_headerClicked && event.target.name == HEADER_NAME) {
				dispatchEvent(new Event(HEADER_CLICKED));
				super.mouseUp(event);
			}
			else if (event.target != _editButton) {
				super.mouseUp(event);
				_clickDelay.stop();
				
				if (_rowSelect || _mouseDistance < THRESHOLD) {
					_rowSelect = false;
					_noScroll = _originalNoScroll;
					rowSelectHandler();
					if (!_alt) {
						if (_editButton) {
							_editButton.visible = true;
						}
						setHighlightRow();
						slideEditButton(true);
					}
					dispatchRowSelected();
				}
				else if (_alt) {
					temporaryRowClear();
					temporaryRowHighlightDraw(_highlightedDataGrid, _highlightedRowIndex);
				}
				else {
					refreshHighlight();
				}
				_mouseDistance = 999999.9;
				if (_alt && _editButton) {
					setHighlightRow();
					slideEditButton();
				}
			}
		}
		
/**
 * The index of the clicked row
 */
		public function get index():int {
			return _clickedRowIndex;
		}
		
/**
 * The index of the selected / highlighted row.  (May be different from the clicked row).
 */
		public function get selectIndex():int {
			return _highlightedRowIndex;
		}
		
		
		public function set selectIndex(value:int):void {
			temporaryRowClear();
			_clickedRowIndex = _highlightedRowIndex = value;
			temporaryRowHighlightDraw(_highlightedDataGrid, _highlightedRowIndex);
		}
		
/**
 * The index of the datagrid that is selected.  First datagrid is 0, second = 1, etc...
 */
		public function get selectDataGrid():int {
			if (_dataGrid) {
				for (var index:String in _dataGrids) {
					if (_dataGrid == _dataGrids[index]) {
						return parseInt(index);
					}
				}
			}
			return -1;
		}
		
		
		protected function timerComplete(event:TimerEvent):void {
			if (_mouseDistance < THRESHOLD) {
				_noScroll = _alt;
				_rowSelect = true;
				if (_editButton && _editButton.visible) {
					slideEditButton(false);
				}
			}
			else if (!_alt) {
				refreshHighlight();
			}
		}
		
		
		override public function layout(attributes:Attributes):void {
			super.layout(attributes);
			refreshHighlight();
		}
		
		
		protected function refreshHighlight():void {
			temporaryRowClear();
			temporaryRowHighlightDraw(_highlightedDataGrid, _highlightedRowIndex);
			setHighlightRow(true);
		} 
		
/**
 * Change datagrid text size
 */
		override public function set textSize(value:Number):void {
			super.textSize = value;
			refreshHighlight();
		}
		
		
		override public function destructor():void {
			super.destructor();
			_clickDelay.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
		}
		
	}
}
