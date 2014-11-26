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
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 */

package com.danielfreeman.madcomponents {

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormat;

/**
 *  MadComponents Navigation Bar
 */
	public class UINavigationBar extends Sprite {
	
		public static const HEIGHT:Number = 46.0;
		protected static const COLOUR:uint = 0x9999BB;
		protected static const LEFTCOLOUR:uint = 0x7777AA;
		protected static const DONECOLOUR:uint = 0xAA7777;
		protected static const SIDES:Number = 100.0;
		protected static const Y:Number = 5;
		
		protected const FORMAT:TextFormat = new TextFormat("Tahoma",20,0xFFFFFF);
		protected const DARK_FORMAT:TextFormat = new TextFormat("Tahoma", 20, 0x333366);

		
		protected var _label:UILabel;
		protected var _shadowLabel:UILabel;
		protected var _leftButton:UIButton;
		protected var _backButton:UIBackButton;
		protected var _attributes:Attributes;
		protected var _rightButton:UIButton;
		protected var _rightArrow:UIBackButton;
		protected var _colour:uint;
		protected var _centrePanel:Sprite;
		
	
		public function UINavigationBar(screen:Sprite, attributes:Attributes) {
			screen.addChildAt(this,0);
			_attributes = attributes;
			_colour = attributes.colour;
			drawBar();
			_shadowLabel = new UILabel(this, 0, Y+1, "", DARK_FORMAT);
			_label = new UILabel(this, 0, Y+2, "", FORMAT);
			_leftButton = new UIButton(this, 8, Y, '<font size="14">left</font>', LEFTCOLOUR, new <uint>[], true);		// JSS
			_leftButton.visible = false;
			_backButton = new UIBackButton(this, 4, Y, "back", COLOUR);
			_rightArrow = new UIBackButton(this, 200, Y, "next", COLOUR, true);
			_rightButton = new UIButton(this, 200, Y, '<font size="14">done</font>', DONECOLOUR, new <uint>[], true);
			addChild(_centrePanel = new Sprite());
			adjustButtons();
			_rightButton.visible = _rightArrow.visible = false;
		}
		
		
		protected function adjustButtons():void {
			_rightArrow.x = _attributes.width - _rightArrow.width - 6;
			_rightButton.x = _attributes.width - _rightButton.width - 8;
			_centrePanel.x = _attributes.width / 2;
		}
		
/**
 *  Text of navigation bar
 */
		public function set text(value:String):void {
			_label.text = value;
			_shadowLabel.text = value;
			_label.x = (_attributes.width - _label.width) / 2;
			_shadowLabel.x=_label.x-1;
		}
		
		
/**
 *  Left button
 */
		public function get leftButton():UIButton {
			return _leftButton;
		}

/**
 *  Left button/arrow text
 */
		public function set leftButtonText(value:String):void {
			_leftButton.text = '<font size="14">'+value+'</font>';
		}
		
/**
 *  Back button
 */
		public function get backButton():UIBackButton {
			return _backButton;
		}
		
/**
 *  Right button
 */
		public function get rightButton():UIButton {
			return _rightButton;
		}
		
/**
 *  Right arrow button
 */
		public function get rightArrow():UIBackButton {
			return _rightArrow;
		}
		
/**
 *  Colour of navigation bar
 */
		public function set colour(value:uint):void {
			_colour = value;
			drawBar();
		}

/**
 *  Colour of navigation bar
 */
		public function get colour():uint {
			return _colour;
		}
		
/**
 *  Right button/arrow text
 */
		public function set rightButtonText(value:String):void {
			_rightButton.text = '<font size="14">'+value+'</font>';
			_rightArrow.text = value;
			adjustButtons();
		}
		
/**
 *  Width of navigation bar
 */
		public function set fixwidth(value:Number):void {
			_attributes.width = value;
			_label.x = (_attributes.width - _label.width) / 2;
			_shadowLabel.x=_label.x-1;
			adjustButtons();
			drawBar();
		}
		
		
		public function get centrePanel():Sprite {
			return _centrePanel;	
		}
		
		
		public function set centrePanel(value:Sprite):void {
			_centrePanel.addChild(value);
			value.x = -value.width / 2;
			value.y = (HEIGHT - value.height) / 2;
		}
		
/**
 *  Draw navigation bar
 */
		protected function drawBar():void {
			var matr:Matrix=new Matrix();
			matr.createGradientBox(_attributes.width, HEIGHT, Math.PI/2, 0, 0);
			graphics.clear();
			graphics.beginGradientFill(GradientType.LINEAR, [Colour.lighten(_colour,64),Colour.darken(_colour)], [1.0,1.0], [0x00,0xff], matr);
			graphics.drawRect(0, 0, _attributes.width, HEIGHT);
		}
		
		
		public function destructor():void {
			_leftButton.destructor();
			_rightButton.destructor();
		}
	}
}
