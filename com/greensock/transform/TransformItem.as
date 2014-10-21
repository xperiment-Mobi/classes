/**
 * VERSION: 1.9669
 * DATE: 2013-01-12
 * AS3 
 * UPDATES AND DOCS AT: http://www.greensock.com/transformmanageras3/
 **/
package com.greensock.transform {
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.utils.MatrixTools;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.getDefinitionByName;

/**
 * TransformManager automatically creates a TransformItem instance for each DisplayObject 
 * that it manages, using it to apply various transformations and check constraints. Typically
 * you won't need to interact much with the TranformItem instances except if you need to 
 * apply item-specific properties like minScaleX, maxScaleX, minScaleY, maxScaleY, or if you
 * need to apply transformations directly. You can use TransformManager's <code>getItem()</code> 
 * method to get the TransformItem instance associated with a particular DisplayObject anytime 
 * after it is added to the TransformManager instance, like:<p><code>
 * 	
 * 	var myItem:TransformItem = myManager.getItem(myObject);</code></p>
 * 
 * <p><b>Copyright 2007-2013, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/eula.html">http://www.greensock.com/eula.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class TransformItem extends EventDispatcher {
		/** @private **/
		public static const VERSION:Number = 1.9669;
		/** @private precomputation for speed**/
		protected static const _DEG2RAD:Number = Math.PI / 180;
		/** @private precomputation for speed**/
		protected static const _RAD2DEG:Number = 180 / Math.PI; 
		/** @private **/
		protected static var _proxyCount:uint = 0;
		/** @private **/
		protected static var _normalMatrix:Matrix = new Matrix();
		
		/** @private **/
		protected var _hasSelectableText:Boolean;
		/** @private **/
		protected var _stage:Stage;
		/** @private **/
		protected var _scaleMode:String;
		/** @private if scaleMode is normal. this will point to the _targetObject. Otherwise, we create a proxy that we scale normally and then use it to scale the width/height or setSize() the targetObject.**/
		protected var _target:DisplayObject;
		/** @private **/
		protected var _proxy:InteractiveObject;
		/** @private used for TextFields - for some odd reason, TextFields created in the IDE must be offset 2 pixels left and up in order to line up properly with their scaled counterparts. **/
		protected var _offset:Point; 
		/** @private **/
		protected var _origin:Point;
		/** @private **/
		protected var _localOrigin:Point;
		/** @private **/
		protected var _baseRect:Rectangle;
		/** @private **/
		protected var _bounds:Rectangle;
		/** @private **/
		protected var _targetObject:DisplayObject;
		/** @private **/
		protected var _allowDelete:Boolean; 
		/** @private **/
		protected var _constrainScale:Boolean;
		/** @private only used when constrainScale is true. scaleX / scaleY **/
		protected var _constrainRatio:Number;
		/** @private **/
		protected var _lockScale:Boolean;
		/** @private **/
		protected var _lockRotation:Boolean;
		/** @private **/
		protected var _lockPosition:Boolean;
		/** @private **/
		protected var _enabled:Boolean;
		/** @private **/
		protected var _selected:Boolean;
		/** @private **/
		protected var _minScaleX:Number;
		/** @private **/
		protected var _minScaleY:Number;
		/** @private **/
		protected var _maxScaleX:Number;
		/** @private **/
		protected var _maxScaleY:Number;
		/** @private **/
		protected var _minWidth:Number;
		/** @private **/
		protected var _minHeight:Number;
		/** @private **/
		protected var _maxWidth:Number;
		/** @private **/
		protected var _maxHeight:Number;
		/** @private **/
		protected var _cornerAngleTL:Number;
		/** @private **/
		protected var _cornerAngleTR:Number;
		/** @private **/
		protected var _cornerAngleBR:Number;
		/** @private **/
		protected var _cornerAngleBL:Number;
		/** @private **/
		protected var _createdManager:TransformManager;
		/** @private **/
		protected var _isFlex:Boolean;
		/** @private **/
		protected var _frameCount:uint = 0;
		/** @private **/
		protected var _dispatchScaleEvents:Boolean;
		/** @private **/
		protected var _dispatchMoveEvents:Boolean;
		/** @private **/
		protected var _dispatchRotateEvents:Boolean;
		/** @private **/
		protected var _flipX:Boolean;
		/** @private whenever the TransformItem is selected, TransformManager controls its origin, but when it is deselected, it returns to its own. **/
		protected var _unselectedOrigin:Point;
		/** @private **/
		protected var _manager:TransformManager;
		/** Should only be used in cases where the selection box is drawn incorrectly on a single-selection of the TransformItem (typically due to bugs in Adobe's Flex framework) - this allows you to define the amount of pixels to offset from the registration and the width/height of the <code>targetObject</code> when drawing the selection box around the single selection of the TransformItem. For example, if the selection should be drawn as though its top-left corner is exactly on the targetObject's registration point and the width and height should be an extra 2 pixels beyond the normal width/height, you'd define the manualBoundsOffset as <code>new Rectangle(0, 0, 2, 2)</code>. These values are relative to the registration point and are in the coordinate space of the targetObject itself (not its parent). **/
		public var manualBoundsOffset:Rectangle;
		
		/** @private **/
		protected var _vars:Object;
		
		
		/**
		 * Constructor
		 * 
		 * @param $targetObject DisplayObject to be managed
		 * @param $vars An object specifying any properties that should be set upon instantiation, like <code>{constrainScale:true, lockRotation:true, bounds:new Rectangle(0, 0, 500, 300)}</code>.
		 */
		public function TransformItem($targetObject:DisplayObject, $vars:Object) {
			if (TransformManager.VERSION < 1.96) {
				trace("TransformManager Error: You have an outdated TransformManager-related class file. You may need to clear your ASO files. Please make sure you're using the latest version of TransformManager, TransformItem, and TransformItemTF, available from www.greensock.com.");
			}
			init($targetObject, $vars);
		}
		
		/** @private **/
		protected function init($targetObject:DisplayObject, $vars:Object):void {
			_vars = $vars || {};
			_targetObject = _target = $targetObject;
			_determineFlexMode();
			_flipX = Boolean(_targetObject.scaleX < 0);
			if (_vars.manualBoundsOffset is Rectangle) {
				this.manualBoundsOffset = _vars.manualBoundsOffset;
			}
			_baseRect = this.getBounds(_targetObject, _targetObject);
			_allowDelete = setDefault(_vars.allowDelete, false);
			this.constrainScale = setDefault(_vars.constrainScale, false);
			_lockScale = setDefault(_vars.lockScale, false);
			_lockRotation = setDefault(_vars.lockRotation, false);
			_lockPosition = setDefault(_vars.lockPosition, false);
			_hasSelectableText = setDefault(_vars.hasSelectableText, (_targetObject is TextField) ? true : false);
			this.scaleMode = setDefault(_vars.scaleMode, (_hasSelectableText) ? TransformManager.SCALE_WIDTH_AND_HEIGHT : TransformManager.SCALE_NORMAL);
			this.minScaleX = setDefault(_vars.minScaleX, -Infinity);
			this.minScaleY = setDefault(_vars.minScaleY, -Infinity);
			this.maxScaleX = setDefault(_vars.maxScaleX, Infinity);
			this.maxScaleY = setDefault(_vars.maxScaleY, Infinity);
			
			this.minWidth = setDefault(_vars.minWidth, 1);
			this.minHeight = setDefault(_vars.minHeight, 1);
			this.maxWidth = setDefault(_vars.maxWidth, Infinity);
			this.maxHeight = setDefault(_vars.maxScaleY, Infinity);
			
			this.origin = _unselectedOrigin = new Point(_targetObject.x, _targetObject.y);
			if (_vars.manager == undefined) {
				_vars.items = [this];
				_manager = _createdManager = new TransformManager(_vars);
			} else {
				_manager = _vars.manager;
			}
			if (_targetObject.stage != null) {
				_stage = _targetObject.stage;
			} else {
				_targetObject.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
			_selected = false;
			this.bounds = _vars.bounds;
			_enabled = !Boolean(_vars.enabled);
			this.enabled = !_enabled;
		}
		
		/** @private **/
		protected function onAddedToStage($e:Event):void { //needed to keep track of _stage primarily for the MOUSE_UP listening and for the scenario when a _targetObject is removed from the stage immediately when selected (very rare and somewhat unintuitive scenario, but a user did want to do it)
			_stage = targetObject.stage;
			_determineFlexMode();
			if (_proxy != null) {
				if (_isFlex && _targetObject.parent.hasOwnProperty("addElement") && _proxy.hasOwnProperty("postLayoutTransformOffsets")) { //for Flex compatibility (spark)
					(_targetObject.parent as Object).addElement(_proxy);
				} else {
					_targetObject.parent.addChild(_proxy);
				}
			}
			_targetObject.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		/** @private **/
		protected function _determineFlexMode():void {
			if ("flexMode" in _vars) {
				_isFlex = Boolean(_vars.flexMode);
			} else {
				try {
					_isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager")); // SystemManager is the first display class created within a Flex application
				} catch ($e:Error) {
					_isFlex = false;
				}
				if (_isFlex && !(_targetObject.parent is (getDefinitionByName("mx.core.UIComponent") as Class))) {
					_isFlex = false;
				}
			}
		}
		
//---- SELECTION ---------------------------------------------------------------------------------------
		
		/** @private **/
		protected function onMouseDown($e:MouseEvent):void {
			if (_hasSelectableText) {
				dispatchEvent(new TransformEvent(TransformEvent.MOUSE_DOWN, [this]));
			} else {
				_stage = _targetObject.stage; //must set this each time in case the stage changes (which can happen in an AIR app)
				_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				dispatchEvent(new TransformEvent(TransformEvent.MOUSE_DOWN, [this], $e));
				if (_selected) {
					dispatchEvent(new TransformEvent(TransformEvent.SELECT_MOUSE_DOWN, [this], $e));
				}
			}
		}
		
		/** @private **/
		protected function onMouseUp($e:MouseEvent):void {
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			if (!_hasSelectableText && _selected) {
				dispatchEvent(new TransformEvent(TransformEvent.SELECT_MOUSE_UP, [this], $e));
			}
		}
		
		/** @private **/
		protected function onRollOverItem($e:MouseEvent):void {
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.ROLL_OVER_SELECTED, [this], $e));
			}
		}
		
		/** @private **/
		protected function onRollOutItem($e:MouseEvent):void {
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.ROLL_OUT_SELECTED, [this], $e));
			}
		}
		
		
