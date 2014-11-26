/**
 * VERSION: 0.12
 * DATE: 2011-10-12
 * AS3
 * UPDATES AND DOCS AT: http://www.greensock.com/
 **/
package com.greensock.transform {
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformItem;
	import com.greensock.transform.TransformManager;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
/**
 * An example implementation of a cropping tool that works with TransformManager, making it relatively simple to allow users
 * to interactively crop a DisplayObject using a rectangular mask. A Crop object is a <code>Sprite</code> that places itself 
 * in front of its <code>target</code> (the DisplayObject that it should crop) and it also creates another Shape object 
 * that serves as the target's <code>mask</code>. So the Crop object and the mask Shape are both automatically added to the
 * display list. When the Crop's <code>attached</code> property is <code>true</code>, the <code>target</code> will 
 * move/scale/rotate along with the Crop object (changes to the Crop are also applied to the target). 
 * When <code>maskEnabled</code> is <code>true</code>, the <code>target</code> will be masked visually.
 * 
 * <p>The Crop object is treated as just another TransformItem in the associated TransformManager so that it is able 
 * to be moved/scaled/rotated/selected. </p>
 * 
 * <p>When the Crop's <code>cropMode</code> property is <code>true</code>, it automatically detaches from the target
 * (<code>attached</code> is set to <code>false</code>) and the following also occur, which you can customize 
 * using the <code>configureCropMode()</code> method: </p>
 * <ul>
 * 		<li><code>maskEnabled</code> is set to <code>false</code> so that the target becomes fully visible (not masked).</li>
 * 		<li>The line color of the selection box becomes red (the TransformManager's <code>lineColor</code> is temporarily changed).</li>
 * 		<li>The <code>alpha</code> of the Crop is set to 0.3 so that the rectangle becomes visible.</li>
 * 		<li>A <code>"enterCropMode"</code> Event is dispatched.</li>
 * </ul>
 * 
 * <p>When <code>cropMode</code> is changed to <code>false</code>, a <code>"exitCropMode"</code> Event is dispatched.</p>
 * 
 * <p>To enter cropMode, simply double-click on the Crop object or manually set <code>cropMode</code> to <code>true</code>.
 * You could also create a button in your interface to toggle cropMode. Or use TransformManager's <code>addSelectionBoxElement()</code>
 * method to add a cropping button/icon to the actual selection box if you prefer. To exit cropMode, double-click the Crop object 
 * again or deselect both the target and Crop object (by clicking off of them) (you can disable this behavior with the 
 * <code>configureCropMode()</code> method).  </p>
 * 
 * <p>Example AS3 code:</p><listing version="3.0">
import com.greensock.transform.~~;

//create the TransformManager first 
var manager:TransformManager = new TransformManager();
 
//now create Crop objects for mc1, mc2, and mc3 which are all DisplayObjects on the stage
var mc1Crop:Crop = new Crop(mc1, manager);
var mc2Crop:Crop = new Crop(mc2, manager);
var mc3Crop:Crop = new Crop(mc3, manager);

//change the default cropMode behavior of mc1Crop so that the lineColor is 0x00FF00 and the alpha is 0.5
mc1Crop.configureCropMode(false, 0.5, 0x00FF00, true);
 </listing>
 * 
 * <p><b>Copyright 2011-2012, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/eula.html">http://www.greensock.com/eula.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class Crop extends Sprite {
		/** @private **/
		protected var _mask:Shape;
		/** @private **/
		protected var _target:DisplayObject;
		/** @private **/
		protected var _manager:TransformManager;
		/** @private **/
		protected var _item:TransformItem;
		/** @private **/
		protected var _targetTransformItem:TransformItem;
		/** @private **/
		protected var _offsetMatrix:Matrix;
		/** @private **/
		protected var _fillColor:uint;
		/** @private **/
		protected var _attached:Boolean;
		/** @private **/
		protected var _cropModeAlpha:Number;
		/** @private **/
		protected var _cropModeMaskEnabled:Boolean;
		/** @private **/
		protected var _cropModeAutoApplyOnDeselect:Boolean;
		/** @private **/
		protected var _cropMode:Boolean;
		/** @private **/
		protected var _cropLineColor:uint;
		/** @private **/
		protected var _originalLineColor:uint; 
		
		/**
		 * Constructor
		 * 
		 * @param target the target DisplayObject that the Crop object should affect (mask/crop). 
		 * @param manager the TransformManager instance that should be used to manage the transformations/selections
		 * @param attached if <code>true</code> (the default), transformations that are made to the Crop (move/scale/rotation) will also affect to the <code>target</code>. Set <code>attached</code> to <code>false</code> to move/scale/rotate them independently.
		 * @param fillColor the fill color (hex value) of the Crop object. When <code>cropMode</code> is <code>false</code> the Crop's alpha is 0, so you won't see the fill color unless <code>cropMode</code> is <code>true</code>. This basically controls the interactive mask color.
		 * @param alpha the initial alpha value of the Crop object (typically 0 is best).
		 */
		public function Crop(target:DisplayObject, manager:TransformManager, attached:Boolean=true, fillColor:uint=0x000000, alpha:Number=0) {
			super();
			_target = target;
			_manager = manager;
			_mask = new Shape();
			_fillColor = fillColor;
			_originalLineColor = _manager.lineColor;
			_manager.removeItem(_target); //just in case the item was added previously. 
			this.alpha = alpha;
			this.configureCropMode(false, 0.3, 0xFF0000, true);
			if (_target.parent) {
				calibrateDepths(null);
			}
			this.transform.matrix = _mask.transform.matrix = _target.transform.matrix;
			_offsetMatrix = new Matrix();
			_calibrateBox();
			_update(null, true);
			_target.mask = _mask;
			_item = _manager.addItem(this);
			_target.addEventListener(Event.ADDED, calibrateDepths, false, 0, true);
			_target.addEventListener(Event.REMOVED, _removeMasks, false, 0, true);
			_item.addEventListener(TransformEvent.SCALE, _update, false, 0, true);
			_item.addEventListener(TransformEvent.MOVE, _update, false, 0, true);
			_item.addEventListener(TransformEvent.ROTATE, _update, false, 0, true);
			_item.addEventListener(TransformEvent.SELECT, calibrateDepths, false, 0, true);
			_item.addEventListener(TransformEvent.DELETE, _deleteHandler, false, 0, true);
			_manager.addEventListener(TransformEvent.DEPTH_CHANGE, calibrateDepths, false, 0, true);
			_manager.addEventListener(TransformEvent.DOUBLE_CLICK, _doubleClickHandler, false, 0, true);
			_manager.addEventListener(TransformEvent.SELECTION_CHANGE, _selectionChangeHandler, false, 0, true);
			this.attached = attached;
		}
		
		/**
		 * Adjusts the depth levels of the <code>target</code> or Crop object in the display list so 
		 * that the Crop is on top of the <code>target</code>.
		 * 
		 * @param event an optional Event, making it easier to use <code>calibrateDepths()</code> as an event listener. The Event isn't used at all internally.
		 * @param leaveTarget if <code>true</code>, the <code>target</code> will remain exactly where it is in the display list and the Crop object will be moved above it rather than leaving the Crop where it is and moving the <code>target</code> under it. 
		 */
		public function calibrateDepths(event:Event=null, leaveTarget:Boolean=false):void {
			if (_target.parent == null) {
				return;
			}
			var targetIndex:int = _target.parent.getChildIndex(_target);
			if (this.parent != _target.parent) {
				_target.parent.addChildAt(this, targetIndex+1);
				_target.parent.addChildAt(_mask, targetIndex+1);
				return;
			}
			var thisIndex:int = this.parent.getChildIndex(this);
			if (!leaveTarget && thisIndex == 0) {
				this.parent.setChildIndex(_target, 0);
				this.parent.setChildIndex(this, 1);
			} else if (leaveTarget) {
				this.parent.setChildIndex(this, targetIndex + 1);
			} else {
				this.parent.setChildIndex(_target, thisIndex - 1);
			}
		}
		
		/** @private **/
		protected function _removeMasks(event:Event):void {
			if (this.parent != null) {
				this.parent.removeChild(this);
			}
			if (_mask.parent != null) {
				_mask.parent.removeChild(_mask);
			}
		}
		
		/** @private redraws the box inside the Crop and _mask so that it matches the _target's native bounding box **/
		protected function _calibrateBox():void {
			var bounds:Rectangle = _target.getBounds(_target);
			var g:Graphics = _mask.graphics;
			g.clear();
			g.beginFill(0xFF0000, 1);
			g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			g = this.graphics;
			g.clear();
			g.beginFill(_fillColor, 1);
			g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
		}
		
		/**
		 * Allows some customization of the <code>cropMode</code>, like alpha, lineColor, etc.
		 * 
		 * @param maskEnabled if <code>true</code>, the mask will stay enabled when in <code>cropMode</code>. 
		 * @param alpha sets the <code>alpha</code> that the Crop object should be when in <code>cropMode</code>. Set the <code>fillColor</code> to control the color.
		 * @param lineColor sets the line color of the selection box when in <code>cropMode</code>. This temporarily changes the TransformManager's <code>lineColor</code> while in <code>cropMode</code>.
		 * @param autoApplyOnDeselect if <code>true</code>, deselecting the Crop object and its <code>target</code> will automatically set <code>cropMode</code> to <code>false</code>.
		 */
		public function configureCropMode(maskEnabled:Boolean, alpha:Number, lineColor:uint, autoApplyOnDeselect:Boolean=true):void {
			_cropModeMaskEnabled = maskEnabled;
			_cropModeAlpha = alpha;
			_cropLineColor = lineColor;
			_cropModeAutoApplyOnDeselect = autoApplyOnDeselect;
		}
		
		/**
		 * Forces an update of the Crop object so that it either applies any recent scale/rotation/movement to the <code>target</code>
		 * (if <code>attached</code> is <code>true</code>) or records the offset values (if <code>attached</code> is <code>false</code>).
		 * 
		 * @param event an optional Event, making it easier to use <code>update()</code> as an event listener. The Event isn't used at all internally.
		 * @param calibrateBox if <code>true</code>, the Crop's rectangle will be updated to match the native bounding box of the <code>target</code>. This can be helpful if the <code>target</code>'s size or bounding box changed since the last update.
		 */
		public function update(event:Event=null, calibrateBox:Boolean=true):void {
			if (calibrateBox) {
				_calibrateBox();
			}
			_update(null);
		}
		
		/** @private **/
		protected function _update(event:Event, force:Boolean=false):void {
			var m:Matrix = this.transform.matrix;
			if (!_attached) {
				_calibrateBox();
				_offsetMatrix = _target.transform.matrix;
				m.invert();
				_offsetMatrix.concat(m);
			}
			if (_attached || force) {
				m = this.transform.matrix;
				_mask.transform.matrix = m;
				var combined:Matrix = _offsetMatrix.clone();
				combined.concat(m);
				_target.transform.matrix = combined;
				/* If you want to enable a scaleMode like scaleWidthAndHeight, you can tap into this but the _target's rotation and the Crop's/mask's rotation MUST be the same when attached otherwise skewing would happen and setting the width/height wouldn't give accurate results (it's impossible)
				if (this.scaleMode == "scaleWidthAndHeight") {
					var bounds:Rectangle = this.getBounds(this);
					_target.rotation = 0;
					_target.width = Math.sqrt(combined.a * combined.a + combined.b * combined.b) * bounds.width;
					_target.height = Math.sqrt(combined.d * combined.d + combined.c * combined.c) * bounds.height;
					_target.rotation = Math.atan2(combined.b, combined.a) * 180 / Math.PI;
					_target.x = combined.tx;
					_target.y = combined.ty;
				}
				*/
			}
		}
		
		/** @private **/
		protected function _doubleClickHandler(event:TransformEvent):void {
			if (event.items[0] == _item && event.items.length == 1) {
				this.cropMode = !this.cropMode;
			}
		}
		
		/** @private **/
		protected function _selectionChangeHandler(event:TransformEvent):void {
			if (_cropModeAutoApplyOnDeselect && !_item.selected && this.cropMode && _targetTransformItem != null && !_targetTransformItem.selected) {
				this.cropMode = false;
			}
		}
		
		/** @private **/
		protected function _deleteHandler(event:TransformEvent):void {
			if (_targetTransformItem) {
				_targetTransformItem.deleteObject();
			} else if (_target.parent) {
				_target.parent.removeChild(_target);
			}
			destroy();
		}
		
		/** Destroys the Crop object, removing its internal event listeners, disabling the mask, and releasing it for garbage collection. **/
		public function destroy():void {
			this.attached = true;
			_target.mask = null;
			_removeMasks(null);
			_target.removeEventListener(Event.ADDED, calibrateDepths);
			_target.removeEventListener(Event.REMOVED, _removeMasks);
			_item.removeEventListener(TransformEvent.SCALE, _update);
			_item.removeEventListener(TransformEvent.MOVE, _update);
			_item.removeEventListener(TransformEvent.ROTATE, _update);
			_item.removeEventListener(TransformEvent.SELECT, calibrateDepths);
			_item.removeEventListener(TransformEvent.DELETE, _deleteHandler);
			_manager.removeEventListener(TransformEvent.DEPTH_CHANGE, calibrateDepths);
			_manager.removeEventListener(TransformEvent.DOUBLE_CLICK, _doubleClickHandler);
			_manager.removeEventListener(TransformEvent.SELECTION_CHANGE, _selectionChangeHandler);
			_manager.removeItem(this);
			_mask = null;
		}
		
		
//---- GETTERS / SETTERS ------------------------------------------------------------------------------
		
		/** If <code>true</code>, transformations that are made to the Crop (move/scale/rotation) will also affect to the <code>target</code>. Set <code>attached</code> to <code>false</code> to move/scale/rotate the crop and its target independently. **/
		public function get attached():Boolean {
			return _attached;
		}
		public function set attached(value:Boolean):void {
			_update(null, false);
			_attached = value;
			_calibrateBox();
			if (_attached) {
				if (_targetTransformItem != null) {
					_targetTransformItem.removeEventListener(TransformEvent.SELECT, calibrateDepths);
					_manager.removeItem(_target);
				}
			} else {
				var bounds:Rectangle = _manager.bounds; //record temporarily so we can re-apply after adding the item. We don't want boundaries imposed on the _target.
				_manager.bounds = null;
				_targetTransformItem = _manager.addItem(_target);
				_targetTransformItem.addEventListener(TransformEvent.SELECT, calibrateDepths, false, 0, true);
				var m:Matrix = _target.transform.matrix;
				_manager.bounds = bounds;
				_targetTransformItem.bounds = null;
				_target.transform.matrix = m;
				_targetTransformItem.update(null);
			}
		}
		
		/** If <code>true</code>, the <code>target</code> will be masked by the crop. Technically the target's <code>mask</code> gets set to a Shape object that the Crop creates internally. **/
		public function get maskEnabled():Boolean {
			return Boolean(_target.mask == _mask);
		}
		public function set maskEnabled(value:Boolean):void {
			if (value) {
				_mask.visible = true;
				_target.mask =_mask;
			} else {
				_mask.visible = false;
				_target.mask = null;
			}
			_update(null, true);
		}
		
		/**  When the Crop's <code>cropMode</code> property is <code>true</code>, it automatically detaches from the target
		 * (<code>attached</code> is set to <code>false</code>) and the following also occur, which you can customize 
		 * using the <code><a href="#configureCropMode()">configureCropMode()</a></code> method: 
		 * <ul>
		 * 		<li><code>maskEnabled</code> is set to <code>false</code> so that the target becomes fully visible (not masked).</li>
		 * 		<li>The line color of the selection box becomes red (the TransformManager's <code>lineColor</code> is temporarily changed).</li>
		 * 		<li>The <code>alpha</code> of the Crop is set to 0.3 so that the rectangle becomes visible.</li>
		 * 		<li>A <code>"enterCropMode"</code> Event is dispatched.</li>
		 * </ul>
		 * 
		 * <p>When <code>cropMode</code> is changed to <code>false</code>, a <code>"exitCropMode"</code> Event is dispatched.</p>
		 * 
		 * <p>To enter cropMode, simply double-click on the Crop object or manually set <code>cropMode</code> to <code>true</code>.
		 * You could also create a button in your interface to toggle cropMode. Or use TransformManager's <code>addSelectionBoxElement()</code>
		 * method to add a cropping button/icon to the actual selection box if you prefer. To exit cropMode, double-click the Crop object 
		 * again or deselect both the target and Crop object (by clicking off of them) (you can disable this behavior with the 
		 * <code>configureCropMode()</code> method).  </p>
		 * @see #configureCropMode()
		 * @see #fillColor
		 * @see #selected
		 * @see #maskEnabled
		 **/
		public function get cropMode():Boolean {
			return _cropMode;
		}
		public function set cropMode(value:Boolean):void {
			if (value != _cropMode) {
				_cropMode = value;
				if (_cropMode) {
					this.attached = false;
					this.maskEnabled = _cropModeMaskEnabled;
					this.alpha = _cropModeAlpha;
					_originalLineColor = _manager.lineColor;
					_manager.lineColor = _cropLineColor;
					dispatchEvent(new Event("enterCropMode"));
				} else {
					this.attached = true;
					this.maskEnabled = true;
					this.alpha = 0;
					_manager.lineColor = _originalLineColor;
					dispatchEvent(new Event("exitCropMode"));
				}
			}
		}
		
		/** The target DisplayObject that the Crop object should affect (mask/crop).  **/
		public function get target():DisplayObject {
			return _target;
		}
		
		/** @inheritDoc **/
		override public function set x(value:Number):void {
			super.x = value;
			_update(null, false);
		}
		/** @inheritDoc **/
		override public function set y(value:Number):void {
			super.y = value;
			_update(null, false);
		}
		/** @inheritDoc **/
		override public function set scaleX(value:Number):void {
			super.scaleX = value;
			_update(null, false);
		}
		/** @inheritDoc **/
		override public function set scaleY(value:Number):void {
			super.scaleY = value;
			_update(null, false);
		}
		/** @inheritDoc **/
		override public function set rotation(value:Number):void {
			super.rotation = value;
			_update(null, false);
		}
		/** @inheritDoc **/
		override public function set width(value:Number):void {
			super.width = value;
			_update(null, false);
		}
		/** @inheritDoc **/
		override public function set height(value:Number):void {
			super.height = value;
			_update(null, false);
		}
		/** @inheritDoc **/
		override public function set transform(value:Transform):void {
			super.transform = value;
			_update(null, false);
		}

	}
	
}
