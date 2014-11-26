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

	import com.danielfreeman.madcomponents.*;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	
/**
 *  Datagrid component
 * <pre>
 * &lt;dataGrid
 *    id = "IDENTIFIER"
 *    colour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, ..."
 *    visible = "true|false"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    widths = "i(%),j(%),k(%)…"
 *    multiline = "true|false"
 *    titleBarColour = "#rrggbb"
 *    footerColour = "#rrggbb"
 *    recycle = "true|false"
 *    <title>
 *    <font>
 *    <headerFont>
 *    <titleFont>
 *    <model>
 *    <header>
 *    <data>
 *    	<header>
 *    </data>
 *    <widths> (depreciated)
 * /&gt;
 * </pre>
 */
	public class UIFastDataGrid extends MadSprite implements IContainerUI { 
		
		protected static const DEFAULT_HEADER_COLOUR:uint=0x9999AA; //0x4481c1; 
		protected static const DEFAULT_COLOURS:Vector.<uint>=new <uint>[0xe8edf5,0xcfd8e9]; 
		protected static const TABLE_WIDTH:Number=300.0;
		protected static const TEXT_SIZE:Number=13.0;
		protected static const THRESHOLD:Number = 100.0;
		
		protected const HEADER_STYLE:TextFormat = new TextFormat('Arial', TEXT_SIZE, 0xFFFFFF);
		protected const TITLE_STYLE:TextFormat = new TextFormat('Arial', 14, 0xFFFFFF, true);
		protected const DATA_STYLE:TextFormat = new TextFormat('Arial', TEXT_SIZE, 0x333333);
		
		
		protected var _table:Vector.<Vector.<UICell>>=new Vector.<Vector.<UICell>>(); 
		protected var _last:Number=0; 
		protected var _lastWidth:Number; 
		protected var _cellWidths:Array = null; 
		protected var _leftMargin:Number;
		protected var _tableWidth:Number;
		protected var _data:Array = [];
		protected var _borderColour:uint;
		protected var _model:DGModel = null;
		protected var _colours:Vector.<uint> = DEFAULT_COLOURS;
		protected var _xml:XML;
		protected var _attributes:Attributes;
		
		protected var _compactTable:Boolean = false;
		protected var _columnWidths:Vector.<Number> = null;
		protected var _multiLine:Boolean = false;
		protected var _hasHeader:Boolean = false;
		protected var _dataStyle:TextFormat = DATA_STYLE;
		protected var _headerStyle:TextFormat = HEADER_STYLE;
		protected var _titleStyle:TextFormat = TITLE_STYLE;
		protected var _titleBarColour:uint = DEFAULT_HEADER_COLOUR;
		protected var _title:UICell = null;
		protected var _footerColour:uint = uint.MAX_VALUE;
		protected var _headerText:Array;
		protected var _headerColour:uint;
		protected var _recycle:Vector.<UICell> = null;
		protected var _recycleHeader:Vector.<UICell> = null;
		protected var _fastLayout:Boolean = false;
		
		
		public function UIFastDataGrid(screen:Sprite, xml:XML, attributes:Attributes) {							   

			screen.addChild(this); 
			x=attributes.x;
			y=attributes.y;
			_xml = xml;
			_attributes = attributes;
			_fastLayout = xml.@fastLayout == "true";
			
			_tableWidth=attributes.width;
			_leftMargin=4.0;
			
			_borderColour=attributes.colour;
			
			if (xml.widths.length() > 0) { // Depreciated
				_cellWidths = xml.widths.split(",");
			}
			if (xml.model.length() > 0) {
				_model = new DGModel(this,xml.model[0]);
			}
			if (xml.font.length() > 0) {
				_dataStyle = UIe.toTextFormat(xml.font[0], DATA_STYLE);
			}
			if (xml.headerFont.length() > 0) {
				_headerStyle = UIe.toTextFormat(xml.headerFont[0], HEADER_STYLE);
			}
			if (xml.titleFont.length() > 0) {
				_titleStyle = UIe.toTextFormat(xml.titleFont[0], TITLE_STYLE);
			}
			if (xml.@footerColour.length() > 0) {
				_footerColour = UI.toColourValue(xml.@footerColour);
			}
			if (xml.@recycle=="true" && !_recycle) {
				_recycle = new Vector.<UICell>();
				_recycleHeader = new Vector.<UICell>();
			}

			customWidths();
			_compactTable = xml.@widths.length() == 0;		
			if (xml.@multiLine.length() > 0) {
				_multiLine = xml.@multiLine == "true";
			}
			
			_headerText = extractHeader(xml);
			_headerColour = (attributes.backgroundColours.length>0) ? attributes.backgroundColours[0] : DEFAULT_HEADER_COLOUR;
			_titleBarColour = _headerColour;
			if (xml.@titleBarColour.length() > 0) {
				_titleBarColour = UI.toColourValue(xml.@titleBarColour);
			}
			if (xml.title.length() > 0) {
			//	var label:String = xml.title.toString();
				_title = new UICell(this, 0, 0, " ", 0, _titleStyle, false, _titleBarColour);
				_title.xmlText = xml.title[0];
			//	_title.selectable = _title.mouseEnabled = false;
				
			//	title = xml.title.toString();
				
				_title.fixwidth = attributes.width;
				_title.defaultColour = _titleBarColour;
				_last = _title.height;
				_title.border = true;
				_title.borderColor = _borderColour;
			}

			if (_headerText) {
				_hasHeader = true;
				makeTable([_headerText], _headerStyle);
			}
			if (attributes.backgroundColours.length>1) {
				_colours = new <uint>[];
				for (var i:int = 1; i < attributes.backgroundColours.length; i++) {
					_colours.push(attributes.backgroundColours[i]);
				}
			}
			
			if (xml.data.length()>0) {
				extractData(xml.data[0]);
			}

			makeTable(_data, null);
			doLayout();
			drawBackground();
		}
		
/**
 *  Grid row colours
 */
		public function set colours(value:Vector.<uint>):void {
			_colours = value && value.length > 0 ? value : DEFAULT_COLOURS;
			drawBackground();
		}
		
		
		public function get colours():Vector.<uint> {
			return _colours;
		}
		
/**
 *  Datagrid title field
 */
		public function set title(value:String):void {
			if (!_title) {
				_title = new UICell(this, 0, 0, "", 0, _titleStyle, false, _titleBarColour);
				_title.fixwidth = _attributes.width;
				_title.defaultColour = _titleBarColour;
			}
			if (XML("<a>"+value+"</a>").hasComplexContent()) {
				_title.htmlText = value;
			}
			else {
				_title.xmlText = value;
				_title.setTextFormat(_titleStyle);
				_title.border = true;
				_title.borderColor = _borderColour;
			}
		}
		
		
		public function get titleCell():UICell {
			return _title;
		}

		
		public function get lastColumnPosition():Number {
			var row:Vector.<UICell> = _table[0];
			return row[row.length - 1].x;
		}
		
		
		public function set lastColumnWidth(value:Number):void {
			_columnWidths[_columnWidths.length - 1] = value;
			for (var i:int = 0; i<_table.length;i++) {
				var row:Vector.<UICell> = _table[i];
				row[row.length - 1].width = value;
			}
		}
		
/**
 *  Column headings background colour
 */
		public function set headerColour(value:uint):void {
			_headerColour = value;
			drawBackground();
		}
		
		
		public function get headerColour():uint {
			return _headerColour;
		}
		
/**
 *  Adjust column widths
 */
		protected function customWidths():void {
			if (_xml.@widths.length() > 0 && _table.length > 0) {
				var total:Number = 0;
				var widths:Array = _xml.@widths.toString().split(",");
				for each (var item : String in widths) {
					if (item.lastIndexOf("%") < 0) {
						total += parseInt(item);
					}
				}
				_columnWidths = new Vector.<Number>();
				for each (var width:String in widths) {
					_columnWidths.push((width.lastIndexOf("%") > 0) ? parseFloat(width)/100 * (_attributes.width - total) : parseFloat(width));			
				}		
			}
			rejig();
		}
		
/**
 *  Render row colours
 */
		public function drawBackground():void {
			if (_table.length == 0) {
				return;
			}
			var lastRow:Vector.<UICell> = _table[_table.length - 1];
			var cornerCell:UICell = lastRow[lastRow.length - 1];
			var theWidth:Number = cornerCell.x + cornerCell.width + 1;
			var colour:uint = _hasHeader ? _headerColour : _colours[0];
			var index:int = _hasHeader ? 0 : 1;
			graphics.clear();
			for each(var row:Vector.<UICell> in _table) {
				graphics.beginFill(colour);
				graphics.drawRect(0, row[0].y, theWidth, row[0].height);
				colour = _colours[index++ % _colours.length];
			}
		}
		
/**
 *  Render table cells
 */
		protected function makeTable(data:Array, format:TextFormat=null):void {  
			if (!format) format=_dataStyle;
			format.leftMargin=_leftMargin; 
			for (var i:int=0;i<data.length;i++) { 
				var dataRow:Array=data[i]; 
				var row:Vector.<UICell>=_table[_table.length]=new Vector.<UICell>(); 
				var wdth0:Number=_tableWidth/dataRow.length; 
				var lastX:Number=0; 
				for (var j:int=0;j<dataRow.length;j++) { 
					var wdth:Number=(_cellWidths) ? _tableWidth*_cellWidths[Math.min(_cellWidths.length-1,j)]/100 : wdth0;
					var txt:UICell = new UICell(this, lastX, _last, dataRow[j], wdth, format);
					row.push(txt); 
					
					txt.border = true;
					txt.borderColor = _borderColour;
					txt.multiline = txt.wordWrap = _multiLine;
					txt.setTextFormat(format);
					txt.fixwidth = wdth;
					lastX=txt.x+txt.width;
				} 
				if (txt) {
					_last=txt.y+txt.height; 
				}
			} 
		}
		
		
		public function get pages():Array {
			return [];
		}
		
/**
 *  Extract an array of object from XML data
 */
		protected function extractData(xml:XML):void {
			var rows:XMLList = xml.row;
			_data=new Array();
			for each (var row:XML in rows) {
				var dataRow:Array = row.toString().split(",");
				_data.push(dataRow);
			}
		}
		
/**
 *  Grid row colours
 */
		public function swapRows(rowIndexA:int, rowIndexB:int):void {
			var rowA:Vector.<UICell> = _table[rowIndexA];
			var rowB:Vector.<UICell> = _table[rowIndexB];
			_table[rowIndexA] = rowB;
			_table[rowIndexB] = rowA;
			var yA:Number = rowA[0].y;
			var yB:Number = rowB[0].y;
			for each (var cellA:UICell in rowA) {
				cellA.y = yB;
			}
			for each (var cellB:UICell in rowB) {
				cellB.y = yA;
			}
			var dataA:Array = _data[rowIndexA];
			_data[rowIndexA] = _data[rowIndexB];
			_data[rowIndexB] = dataA;
			drawBackground();
		}
		
/**
 *  Shift rows up or down - utilised when inserting or deleting rows
 */
		protected function shiftRows(index:int, deltaHeight:Number):void {
			for (var i:int = index; i < _table.length; i++) {
				var row:Vector.<UICell> = _table[i];
				for each (var cell:UICell in row) {
					cell.y += deltaHeight;
				}
			}
		}
		
/**
 *  Insert a row within the datagrid
 */
		public function insertRow(rowIndex:int, rowData:Array):void {
			var cell:UICell = rowIndex >= _table.length ? null : _table[rowIndex][0];
			var row:Vector.<UICell> = _table[_table.length - 1];
			var rowY:Number = cell ? cell.y : row[0].y;
			if (cell) {
				shiftRows(rowIndex, cell.height);
			}
			
			var index:int = 0;
			var newRow:Vector.<UICell> = new Vector.<UICell>();
			for each (var topCell:UICell in row) {
				newRow.push(cell = newCell(rowData[index]));
				cell.x = topCell.x;
				cell.y = rowY;
				cell.fixwidth = topCell.width;
				index++;
			}
			_table.splice(rowIndex, 0, newRow);
			_data.splice(rowIndex, 0, rowData);
			drawBackground();
		}
		
/**
 *  Delete a specific row from the datagrid
 */
		public function deleteRow(rowIndex:int):void {
			var row:Vector.<UICell> = _table[rowIndex];
			shiftRows(rowIndex, -row[0].height);
			_data.splice(rowIndex, 1);
			_table.splice(rowIndex, 1);
			for each (var cell:UICell in row) {
				removeCell(cell);
			}
			drawBackground();
			
		}

/**
 *  Realign and adjust the datagrid cell positions
 */
		protected function rejig():void {
			var lastY:Number = 0;
			if (_title) {
				_title.autoSize = TextFieldAutoSize.LEFT;
				lastY = _title.height;
				_title.fixwidth = _tableWidth;
			}
			for (var i:int = 0; i<_table.length;i++) {
				var row:Vector.<UICell> = _table[i];
				var wdth0:Number=_tableWidth/row.length;
				var position:Number = 0;
				var maxHeight:Number = 0;
				for (var j:int = 0; j < row.length; j++) {
					var wdth:Number= Math.ceil(_columnWidths ? _columnWidths[j] : (_cellWidths) ? _tableWidth*_cellWidths[Math.min(_cellWidths.length-1,j)]/100 : wdth0);
					var cell:UICell = row[j];
					cell.x = position;
					cell.y = lastY;
					cell.fixwidth = wdth;
					cell.multiline = cell.wordWrap = _multiLine;
	//	cell.background = false;
					position += wdth;
					if (_multiLine) {
						cell.autoSize = TextFieldAutoSize.LEFT;
					}
					if (cell.height > maxHeight) {
						maxHeight = cell.height;
					}
				}
			//	if (_multiLine) {
					for each (var cell0:UICell in row) {
						cell0.fixheight = maxHeight;
					//	cell0.y = lastY;
					}
				//	lastY += maxHeight;
			//	}
				lastY += maxHeight;
			}
		}
		
/**
 *  Refresh datagrid layout
 */
		public function doLayout():void {
			_tableWidth=_attributes.width;
			if (_cellWidths) {
				rejig();
			}
			else if (_xml.@widths.length()>0) {
				customWidths();
			}
			else if (_compactTable) {
				compact(true);
			}
			else {
				rejig();
			}
			drawBackground();
		}
		
		
		public function layout(attributes:Attributes):void {
			x=attributes.x;
			y=attributes.y;
			_attributes = attributes;
			if (_fastLayout) {
				drawBackground();
			}
			else {
				doLayout();
			}
		}
		
		
		public function drawComponent():void {	
		}
		
/**
 * Clear the data grid
 */
		public function clear():void {
			var header:Boolean = _hasHeader;
			for each (var row:Vector.<UICell> in _table) {
				if (header) {
					for each (var cell0:UICell in row) {
						removeHeaderCell(cell0);
					}
					header = false;
				}
				else {
					for each (var cell:UICell in row) {
						removeCell(cell);
					}
				}
			}
			_table = new Vector.<Vector.<UICell>>();
		}
		
/**
 * Find a particular row,column (group) inside the grid
 */
		public function findViewById(id:String, row:int = -1, group:int = -1):DisplayObject {
			return (id=="") ? _table[row][group] : null;
		}
		
		
		protected function extractHeader(xml:XML):Array {
			if (xml.header.length()>0) {
				return xml.header[0].toString().split(",");
			}
			else if (xml.data.length()>0 && xml.data[0].header.length()>0) {
				return xml.data[0].header[0].toString().split(",");
			}
			else {
				return null;
			}
		}
	
		
/**
 *  Convert y coordinate to row index
 */
		public function yToRow(y:Number):int {
			var result:int = -1;
			if (_table.length > 0 && y > 0 && y <= height) {
				result = Math.min(Math.round(_table.length * y / height), _table.length - 1);
				var cell:UICell = _table[result][0];
				if (y < cell.y) {
					result--;
					while (result >= 0 && y < _table[result][0].y) {
						result--;
					}
				}
				else if (y > cell.y + cell.height) {
					result++;
					while (result < _table.length && y > (cell = _table[result][0]).y + cell.height) {
						result++;
					}
				}
			}
			return (hasHeader && result == 0) ? -1 : result;
		}
		
/**
 *  Reset datagrid text size
 */
		public function set textSize(value:Number):void {
			_dataStyle.size = value;
			_headerStyle.size = value;
			var sizeFormat:TextFormat = new TextFormat(null, value);
			for each (var row:Vector.<UICell> in _table) {
				for each (var cell:UICell in row) {
					cell.setTextFormat(sizeFormat);
				}
			}
			rejig();
		}
		
		
		protected function addHeaderToTable():void {
			//_table.unshift()
			_hasHeader = true;
		}
		
		
		protected function removeHeaderFromTable():void {
			_hasHeader = false;
		}
		
				
/**
 * Set datagrid data
 */
		protected function setData(value:Array, includeHeader:Boolean = false):void {
			_data = value;
			if (includeHeader) {
				if (!_hasHeader) {
					addHeaderToTable();
				}
			}
			else if (_hasHeader) {
				removeHeaderFromTable();
			}
			newDimensions(value.length + (!includeHeader && _hasHeader ? 1 : 0), value[0].length);
			invalidate(false, includeHeader);
			doLayout();
		}
		
		
		public function set data(value:Array):void {
			setData(value);
		}
		
		
		public function set headerAndData(value:Array):void {
			setData(value, true);
		}
		
/**
 * Refresh datagrid with new data
 */
		public function set dataProvider(value:Array):void {
			_data = value;
			invalidate();
		}
		 
/**
 * Refresh datagrid
 */
		public function invalidate(readGrid:Boolean = false, includeHeader:Boolean = false):void {
			var start:int = !includeHeader && _hasHeader ? 1 : 0;
			for (var i:int = start; i<_table.length; i++) {
				var row:Vector.<UICell> = _table[i];
				for (var j:int=0; j<row.length; j++) {
					if (readGrid) {
						_data[i-start][j] = row[j].text;
					}
					else {
						var item:String = _data[i-start][j];
						row[j].xmlText = (item != null) ? item : "";
					}
				}
			}
		}
		
		
		public function get xml():XML {
			return _xml;
		}
		
		
		public function get attributes():Attributes {
			return _attributes;
		}
		
/**
 *  Access datagrid cells
 */
		public function get tableCells():Vector.<Vector.<UICell>> {
			return _table;
		}
		

		public function get hasHeader():Boolean {
			return _hasHeader;
		}
		
/**
 *  Attempt to make the datagrid width fit exactly the width of the screen
 */
		public function compact(padding:Boolean = false):void {
			if (_table.length > 0) {
				_columnWidths = new Vector.<Number>(_table[0].length);
				for (var i:int = 0; i<_table.length; i++) {
					var row:Vector.<UICell> = _table[i];
					for (var j:int=0; j<row.length; j++) {
						var cell:UICell = row[j];
						cell.multiline = cell.wordWrap = false;
						cell.autoSize = TextFieldAutoSize.LEFT;
						if (cell.width > _columnWidths[j]) {
							_columnWidths[j] = cell.width + 1.0;
						}
					}
				}
				if (padding) {
					var sum:Number = 0;
					for each (var width:Number in _columnWidths) {
						sum += width;
					}
					if (sum < _tableWidth) {
						var padEachCellBy:Number = (_tableWidth - sum) / _columnWidths.length;
						for (var k:int = 0; k < _columnWidths.length; k++) {
							_columnWidths[k] += padEachCellBy;
						}
					}
					else if (_multiLine) {
						var maxColumn:int = -1;
						var maxValue:Number = 0;
						for (var l:int = 0; l < _columnWidths.length; l++) {
							if (_columnWidths[l] > maxValue) {
								maxColumn = l;
								maxValue = _columnWidths[l];
							}
						}
						if (sum - _tableWidth + THRESHOLD < _columnWidths[maxColumn]) {
							_columnWidths[maxColumn] -= sum - _tableWidth;
						}
					}
				}
				rejig();
			}
		}
		
		
		protected function removeCell(cell:UICell):void {
			if (_recycle) {
				_recycle.push(cell);
			}
			cell.parent.removeChild(cell);
		}
		
		
		protected function removeHeaderCell(cell:UICell):void {
			if (_recycleHeader) {
				_recycleHeader.push(cell);
			}
			if (cell.parent) {
				cell.parent.removeChild(cell);
			}
		}
		
		
		protected function newCell(label:String = ""):UICell {
			_dataStyle.leftMargin=_leftMargin; 
			var result:UICell;
			if (_recycle && _recycle.length > 0) {
				addChild(result = _recycle.pop());
			}
			else {
				result = new UICell(this, 0, 0, label, 0, _dataStyle);
			}
			return result;
		}
		
		
		protected function newHeaderCell():UICell {
			_headerStyle.leftMargin=_leftMargin; 
			var result:UICell;
			if (_recycleHeader && _recycleHeader.length > 0) {
				addChild(result = _recycleHeader.pop());
			}
			else {
				result = new UICell(this, 0, 0, " ", 0, _headerStyle);
			}
			return result;
		}
		
/**
 *  Add and remove rows and columns to resize the datagrid efficiently
 */
		protected function newDimensions(rows:int, columns:int):void {
			var oldRows:int = _table.length;
			var oldColumns:int = _table.length > 0 ? _table[0].length : 0;
			var header:Boolean = _hasHeader;
			if (rows < oldRows) {
				for (var r0:int = rows; r0 < oldRows; r0++) {
					var row0:Vector.<UICell> = _table[r0];
					for each (var cell:UICell in row0) {
						removeCell(cell);
					}
				}
				_table.splice(rows, oldRows - rows);
			}
			if (columns < oldColumns) {
				for each (var row1:Vector.<UICell> in _table) {
					if (header) {
						for (var c0:int = columns; c0 < oldColumns; c0++) {
							removeHeaderCell(row1[c0]);
						}
						header = false;
					}
					else {
						for (var c1:int = columns; c1 < oldColumns; c1++) {
							removeCell(row1[c1]);
						}
					}
					row1.splice(columns, oldColumns - columns);
				}
			}
			if (rows > oldRows) {
				for (var r1:int = oldRows; r1 < rows; r1++) {
					var newRow:Vector.<UICell> = new Vector.<UICell>();
					for (var c2:int = 0; c2 < Math.min(columns, oldColumns); c2++) {
						newRow.push(newCell());
					}
					_table.push(newRow);
				}
			}
			if (columns > oldColumns) {
				for each (var row:Vector.<UICell> in _table) {
					if (header) {
						for (var c3:int = oldColumns; c3 < columns; c3++) {
							row.push(newHeaderCell());
						}
						header = false;
					}
					else {
						for (var c4:int = oldColumns; c4 < columns; c4++) {
							row.push(newCell());
						}
					}
				}
			}
		}
		
		
		override public function get height():Number {
			return getBounds(this).bottom;
		}
		
		
		public function destructor():void {
		//	for (var i:int = 0; i<_table.length;i++) {
		//		var row:Array = _table[i];
			//	for (var j:int=0;j<row.length;j++) {
			//		UILabel(row[j]).destructor();
			//	}
		//	}
		}
		
	} 
}