//---- GENERAL -----------------------------------------------------------------------------------------
		
		/** @private **/
		public function update($e:Event = null):void {
			_baseRect = this.getBounds(_targetObject, _targetObject);
			if (_targetObject.scaleX < 0) {
				_flipX = true; //note: Flex (and sometimes Flash) doesn't always maintain negative scaleX values when reporting (visually they're fine). If it is negative, we know for sure it's right, but if it's positive we can't be sure, therefore we'll allow _flipX to remain true if _targetObject.scaleX is positive. It seems to be the safest assumption. Otherwise, if TransformItem flipped X and then update() is called and the bug in Flex/Flash still reports scaleX as positive, it'd throw things off here.
			}
			setCornerAngles();
			if (_proxy != null) {
				calibrateProxy();
			}
			dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
		}
		
		/** @private **/
		protected function getBounds(target:DisplayObject, coordinateSpace:DisplayObject):Rectangle {
			if (this.manualBoundsOffset != null) {
				var m:Matrix = _target.transform.matrix;
				var bounds:Rectangle;
				if (target == _target || target == _targetObject) {
					if (coordinateSpace == target) {
						target.transform.matrix = _normalMatrix; //removes all transforms so we can accurately measure width/height, particularly in Flex.
						bounds = new Rectangle(this.manualBoundsOffset.x, this.manualBoundsOffset.y, target.width + this.manualBoundsOffset.width, target.height + this.manualBoundsOffset.height); 
						target.transform.matrix = m; //re-applies the original transforms
						return bounds;
					} else if (coordinateSpace == _targetObject.parent) {
						_baseRect = this.getBounds(target, target);
						var s:Shape = new Shape();
						s.graphics.beginFill(0, 1);
						s.graphics.drawRect(_baseRect.x, _baseRect.y, _baseRect.width, _baseRect.height);
						s.graphics.endFill();
						s.transform.matrix = m;
						var c:Sprite = new Sprite();
						c.addChild(s);
						return s.getBounds(c);
					}
				}
			}
			return target.getBounds(coordinateSpace);
		}
		
		/**
		 * Allows listening for the following events:
		 * <ul>
		 * 		<li> TransformEvent.MOVE</li>
		 * 		<li> TransformEvent.SCALE</li>
		 * 		<li> TransformEvent.ROTATE</li>
		 * 		<li> TransformEvent.SELECT</li>
		 * 		<li> TransformEvent.DELETE</li>
		 * 		<li> TransformEvent.UPDATE</li>
		 * </ul>
		 * 
		 * @param $type Event type
		 * @param $listener Listener function
		 * @param $useCapture Use capture phase
		 * @param $priority Priority
		 * @param $useWeakReference Use weak reference
		 */
		override public function addEventListener($type:String, $listener:Function, $useCapture:Boolean=false, $priority:int=0, $useWeakReference:Boolean=false):void {
			//to improve performance, only dispatch the continuous move/scale/rotate events when necessary (the ones that fire on MOUSE_MOVE).
			if ($type == TransformEvent.MOVE) {
				_dispatchMoveEvents = true;
			} else if ($type == TransformEvent.SCALE) {
				_dispatchScaleEvents = true;
			} else if ($type == TransformEvent.ROTATE) {
				_dispatchRotateEvents = true;
			}
			super.addEventListener($type, $listener, $useCapture, $priority, $useWeakReference);
		}
		
		/** @private In Flex, we cannot addChild() immediately because the container needs time to instantiate or it will throw errors, so we wait 3 frames...**/
		protected function autoCalibrateProxy($e:Event=null):void {
			if (_frameCount >= 3) {
				_targetObject.removeEventListener(Event.ENTER_FRAME, autoCalibrateProxy);
				if (_targetObject.parent) {
					if (_isFlex && _targetObject.parent.hasOwnProperty("addElement") && _proxy.hasOwnProperty("postLayoutTransformOffsets")) { //for Flex compatibility (spark)
						(_targetObject.parent as Object).addElement(_proxy);
					} else {
						_targetObject.parent.addChild(_proxy);
					}
				}
				_target = _proxy;
				calibrateProxy();
				_frameCount = 0;
			} else {
				_frameCount++;
			}
		}
		
		/** @private **/
		protected function createProxy():void {
			removeProxy();
			
			_proxy = (_isFlex) ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite();
			_proxyCount++;
			_proxy.name = "__tmProxy" + _proxyCount;  //important: FlexTransformManager looks for this name in order to avoid infinite loop problems with addChild()
			_proxy.visible = false;
			
			try {
				_target = _proxy;
				if (_targetObject.parent.hasOwnProperty("addElement") && _proxy.hasOwnProperty("postLayoutTransformOffsets")) { //for Flex compatibility (spark)
					(_targetObject.parent as Object).addElement(_proxy);
				} else {
					_targetObject.parent.addChild(_proxy);
				}
			} catch ($e:Error) {
				_target = _targetObject;
				_targetObject.addEventListener(Event.ENTER_FRAME, autoCalibrateProxy); //In Flex, sometimes the parent can need a few frames to instantiate properly
			}
			_offset = new Point(0, 0);
			
			//TextFields created in the IDE have a different gutter than ones created via ActionScript (2 pixels), so we must attempt to discern between the 2 using the line metrics...
			if (_targetObject is TextField) {
				var tf:TextField = (_targetObject as TextField);
				var isEmpty:Boolean = false;
				if (tf.text == "") {
					tf.text = "Y"; //temporarily dump a character in for measurement.
					isEmpty = true;
				}
				var format:TextFormat = tf.getTextFormat(0, 1);
				var altFormat:TextFormat = tf.getTextFormat(0, 1);
				altFormat.align = "left";
				tf.setTextFormat(altFormat, 0, 1);
				var metrics:TextLineMetrics = tf.getLineMetrics(0);
				if (metrics.x == 0) {
					_offset = new Point(-2, -2);
				}
				tf.setTextFormat(format, 0, 1);
				if (isEmpty) {
					tf.text = "";
				}
				
			}
			calibrateProxy();
		}
		
		/** @private **/
		protected function removeProxy():void {
			if (_proxy != null) {
				if (_proxy.parent != null) {
					if (_isFlex && _proxy.parent.hasOwnProperty("removeElement") && _proxy.hasOwnProperty("postLayoutTransformOffsets")) { //for Flex compatibility (spark)
						(_proxy.parent as Object).removeElement(_proxy);
					} else {
						_proxy.parent.removeChild(_proxy);
					}
				}
				_proxy = null;
			}
			_target = _targetObject;
		}
		
		/** @private **/
		protected function calibrateProxy():void {
			var m:Matrix = _targetObject.transform.matrix;
			_targetObject.transform.matrix = _normalMatrix; //to clear all transformations
			
			var r:Rectangle = this.getBounds(_targetObject, _targetObject);
			var g:Graphics = (_proxy as Sprite).graphics;
			g.clear();
			if (_targetObject.width != 0 && _targetObject.height != 0) {
				g.beginFill(0xFF0000, 0);
				g.drawRect(r.x, r.y, _targetObject.width, _targetObject.height); //don't use r.width and r.height because often times Flex components report those inaccurately with getBounds()!
				g.endFill();
			}
			
			_proxy.scaleX = _targetObject.scaleX;
			_proxy.scaleY = _targetObject.scaleY;
			_proxy.width = _baseRect.width = _targetObject.width;
			_proxy.height = _baseRect.height = _targetObject.height;
			_proxy.transform.matrix = _targetObject.transform.matrix = m;
		}
		
		/** @private **/
		protected function setCornerAngles():void { //figures out the angles from the origin to each of the corners of the _bounds rectangle.
			if (_bounds != null) {
				_cornerAngleTL = TransformManager.positiveAngle(Math.atan2(_bounds.y - _origin.y, _bounds.x - _origin.x));
				_cornerAngleTR = TransformManager.positiveAngle(Math.atan2(_bounds.y - _origin.y, _bounds.right - _origin.x));
				_cornerAngleBR = TransformManager.positiveAngle(Math.atan2(_bounds.bottom - _origin.y, _bounds.right - _origin.x));
				_cornerAngleBL = TransformManager.positiveAngle(Math.atan2(_bounds.bottom - _origin.y, _bounds.x - _origin.x));
			}
		}
		
		/** @private **/
		protected function reposition(targetOnly:Boolean=false):void { //Ensures that the _origin lines up with the _localOrigin.
			var p:Point = _target.parent.globalToLocal(_target.localToGlobal(_localOrigin)); 
			_target.x += _origin.x - p.x;
			_target.y += _origin.y - p.y;
			
			if (!targetOnly && _target == _proxy) {
				p = _proxy.parent.globalToLocal(_proxy.localToGlobal(_offset));
				_targetObject.x = p.x;
				_targetObject.y = p.y;
			}
		}
		
		/** @private **/
		public function onPressDelete($e:Event = null, $allowSelectableTextDelete:Boolean = false):Boolean {
			if (_enabled && _allowDelete && (_hasSelectableText == false || $allowSelectableTextDelete)) { //_hasSelectableText typically means it's a TextField in which case users should be able to hit the DELETE key without deleting the whole TextField.
				deleteObject();
				return true;
			}
			return false;
		}
		
		/** Deletes the DisplayObject (removing it from the display list) **/
		public function deleteObject():void {
			this.selected = false;
			if (_targetObject.parent) {
				if (_isFlex && _targetObject.parent.hasOwnProperty("removeElement")) { //for Flex compatibility (spark)
					(_targetObject.parent as Object).removeElement(_targetObject);
				} else {
					_targetObject.parent.removeChild(_targetObject);
				}
			}
			removeProxy();
			dispatchEvent(new TransformEvent(TransformEvent.DELETE, [this]));
		}
		
		/** Destroys the TransformItem instance, preparing for garbage collection **/
		public function destroy():void {
			this.enabled = false; //kills listeners too
			this.selected = false; //kills listeners too
			dispatchEvent(new TransformEvent(TransformEvent.DESTROY, [this]));
		}


