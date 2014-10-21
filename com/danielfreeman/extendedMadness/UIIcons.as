package com.danielfreeman.extendedMadness
{
	import flash.text.TextField;
	import com.danielfreeman.madcomponents.*;	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	import flash.text.TextFormat;
	
/**
 *  MadComponents icons component
 * <pre>
 * &lt;icons
 *    id = "IDENTIFIER"
 *    highlightColour = "#rrggbb"
 *    iconColour = "#rrggbb"
 *    activeColour = "#rrggbb"
 *    background = "#rrggbb, #rrggbb, …"
 *    gapV = "NUMBER"
 *    gapH = "NUMBER"
 *    alignH = "left|right|centre|fill"
 *    alignV = "top|bottom|centre|fill"
 *    visible = "true|false"
 *    border = "true|false"
 *    leftMargin = "NUMBER"
 *    &lt;data&gt;LABELS&lt;/data&gt;
 *    &lt;font&gt;FORMAT&lt;/font&gt;
 *    &lt;activeFont&gt;FORMAT&lt;/activeFont&gt;
 *    &lt;disableFont&gt;FORMAT&lt;/disableFont&gt;
 * /&gt;
 * </pre>
 */	
	public class UIIcons extends UIContainerBaseClass {

		protected static const COLOUR_OFFSET:Number = 0.5;
		protected static const COLOUR_FACTOR:Number = 0.5;
		protected static const DISABLED_COLOUR:uint = 0x333366;
		
		protected const LABEL_FORMAT:TextFormat = new TextFormat("Arial", 10, 0xCCCCCC);
		protected const LABEL_HIGHLIGHT:TextFormat = new TextFormat("Arial", 10, 0xFFFFFF);
		protected const LABEL_DISABLE:TextFormat = new TextFormat("Arial", 10, DISABLED_COLOUR);
		
		protected var _icons:Vector.<DisplayObject>;
		protected var _timer:Timer = new Timer(50,1);
		protected var _index:int = -1;
		protected var _pressIndex:int = -1;
		protected var _iconColour:uint = uint.MAX_VALUE;
		protected var _activeColour:uint = uint.MAX_VALUE;
		protected var _highlightColour:uint = UIList.HIGHLIGHT;
		protected var _disableColour:uint = DISABLED_COLOUR;
		protected var _leftMargin:Number = 0;
		protected var _data:Vector.<String> = null;
		protected var _labels:Vector.<UILabel> = null;
		protected var _labelFormat:TextFormat = LABEL_FORMAT;
		protected var _labelHighlight:TextFormat = LABEL_HIGHLIGHT;
		protected var _labelDisable:TextFormat = LABEL_DISABLE;
		protected var _enabled:Vector.<Boolean> = null;
		
		
		public function UIIcons(screen:Sprite, xml:XML, attributes:Attributes) {
			
			if (xml.@highlightColour.length() > 0) {
				_highlightColour = UI.toColourValue(xml.@highlightColour);
			}
			if (xml.@iconColour.length() > 0) {
				_iconColour = UI.toColourValue(xml.@iconColour);
			}
			if (xml.@activeColour.length() > 0) {
				_activeColour = UI.toColourValue(xml.@activeColour);
			}
			if (xml.@disableColour.length() > 0) {
				_disableColour = UI.toColourValue(xml.@disableColour);
			}
			if (xml.@leftMargin.length() > 0) {
				_leftMargin = parseFloat(xml.@leftMargin);
			}
			super(screen, xml, attributes);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			_timer.addEventListener(TimerEvent.TIMER, unHighlight);
			if (xml.data.length() > 0) {
				_data = new <String>[];
				_labels = new <UILabel>[];
				for each(var item:XML in xml.data.children()) {
					_data.push((item.@label.length() > 0) ? item.@label : item.localName());
				}
				delete xml.data;
			}
			if (xml.font.length() > 0) {
				_labelFormat = UIe.toTextFormat(xml.font[0] ,LABEL_FORMAT);
				delete xml.font;
			}
			if (xml.activeFont.length() > 0) {
				_labelHighlight = UIe.toTextFormat(xml.activeFont[0] ,LABEL_HIGHLIGHT);
				delete xml.activeFont;
			}
			if (xml.disableFont.length() > 0) {
				_labelDisable = UIe.toTextFormat(xml.disableFont[0] ,LABEL_DISABLE);
				delete xml.disableFont;
			}
			text = xml.toString().replace(/[\s\r\n\t]/g,"");
			unHighlight();
		}
		
		
		public function get labels():Vector.<UILabel> {
			return _labels;
		}
		
		
		public function enable(index:int, state:Boolean):void {
		//	var colour:ColorTransform = new ColorTransform();
		//	colour.color = state ? _iconColour : _disableColour;
		//	DisplayObject(_icons[index]).transform.colorTransform = colour;
			_enabled[index] = state;
			unHighlight();
		}
		
		
		protected function mouseDown(event:MouseEvent):void {
			_pressIndex = -1;
			for (var i:int = 0; i < _icons.length; i++) {
				var icon:DisplayObject = _icons[i];
				if (mouseX < icon.x + icon.width + _attributes.paddingH/2) {
					if (_enabled[i]) {
						_pressIndex = i;
						highlight();
					}
					break;
				}
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);					
		}
		
		
		public function clearHighlight():void {
			var index:int = 0;
			for each(var label:UILabel in _labels) {
				label.setTextFormat(_enabled[index++] ? _labelFormat : _labelDisable);
			}
		}
		
		
		override public function touchCancel():void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			unHighlight();
		}
		
		
		protected function labelHighlight():void {
			clearHighlight();
			if (_labels && _index < _labels.length) {
				_labels[_index].setTextFormat(_labelHighlight);
			}
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			var index:int = -1;
			for (var i:int = 0; i < _icons.length; i++) {
				var icon:DisplayObject = _icons[i];
				if (mouseX < icon.x + icon.width + _attributes.paddingH/2) {
					if (_enabled[i]) {
						index = i;
					}
					break;
				}
			}
			if (index >=0 && _pressIndex == index) {
				_index = _pressIndex;
				dispatchEvent(new Event(Event.CHANGE));
				labelHighlight();
			}
			_timer.reset();
			_timer.start();
			_pressIndex = -1;
		}
		
		
		protected function highlight():void {
			var colour:ColorTransform = new ColorTransform();
			colour.color = _highlightColour;
			DisplayObject(_icons[_pressIndex]).transform.colorTransform = colour;
		}
		
		
		protected function newColourTransform(colour:uint):ColorTransform {
				if (colour < uint.MAX_VALUE) {
					return new ColorTransform(
						COLOUR_OFFSET, COLOUR_OFFSET, COLOUR_OFFSET, 1.0,
						Math.round(COLOUR_FACTOR * (( colour >> 16 ) & 0xFF)),
						Math.round(COLOUR_FACTOR * (( colour >> 8 ) & 0xFF)),
						Math.round(COLOUR_FACTOR * ( colour & 0xFF)), 0
					);
				}
				else {
					return new ColorTransform();
				}
		}
		
		
		protected function unHighlight(event:TimerEvent = null):void {
			var disableColourTransform:ColorTransform = new ColorTransform();
			disableColourTransform.color = _disableColour;
			var index:int = 0;
			for each (var icon:DisplayObject in _icons) {
				icon.transform.colorTransform = _enabled[index++] ? newColourTransform( _iconColour) : disableColourTransform;
			}
			if (_index >= 0 && _activeColour < uint.MAX_VALUE) {
				_icons[_index].transform.colorTransform = _enabled[_index] ? newColourTransform(_activeColour) : disableColourTransform;
			}
		}
		
		
		public function get index():int {
			return _index;
		}
		
		
		public function set index(value:int):void {
			_pressIndex = _index = value;
			unHighlight();
			labelHighlight();
			_timer.reset();
			_timer.start();
		}
		
		
		override public function drawComponent():void {
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, width + _attributes.paddingH, height);
		}
		
		
		public function set text(source:String):void {
			var position:Number = _leftMargin;
			var dimensions:Array = source.split(",");
			if (_icons) {
				clear();
			}
			_icons = new <DisplayObject>[];
			_enabled = new <Boolean>[];
			for (var i:int = 0; i < dimensions.length; i++) {
				var icon:DisplayObject = DisplayObject(new (getDefinitionByName(dimensions[i]) as Class));
				_icons.push(icon);
				_enabled.push(true);
				if (icon is Bitmap) {
					Bitmap(icon).smoothing = true;
				}
				addChild(icon);
				icon.x = position;
				if (_data && i < _data.length) {
					var label:UILabel = new UILabel(this, 0, icon.height - 2, _data[i], _labelFormat);
					label.x = position + icon.width / 2 - label.width / 2;
					_labels.push(label);
				}
				position += icon.width + _attributes.paddingH;
			}
			drawComponent();
		}
		
		
		override public function clear():void {
			for each (var icon:DisplayObject in _icons) {
				removeChild(icon);
			}
			graphics.clear();
			_icons = null;
		}
		
		
		public function set icons(value:Vector.<DisplayObject>):void {
			if (_icons) {
				clear();
			}
			_icons = value;
		}
	
	
		override public function destructor():void {
			removeEventListener(MouseEvent.MOUSE_UP, mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_timer.removeEventListener(TimerEvent.TIMER, unHighlight);
		}
	}
}
