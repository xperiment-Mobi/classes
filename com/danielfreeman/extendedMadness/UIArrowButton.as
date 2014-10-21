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
 
package com.danielfreeman.extendedMadness
{
	import flash.events.MouseEvent;
	import com.danielfreeman.madcomponents.*;
	import flash.geom.Matrix;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.text.TextFormat;
	import flash.events.Event;


	public class UIArrowButton extends UIContainerBaseClass {
		
	//	public static const CLICKED:String = "clicked";	
		
		protected static const CURVE:Number = 4.0;
		protected static const HEIGHT:Number = 38.0;
		protected static const ARROW:Number = 6.0;
		protected static const ARROW_COLOUR:uint = 0xFFFFFF;
		
		protected var _curve:Number = CURVE;
		protected var _height:Number = HEIGHT;
		protected var _width:Number = -1;
		protected var _arrow:Number = ARROW;
		protected var _enabled:Boolean;
		protected var _arrowColour:uint = ARROW_COLOUR;
			

		public function UIArrowButton(screen:Sprite, xml:XML, attributes:Attributes) {
			if (attributes.fillH) {
				_width = attributes.widthH;
			}
			if (attributes.fillV) {
				_height = attributes.heightV;
			}
			if (xml.@arrowColour.length() > 0) {
				_arrowColour = UI.toColourValue(xml.@arrowColour);
			}
			if (xml.@curve.length() > 0) {
				_curve = parseFloat(xml.@curve);
			}
			if (xml.@up == "true") {
				_arrow = - ARROW;
			}
			super(screen, xml, attributes);
			buttonMode = useHandCursor = true;
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
			
		
		protected function mouseDown(event:MouseEvent):void {
			_enabled = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			drawComponent();
		}
		
		
		protected function mouseUp(event:MouseEvent):void {
			if (_enabled && event.target == this) {
				dispatchEvent(new Event(UIButton.CLICKED));
			}
			_enabled = false;
			drawComponent();
		}


		override public function drawComponent():void {

			var matr:Matrix = new Matrix();
		//	const gradient:Array = [Colour.lighten(attributes.colour,128),attributes.colour,attributes.colour];
			const gradient:Array = _enabled ? [Colour.darken(attributes.colour,128),Colour.lighten(attributes.colour),Colour.darken(attributes.colour)]
										: [Colour.lighten(attributes.colour,80),Colour.darken(attributes.colour),Colour.darken(attributes.colour)];
			matr.createGradientBox(_width, _height, Math.PI/2, 0, 0);
			graphics.clear();
			graphics.beginGradientFill(GradientType.LINEAR, gradient, [1.0,1.0,1.0], [0x00,0x80,0xff], matr);
			graphics.lineStyle(1, Colour.darken(attributes.colour,-32), 1.0, true);
			graphics.moveTo(0,_curve);
			graphics.curveTo(0, 0, _curve, 0);
			graphics.lineTo(_width - _curve, 0);
			graphics.curveTo(_width, 0, _width, _curve);
			graphics.lineTo(_width, _height - _curve);
			graphics.curveTo(_width, _height, _width - _curve, _height);
			graphics.lineTo(_curve, _height);
			graphics.curveTo(0, _height, 0, _height - _curve);
			graphics.lineTo(0, _curve);

			graphics.beginFill(mouseEnabled ? _arrowColour : Colour.darken(attributes.colour, -32));
			graphics.lineStyle(0, 0, 0);
			graphics.moveTo(_width/2, _height/2 + _arrow/2);
			graphics.lineTo(_width/2 + ARROW, _height/2 - _arrow/2);
			graphics.lineTo(_width/2 - ARROW, _height/2 - _arrow/2);
			graphics.lineTo(_width/2, _height/2 + _arrow/2);

		}
		
		
		public function set enable(value:Boolean):void {
			mouseEnabled = value;
			drawComponent();
		}


		override public function layout(attributes:Attributes):void {
			if (attributes.fillH) {
				_width = attributes.widthH;
			}
			if (attributes.fillV) {
				_height = attributes.heightV;
			}
			super.layout(attributes);
		}


		override public function destructor():void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
		}
	}
}