//---- MOVE --------------------------------------------------------------------------------------------

		/**
		 * Moves the selected items by a certain number of pixels on the x axis and y axis
		 *  
		 * @param $x Number of pixels to move the item along the x-axis (can be negative or positive)
		 * @param $y Number of pixels to move the item along the y-axis (can be negative or positive)
		 * @param $checkBounds If false, bounds will be ignored
		 * @param $dispatchEvent If false, no MOVE events will be dispatched
		 */
		public function move($x:Number, $y:Number, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
			if (!_lockPosition) {
				if ($checkBounds && _bounds != null) {
					var safe:Object = {x:$x, y:$y};
					moveCheck($x, $y, safe);
					$x = safe.x;
					$y = safe.y;
				}
				_target.x += $x;
				_target.y += $y;
				_origin.x += $x;
				_origin.y += $y;
				if (_target != _targetObject) {
					_targetObject.x += $x;
					_targetObject.y += $y;
				}
				//this.setCornerAngles();
				
				if ($dispatchEvent && _dispatchMoveEvents && ($x != 0 || $y != 0)) {
					dispatchEvent(new TransformEvent(TransformEvent.MOVE, [this]));
				}
			}
		}
		
		/** @private **/
		public function moveCheck($x:Number, $y:Number, $safe:Object):void { //Just checks to see if the translation will hit the bounds and edits the $safe object properties to make sure it doesn't
			if (_lockPosition) {
				$safe.x = $safe.y = 0;
			} else if (_bounds != null) {
				var r:Rectangle = this.getBounds(_target, _targetObject.parent);
				r.offset($x, $y);
				if (!_bounds.containsRect(r)) {
					if (_bounds.right < r.right) {
						$x += _bounds.right - r.right;
						$safe.x = int(Math.min($safe.x, $x));
					} else if (_bounds.left > r.left) {
						$x += _bounds.left - r.left;
						$safe.x = int(Math.max($safe.x, $x) + 0.5);
					}
					if (_bounds.top > r.top) {
						$y += _bounds.top - r.top;
						$safe.y = int(Math.max($safe.y, $y) + 0.5);
					} else if (_bounds.bottom < r.bottom) {
						$y += _bounds.bottom - r.bottom;
						$safe.y = int(Math.min($safe.y, $y));
					}
				}
			}
		}
		

