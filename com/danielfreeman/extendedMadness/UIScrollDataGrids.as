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
	
	import flash.text.TextFormat;
	import com.danielfreeman.extendedMadness.*;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import com.danielfreeman.madcomponents.*;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.InteractiveObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
/**
 * ScrollDatagrid component
 * <pre>
 * &lt;scrollDataGrids
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
 *    alignGridWidths = "true|false"
 *    <title>
 *    <font>
 *    <headerFont>
 *    <model>
 *    <widths> (depreciated)
 * /&gt;
 * </pre>
 */
	public class UIScrollDataGrids extends UIScrollDataGrid {
	
		protected static const EXTRA:Number = 32.0;
		protected static const STATUS_STYLE:TextFormat = new TextFormat('Arial', 13, 0xFFFFFF);
		protected static const HEADER_NAME:String = "#header";
		
		protected var _dataGrids:Vector.<UIFastDataGrid> = new Vector.<UIFastDataGrid>();
		protected var _fixedColumnLayers:Vector.<Sprite> = new Vector.<Sprite>();
		protected var _currentHeading:int = 0;
		protected var _titleSlider:Sprite = null;
		protected var _headerTitleSlider:Sprite = null;
		protected var _alignGridWidths:Boolean = false;
		protected var _statusFormat:TextFormat = STATUS_STYLE;
		protected var _status:UILabel;
		protected var _screen:Sprite;


		public function UIScrollDataGrids(screen : Sprite, xml : XML, attributes : Attributes) {
			_screen = screen;
			_alignGridWidths = xml.@alignGridWidths == "true";
			initialiseLayers(xml);
			if (xml.statusFont.length() > 0) {
				_statusFormat = UIe.toTextFormat(xml.statusFont[0], _statusFormat);
				delete xml.statusFont;
			}
			super(screen, xml, attributes);
			this.setChildIndex(_slider, 0);

			_status = new UILabel(this, 0, 0, xml.@status, _statusFormat);
			_status.x = attributes.width - _status.width;
			doLayout();
		}
		
/**
 * Set status label at top-right of datagrids
 */
		public function set status(value:String):void {
			_status.text = value;
			_status.x = attributes.width - _status.width;
		}


		protected function reposition(cell:UICell):void {
			var globalPoint:Point = cell.localToGlobal(new Point(0,0));
			var sliderPoint:Point = _slider.globalToLocal(globalPoint);
			cell.x = sliderPoint.x;
			cell.y = sliderPoint.y;
		}
		
/**
 *  Create all the layers which slide in different ways for scrolling the grid.
 */
		protected function initialiseLayers(xml:XML):void {
			addChild(_headerSlider = new Sprite());
			_headerSlider.name = "_headerSlider";
			if (xml.@fixedColumns.length() > 0) {
				_fixedColumns = parseInt(xml.@fixedColumns);
				addChild(_fixedColumnSlider = new Sprite());
				_fixedColumnSlider.name = "_fixedColumnSlider";
			}
			addChild(_titleSlider = new Sprite());
			_titleSlider.name = "_titleSlider";
			addChild(_headerFixedColumnSlider = new Sprite());
			_headerFixedColumnSlider.name = "_headerFixedColumnSlider";
			addChild(_headerTitleSlider = new Sprite());
			_headerTitleSlider.name = "_headerTitleSlider";
		}
		
		
		override protected function sliceTable(dataGrid:UIFastDataGrid):void {
		}
		
/**
 *  Put headers, fixed columns, and grid cells all within their appropriate layers
 */
		protected function sliceTables(dataGrid:UIFastDataGrid, index:int = 0):void {
			var fixedColumnLayer:Sprite;
			if (!_fixedColumnSlider) {
				addChild(_fixedColumnSlider = new Sprite());
			}
			if (_fixedColumnLayers.length == index) {
				_fixedColumnSlider.addChild(fixedColumnLayer = new Sprite());
				var dataGridGlobalPoint:Point = dataGrid.localToGlobal(new Point(0,0));
				fixedColumnLayer.y = _slider.globalToLocal(dataGridGlobalPoint).y;
				_fixedColumnLayers.push(fixedColumnLayer);
			}
			else {
				fixedColumnLayer = _fixedColumnLayers[index];
			}
			if (_fixedColumns > 0 && dataGrid.tableCells.length > 0) {
				var rowIndex:int = 0;
				var start:int = dataGrid.hasHeader ? 1 : 0;
				for (var i:int = 0; i < dataGrid.tableCells.length; i++) {
					var tableRow:Vector.<UICell> = dataGrid.tableCells[i];
					for (var j:int = 0; j < _fixedColumns; j++) {
						var cell:UICell = tableRow[j];
						if (i < start) {
							cell.defaultColour = dataGrid.headerColour;
						}
						else if (_fixedColumnColours) {
							cell.defaultColour = _fixedColumnColours[(rowIndex - start) % _fixedColumnColours.length];
						}
						fixedColumnLayer.addChild(cell);
					}
					rowIndex++;
				}
			}
			colourFixedColumns(dataGrid);
			if (dataGrid.titleCell) {
				_titleSlider.addChild(dataGrid.titleCell);
				dataGrid.titleCell.y = fixedColumnLayer.y;
			}
		}

/**
 *  Put headers, fixed columns, and grid cells all within their appropriate layers
 */
		protected function sliceAllTables():void {
			for (var i:int = 0; i < _slider.numChildren; i++) {
				var child:DisplayObject = _slider.getChildAt(i);
				if (child is UIFastDataGrid) {
					if (i < _fixedColumnLayers.length) {
						_fixedColumnLayers[i].visible = UIFastDataGrid(child).includeInLayout;
					}
					if (UIFastDataGrid(child).titleCell) {
						UIFastDataGrid(child).titleCell.visible = UIFastDataGrid(child).includeInLayout;					
					}
					if (UIFastDataGrid(child).includeInLayout) {
						sliceTables(UIFastDataGrid(child), i);
					}
					
				}
			}
			_slider.cacheAsBitmap = true;
			if (_fixedColumnSlider) {
				_fixedColumnSlider.cacheAsBitmap = true;
			}
			if (_headerSlider) {
				_headerSlider.cacheAsBitmap = true;
			}
			_headerFixedColumnSlider.cacheAsBitmap = true;
			_titleSlider.cacheAsBitmap = true;
		}
				
		
		protected function copyText(parent:Sprite, source:UICell, yPosition:Number = 0, colour:uint = uint.MAX_VALUE):UICell {
			var copyText:UICell = new UICell(parent, source.x, yPosition, source.text, source.width, source.getTextFormat(), source.multiline, source.borderColor);
			copyText.height = source.height;
			copyText.backgroundColor = colour == uint.MAX_VALUE ? source.backgroundColor : colour;
			copyText.background = colour == uint.MAX_VALUE ? source.background : true;
			copyText.y = yPosition;
			return copyText;
		}
		
		
		protected function copyRow(parent:Sprite, row:Vector.<UICell>, start:int, end:int, yPosition:Number, colour:uint):void {
			for (var i:int = start; i < end; i++) {
				copyText(parent, row[i], yPosition, colour);
			}
		}
		
/**
 *  The top header doesn't move, and changes to row headings depending on which datagrid is
 *  beneath it.  This method pre-renders all column headers for the datagrids
 */
		protected function preExtractHeadersCells():void {
			_headerTitleSlider.removeChildren();
			_headerFixedColumnSlider.removeChildren();
			_headerSlider.removeChildren();
			_headerTitleSlider.name = HEADER_NAME;
			_headerFixedColumnSlider.name = HEADER_NAME;
			_headerSlider.name = HEADER_NAME;
			var i:int = 0;
			for each (var dataGrid:UIFastDataGrid in _dataGrids) {
				var cellTitle:UICell = null;
				if (dataGrid.titleCell && dataGrid.includeInLayout) {
					cellTitle = copyText(_headerTitleSlider, dataGrid.titleCell);
					cellTitle.visible = i == 0;
				}
				if (dataGrid.hasHeader && dataGrid.tableCells.length > 0) {
					var row:Vector.<UICell> = dataGrid.tableCells[0];
					if (_fixedColumns > 0 && _headerFixedColumnSlider) {
						var spriteFixedHeader:Sprite = new Sprite();
						copyRow(spriteFixedHeader, row, 0, _fixedColumns, cellTitle ? cellTitle.height : 0, dataGrid.headerColour);
						_headerFixedColumnSlider.addChild(spriteFixedHeader);
						spriteFixedHeader.visible = i == 0;
					}
					var spriteHeader:Sprite = new Sprite();
					copyRow(spriteHeader, row, _fixedColumns, row.length, cellTitle ? cellTitle.height : 0, dataGrid.headerColour);
					_headerSlider.addChild(spriteHeader);
					spriteHeader.visible = i == 0;
				}
				i++;
			}
		}
		
/**
 *  When the datagrid is scrolled - possibly change top column headings
 */
		protected function swapCellHeaders():void {
			var index:int = -1;
			if (_slider.y < 0) {
				while (index + 1 < _fixedColumnLayers.length && _dataGrids[index + 1].includeInLayout && -_slider.y + (_currentHeading >=0 ? _headerSlider.getBounds(this).bottom / 2 : 0) > _fixedColumnLayers[index + 1].y) {
					index++;
				}
			}
			if (index >= 0 && index != _currentHeading) {
				if (_currentHeading >= 0 && _currentHeading < _headerSlider.numChildren) {
					if (_currentHeading < _headerTitleSlider.numChildren) {
						UICell(_headerTitleSlider.getChildAt(_currentHeading)).visible = false;
					}
					Sprite(_headerSlider.getChildAt(_currentHeading)).visible = false;
					if (_fixedColumns > 0) {
						Sprite(_headerFixedColumnSlider.getChildAt(_currentHeading)).visible = false;
					}
				}
				if (index >= 0 && index < _headerSlider.numChildren) {
					if (index < _headerTitleSlider.numChildren) {
						UICell(_headerTitleSlider.getChildAt(index)).visible = true;
					}
					Sprite(_headerSlider.getChildAt(index)).visible = true;
					if (_fixedColumns > 0) {
						Sprite(_headerFixedColumnSlider.getChildAt(index)).visible = true;
					}
					headerFixedColumnLine(index);
				}
				_currentHeading = index;
			}
		}

		
		override protected function set sliderX(value:Number):void {
			super.sliderX = value;
			_titleSlider.x = value > 0 ? value : 0;
			_headerTitleSlider.x = value > 0 ? value : 0;
		}
		
		
		override public function set sliderY(value:Number):void {
			super.sliderY = value;
			_titleSlider.y = value;
			_headerTitleSlider.y = value > 0 ? value : 0;
			if (_status) {
				_status.y = _headerTitleSlider.y;
			}
			swapCellHeaders();
		}

/**
 *  Create sliding parts of container
 */	
		override protected function createSlider(xml:XML, attributes:Attributes):void {
			_slider = new UI.FormClass(this, _dataGridXML, sliderAttributes(attributes));
			_slider.name = "-";
			adjustMaximumSlide();
			for (var i:int = 0; i < _slider.numChildren; i++) {
				var child:DisplayObject = _slider.getChildAt(i);
				if (child is UIFastDataGrid && UIFastDataGrid(child).includeInLayout) {
					_dataGrids.push(child);
				}
			}
			sliceAllTables();
		}
		
		
		protected function headerFixedColumnLine(index:int):void {
			if (_currentHeading >= 0) {
				var dataGrid:UIFastDataGrid = _dataGrids[index];
				if (dataGrid.includeInLayout && dataGrid.tableCells.length > 0) {
					_headerFixedColumnSlider.graphics.clear();
					_headerFixedColumnSlider.graphics.beginFill(dataGrid.attributes.colour);
					_headerFixedColumnSlider.graphics.drawRect(dataGrid.tableCells[0][_fixedColumns].x, _headerFixedColumnSlider.getBounds(this).top, 2.0, _headerFixedColumnSlider.height);
				}
			}
		}

		
		public function set selectDataGrid(value:int):void {
			_dataGrid = _dataGrids[value];
		}
		
		
		public function get dataGrids():Vector.<UIFastDataGrid> {
			return _dataGrids;
		}
		
		
		protected function doAlignGridWidths():void {
			var newWidth:Number = 0;//_slider.getBounds(_slider).right + EXTRA;
			
			for each (var dataGrid0:UIFastDataGrid in _dataGrids) {
				if (dataGrid0.width > newWidth) {
					newWidth = dataGrid0.width;
				}
			}
			newWidth += EXTRA;
			for each (var dataGrid:UIFastDataGrid in _dataGrids) {
				if (dataGrid.includeInLayout) {
					if (dataGrid.tableCells.length > 0) {
						dataGrid.lastColumnWidth = (newWidth - dataGrid.lastColumnPosition);
					}
				dataGrid.drawBackground();
				}
			}
		}
		
		
		protected function relayout(adjust:Boolean = false):void {
			var index:int = 0;
			for each(var fixedColumnLayer:Sprite in _fixedColumnLayers) {
				fixedColumnLayer.graphics.clear();
				fixedColumnLayer.graphics.beginFill(_dataGrids[index].attributes.colour);
				fixedColumnLayer.graphics.drawRect(fixedColumnLayer.width, fixedColumnLayer.getBounds(fixedColumnLayer).top, 2.0, fixedColumnLayer.height);
				index++;
			}
			if (_alignGridWidths) {
				doAlignGridWidths();
			}
			headerFixedColumnLine(_currentHeading);
			drawComponent();
			if (adjust) {
				adjustMaximumSlide();
			}
			refreshMasking();
			preExtractHeadersCells();
		}
		
/**
 *  Rearrange the layout to new screen dimensions
 */	
		override public function layout(attributes:Attributes):void {
			_attributes = attributes;
			IContainerUI(_slider).layout(sliderAttributes(attributes));
			relayout(true);
			_status.x = attributes.width - _status.width;
		}
		
		
		public function set fixheight(value:Number):void {
			_attributes.height = value;
			super.adjustMaximumSlide();
		}
		
		
		public function set alignGridWidths(value:Boolean):void {
			_alignGridWidths = value
		}
		
		
		protected function realignColumnLayers():void {
			var index:int = 0;
			for each (var dataGrid:UIFastDataGrid in _dataGrids) {
				if (dataGrid.includeInLayout) {
					var dataGridGlobalPoint:Point = dataGrid.localToGlobal(new Point(0,0));
					if (dataGrid.titleCell) {
						_titleSlider.addChild(dataGrid.titleCell);
						dataGrid.titleCell.y = _slider.globalToLocal(dataGridGlobalPoint).y;
					}
					_fixedColumnLayers[index++].y = _slider.globalToLocal(dataGridGlobalPoint).y;
				}
				
			}
		}
		
		
		override protected function adjustMaximumSlide():void {
			sliderX = 0;
			sliderY = 0;
			var index:int = 0;
			var width:Number = 0;
			for each (var dataGrid:UIFastDataGrid in _dataGrids) {
				if (dataGrid.includeInLayout) {
					if (dataGrid.getBounds(dataGrid).right > width) {
						width = dataGrid.getBounds(dataGrid).right;
					}
				}
				else {
					dataGrid.y = 0;
					if (index < _fixedColumnLayers.length) {
						_fixedColumnLayers[index].y = 0;
					}
					if (dataGrid.titleCell) {
						dataGrid.titleCell.y = 0;
					}
				}
				index++;
			}
			adjustVerticalSlide();
			adjustHorizontalSlide(width);
			hideScrollBar();
		}
		
		
		override public function doLayout():void {
			_delta = 0;
			_deltaX = 0;
			var y:Number = sliderY;
			sliceAllTables();
			layout(_attributes);
			realignColumnLayers();
			adjustMaximumSlide();
			sliderY = y;
		}
		
/**
 * Find a particular row,column (group) inside the grid
 */
		override public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			for each (var dataGrid:UIFastDataGrid in _dataGrids) {
				if (dataGrid.name == id) {
					return (row < 0 && group < 0) ? dataGrid : dataGrid.findViewById(id, row, group);
				}
			}
			return null;
		}
		
		
		override public function set textSize(value:Number):void {

			for each (var dataGrid:UIFastDataGrid in _dataGrids) {
				dataGrid.textSize = value;
			}
			IContainerUI(_slider).layout(sliderAttributes(attributes));
			for each (var layer:Sprite in _fixedColumnLayers) {
				_fixedColumnSlider.removeChild(layer);
			}
			if (_alignGridWidths) {
				doAlignGridWidths();
			}
			adjustMaximumSlide();
			_fixedColumnLayers = new Vector.<Sprite>();
			sliceAllTables();
			relayout(false);
		}
		
		
		override public function clear():void {
			for each (var dataGrid:UIFastDataGrid in _dataGrids) {
				dataGrid.clear();
			}
		}

		
		override public function destructor():void {
			super.destructor();
		}
		
	}
}