//---- SCALE -------------------------------------------------------------------------------------------
		
		
		/**
		 * Scales the item along the x- and y-axis using multipliers. Keep in mind that these are
		 * not absolute values, so if the item's scaleX is 2 and you scale(2, 1), its new
		 * scaleX would be 4 because 2 &#42; 2 = 4. 
		 * 
		 * @param $sx Multiplier for scaling along the selection box's x-axis (which may or may not be the same as the selected item's y-axis, depending on whether or not multiple items are selected and if any are rotated)
		 * @param $sy Multiplier for scaling along the selection box's y-axis (which may or may not be the same as the selected item's y-axis, depending on whether or not multiple items are selected and if any are rotated)
		 * @param $angle Angle at which the item should be scaled (in Radians)
		 * @param $checkBounds If false, bounds will be ignored
		 * @param $dispatchEvent If false, no SCALE event will be dispatched
		 * 
		 */
		public function scale($sx:Number, $sy:Number, $angle:Number = 0, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
			if (!_lockScale) {
				scaleRotated($sx, $sy, $angle, -$angle, $checkBounds, $dispatchEvent);
			}
		}
		
		/** @private **/
		public function scaleRotated($sx:Number, $sy:Number, $angle:Number, $skew:Number, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
			if (!_lockScale) {
				var m:Matrix = _target.transform.matrix;
				
				if ($angle != -$skew && Math.abs(($angle + $skew) % (Math.PI - 0.01)) < 0.01) { //protects against rounding errors in tiny decimals
					$skew = -$angle;
				}
				
				if ($checkBounds && _bounds != null) {
					var safe:Object = {sx:$sx, sy:$sy};
					scaleCheck(safe, $angle, $skew, _constrainScale);
					$sx = safe.sx;
					$sy = safe.sy;
				}
				
				MatrixTools.scaleMatrix(m, $sx, $sy, $angle, $skew);
				if ($sx < 0) {
					_flipX = !_flipX;
				}
				
				_target.transform.matrix = m;
				reposition(false);
				
				if (_scaleMode != "scaleNormal") {
					var w:Number = Math.sqrt(m.a * m.a + m.b * m.b) * _baseRect.width;
					var h:Number = Math.sqrt(m.d * m.d + m.c * m.c) * _baseRect.height;
					
					if (_targetObject is TextField) { //TextFields do some funky stuff with scaling, so we need to factor the scaleX/scaleY in here...
						w /= _targetObject.scaleX;
						h /= _targetObject.scaleY;
					}
					
					var p:Point = _targetObject.parent.globalToLocal(_proxy.localToGlobal(_offset)); //had to use _targetObject.parent instead of _proxy.parent because of another bug in Flex that prevented _proxy items from accurately reporting their parent for a few frames after being added to the display list! Since they both have the same parent, this shouldn't matter though.
					_targetObject.rotation = 0;
					_targetObject.width = w;
					_targetObject.height = h;
					_targetObject.rotation = _proxy.rotation;
					_targetObject.x = p.x;
					_targetObject.y = p.y;
				}
				
				if ($dispatchEvent && _dispatchScaleEvents && ($sx != 1 || $sy != 1)) {
					dispatchEvent(new TransformEvent(TransformEvent.SCALE, [this]));
				}
			}
		}
		
		/** @private **/
		public function scaleCheck($safe:Object, $angle:Number, $skew:Number, $forceConstrain:Boolean=false):void { //Just checks to see if the scale will hit the bounds and edits the $safe object properties to make sure it doesn't
			if (_lockScale) {
				$safe.sx = $safe.sy = 1;
			} else {
				var sx:Number, sy:Number;
				var original:Matrix = _target.transform.matrix;
				var originalScaleX:Number = MatrixTools.getScaleX(original, _flipX);
				var originalScaleY:Number = MatrixTools.getScaleY(original, _flipX);
				var originalAngle:Number = MatrixTools.getAngle(original, _flipX);
				var m:Matrix = original.clone();
				var sxMin:Number = 0;
				var syMin:Number = 0;
				var tempFlipX:Boolean = Boolean(_flipX != ($safe.sx < 0));
				
				MatrixTools.scaleMatrix(m, $safe.sx, $safe.sy, $angle, $skew);
				
				if (this.hasSizeLimits) {
					
					sx = MatrixTools.getScaleX(m, tempFlipX);
					sy = MatrixTools.getScaleY(m, tempFlipX);
					
					var b:Rectangle = this.getBounds(_target, _target);
					
					var skewDif:Number = $skew - MatrixTools.getSkew(original);
					var skewChanged:Boolean = Boolean(skewDif < -0.0001 || skewDif > 0.0001); 
					
					var sxOuterMax:Number = _maxWidth / b.width;
					var sxOuterMin:Number = -sxOuterMax;
					if (_minScaleX > sxOuterMin) {
						sxOuterMin = _minScaleX;
					}
					if (_maxScaleX < sxOuterMax) {
						sxOuterMax = _maxScaleX;
					}
					var sxInnerMax:Number = _minWidth / b.width;
					var sxInnerMin:Number = -sxInnerMax;
					if (sxOuterMin > sxInnerMin && sxOuterMin < sxInnerMax) {
						sxOuterMin = sxInnerMax;
					}
					if (sxOuterMax < sxInnerMax && sxOuterMax > sxInnerMin) {
						sxOuterMax = sxInnerMin;
					}
					
					var syOuterMax:Number = _maxHeight / b.height;
					var syOuterMin:Number = -syOuterMax;
					if (_minScaleY > syOuterMin) {
						syOuterMin = _minScaleY;
					}
					if (_maxScaleY < syOuterMax) {
						syOuterMax = _maxScaleY;
					}
					var syInnerMax:Number = _minHeight / b.height;
					var syInnerMin:Number = -syInnerMax;
					if (syOuterMin > syInnerMin && syOuterMin < syInnerMax) {
						syOuterMin = syInnerMax;
					}
					if (syOuterMax < syInnerMax && syOuterMax > syInnerMin) {
						syOuterMax = syInnerMin;
					}
					
					sxMin = Math.max(Math.abs(sxInnerMin), Math.abs(sxInnerMax)) / originalScaleX;
					syMin = Math.max(Math.abs(syInnerMin), Math.abs(syInnerMax)) / originalScaleY;
					
					var changed:Boolean = false;
					if (sx < sxOuterMin) {
						$safe.sx = sxOuterMin / originalScaleX;
						changed = true;
					} else if (sx > sxOuterMax) {
						$safe.sx = sxOuterMax / originalScaleX;
						changed = true;
					} else if (sx < sxInnerMax && sx > sxInnerMin) {
						$safe.sx = (originalScaleX > sxInnerMax) ? Math.abs(sxInnerMax / originalScaleX) : Math.abs(sxInnerMin / originalScaleX);
						changed = true;
					}
					
					if (sy < syOuterMin) {
						$safe.sy = syOuterMin / originalScaleY;
						changed = true;
					} else if (sy > syOuterMax) {
						$safe.sy = syOuterMax / originalScaleY;
						changed = true;
					} else if (sy < syInnerMax && sy > syInnerMin) {
						$safe.sy = (originalScaleY > syInnerMax) ? Math.abs(syInnerMax / originalScaleY) : Math.abs(syInnerMin / originalScaleY);
						changed = true;
					}
					
					if (changed && (skewChanged || $forceConstrain)) {
						$safe.sx = $safe.sy = 1;
					} else if (_constrainScale) {
						if (Math.abs($safe.sx - 1) < Math.abs($safe.sy - 1)) {
							$safe.sy = $safe.sx;
						} else {
							$safe.sx = $safe.sy;
						}
					}
					
					m = original.clone();
					MatrixTools.scaleMatrix(m, $safe.sx, $safe.sy, $angle, $skew);
					
					tempFlipX = Boolean(_flipX != ($safe.sx < 0));
				}
				
				_target.transform.matrix = m;
				reposition(true);
				
				if (_bounds != null) {
					if (!_bounds.containsRect(this.getBounds(_target, _targetObject.parent))) {
						if ($safe.sy == 1) {
							_target.transform.matrix = original;
							iterateStretchX($safe, $angle, $skew, sxMin);
						} else if ($safe.sx == 1) {
							_target.transform.matrix = original;
							iterateStretchY($safe, $angle, $skew, syMin);
						} else {
							
							var i:int, corner:Point, cornerAngle:Number, oldLength:Number, newLength:Number, dx:Number, dy:Number;
							var minScale:Number = 1;
							var r:Rectangle = this.getBounds(_target, _target);
							var corners:Array = [new Point(r.x, r.y), new Point(r.right, r.y), new Point(r.right, r.bottom), new Point(r.x, r.bottom)]; //top left, top right, bottom right, bottom left
							for (i = corners.length - 1; i > -1; i--) {
								corner = _target.parent.globalToLocal(_target.localToGlobal(corners[i]));
								
								if (!(Math.abs(corner.x - _origin.x) < 1 && Math.abs(corner.y - _origin.y) < 1)) { //If the origin is on top of the corner (same coordinates), no need to factor it in.
									cornerAngle = TransformManager.positiveAngle(Math.atan2(corner.y - _origin.y, corner.x - _origin.x));
									dx = _origin.x - corner.x;
									dy = _origin.y - corner.y;
									oldLength = Math.sqrt(dx * dx + dy * dy);
									
									if (cornerAngle < _cornerAngleBR || (cornerAngle > _cornerAngleTR && _cornerAngleTR != 0)) { //Extends RIGHT
										dx = _bounds.right - _origin.x;
										newLength = (dx < 1 && ((_cornerAngleBR - cornerAngle < 0.01) || (cornerAngle - _cornerAngleTR < 0.01))) ? 0 : dx / Math.cos(cornerAngle); //Flash was occassionally reporting the angle slightly off when you put the object in the very bottom right corner and then scale inwards/upwards, and since the Math.sin() was so small, there were rounding errors in the decimals. This prevents the odd behavior.
									} else if (cornerAngle <= _cornerAngleBL) { //Extends DOWN
										dy = _bounds.bottom - _origin.y;
										newLength = (_cornerAngleBL - cornerAngle < 0.01) ? 0 : dy / Math.sin(cornerAngle); //Flash was occassionally reporting the angle slightly off when you put the object in the very bottom right corner and then scale inwards/upwards, and since the Math.sin() was so small, there were rounding errors in the decimals. This prevents the odd behavior.
									} else if (cornerAngle < _cornerAngleTL) { //Extends LEFT
										dx = _origin.x - _bounds.x;
										newLength = dx / Math.cos(cornerAngle);
									} else { //Extends UP
										dy = _origin.y - _bounds.y;
										newLength = dy / Math.sin(cornerAngle);
									}
									if (newLength != 0) {
										minScale = Math.min(minScale, Math.abs(newLength) / oldLength);
									}
								}
							}
							
							m = _target.transform.matrix;
							
							if (minScale == 1 || ($safe.sx < 0 && (_origin.x == _bounds.x || _origin.x == _bounds.right)) || ($safe.sy < 0 && (_origin.y == _bounds.y || _origin.y == _bounds.bottom))) {  //Otherwise if the origin was sitting directly on top of the bounds edge, you could scale right past it in a negative direction (flip)
								$safe.sx = 1;
								$safe.sy = 1;
							} else {
								$safe.sx = (MatrixTools.getScaleX(m, tempFlipX) * minScale) / MatrixTools.getScaleX(original, _flipX);
								$safe.sy = (MatrixTools.getScaleY(m, tempFlipX) * minScale) / MatrixTools.getScaleY(original, _flipX);
								if ((int($safe.sx) == 0 && Math.abs($safe.sx) < sxMin) || (int($safe.sy) == 0 && Math.abs($safe.sy) < syMin)) {
									$safe.sx = $safe.sy = 1;
								}
							}
							
						}
						
					}
				}
				_target.transform.matrix = original;
			}
		}
		
		/** @private **/
		protected function iterateStretchX($safe:Object, $angle:Number, $skew:Number, $sxMin:Number):void {
			if (_lockScale) {
				$safe.sx = $safe.sy = 1;
			} else if (_bounds != null && $safe.sx != 1) {
				if ($safe.sx < 1 && $safe.sx > 0) { //if the target scale is between 0 and 1 (reducing scale) and it overlapped with the bounds, there's no point in iterating the stretch from 1 downward because it'll always overlap!
					return;
				}
				var original:Matrix = _target.transform.matrix;
				var i:uint, loops:uint, base:Number, m:Matrix = original.clone();
				var inc:Number = ($safe.sx < 1) ? -0.01 : 0.01;
				
				if ($safe.sx > 0) {
					base = 1;
					loops = Math.abs(($safe.sx - base) / inc) + 1;
					
				} else {
					
					base = -$sxMin;
					loops = (($safe.sx - base) / inc) + 1;
					
					if (base != 0) {
						MatrixTools.scaleMatrix(m, base, 1, $angle, $skew);
						_target.transform.matrix = m;
						reposition(true);
						if (!_bounds.containsRect(this.getBounds(_target, _targetObject.parent))) {
							$safe.sx = 1;
							return;
						}
					}
				}
				
				for (i = 1; i <= loops; i++) {
					m.a = original.a; //faster than m.clone();
					m.b = original.b;
					m.c = original.c;
					m.d = original.d;
					
					MatrixTools.scaleMatrix(m, base + (i * inc), 1, $angle, $skew);
					_target.transform.matrix = m;
					reposition(true);
					if (!_bounds.containsRect(this.getBounds(_target, _targetObject.parent))) {
						$safe.sx = base + ((i - 1) * inc);
						break;
					}
				}
			}
		}
		
		
		/** @private **/
		protected function iterateStretchY($safe:Object, $angle:Number, $skew:Number, $syMin:Number):void {
			if (_lockScale) {
				$safe.sx = $safe.sy = 1;
			} else if (_bounds != null && $safe.sy != 1) {
				if ($safe.sy < 1 && $safe.sy > 0) { //if the target scale is between 0 and 1 (reducing scale) and it overlapped with the bounds, there's no point in iterating the stretch from 1 downward because it'll always overlap!
					return;
				}
				var original:Matrix = _target.transform.matrix;
				var i:uint, loops:uint, base:Number, m:Matrix = original.clone();
				var inc:Number = ($safe.sy < 1) ? -0.01 : 0.01;
				
				if ($safe.sy > 0) {
					base = 1;
					loops = Math.abs(($safe.sy - base) / inc) + 1;
				} else {
					
					base = -$syMin;
					loops = (($safe.sy - base) / inc) + 1;
					
					if (base != 0) {
						MatrixTools.scaleMatrix(m, 1, base, $angle, $skew);
						_target.transform.matrix = m;
						reposition(true);
						if (!_bounds.containsRect(this.getBounds(_target, _targetObject.parent))) {
							$safe.sy = 1;
							return;
						}
					}
				}
				
				for (i = 1; i <= loops; i++) {
					m.a = original.a; //faster than m.clone();
					m.b = original.b;
					m.c = original.c;
					m.d = original.d;
					
					MatrixTools.scaleMatrix(m, 1, base + (i * inc), $angle, $skew);
					_target.transform.matrix = m;
					reposition(true);
					if (!_bounds.containsRect(this.getBounds(_target, _targetObject.parent))) {
						$safe.sy = base + ((i - 1) * inc);
						break;
					}
				}
			}
		}
		
		/**
		 * Immediately applies bounds to the targetObject, forcing it to stay within the bounds
		 * by scaling it down (if necessary) and optionally moving it as well. If, for example, the targetObject
		 * is much larger than the bounds, it will be scaled down to fit within them. If it is positioned outside
		 * the bounds, <code>fitInsideBounds(true)</code> will move it only as much as is necessary for it to fit within
		 * the bounds. Applying bounds with <code>fitInsideBounds()</code> is <strong>NOT</strong> the same thing as 
		 * setting the <code>bounds</code> property - <code>fitInsideBounds()</code> is only temporary and does
		 * not set the TransformItem's <code>bounds</code> property. <code>fitInsideBounds()</code> will never
		 * scale an object <strong>up</strong> - it will only shrink objects and/or move them. 
		 * 
		 * @param move If <code>true</code> (the default), the targetObject's position will change if necessary in order to fit within the bounds.
		 * @param updateFirst If <code>true</code> (the default), <code>update()</code> will be called first before applying the bounds. This will ensure that any changes that were made manually to the targetObject are taken into account and that the targetObject's size/position/rotation/proportions are calibrated.
		 * @param customBounds Normally, <code>fitInsideBounds()</code> uses the TransformItem's <code>bounds</code> property, but if you'd like it to use a custom Rectangle instead, define it here. Use <code>null</code> in order to apply the TransformItem's normal bounds that were likely set through its TransformManager.
		 */
		public function fitInsideBounds(move:Boolean=true, updateFirst:Boolean=true, customBounds:Rectangle=null):void {
			if (updateFirst) {
				this.update(null);
			}
			var mBounds:Rectangle = (customBounds != null) ? customBounds : _bounds;
			if (_target.parent && mBounds != null) {
				var bounds:Rectangle = this.getBounds(_target, _targetObject.parent);
				if (!mBounds.containsRect(bounds) && bounds.width != 0) {
					var xMin:Number = (move) ? mBounds.x : bounds.x;
					var yMin:Number = (move) ? mBounds.y : bounds.y;
					
					var w:Number = Math.min(bounds.width, mBounds.width - Math.abs(xMin - mBounds.x));
					var h:Number = Math.min(bounds.height, mBounds.height - Math.abs(yMin - mBounds.y));
					
					var ratio:Number = Math.min(w / bounds.width, h / bounds.height);
					if (ratio < 0) {
						ratio = 0;
					}
					
					if (ratio < 1) {
						var prevOrigin:Point = _origin;
						this.origin = new Point(bounds.x, bounds.y);
						this.scale(ratio, ratio, 0, false, true);
						this.origin = prevOrigin;
					} else {
						ratio = 1;
					}
					
					if (move) {
						var dx:Number = 0;
						var dy:Number = 0;
						var xMax:Number = mBounds.x + (mBounds.width - (bounds.width * ratio));
						if (bounds.x > xMax) {
							dx = xMax - bounds.x;
						} else if (bounds.x < mBounds.x) {
							dx = mBounds.x - bounds.x;
						}
						var yMax:Number = mBounds.y + (mBounds.height - (bounds.height * ratio));
						if (bounds.y > yMax) {
							dy = yMax - bounds.y;
						} else if (bounds.y < mBounds.y) {
							dy = mBounds.y - bounds.y;
						}
						this.move(dx, dy, false, true);
					}
				}
			}
		}
		
		/**
		 * Sets minimum scaleX, maximum scaleX, minimum scaleY, and maximum scaleY
		 * 
		 * @param $minScaleX Minimum scaleX
		 * @param $maxScaleX Maximum scaleX
		 * @param $minScaleY Minimum scaleY
		 * @param $maxScaleY Maximum scaleY
		 */
		public function setScaleConstraints($minScaleX:Number, $maxScaleX:Number, $minScaleY:Number, $maxScaleY:Number):void {
			this.minScaleX = $minScaleX;
			this.maxScaleX = $maxScaleX;
			this.minScaleY = $minScaleY;
			this.maxScaleY = $maxScaleY;
		}


//---- ROTATE ------------------------------------------------------------------------------------------

		/**
		 * Rotates the item by a particular angle (in Radians). This is NOT an absolute value, so if one
		 * of the item's rotation property is Math.PI and you <code>rotateSelection(Math.PI)</code>, the new
		 * angle would be Math.PI &#42; 2.
		 * 
		 * @param $angle Angle (in Radians) that should be added to the selected item's current rotation
		 * @param $checkBounds If false, bounds will be ignored
		 * @param $dispatchEvent If false, no ROTATE events will be dispatched
		 */
		public function rotate($angle:Number, $checkBounds:Boolean = true, $dispatchEvent:Boolean = true):void {
			if (!_lockRotation) {
				if ($checkBounds && _bounds != null) {
					var safe:Object = {angle:$angle};
					rotateCheck(safe);
					$angle = safe.angle;
				}
				
				var m:Matrix = _targetObject.transform.matrix;
				m.rotate($angle);
				_targetObject.transform.matrix = m;
				if (_proxy != null) {
					m = _proxy.transform.matrix;
					m.rotate($angle);
					_proxy.transform.matrix = m;
				}
				reposition(false);
				
				if ($dispatchEvent && _dispatchRotateEvents && $angle != 0) {
					dispatchEvent(new TransformEvent(TransformEvent.ROTATE, [this]));
				}
			}
		}
		
		/** @private **/
		public function rotateCheck($safe:Object):void { //Just checks to see if the rotation will hit the bounds and edits the $safe.angle property to make sure it doesn't
			if (_lockRotation) {
				$safe.angle = 0;
			} else if (_bounds != null && $safe.angle != 0) {
				var originalAngle:Number = _target.rotation * _DEG2RAD;
				var original:Matrix = _target.transform.matrix;
				var m:Matrix = original.clone();
				m.rotate($safe.angle);
				_target.transform.matrix = m;
				reposition(true);
				if (!_bounds.containsRect(this.getBounds(_target, _targetObject.parent))) {
					m = original.clone();
					var inc:Number = _DEG2RAD; //1 degree increments
					if (TransformManager.acuteAngle($safe.angle) < 0) {
						inc *= -1;
					}
					for (var i:uint = 1; i < 360; i++) {
						m.rotate(inc);
						_target.transform.matrix = m;
						reposition(true);
						if (!_bounds.containsRect(this.getBounds(_target, _targetObject.parent))) {
							$safe.angle = (i - 1) * inc;
							break;
						}
					}
				}
				_target.transform.matrix = original;
			}
		}
		
		
//---- STATIC FUNCTIONS --------------------------------------------------------------------------------
		
		/** @private **/
		protected static function setDefault($value:*, $default:*):* {
			if ($value == undefined) {
				return $default;
			} else {
				return $value;
			}
		}
		
		
//---- GETTERS / SETTERS --------------------------------------------------------------------------------
		
		/** Enable or disable the TransformItem. **/
		public function get enabled():Boolean {
			return _enabled;
		}
		public function set enabled($b:Boolean):void { 
			if ($b != _enabled) {
				_enabled = $b;
				this.selected = false;
				if ($b) {
					_targetObject.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown); //note: if weak reference was used here, it occasionally wouldn't work at all.
					_targetObject.addEventListener(MouseEvent.ROLL_OVER, onRollOverItem);
					_targetObject.addEventListener(MouseEvent.ROLL_OUT, onRollOutItem);
				} else {
					_targetObject.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					_targetObject.removeEventListener(MouseEvent.ROLL_OVER, onRollOverItem);
					_targetObject.removeEventListener(MouseEvent.ROLL_OUT, onRollOutItem);
					if (_stage != null) {
						_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					}
				}
			}
		}
		
		/** x-coordinate **/
		public function get x():Number {
			return _targetObject.x;
		}
		public function set x($n:Number):void {
			move($n - _targetObject.x, 0, true, true);
		}
		
		/** y-coordinate **/
		public function get y():Number {
			return _targetObject.y;
		}
		public function set y($n:Number):void {
			move(0, $n - _targetObject.y, true, true);
		}
		
		/** The associated DisplayObject **/
		public function get targetObject():DisplayObject {
			return _targetObject;
		}
		
		/** scaleX **/
		public function get scaleX():Number {
			return MatrixTools.getScaleX(_targetObject.transform.matrix, _flipX); //_targetObject.scaleX doesn't report properly in Flex, so this is the only way to get reliable results.
		}
		public function set scaleX($n:Number):void {
			var m:Matrix = _targetObject.transform.matrix;
			scaleRotated($n / MatrixTools.getScaleX(m, _flipX), 1, _targetObject.rotation * _DEG2RAD, Math.atan2(m.c, m.d), true, true);
		}
		
		/** scaleY **/
		public function get scaleY():Number {
			return MatrixTools.getScaleY(_targetObject.transform.matrix, _flipX); //_targetObject.scaleY doesn't report properly in Flex, so this is the only way to get reliable results.
		}
		public function set scaleY($n:Number):void {
			var m:Matrix = _targetObject.transform.matrix;
			scaleRotated(1, $n / MatrixTools.getScaleY(m, _flipX), _targetObject.rotation * _DEG2RAD, Math.atan2(m.c, m.d), true, true); 
		}
		
		/** width **/
		public function get width():Number {
			if (_targetObject.parent != null) {
				return this.getBounds(_targetObject, _targetObject.parent).width;
			} else {
				var s:Sprite = new Sprite();
				s.addChild(_targetObject);
				var w:Number = this.getBounds(_targetObject, s).width;
				s.removeChild(_targetObject);
				return w;
			}
		}
		public function set width($n:Number):void {
			scale($n / this.width, 1, 0, true, true);
		}
		
		/** height **/
		public function get height():Number {
			if (_targetObject.parent != null) {
				return this.getBounds(_targetObject, _targetObject.parent).height;
			} else {
				var s:Sprite = new Sprite();
				s.addChild(_targetObject);
				var h:Number = this.getBounds(_targetObject, s).height;
				s.removeChild(_targetObject);
				return h;
			}
		}
		public function set height($n:Number):void {
			scale(1, $n / this.height, 0, true, true);
		}
		
		/** rotation **/
		public function get rotation():Number {
			return MatrixTools.getAngle(_targetObject.transform.matrix, _flipX) * _RAD2DEG; //_targetObject.rotation doesn't report properly in Flex, so this is the only way to get reliable results.
		}
		public function set rotation($n:Number):void {
			rotate(($n * _DEG2RAD) - MatrixTools.getAngle(_targetObject.transform.matrix, _flipX), true, true);
		}
		
		/** alpha **/
		public function get alpha():Number {
			return _targetObject.alpha;
		}
		public function set alpha($n:Number):void {
			_targetObject.alpha = $n;
		}
		
		/** Center point (according to the DisplayObject.parent's coordinate space **/
		public function get center():Point {
			if (_targetObject.parent != null) { //Check to make sure it wasn't removed from the DisplayList. If it was, just return the innerCenter.
				return _targetObject.parent.globalToLocal(_targetObject.localToGlobal(this.innerCenter));
			} else {
				return this.innerCenter;
			}
		}
		
		/** Center point according to the local coordinate space **/
		public function get innerCenter():Point {
			var r:Rectangle = this.getBounds(_targetObject, _targetObject);
			return new Point(r.x + r.width / 2, r.y + r.height / 2);
		}
		
		/** To constrain the item so that it only scales proportionally, set this to true [default: <code>false</code>] **/
		public function get constrainScale():Boolean {
			return _constrainScale;
		}
		public function set constrainScale($b:Boolean):void {
			_constrainScale = $b;
			var m:Matrix = _targetObject.transform.matrix;
			_constrainRatio = MatrixTools.getScaleX(m, _flipX) / MatrixTools.getScaleY(m, _flipX);
		}
		
		/** Prevents scaling **/
		public function get lockScale():Boolean {
			return _lockScale;
		}
		public function set lockScale($b:Boolean):void {
			_lockScale = $b;
		}
		
		/** Prevents rotating **/
		public function get lockRotation():Boolean {
			return _lockRotation;
		}
		public function set lockRotation($b:Boolean):void {
			_lockRotation = $b;
		}
		
		/** Prevents moving **/
		public function get lockPosition():Boolean {
			return _lockPosition;
		}
		public function set lockPosition($b:Boolean):void {
			_lockPosition = $b;
		}
		
		/** If true, when the user presses the DELETE (or BACKSPACE) key while this item is selected, it will be deleted (unless <code>hasSelectableText</code> is set to true) [default: <code>false</code>] **/
		public function get allowDelete():Boolean {
			return _allowDelete;
		}
		public function set allowDelete($b:Boolean):void {
			if ($b != _allowDelete) {
				_allowDelete = $b;
				if (_createdManager != null) {
					_createdManager.allowDelete = $b;
				}
			}
		}
		
		/** selected state of the item **/
		public function get selected():Boolean {
			return _selected;
		}
		public function set selected($b:Boolean):void {
			if ($b != _selected) {
				_selected = $b;
				if ($b) {
					if (_targetObject.parent == null) {
						return;
					}
					if (_targetObject.hasOwnProperty("setStyle")) { //focus borders get in the way of the selection box/handles.
						(_targetObject as Object).setStyle("focusThickness", 0);
					}
					if (_proxy != null) {
						calibrateProxy();
					}
					dispatchEvent(new TransformEvent(TransformEvent.SELECT, [this]));
				} else {
					this.origin = _unselectedOrigin;
					dispatchEvent(new TransformEvent(TransformEvent.DESELECT, [this]));
				}
			}
		}
		
		/** @private A Rectangle defining the boundaries for movement/scaling/rotation - this should match the bounds of the TransformItem's TransformManager instance. [default:null] **/
		public function get bounds():Rectangle {
			return _bounds;
		}
		/** @private **/
		public function set bounds($r:Rectangle):void {
			_bounds = $r;
			setCornerAngles();
			dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this])); //the TransformManager should update its constraints accordingly
		}
		
		/** Point that serves as the origin for scaling or axis of rotation **/
		public function get origin():Point {
			return _origin;
		}
		public function set origin($p:Point):void {
			if (!_selected) {
				_unselectedOrigin = $p;
			}
			_origin = $p;
			if (_proxy != null && _proxy.parent != null) {
				_localOrigin = _proxy.globalToLocal(_proxy.parent.localToGlobal($p));
			} else if (_targetObject.parent != null) {
				_localOrigin = _targetObject.globalToLocal(_targetObject.parent.localToGlobal($p));
			}
			setCornerAngles();
		}
		
		/** Maximum width (measured as if the object was unrotated). Default is Infinity. **/
		public function get maxWidth():Number {
			return _maxWidth;
		}
		public function set maxWidth(value:Number):void {
			if (value < 1) {
				_maxWidth = 1;
			} else {
				_maxWidth = value;
			}
			var m:Matrix = _targetObject.transform.matrix;
			var w:Number = this.getBounds(_targetObject, _targetObject).width * Math.sqrt(m.a * m.a + m.b * m.b);
			if (w > _maxWidth) {
				_targetObject.scaleX *= _maxWidth / w;
				if (_constrainScale) {
					_targetObject.scaleY = _targetObject.scaleX / _constrainRatio;
				}
			}
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
			}
		}
		
		/** Maximum height (measured as if the object was unrotated). Default is Infinity. **/
		public function get maxHeight():Number {
			return _maxHeight;
		}
		public function set maxHeight(value:Number):void {
			if (value < 1) {
				_maxHeight = 1;
			} else {
				_maxHeight = value;
			}
			var m:Matrix = _targetObject.transform.matrix;
			var h:Number = this.getBounds(_targetObject, _targetObject).height * Math.sqrt(m.c * m.c + m.d * m.d);
			if (h > _maxHeight) {
				_targetObject.scaleY *= _maxHeight / h;
				if (_constrainScale) {
					_targetObject.scaleX = _targetObject.scaleY * _constrainRatio;
				}
			}
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
			}
		}
		
		/** Minimum height (measured as if the object was unrotated). Default is 1 (and cannot be less than 1). **/
		public function get minHeight():Number {
			return _minHeight;
		}
		public function set minHeight(value:Number):void {
			if (value < 1) {
				_minHeight = 1;
			} else {
				_minHeight = value;
			}
			var m:Matrix = _targetObject.transform.matrix;
			var h:Number = this.getBounds(_targetObject, _targetObject).height * Math.sqrt(m.c * m.c + m.d * m.d);
			if (h < _minHeight && h != 0) {
				_targetObject.scaleY *= _minHeight / h;
				if (_constrainScale) {
					_targetObject.scaleX = _targetObject.scaleY * _constrainRatio;
				}
			}
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
			}
		}
		
		/** Minimum width (measured as if the object was unrotated). Default is 1 (and cannot be less than 1). **/
		public function get minWidth():Number {
			return _minWidth;
		}
		public function set minWidth(value:Number):void {
			if (value < 1) {
				_minWidth = 1;
			} else {
				_minWidth = value;
			}
			var m:Matrix = _targetObject.transform.matrix;
			var w:Number = this.getBounds(_targetObject, _targetObject).width * Math.sqrt(m.a * m.a + m.b * m.b);
			if (w < _minWidth && w != 0) {
				_targetObject.scaleX *= _minWidth / w;
				if (_constrainScale) {
					_targetObject.scaleY = _targetObject.scaleX / _constrainRatio;
				}
			}
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
			}
		}
		
		/** Minimum scaleX **/
		public function get minScaleX():Number {
			return _minScaleX;
		}
		public function set minScaleX($n:Number):void {
			if ($n == 0) {
				$n = this.getBounds(_targetObject, _targetObject).width || 500;
				_minScaleX = 1 / $n; //don't let it scale smaller than 1 pixel.
			} else {
				_minScaleX = $n;
			}
			if (_targetObject.scaleX < _minScaleX) {
				_targetObject.scaleX = _minScaleX;
				if (_constrainScale) {
					_targetObject.scaleY = _targetObject.scaleX / _constrainRatio;
				}
			}
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
			}
		}
		
		/** Minimum scaleY **/
		public function get minScaleY():Number {
			return _minScaleY;
		}
		public function set minScaleY($n:Number):void {
			if ($n == 0) {
				$n = this.getBounds(_targetObject, _targetObject).height || 500;
				_minScaleY = 1 / $n; //don't let it scale smaller than 1 pixel.
			} else {
				_minScaleY = $n;
			}
			if (_targetObject.scaleY < _minScaleY) {
				_targetObject.scaleY = _minScaleY;
				if (_constrainScale) {
					_targetObject.scaleX = _targetObject.scaleY * _constrainRatio;
				}
			}
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
			}
		}
		
		/** Maximum scaleX **/
		public function get maxScaleX():Number {
			return _maxScaleX;
		}
		public function set maxScaleX($n:Number):void {
			if ($n == 0) {
				$n = this.getBounds(_targetObject, _targetObject).width || 0.005;
				_maxScaleX = 0 - (1 / $n); //don't let it scale smaller than 1 pixel.
			} else {
				_maxScaleX = $n;
			}
			if (_targetObject.scaleX > _maxScaleX) {
				_targetObject.scaleX = _maxScaleX;
				if (_constrainScale) {
					_targetObject.scaleY = _targetObject.scaleX / _constrainRatio;
				}
			}
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
			}
		}
		
		/** Maximum scaleY **/
		public function get maxScaleY():Number {
			return _maxScaleY;
		}
		public function set maxScaleY($n:Number):void {
			if ($n == 0) {
				$n = this.getBounds(_targetObject, _targetObject).height || 0.005;
				_maxScaleY = 0 - (1 / $n); //don't let it scale smaller than 1 pixel.
			} else {
				_maxScaleY = $n;
			}
			if (_targetObject.scaleY > _maxScaleY) {
				_targetObject.scaleY = _maxScaleY;
				if (_constrainScale) {
					_targetObject.scaleX = _targetObject.scaleY * _constrainRatio;
				}
			}
			if (_selected) {
				dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [this]));
			}
		}
		
		/** Maximum scale (affects both the maxScaleX and maxScaleY properties) **/
		public function set maxScale($n:Number):void {
			this.maxScaleX = this.maxScaleY = $n;
		}
		
		/** Minimum scale (affects both the minScaleX and minScaleY properties) **/
		public function set minScale($n:Number):void {
			this.minScaleX = this.minScaleY = $n;
		}
		
		/** Reflects whether or not minScaleX, maxScaleX, minScaleY, or maxScaleY have been set. **/
		public function get hasSizeLimits():Boolean {
			return (_minScaleX != -Infinity || _minScaleY != -Infinity || _maxScaleX != Infinity || _maxScaleY != Infinity || _minWidth != 1 || _minHeight != 1 || _maxWidth != Infinity || _maxHeight != Infinity);
		}
		
		/** Either <code>TransformManager.SCALE_NORMAL</code> for normal scaleX/scaleY scaling or <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code> if you prefer that TransformManager alters the <code>width</code>/<code>height</code> properties instead. **/
		public function get scaleMode():String {
			return _scaleMode;
		}
		public function set scaleMode($s:String):void {
			_scaleMode = $s;
			if ($s != TransformManager.SCALE_NORMAL) {
				createProxy();
			} else {
				removeProxy();
			}
		}
		
		/** If true, this prevents dragging of the object unless clicking on the edges/border or center handle, and allows the DELETE key to be pressed without deleting the object itself. It will also force the scaleMode to <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code>. **/
		public function get hasSelectableText():Boolean {
			return _hasSelectableText;
		}
		public function set hasSelectableText($b:Boolean):void {
			_hasSelectableText = $b;
			if ($b) {
				this.scaleMode = TransformManager.SCALE_WIDTH_AND_HEIGHT;
				this.allowDelete = false;
			}
		}
		
		/** The TransformManager instance to which the TransformItem belongs [read-only] **/
		public function get manager():TransformManager {
			return _manager;
		}
		
	}
	
}