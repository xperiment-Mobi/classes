﻿/**
 * VERSION: 1.9669
 * DATE: 2013-01-12
 * AS3 
 * UPDATES AND DOCS AT: http://www.greensock.com/transformmanageras3/
 **/
package com.greensock.transform {
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.utils.MatrixTools;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
/**
 * TransformManager makes it easy to add interactive scaling/rotating/moving of DisplayObjects to your Flash 
 * or Flex application. It uses an intuitive interface that's similar to most modern drawing applications. 
 * When the user clicks on a managed DisplayObject, a selection box will be drawn around it along with 8 handles 
 * for scaling/rotating. When the mouse is placed just outside of any of the scaling handles, the cursor will 
 * change to indicate that they're in rotation mode. Just like most other applications, the user can hold down 
 * the SHIFT key to select multiple items, to constrain scaling proportions, or to limit the rotation to 
 * 45 degree increments.
 * 
 * <p><b>FEATURES INCLUDE:</b>
 * <ul>
 *	 <li> Select multiple items and scale/rotate/move them all simultaneously. </li>
 *	 <li> Includes a <code>FlexTransformManager</code> class that makes it simple to integrate into Flex applications.</li>
 *	 <li> Perform virtually any action (transformations, selections, etc.) through code.</li>
 *	 <li> Depth management which allows you to programmatically push the selected items forward or backward in the stacking order</li>
 *	 <li> Set minScaleX, maxScaleX, minScaleY, and maxScaleY properties and/or minWidth, maxWidth, minHeight, and maxHeight on each item </li>
 *	 <li> Arrow keys move the selection </li>
 *	 <li> You can set the scaleMode of any TransformItem to SCALE_WIDTH_AND_HEIGHT so that the width/height properties are altered instead of scaleX/scaleY. This can be helpful for text-related components because altering the width/height changes only the container's dimensions while retaining the text's size.</li>
 *	 <li> There is a 10-pixel wide draggable edge around around the border that users can drag. This is particularly helpful with TextFields/TextAreas.</li>
 *	 <li> Define bounds within which the DisplayObjects must stay, and TransformManager will not let the user scale/rotate/move them beyond those bounds</li>
 *	 <li> Automatically bring the selected item(s) to the front in the stacking order </li>
 *	 <li> The DELETE and BACKSPACE keys can be used to delete the selected DisplayObjects </li>
 *	 <li> Lock certain kinds of transformations like rotation, scale, and/or movement </li>
 *	 <li> Lock the proportions of the DisplayObjects so that users cannot distort them when scaling</li>
 *	 <li> Scale from the DisplayObject's center or from its corners</li>
 *	 <li> Listen for Events like SCALE, MOVE, ROTATE, SELECTION_CHANGE, DEPTH_CHANGE, CLICK_OFF, START_INTERACTIVE_MOVE, START_INTERACTIVE_SCALE, START_INTERACTIVE_ROTATE, FINISH_INTERACTIVE_MOVE, FINISH_INTERACTIVE_SCALE, FINISH_INTERACTIVE_ROTATE, DOUBLE_CLICK, SEIZE_CURSOR, RELEASE_CURSOR, and DESTROY </li>
 *	 <li> Set the selection box line color and handle thickness</li>
 *	 <li> Cursor will automatically change to indicate scale or rotation mode</li>
 *	 <li> Customize the the move, scale, and/or rotation cursors and their behavior (like whether or not they replace the mouse, how far they're offset from the mouse position, whether or not they automatically rotate based on the mouse's position and define custom Shapes)</li>
 * 	 <li> Optionally hide the center handle</li>
 * 	 <li> Export transformational data for each item's scale, rotation, and position as well as the TranformManager's settings in XML format so that you can easily save it to a database (or wherever). Then apply it anytime to revert objects to a particular state.</li>
 *	 <li> VERY easy to use. In fact, all it takes is one line of code to get it up and running with the default settings. </li>
 * </ul>
 * </p>
 * 
 * <p><b>NOTES / LIMITATIONS</b>:
 * <ul>
 * 		<li> All DisplayObjects that are managed by a particular TransformManager instance must have the same parent (you can create multiple TransformManager instances if you want)</li>
 * 		<li> TextFields cannot be flipped (have negative scales).</li>
 * 		<li> TextFields cannot be skewed. Therefore, when a TextField is part of a multi-selection, scaling will be disabled because it could skew the TextField (imagine if a TextField is at a 45 degree angle, and then you selected another item and scaled vertically - your TextField would end up getting skewed).</li>
 * 		<li> Due to several bugs in the Flex framework (acknowledged by Adobe), TransformManager doesn't work quite as expected inside Flex containers, but I created a FlexTransformManager class that helps avoid the limitations. However, you still cannot scale TextFields disproportionately.</li>
 * 		<li> Due to a limitation in the way Flash reports bounds, items that are extremely close or exactly on top of a boundary (if you define bounds) will be moved about 0.1 pixel away from the boundary when you select them. If an item fills the width and/or height of the bounds, it will be scaled down very slightly (about 0.2 pixels total) to move it away from the bounds and allow accurate collision detection.</li>
 * </ul></p>
 * 
 * <p><b>USAGE</b></p>
 * 
 * <p>The first (and only) parameter in the constructor should be an object with any number of properties. 
 * This makes it easier to set only the properties that shouldn't use their default values (you'll 
 * probably find that most of the time the default values work well for you). It also makes the code 
 * easier to read. The properties can be in any order, like so:</p><p><code>
 * 
 * 		var manager:TransformManager = new TransformManager({targetObjects:[mc1, mc2], forceSelectionToFront:true, bounds:new Rectangle(0, 0, 550, 450), allowDelete:true});</code></p>
 * 
 * <p>All TransformEvents have an "items" property which is an Array populated by the affected TransformItem instances. TransformEvents also have a "mouseEvent" property that will be populated if there was an associted MouseEvent (like CLICK_OFF)</p>
 * 
 * <p><b>EXAMPLES:</b></p>
 * 
 * <p>To make two MovieClips (mc1 and mc2) transformable using the default settings:</p>
 * 
<listing version="3.0">
import com.greensock.transform.TransformManager;

var manager:TransformManager = new TransformManager({targetObjects:[mc1, mc2]});
</listing>
 * 		
 * <p>To make the two MovieClips transformable, constrain their scaling to be proportional (even if the user is not holding
 * down the shift key), call the onScale function everytime one of the objects is scaled, lock the rotation value of each 
 * MovieClip (preventing rotation), and allow the delete key to appear to delete the selected MovieClip from the stage:</p>
<listing version="3.0">
import com.greensock.transform.TransformManager;
import com.greensock.events.TransformEvent;

var manager:TransformManager = new TransformManager({targetObjects:[mc1, mc2], constrainScale:true, lockRotation:true, allowDelete:true, autoDeselect:true});
manager.addEventListener(TransformEvent.SCALE, onScale);
function onScale(event:TransformEvent):void {
	trace("Scaled " + event.items.length + " items");
}
</listing>
 * 		
 * <p>To add mc1 and mc2 and myText after a TransformManager has been created, and then listen for when only mc1 is selected:</p>
<listing version="3.0">
import com.greensock.transform.TransformManager;
import com.greensock.transform.TransformItem;
import com.greensock.events.TransformEvent;

var manager:TransformManager = new TransformManager();
	
var mc1Item:TransformItem = manager.addItem(mc1);
var mc2Item:TransformItem = manager.addItem(mc2);
var myTextItem:TransformItem = manager.addItem(myText, TransformManager.SCALE_WIDTH_AND_HEIGHT, true);
	
mc1Item.addEventListener(TransformEvent.SELECT, onSelectClip1);

function onSelectClip1(event:TransformEvent):void {
	trace("selected mc1");
}
</listing>
 *  
 * <p><b>A note about using fl.controls.~~ Flash components like TextArea and TextInput:</b> Due to the fact that 
 * these components have certain inconsistencies and quirks, by default they will act slightly strange with
 * TransformManager (selection box will appear off by about 2 pixels in each direction and the text will scale). 
 * However, it is relatively easy to work around these issues by changing their style's "focusRectPadding" 
 * and adding a RENDER event listener that calls drawFocus(false) on your TextArea/TextInput instance like this:</p>
<listing version="3.0">
//add a TextArea instance ("textArea") to the TransformManager instance ("manager")
var item:TransformItem = manager.addItem(textArea);

//set hasSelectableText to true so that its width/height are altered rather than scaleX/scaleY and the custom cursors don't interfere when hovering
item.hasSelectableText = true;

//focusRectPadding must be 0 to eliminate the offset
textArea.setStyle("focusRectPadding", 0);

//listen for the textArea's RENDER event and call drawFocus() in order to work around a problem with the components that can leave an odd focus rectangle in place after scaling
textArea.addEventListener(Event.RENDER, fixFocusRect);
function fixFocusRect(event:Event):void {
	event.target.drawFocus(false);
}
</listing>
 * 
 * <p>TransformManager attempts to automatically determine whether or not it is being used inside of 
 * a Flex app (which means it must use UIComponents and make a few other accommodations), but if you want to force
 * TransformManager into Flex mode (or not), simply define the <code>flexMode</code> special property in the vars
 * object like <code>var manager:TransformManager = new TransformManager({flexMode:false});</code> (added in version 1.955)</p>
 * 
 * <p><b>Copyright 2007-2013, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/eula.html">http://www.greensock.com/eula.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.</p>
 * 
 * @author Jack Doyle, jack@greensock.com
 */
	public class TransformManager extends EventDispatcher {
		/** @private **/
		public static const VERSION:Number = 1.9669;
		/** Normal scale mode **/
		public static const SCALE_NORMAL:String = "scaleNormal";
		/** Scale only <code>width</code> and <code>height</code> properties **/
		public static const SCALE_WIDTH_AND_HEIGHT:String = "scaleWidthAndHeight";
		/** @private precomputation for speed **/
		private static const _DEG2RAD:Number = Math.PI / 180; 
		/** @private precomputation for speed **/
		private static const _RAD2DEG:Number = 180 / Math.PI;
		/** @private can be scaleCursor or rotationCursor **/
		private static var _currentCursor:CustomCursor; 
        /** @private the TransformManager instance that called swapCursorIn() most recently (we need to track this for cases where multiple instances exist - it's possible for a swapCursorOut() to be called by the one releasing control after the swapCursorIn() is called by the one gaining control. **/
		private static var _cursorManager:TransformManager; 
        /** @private stores key codes of pressed keys **/
		private static var _keysDown:Object; 
        /** @private a Dictionary that gives us a way to look up the stages that have had listeners added to them (to accommodate multi-window AIR apps) **/
		private static var _keyListenerInits:Dictionary = new Dictionary();
		/** @private **/
		private static var _keyDispatcher:EventDispatcher = new EventDispatcher();
		/** @private **/
		private static var _tempDeselectedItem:TransformItem;
		/** @private **/
		private static var _scaleCursor:CustomCursor;
		/** @private **/
		private static var _rotationCursor:CustomCursor;
		/** @private **/
		private static var _moveCursor:CustomCursor;
		
		/** @private **/
		private static var _handleOrientationsNormal:Object = {center:0, top:1, right:2, bottom:3, left:4, topLeft:5, topRight:6, bottomRight:7, bottomLeft:8};
		/** @private **/
		private static var _handleOrientationsFlipped:Object = {center:0, top:1, right:4, bottom:3, left:2, topLeft:6, topRight:5, bottomRight:8, bottomLeft:7};

		
		/** @private If true, we'll delete a TransformItem's MovieClip when it's selected and the user hits the Delete key. **/
		private var _allowDelete:Boolean; 
		/** @private **/
		private var _allowMultiSelect:Boolean; 
		/** @private **/
		private var _hideCenterHandle:Boolean;
		/** @private if true, whenever you select an item, it will be ADDED to the selection instead of replacing it.**/
		private var _multiSelectMode:Boolean; 
		/** @private used to prevent unnecessary actions when this TransformManager is causing TransformItem events to get dispatched, like when selecting/deselecting multiple items or rotating/scaling/moving **/
		private var _ignoreEvents:Boolean; 
		/** @private If true (and it's true by default), TransformItems will be deselected when the user clicks off of them. Disabling this is sometimes necessary in cases where you want the user to be able to select a MovieClip and then select/edit separate form fields without deselecting the MovieClip. In that case, you'll need to handle things in a custom way through your _eventHandler (look for action_str == "deselect" which will still get fired when the user clicks off of it)**/
		private var _autoDeselect:Boolean; 
		/** @private If true, only proportional scaling is allowed (even if the SHIFT key isn't held down).**/
		private var _constrainScale:Boolean; 
		/** @private **/
		private var _lockScale:Boolean;
		/** @private **/
		private var _scaleFromCenter:Boolean;
		/** @private **/
		private var _lockRotation:Boolean;
		/** @private **/
		private var _lockPosition:Boolean;
		/** @private **/
		private var _arrowKeysMove:Boolean;
		/** @private reflects info about the selection. If any selected items have contrainScale set to true, this will be true.**/
		private var _selConstrainScale:Boolean; 
		/** @private reflects info about the selection. If any selected items have lockScale set to true, this will be true.**/
		private var _selLockScale:Boolean; 
		/** @private reflects info about the selection. If any selected items have loclRotation set to true, this will be true.**/
		private var _selLockRotation:Boolean; 
		/** @private reflects info about the selection. If any selected items have lockPosition set to true, this will be true.**/
		private var _selLockPosition:Boolean; 
		/** @private **/
		private var _selHasTextFields:Boolean; 
		/** @private if any of the items in the selection have scale limits (minScaleX, maxScaleX, minScaleY, maxScaleY), this should be true.**/
		private var _selHasSizeLimits:Boolean; 
		/** @private Minimum common bounds among selected items **/
		private var _selMinBounds:Rectangle;
		/** @private Maximum common bounds among selected items **/
		private var _selMaxBounds:Rectangle;
		/** @private **/
		private var _lineColor:uint;
		/** @private **/
		private var _lineThickness:Number;
		/** @private **/
		private var _handleColor:uint;
		/** @private **/
		private var _handleSize:Number;
		/** @private **/
		private var _paddingForRotation:Number;
		/** @private **/
		private var _selectedItems:Array;
		/** @private **/
		private var _forceSelectionToFront:Boolean;
		/** @private Holds references to all TransformItems that this TransformManager can control (use addItem() to add DisplayObjects)**/
		private var _items:Array; 
		/** @private ignore clicks on the DisplayObjects in this list (like form elements, etc.)**/
		private var _ignoredObjects:Array; 
		/** @private Set this value to false if you want to disable all TransformItems. Setting it to true will enable them all.**/
		private var _enabled:Boolean; 
		/** @private Defines an area that the items are restrained to (according to their parent coordinate system)**/
		private var _bounds:Rectangle; 
		/** @private **/
		private var _selection:Sprite;
		/** @private Invisible - mirrors the transformations of the overall selection. We use this to pin the handles in the right spots.**/
		private var _dummyBox:Sprite;
		/** @private **/
		private var _handles:Array;
		/** @private To make lookups faster on cursor rollovers. **/
		private var _handlesDict:Dictionary; 
		/** @private the parent of the items (they all must share the same parent!)**/
		private var _parent:DisplayObjectContainer; 
		/** @private **/
		private var _stage:Stage;
		/** @private acts like a registration point for transformations**/
		private var _origin:Point; 
		/** @private stores various data about the selection during transformations**/
		private var _trackingInfo:Object; 
		/** @private Only true after at least one item is added (which gives us a way to get to the stage and set up listeners)**/
		private var _initted:Boolean; 
		/** @private **/
		private var _isFlex:Boolean;
		/** @private **/
		private var _edges:Sprite;
		/** @private **/
		private var _lockCursor:Boolean;
		/** @private **/
		private var _onUnlock:Function;
		/** @private **/
		private var _onUnlockParam:Event;
		/** @private **/
		private var _dispatchScaleEvents:Boolean;
		/** @private **/
		private var _dispatchMoveEvents:Boolean;
		/** @private **/
		private var _dispatchRotateEvents:Boolean;
		/** @private while an interactive scale/move/rotation is in progress, this is true.**/
		private var _isTransforming:Boolean; 
		/** @private **/
		private var _prevScaleX:Number = 0;
		/** @private **/
		private var _prevScaleY:Number = 0;
		/** @private **/
		private var _lockOrigin:Boolean;
		/** @private **/
		private var _lastClickTime:uint = 0;
		/** @private **/
		private var _lastClickEvent:MouseEvent;
		/** @private indicates whether or not scaleX has been set to a negative value (Flex/Flash don't always maintain it properly). **/
		private var _flipX:Boolean;
		/** @private **/
		private var _selectionElements:Array = [];
		/** @private **/
		public var vars:Object;

		/**
		 * Constructor
		 * 
		 * @param $vars An object specifying any properties that should be set upon instantiation, like <code>{items:[mc1, mc2], lockRotation:true, bounds:new Rectangle(0, 0, 500, 300)}</code>.
		 */
		public function TransformManager($vars:Object = null) {
			if (TransformItem.VERSION < 1.965) {
				throw new Error("TransformManager Error: You have an outdated TransformManager-related class file. You may need to clear your ASO files. Please make sure you're using the latest version of TransformManager and TransformItem, available from www.greensock.com.");
			}
			init($vars);
		}
		
		/** @private **/
		protected function init($vars:Object):void {
			this.vars = $vars || {};
			_allowDelete = setDefault(this.vars.allowDelete, false);
			_allowMultiSelect = setDefault(this.vars.allowMultiSelect, true);
			_autoDeselect = setDefault(this.vars.autoDeselect, true);
			_constrainScale = setDefault(this.vars.constrainScale, false);
			_lockScale = setDefault(this.vars.lockScale, false);
			_scaleFromCenter = setDefault(this.vars.scaleFromCenter, false);
			_lockRotation = setDefault(this.vars.lockRotation, false);
			_lockPosition = setDefault(this.vars.lockPosition, false);
			_arrowKeysMove = setDefault(this.vars.arrowKeysMove, false);
			_forceSelectionToFront = setDefault(this.vars.forceSelectionToFront, true);
			_lineColor = setDefault(this.vars.lineColor, 0x3399FF); //Line color (including handles and selection around MovieClip)
			_lineThickness = setDefault(this.vars.lineThickness, 1);
			_handleColor = setDefault(this.vars.handleFillColor, 0xFFFFFF); //Handle fill color
			_handleSize = setDefault(this.vars.handleSize, 8); //Number of pixels the handles should be (square)
			_paddingForRotation = setDefault(this.vars.paddingForRotation, 12); //Number of pixels beyond the handles that should be sensitive for rotating.
			_hideCenterHandle = setDefault(this.vars.hideCenterHandle, false);
			_multiSelectMode = _ignoreEvents = false;
			_bounds = this.vars.bounds;
			_enabled = true;
			_keyDispatcher.addEventListener("pressDelete", onPressDelete, false, 0, true);
			_keyDispatcher.addEventListener("pressArrowKey", onPressArrowKey, false, 0, true);
			_keyDispatcher.addEventListener("pressMultiSelectKey", onPressMultiSelectKey, false, 0, true);
			_keyDispatcher.addEventListener("releaseMultiSelectKey", onReleaseMultiSelectKey, false, 0, true);
			_items = this.vars.items || [];
			_selectedItems = [];
			
			this.ignoredObjects = this.vars.ignoredObjects || [];
			_handles = [];
			_handlesDict = new Dictionary();
			if (this.vars.targetObjects != undefined) {
				addItems(this.vars.targetObjects);
			}
		}
		
		/** @private **/
		protected function initParent($parent:DisplayObjectContainer):void {
			if (!_initted && _parent == null) {
				if ("flexMode" in this.vars) {
					_isFlex = Boolean(this.vars.flexMode);
				} else {
					try {
						_isFlex = Boolean(getDefinitionByName("mx.managers.SystemManager")); // SystemManager is the first display class created within a Flex application
					} catch ($e:Error) {
						_isFlex = false;
					}
					if (_isFlex && !($parent is (getDefinitionByName("mx.core.UIComponent") as Class))) {
						_isFlex = false;
					}
				}
				_parent = $parent;
				for (var i:int = _items.length - 1; i > -1; i--) {
					_items[i].targetObject.removeEventListener(Event.ADDED_TO_STAGE, onTargetAddedToStage);
				}
				if (_parent.stage == null) {
					_parent.addEventListener(Event.ADDED_TO_STAGE, initStage, false, 0, true); //Sometimes in Flex, the parent hasn't been added to the stage yet, so we need to wait so that we can access the stage.
				} else {
					initStage();
				}
			}
		}
		
		/** @private **/
		protected function onTargetAddedToStage($e:Event):void {
			initParent($e.target.parent);
		}
		
		/** @private **/
		protected function initStage($e:Event=null):void {
			_parent.removeEventListener(Event.ADDED_TO_STAGE, initStage);
			_stage = _parent.stage;
			initKeyListeners(_stage);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, checkForDeselect, false, 0, true);
			_stage.addEventListener(Event.DEACTIVATE, onReleaseMultiSelectKey, false, 0, true); //otherwise, if the user has the SHIFT key down and they click on another window and then release the key and then click back on this window, it could get stuck in multiselect mode.
			initSelection();
			
			if (_moveCursor == null) {
				customizeMoveCursor(null, true, 0, 0);
			}
			if (_scaleCursor == null) {
				customizeScaleCursor(null, true, 0, 0);
			}
			if (_rotationCursor == null) {
				customizeRotationCursor(null, true, 0, 0);
			}
			_initted = true;
			
			if (_selectedItems.length != 0) {
				if (_forceSelectionToFront) {
					for (var i:int = _selectedItems.length - 1; i > -1; i--) {
						bringToFront(_selectedItems[i].targetObject);
					}
				}
				calibrateConstraints();
				updateSelection();
			}
		}
		
		/**
		 * In order for a DisplayObject to be managed by TransformManger, it must first be added via <code>addItem()</code>. When the
		 * DisplayObject is added, a TransformItem instance is automatically created and associated with the DisplayObject. 
		 * If you need to set item-specific settings like minScaleX, maxScaleX, etc., you would set those via the TransformItem 
		 * instance. <code>addItem()</code> returns a TransformItem instance, but you can retrieve it anytime with the <code>getItem()</code>
		 * method (just pass it your DisplayObject, like <code>var myItem:TransformItem = myManager.getItem(myDisplayObject)</code>
		 * 
		 * <p>NOTE: If your targetObject isn't an InteractiveObject, it will not receive MouseEvents like clicks and rollovers that trigger
		 * selection, dragging, cursor changes, etc. so user interaction-based actions won't be possible. That may be perfectly 
		 * acceptable, though, if you're going to do transformations directly via code.</p>
		 * 
		 * @param $targetObject The DisplayObject to be managed
		 * @param $scaleMode Either <code>TransformManager.SCALE_NORMAL</code> for normal scaleX/scaleY scaling or <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code> if you prefer that TransformManager alters the <code>width</code>/<code>height</code> properties instead.
		 * @param $hasSelectableText If true, this prevents dragging of the object unless clicking on the edges/border or center handle, and allows the DELETE key to be pressed without deleting the object itself. It will also force the scaleMode to <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code>.
		 * @return TransformItem instance
		 */
		public function addItem($targetObject:DisplayObject, $scaleMode:String="scaleNormal", $hasSelectableText:Boolean=false):TransformItem {
			if ($targetObject == _dummyBox || $targetObject == _selection) {
				return null;
			}
			var props:Array = ["constrainScale", "scaleFromCenter", "lockScale", "lockRotation", "lockPosition", "autoDeselect", "allowDelete", "bounds", "enabled", "forceSelectionToFront"];
			var newVars:Object = {manager:this};
			for (var i:uint = 0; i < props.length; i++) {
				newVars[props[i]] = this[props[i]];
			}
			var existingItem:TransformItem = getItem($targetObject); //Just in case it's already in the _items Array
			if (existingItem != null) {
				existingItem.update(null);
				return existingItem;
			}
			if ("flexMode" in this.vars) {
				newVars.flexMode = this.vars.flexMode;
			}
			newVars.scaleMode = ($targetObject is TextField) ? SCALE_WIDTH_AND_HEIGHT : $scaleMode;
			newVars.hasSelectableText = ($targetObject is TextField) ? true : $hasSelectableText;
			var newItem:TransformItem = newItem = new TransformItem($targetObject, newVars);
			newItem.addEventListener(TransformEvent.SELECT, onSelectItem);
			newItem.addEventListener(TransformEvent.DESELECT, onDeselectItem);
			newItem.addEventListener(TransformEvent.MOUSE_DOWN, onMouseDownItem);
			newItem.addEventListener(TransformEvent.SELECT_MOUSE_DOWN, onPressMove);
			newItem.addEventListener(TransformEvent.SELECT_MOUSE_UP, onReleaseMove);
			newItem.addEventListener(TransformEvent.UPDATE, onUpdateItem);
			newItem.addEventListener(TransformEvent.SCALE, onUpdateItem);
			newItem.addEventListener(TransformEvent.ROTATE, onUpdateItem);
			newItem.addEventListener(TransformEvent.MOVE, onUpdateItem);
			newItem.addEventListener(TransformEvent.ROLL_OVER_SELECTED, onRollOverSelectedItem);
			newItem.addEventListener(TransformEvent.ROLL_OUT_SELECTED, onRollOutSelectedItem);
			newItem.addEventListener(TransformEvent.DESTROY, onDestroyItem);
			
			_items.push(newItem);
			if (!_initted) {
				if ($targetObject.parent == null) {
					$targetObject.addEventListener(Event.ADDED_TO_STAGE, onTargetAddedToStage, false, 0, true);
				} else {
					initParent($targetObject.parent);
				}
			}
			return newItem;
		}
		
		/**
		 * Same as addItem() but accepts an Array containing multiple DisplayObjects.
		 * 
		 * @param $targetObjects An Array of DisplayObject to be managed
		 * @param $scaleMode Either <code>TransformManager.SCALE_NORMAL</code> for normal scaleX/scaleY scaling or <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code> if you prefer that TransformManager alters the <code>width</code>/<code>height</code> properties instead.
		 * @param $hasSelectableText If true, this prevents dragging of the objects unless clicking on the edges/border or center handle, and allows the DELETE key to be pressed without deleting the object itself. It will also force the scaleMode to <code>TransformManager.SCALE_WIDTH_AND_HEIGHT</code>.
		 * @return An Array of corresponding TransformItems that are created
		 */
		public function addItems($targetObjects:Array, $scaleMode:String="scaleNormal", $hasSelectableText:Boolean=false):Array { 
			var a:Array = [];
			for (var i:uint = 0; i < $targetObjects.length; i++) {
				a.push(addItem($targetObjects[i], $scaleMode, $hasSelectableText));
			}
			return a;
		}
		
		/**
		 * Removes an item. Calling this on an item will NOT delete the DisplayObject - it just prevents it from being affected by this TransformManager anymore.
		 * 
		 * @param $item Either the DisplayObject or the associated TransformItem that should be removed
		 */
		public function removeItem($item:*):void {
			var item:TransformItem = findObject($item);
			if (item != null) {
				item.selected = false;
				item.removeEventListener(TransformEvent.SELECT, onSelectItem);
				item.removeEventListener(TransformEvent.DESELECT, onDeselectItem);
				item.removeEventListener(TransformEvent.MOUSE_DOWN, onMouseDownItem);
				item.removeEventListener(TransformEvent.SELECT_MOUSE_DOWN, onPressMove);
				item.removeEventListener(TransformEvent.SELECT_MOUSE_UP, onReleaseMove);
				item.removeEventListener(TransformEvent.UPDATE, onUpdateItem);
				item.removeEventListener(TransformEvent.SCALE, onUpdateItem);
				item.removeEventListener(TransformEvent.ROTATE, onUpdateItem);
				item.removeEventListener(TransformEvent.MOVE, onUpdateItem);
				item.removeEventListener(TransformEvent.ROLL_OVER_SELECTED, onRollOverSelectedItem);
				item.removeEventListener(TransformEvent.ROLL_OUT_SELECTED, onRollOutSelectedItem);
				item.removeEventListener(TransformEvent.DESTROY, onDestroyItem);
				for (var i:int = _items.length - 1; i > -1; i--) {
					if (item == _items[i]) {
						_items.splice(i, 1);
						item.destroy();
						break;
					}
				}
			}
		}
		
		/** Removes all items from the TransformManager instance. This does NOT delete the items - it just prevents them from being affected by this TransformManager anymore. **/
		public function removeAllItems():void {
			var item:TransformItem;
			for (var i:int = _items.length - 1; i > -1; i--) {
				item = _items[i];
				item.selected = false;
				item.removeEventListener(TransformEvent.SELECT, onSelectItem);
				item.removeEventListener(TransformEvent.DESELECT, onDeselectItem);
				item.removeEventListener(TransformEvent.MOUSE_DOWN, onMouseDownItem);
				item.removeEventListener(TransformEvent.SELECT_MOUSE_DOWN, onPressMove);
				item.removeEventListener(TransformEvent.SELECT_MOUSE_UP, onReleaseMove);
				item.removeEventListener(TransformEvent.UPDATE, onUpdateItem);
				item.removeEventListener(TransformEvent.SCALE, onUpdateItem);
				item.removeEventListener(TransformEvent.ROTATE, onUpdateItem);
				item.removeEventListener(TransformEvent.MOVE, onUpdateItem);
				item.removeEventListener(TransformEvent.ROLL_OVER_SELECTED, onRollOverSelectedItem);
				item.removeEventListener(TransformEvent.ROLL_OUT_SELECTED, onRollOutSelectedItem);
				item.removeEventListener(TransformEvent.DESTROY, onDestroyItem);
				_items.splice(i, 1);
				item.destroy();
			}
		}
		
		/**
		 * Allows you to have TransformManager ignore clicks on a particular DisplayObject (handy for buttons, color pickers, etc.). The DisplayObject CANNOT be a child of a targetObject
		 * 
		 * @param $object DisplayObject that should be ignored
		 */
		public function addIgnoredObject($object:DisplayObject):void {
			for (var i:uint = 0; i < _ignoredObjects.length; i++) { //first make sure it's not already in the Array
				if (_ignoredObjects[i] == $object) {
					return;
				}
			}
			removeItem($object);
			_ignoredObjects.push($object);
		}
		
		/**
		 * Removes an ignored DisplayObject so that its clicks are no longer ignored.
		 * 
		 * @param $object DisplayObject that should not be ignored anymore
		 */
		public function removeIgnoredObject($object:DisplayObject):void {
			for (var i:uint = 0; i < _ignoredObjects.length; i++) {
				if (_ignoredObjects[i] == $object) {
					_ignoredObjects.splice(i, 1);
				}
			}
		}
		
		/** @private **/
		private function onDestroyItem($e:TransformEvent):void {
			removeItem($e.target);
		}
		
		
//---- GENERAL -------------------------------------------------------------------------------------------------------------------------
		
		/** @private **/
		private function setOrigin($p:Point):void { //Repositions the registration point of the _dummyBox and then calls plotHandles() to redraw the handles
			if (!_lockOrigin) {
				_lockOrigin = true; //prevents problems with recursion, particularly in updateSelection() when enforcing the saftey zone
				_origin = $p;
				
				var local:Point = _dummyBox.globalToLocal(_parent.localToGlobal($p));
				var bounds:Rectangle = _dummyBox.getBounds(_dummyBox);
				
				_dummyBox.graphics.clear();
				_dummyBox.graphics.beginFill(0x0066FF, 1);
				_dummyBox.graphics.drawRect(bounds.x - local.x, bounds.y - local.y, bounds.width, bounds.height);
				_dummyBox.graphics.endFill();
				
				_dummyBox.x = _origin.x;
				_dummyBox.y = _origin.y;
				
				enforceSafetyZone();
				
				for (var i:int = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].origin = _origin;
				}
				
				plotHandles();
				renderSelection();
				_lockOrigin = false;
			}
		}
		
		/** @private **/
		private function enforceSafetyZone():void { //Due to rounding issues in extremely small decimals, a selection can creep slightly over the bounds when the origin and/or selection bounding box is directly on top of one of the edges of the boundaries. This function enforces a 0.1 pixel "safety zone" to avoid that issue.
			if (_selMaxBounds != null) {
				var locks:Array;
				var prevLockPosition:Boolean = _selLockPosition;
				var prevLockScale:Boolean = _selLockScale;
				_selLockPosition = false;
				_selLockScale = false;
				
				if (!_selMaxBounds.containsPoint(_origin)) {
					locks = recordLocks();
					if (_selMaxBounds.left > _origin.x) {
						shiftSelection(_selMaxBounds.left - _origin.x, 0);
					} else if (_selMaxBounds.right < _origin.x) {
						shiftSelection(_selMaxBounds.right - _origin.x, 0);
					}
					if (_selMaxBounds.top > _origin.y) {
						shiftSelection(0, _selMaxBounds.top - _origin.y);
					} else if (_selMaxBounds.bottom < _origin.y) {
						shiftSelection(0, _selMaxBounds.bottom - _origin.y);
					}
				}
				
				if (_selectedItems.length != 0) {
					if (locks == null) {
						locks = recordLocks();
					}				
					if (_handles[0].point == null) {
						plotHandles();
					}
					
					var b:Rectangle = getSelectionRect();
					
					if (_selMaxBounds.width - b.width < 0.2) {
						shiftSelectionScale(1 - (0.22 / b.width));
					}
					
					b = getSelectionRect();
					if (_selMaxBounds.height - b.height < 0.2) {
						shiftSelectionScale(1 - (0.22 / b.height));
					}
					if (Math.abs(b.top - _selMaxBounds.top) < 0.1) {
						shiftSelection(0, 0.1);
					}
					if (Math.abs(b.bottom - _selMaxBounds.bottom) < 0.1) {
						shiftSelection(0, -0.1);
					}
					if (Math.abs(b.left - _selMaxBounds.left) < 0.1) {
						shiftSelection(0.1, 0);					
					}
					if (Math.abs(b.right - _selMaxBounds.right) < 0.1) {
						shiftSelection(-0.1, 0);
					}
					
				}
				
				if (locks != null) {
					restoreLocks(locks);
				}
				_selLockPosition = prevLockPosition;
				_selLockScale = prevLockScale;
				
			}
			
			//In order to impose the safe area, we need to make sure the lockPosition and lockScale properties are false. This function records the current values so we can restore them later.
			function recordLocks():Array {
				var a:Array = [];
				for (var i:int = _selectedItems.length - 1; i > -1; i--) {
					a[i] = {position:_selectedItems[i].lockPosition, scale:_selectedItems[i].lockScale};
				}
				return a;
			}
			
			function restoreLocks($a:Array):void {
				for (var i:int = $a.length - 1; i > -1; i--) {
					_selectedItems[i].lockPosition = $a[i].position;
					_selectedItems[i].lockScale = $a[i].scale;
				}
			}
			
			function shiftSelection($x:Number, $y:Number):void {
				_dummyBox.x += $x;
				_dummyBox.y += $y;
				for (var i:int = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].move($x, $y, false, false);
				}
				_origin.x += $x;
				_origin.y += $y;
			}
			
			function shiftSelectionScale($scale:Number):void {
				var o:Point = _origin.clone();
				_origin.x = _selMaxBounds.x + (_selMaxBounds.width / 2);
				_origin.y = _selMaxBounds.y + (_selMaxBounds.height / 2);
				var i:int;
				for (i = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].origin = _origin;
				}
				scaleSelection($scale, $scale, false);
				_origin.x = o.x;
				_origin.y = o.y;
				for (i = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].origin = _origin;
				}
				updateSelection();
			}
			
		}
		
		/** @private **/
		protected function onPressDelete($e:Event = null):void {
			if (_enabled && _allowDelete) {
				var deletedItems:Array = [];
				var item:TransformItem;
				var multiple:Boolean = Boolean(_selectedItems.length > 1);
				var i:int = _selectedItems.length;
				while (i--) {
					item = _selectedItems[i];
					if (item.onPressDelete($e, multiple)) {
						deletedItems[deletedItems.length] = item;
					}
				}
				if (_selectedItems.length == 0) {
					removeParentListeners();
				}
				if (deletedItems.length > 0) {
					dispatchEvent(new TransformEvent(TransformEvent.DELETE, deletedItems));
				}
			}
		}
		
		/**
		 * Deletes all selected items.
		 * 
		 * @param $e Accepts an optional Event in case you want to use this as an event handler
		 */
		public function deleteSelection($e:Event = null):void {
			var deletedItems:Array = [];
			var item:TransformItem;
			for (var i:int = _selectedItems.length - 1; i > -1; i--) {
				item = _selectedItems[i];
				item.deleteObject();
				deletedItems.push(item);
			}
			if (deletedItems.length != 0) {
				dispatchEvent(new TransformEvent(TransformEvent.DELETE, deletedItems));
			}
		}
		
		/** @private **/
		private function onPressArrowKey($e:KeyboardEvent = null):void {
			if (_arrowKeysMove && _enabled && _selectedItems.length != 0 && !(_stage.focus is TextField)){
				var moveAmount:int = isKeyDown(Keyboard.SHIFT) ? 10 : 1;// Move faster if the shift key is down.
				dispatchInteractiveEvent(TransformEvent.START_INTERACTIVE_MOVE);
				switch($e.keyCode) {
					case Keyboard.UP:
						moveSelection(0, -moveAmount);
						break;
					case Keyboard.DOWN:
						moveSelection(0, moveAmount);
						break;
					case Keyboard.LEFT:
						moveSelection(-moveAmount, 0);
						break;
					case Keyboard.RIGHT:
						moveSelection(moveAmount, 0);
						break;
				}
				dispatchInteractiveEvent(TransformEvent.FINISH_INTERACTIVE_MOVE);
			}
		}
		
		/** @private **/
		public function centerOrigin():void {
			setOrigin(getSelectionCenter());
		}
		
		/**
		 * Gets the center point of the current selection
		 * 
		 * @return Center Point of the current selection
		 */
		public function getSelectionCenter():Point {
			var bounds:Rectangle = _dummyBox.getBounds(_dummyBox);
			return _parent.globalToLocal(_dummyBox.localToGlobal(new Point(bounds.x + bounds.width / 2, bounds.y + bounds.height / 2)));
		}
		
		/**
		 * Gets the bounding Rectangle of the current selection (not including handles)
		 * 
		 * @param targetCoordinateSpace The display object that defines the coordinate system to use. 
		 * @return Bounding Rectangle of the current selection (not including handles).
		 */
		public function getSelectionBounds(targetCoordinateSpace:DisplayObject=null):Rectangle {
			if (_parent.contains(_dummyBox) && _selectedItems.length != 0) {
				if (targetCoordinateSpace) {
					return _dummyBox.getBounds(targetCoordinateSpace);
				} else {
					return _dummyBox.getBounds(_parent);
				}
			} else {
				return null;
			}
		}
		
		/**
		 * Gets the bounding Rectangle of the current selection (including handles)
		 * 
		 * @param targetCoordinateSpace The display object that defines the coordinate system to use. 
		 * @return Bounding Rectangle of the current selection (including handles)
		 */
		public function getSelectionBoundsWithHandles(targetCoordinateSpace:DisplayObject=null):Rectangle {
			if (_parent.contains(_selection) && _selectedItems.length != 0) {
				if (targetCoordinateSpace) {
					return _selection.getBounds(targetCoordinateSpace);
				} else {
					return _selection.getBounds(_parent);
				}
			} else {
				return null;
			}
		}
		
		/**
		 * Gets the width of the selection as if it were not rotated.
		 * 
		 * @return The unrotated selection width
		 */
		public function getUnrotatedSelectionWidth():Number {
			var bounds:Rectangle = _dummyBox.getBounds(_dummyBox);
			return bounds.width * MatrixTools.getScaleX(_dummyBox.transform.matrix, _flipX);
		}
		
		/**
		 * Gets the height of the selection as if it were not rotated.
		 * 
		 * @return The unrotated selection height
		 */
		public function getUnrotatedSelectionHeight():Number {
			var bounds:Rectangle = _dummyBox.getBounds(_dummyBox);
			return bounds.height * MatrixTools.getScaleY(_dummyBox.transform.matrix, _flipX);
		}
		
		/**
		 * Gets the TransformItem associated with a particular DisplayObject (if any). This can be useful if you 
		 * need to set item-specific properties like minScaleX/maxScaleX, etc.
		 * 
		 * @param $targetObject The DisplayObject with which the TransformItem is associated
		 * @return The associated TransformItem
		 */
		public function getItem($targetObject:DisplayObject):TransformItem {
			for (var i:int = _items.length - 1; i > -1; i--) {
				if (_items[i].targetObject == $targetObject) {
					return _items[i];
				}
			}
			return null;
		}
		
		/** @private **/
		private function findObject($item:*):TransformItem {
			if ($item is DisplayObject) {
				return getItem($item);
			} else if ($item is TransformItem) {
				return $item;
			} else {
				return null;
			}
		}
		
		/** @private **/
		private function updateItemProp($prop:String, $value:*):void {
			for (var i:int = _items.length - 1; i > -1; i--) {
				_items[i][$prop] = $value;
			}
		}
		
		/** @private **/
		private function removeParentListeners():void {
			if (_parent != null && _stage != null) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseMove);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveMove);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveRotate);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveScale);
			}
		}
		
		/**
		 * Allows listening for the following events:
		 * <ul>
		 * 		<li> TransformEvent.MOVE </li>
		 * 		<li> TransformEvent.SCALE </li>
		 * 		<li> TransformEvent.ROTATE </li>
		 * 		<li> TransformEvent.DELETE </li>
		 * 		<li> TransformEvent.SELECTION_CHANGE </li>
		 * 		<li> TransformEvent.CLICK_OFF </li>
		 * 		<li> TransformEvent.SEIZE_CURSOR </li>
		 * 		<li> TransformEvent.RELEASE_CURSOR </li>
		 * 		<li> TransformEvent.DEPTH_CHANGE </li>
		 * 		<li> TransformEvent.DESTROY </li>
		 * 		<li> TransformEvent.START_INTERACTIVE_MOVE </li>
		 * 		<li> TransformEvent.START_INTERACTIVE_SCALE </li>
		 * 		<li> TransformEvent.START_INTERACTIVE_ROTATE </li>
		 * 		<li> TransformEvent.FINISH_INTERACTIVE_MOVE </li>
		 * 		<li> TransformEvent.FINISH_INTERACTIVE_SCALE </li>
		 * 		<li> TransformEvent.FINISH_INTERACTIVE_ROTATE </li>
		 * 		<li> TransformEvent.DOUBLE_CLICK </li>
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
		
		/** @private **/
		protected function dispatchInteractiveEvent(type:String):void {
			dispatchEvent(new TransformEvent(type, _selectedItems.slice()));
			var i:int = _selectedItems.length;
			while (--i > -1) {
				TransformItem(_selectedItems[i]).dispatchEvent(new TransformEvent(type, [_selectedItems[i]]));
			}
		}
		
		/** Destroys the TransformManager instance, removing all items and preparing it for garbage collection **/
		public function destroy():void {
			deselectAll();
			_keyDispatcher.removeEventListener("pressDelete", onPressDelete);
			_keyDispatcher.removeEventListener("pressArrowKey", onPressArrowKey);
			_keyDispatcher.removeEventListener("pressMultiSelectKey", onPressMultiSelectKey);
			_keyDispatcher.removeEventListener("releaseMultiSelectKey", onReleaseMultiSelectKey);
			
			if (_stage != null) {
				_stage.removeEventListener(Event.DEACTIVATE, onReleaseMultiSelectKey);
			}
			removeParentListeners();
			for (var i:int = _items.length - 1; i > -1; i--) {
				_items[i].destroy();
			}
			dispatchEvent(new TransformEvent(TransformEvent.DESTROY, _items.slice()));
		}
		

//---- DEPTH MANAGEMENT ------------------------------------------------------------------------------------------------------------

		/** Moves the selection down one level. **/
		public function moveSelectionDepthDown():void{
			moveSelectionDepth(-1);
		}
		
		/** Moves the selection up one level. **/
		public function moveSelectionDepthUp():void{
			moveSelectionDepth(1);
		}
		
		/** @private **/
		private function moveSelectionDepth(direction:int = 1):void{
			if (_enabled && _selectedItems.length != 0 && _parent != null && _parent.contains(_dummyBox) && _parent.contains(_selection)) {
				var curDepths:Array = [];
				var useElement:Boolean = _parent.hasOwnProperty("getElementIndex");
				var i:int;
				for (i = _items.length - 1; i > -1; i--) {
					if (_items[i].targetObject.parent == _parent) {
						curDepths.push({depth:(useElement ? Object(_parent).getElementIndex(_items[i].targetObject) : _parent.getChildIndex(_items[i].targetObject)), item:_items[i]});
					}
				}
				curDepths.sortOn("depth", Array.NUMERIC);
				var newDepths:Array = [];
				var hitGap:Boolean = false;
				if (direction == -1) {
					newDepths.push(curDepths[0].item.targetObject);
					if (!curDepths[0].item.selected) {
						hitGap = true;
					}
					for (i = 1; i < curDepths.length; i++) {
						if (curDepths[i].item.selected && hitGap) { // prevent the bottom two items from swapping depths when they're both selected
							newDepths.splice(-1, 0, curDepths[i].item.targetObject);
						} else {
							newDepths.push(curDepths[i].item.targetObject);
							if (!curDepths[i].item.selected && !hitGap) {
								hitGap = true;
							}
						}
					}
				} else {
					newDepths.push(curDepths[curDepths.length - 1].item.targetObject);
					if (!curDepths[curDepths.length - 1].item.selected) {
						hitGap = true;
					}
					for (i = curDepths.length - 2; i > -1; i--) {
						if (curDepths[i].item.selected && hitGap) {
							newDepths.splice(1, 0, curDepths[i].item.targetObject);
						} else {
							newDepths.unshift(curDepths[i].item.targetObject);
							if (!curDepths[i].item.selected && !hitGap) {
								hitGap = true;
							}
						}
					}
				}
				useElement = Boolean(_isFlex && _parent.hasOwnProperty("setElementIndex"));
				for (i = 0; i < newDepths.length; i++) {
					if (useElement) { //for Flex compatibility (spark)
						Object(_parent).setElementIndex(newDepths[i], curDepths[i].depth);
					} else {
						_parent.setChildIndex(newDepths[i], curDepths[i].depth);
					}
				}
				dispatchEvent(new TransformEvent(TransformEvent.DEPTH_CHANGE, _items.slice()));
			}
		}
		
		
//---- SELECTION ---------------------------------------------------------------------------------------------------------------------
		
		/** @private **/
		private function checkForDeselect($e:MouseEvent = null):void {
			if (_selectedItems.length != 0 && _parent != null) {
				var i:int = _selectedItems.length;
				var x:Number = $e.stageX;  
				var y:Number = $e.stageY;
				var deselectedItem:TransformItem = _tempDeselectedItem; //if an item was JUST deselected on this click, it'll be stored here (because it's now deselected, but we need to still sense whether or not the user CTRL-clicked on it to deselect it, in which case we shouldn't deselectAll())
				_tempDeselectedItem = null;
				if (_selection.hitTestPoint(x, y, true)) {
					return;
				} else if (deselectedItem) {
					if (deselectedItem.targetObject.hitTestPoint(x, y, true)) {
						return;
					}
				}
				while (i--) {
					 if (_selectedItems[i].targetObject.hitTestPoint(x, y, true)) {
						return;
					}
				}
				i = _ignoredObjects.length;
				while (i--) {
					if (_ignoredObjects[i].hitTestPoint(x, y, true)) {
						return;
					}
				}
				if (_autoDeselect) {
					deselectAll();
				} else {
					dispatchEvent(new TransformEvent(TransformEvent.CLICK_OFF, _selectedItems.slice(), $e));
				}
			}
		}
		
		/** @private **/
		private function onMouseDownItem($e:TransformEvent):void {
			if (isKeyDown(Keyboard.CONTROL)) {
				$e.target.selected = !$e.target.selected;
				if (!$e.target.selected) {
					_tempDeselectedItem = $e.target as TransformItem; //we need to keep track of this just until the checkForDeselect() runs, otherwise it'll always deselectAll() when we CTRL-CLICK an item to deselect it.
				}
			} else {
				$e.target.selected = true;
			}
			if (!$e.target.hasSelectableText) {
				_stage.stageFocusRect = false; //otherwise when we set the focus, a big yellow rectangle will be drawn around the selected object!
				_stage.focus = $e.target.targetObject; //otherwise the text in a targetObject that's highlighted could remain highlighted, and then if the user hits the DELETE or BACKSPACE key, the text would also get deleted.
			}
		}
		
		/** @private **/
		private function onMouseDownSelection($e:MouseEvent):void {
			_stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseMove, false, 0, true);
			onPressMove($e);
		}
		
		/**
		 * Selects a particular TransformItem or DisplayObject (you must have already added the DisplayObject
		 * to TransformManager in order for it to be selectable - use <code>addItem()</code> for that)
		 * 
		 * @param $item The TransformItem or DisplayObject that should be selected
		 * @param $addToSelection If true, any currently selected items will remain selected and the new item/DisplayObject will be added to the selection.
		 * @return The TransformItem that was selected.
		 */
		public function selectItem($item:*, $addToSelection:Boolean = false):TransformItem { //You can pass in a reference to the DisplayObject or its associated TransformItem.
			var item:TransformItem = findObject($item); //makes it possible to pass in DisplayObjects or TransformItems
			if (item == null) {
				trace("TransformManager Error: selectItem() and selectItems() only work with objects that have a TransformItem associated with them. Make sure you create one by calling TransformManager.addItem() before attempting to select it.");
			} else if (!item.selected) {
				var previousMode:Boolean = _multiSelectMode;
				_multiSelectMode = $addToSelection; //otherwise when the item dispatches a SELECT event, it'll wipe out the other selected items.
				_ignoreEvents = true;
				item.selected = true;
				_ignoreEvents = false;
				_multiSelectMode = previousMode;
				dispatchEvent(new TransformEvent(TransformEvent.SELECTION_CHANGE, [item]));
			}
			return item;
		}
		
		/**
		 * Deselects a TransformItem or DisplayObject.
		 * 
		 * @param $item The TransformItem or DisplayObject that should be deselected
		 * @return The TransformItem that was deselected
		 */
		public function deselectItem($item:*):TransformItem {
			var item:TransformItem = findObject($item);
			if (item != null) {
				item.selected = false;
			}
			return item;
		}
		
		/**
		 * Selects an Array of TransformItems and/or DisplayObjects. (you must have already added the DisplayObjects
		 * to TransformManager in order for it to be selectable - use <code>addItem()</code> or <code>addItems()</code> for that)
		 * 
		 * @param $items An Array of TransformItems and/or DisplayObjects to be selected
		 * @param $addToSelection If true, any currently selected items will remain selected and the new items/DisplayObjects will be added to the selection.
		 * @return An Array of TransformItems that were selected
		 */
		public function selectItems($items:Array, $addToSelection:Boolean = false):Array {
			var i:uint, j:uint, item:TransformItem, selectedItem:TransformItem, found:Boolean;
			var validItems:Array = [];
			_ignoreEvents = true;

			for (i = 0; i < $items.length; i++) {
				item = findObject($items[i])
				if (item != null) {
					validItems.push(item);	
				}
			}
			if (!$addToSelection) {
				var items:Array = _selectedItems.slice();
				for (i = 0; i < items.length; i++) {
					selectedItem = items[i];
					found = false;
					for (j = 0; j < validItems.length; j++) {
						if (validItems[j] == selectedItem) {
							found = true;
							break;
						}
					}
					if (!found) {
						selectedItem.selected = false;
					}
				}
			}
			var previousMode:Boolean = _multiSelectMode;
			_multiSelectMode = true;
			for (i = 0; i < validItems.length; i++) {
				validItems[i].selected = true;
			}
			_multiSelectMode = previousMode;
			_ignoreEvents = false;
			dispatchEvent(new TransformEvent(TransformEvent.SELECTION_CHANGE, validItems));
			return validItems;
		}
		
		/** Deselects all items **/
		public function deselectAll():void {
			var oldItems:Array = _selectedItems.slice();
			_ignoreEvents = true;
			for (var i:int = _selectedItems.length - 1; i > -1; i--) {
				_selectedItems[i].selected = false;
			}
			_ignoreEvents = false;
			swapCursorOut(null);
			dispatchEvent(new TransformEvent(TransformEvent.SELECTION_CHANGE, oldItems));
		}
		
		/**
		 * Determines whether or not a particular DisplayObject or TranformItem is currently selected.
		 * 
		 * @param $item The TransformItem or DisplayObject whose selection status needs to be checked
		 * @return If true, the item/DisplayObject is currently selected
		 */
		public function isSelected($item:*):Boolean {
			var item:TransformItem = findObject($item);
			if (item != null) {
				return item.selected;
			} else {
				return false;
			}
		}
		
		/** @private **/
		private function onSelectItem($e:TransformEvent):void {
			var i:int;
			var previousIgnore:Boolean = _ignoreEvents;
			_ignoreEvents = true;
			var changed:Array = [$e.target as TransformItem];
			if (!_multiSelectMode) {
				for (i = _selectedItems.length - 1; i > -1; i--) {
					changed.push(_selectedItems[i]);
					_selectedItems[i].selected = false;
					_selectedItems.splice(i, 1);
				}
			}
			_selectedItems.push($e.target);
			if (_initted) {
				if (_forceSelectionToFront) {
					for (i = _selectedItems.length - 1; i > -1; i--) {
						bringToFront(_selectedItems[i].targetObject);
					}
				}
				calibrateConstraints();
				updateSelection();
				
				if (mouseIsOverSelection(true)) {
					onRollOverSelectedItem($e);
				}
				
			}
			_ignoreEvents = previousIgnore;
			if (!_ignoreEvents) {
				dispatchEvent(new TransformEvent(TransformEvent.SELECTION_CHANGE, changed));
			}
		}
		
		/** @private **/
		private function calibrateConstraints():void {
			_selConstrainScale = false;
			_selLockScale = _lockScale;
			_selLockRotation = _lockRotation;
			_selLockPosition = _lockPosition;
			_selHasTextFields = _selHasSizeLimits = false;
			_selMinBounds = null;
			_selMaxBounds = null;
			var i:int = _selectedItems.length;
			var item:TransformItem;
			while (--i > -1) {
				item = _selectedItems[i];
				if (item.constrainScale) {
					_selConstrainScale = true;
				}
				if (item.lockScale) {
					_selLockScale = true;
				}
				if (item.lockRotation) {
					_selLockRotation = true;
				}
				if (item.lockPosition) {
					_selLockPosition = true;
				}
				if (item.scaleMode != SCALE_NORMAL) {
					_selHasTextFields = true;
				}
				if (item.hasSizeLimits) {
					_selHasSizeLimits = true;
				}
				if (item.bounds != null) {
					if (_selMinBounds == null) {
						_selMinBounds = item.bounds.clone();
						_selMaxBounds = _selMinBounds.clone();
					} else {
						_selMinBounds = _selMinBounds.intersection(item.bounds);
						_selMaxBounds = _selMaxBounds.union(item.bounds);
					}
				}
			}
		}
		
		/** @private **/
		private function onDeselectItem($e:TransformEvent):void {
			for (var i:int = _selectedItems.length - 1; i > -1; i--) {
				if (_selectedItems[i] == $e.target) {
					_selectedItems.splice(i, 1);
					updateSelection();
					if (!_ignoreEvents) {
						dispatchEvent(new TransformEvent(TransformEvent.SELECTION_CHANGE, [$e.target as TransformItem]));
					}
					if (!mouseIsOverSelection(true)) {
						swapCursorOut();
					}
					if (_lockCursor && _selectedItems.length == 0) {
						unlockCursor(); //in case the selected object is deselected/deleted while dragging it, we must release the cursor
					} 
					return;
				}
			}
		}
		
		/** @private **/
		private function onUpdateItem($e:TransformEvent):void {
			if (!_ignoreEvents) {
				if ($e.type == TransformEvent.UPDATE) {
					calibrateConstraints();
				}
				if ($e.target.selected && !_isTransforming) {
					updateSelection(true);
					dispatchEvent(new TransformEvent(TransformEvent.UPDATE, [$e.target]));
				}
			}
		}
		
		/**
		 * Refreshes the selection box/handles. 
		 * 
		 * @param $centerOrigin If true, the origin (axis of rotation/scaling) will be automatically centered.
		 */
		public function updateSelection($centerOrigin:Boolean=true):void { 
			if (!_initted) {
				//do nothing
			} else if (_selectedItems.length != 0) {
				if (_dummyBox.parent != _parent) { //in case the user accidentally removed it
					if (_isFlex && _parent.hasOwnProperty("addElement")) { //for Flex compatibility (spark)
						(_parent as Object).addElement(_dummyBox);
					} else {
						_parent.addChild(_dummyBox);
					}
				}
				var r:Rectangle;
				_dummyBox.transform.matrix = new Matrix(); //Clears any transformations.
				_dummyBox.graphics.clear();
				_dummyBox.graphics.beginFill(0x0066FF, 1);
				if (_selectedItems.length == 1) {
					var ti:TransformItem = _selectedItems[0];
					var t:DisplayObject = ti.targetObject;
					var m:Matrix = t.transform.matrix;
					if (ti.manualBoundsOffset != null) {
						t.transform.matrix = new Matrix(); //gets rid of all transformations. Bugs in the Flex framework prevented getBounds() from accurately reporting the width/height, so I had to remove all transformations and check it directly with object.width and object.height.
						_dummyBox.graphics.drawRect(ti.manualBoundsOffset.x, ti.manualBoundsOffset.y, t.width + ti.manualBoundsOffset.width, t.height + ti.manualBoundsOffset.height);
						_dummyBox.transform.matrix = t.transform.matrix = m;
					} else if (t.width != 0) { //in Flex, SWFLoaders/Images and some other components don't accurately report width/height
						t.transform.matrix = new Matrix(); //gets rid of all transformations. Bugs in the Flex framework prevented getBounds() from accurately reporting the width/height, so I had to remove all transformations and check it directly with object.width and object.height.
						r = t.getBounds(t);
						_dummyBox.graphics.drawRect(r.x, r.y, t.width, t.height);
						_dummyBox.transform.matrix = t.transform.matrix = m;
					} else {
						r = t.getBounds(t);
						_dummyBox.graphics.drawRect(r.x, r.y, r.width, r.height);
						_dummyBox.transform.matrix = t.transform.matrix;
					}
					_flipX = Boolean(ti.scaleX < 0);
				} else {
					_flipX = false;
					r = getSelectionRect();
					_dummyBox.graphics.drawRect(r.x, r.y, r.width, r.height);
				}
				_dummyBox.graphics.endFill();
				if ($centerOrigin || _origin == null) {
					centerOrigin();
				} else {
					setOrigin(_origin);
				}
				if (_selection.parent != _parent) {
					if (_isFlex && _parent.hasOwnProperty("addElement")) { //for Flex compatibility (spark)
						(_parent as Object).addElement(_selection);
					} else {
						_parent.addChild(_selection);
					}
				}
				renderSelection();
				bringToFront(_selection);
			} else if (_parent != null) {
				if (_selection.parent == _parent) {
					if (_isFlex && _parent.hasOwnProperty("removeElement")) { //for Flex compatibility (spark)
						(_parent as Object).removeElement(_selection);
					} else {
						_parent.removeChild(_selection);
					}
				}
				if (_dummyBox.parent == _parent) {
					if (_isFlex && _parent.hasOwnProperty("removeElement")) { //for Flex compatibility (spark)
						(_parent as Object).removeElement(_dummyBox);
					} else {
						_parent.removeChild(_dummyBox);
					}
				}
			}
		}
		
		/** @private **/
		private function renderSelection():void { //Only makes the selection handles and edges match where the _dummyBox is
			if (_initted) {
				var m:Matrix = _dummyBox.transform.matrix;
				_selection.graphics.clear();
				if (_lineThickness) {
					_selection.graphics.lineStyle(_lineThickness, _lineColor, 1, false, "none");
				}
				_edges.graphics.clear();
				_edges.graphics.lineStyle(10, 0xFF0000, 0, false, "none");
				
				var rotation:Number = MatrixTools.getAngle(m, _flipX) * _RAD2DEG; //_dummyBox.rotation;
				var flip:Boolean = Boolean(MatrixTools.getScaleX(m, _flipX) * MatrixTools.getScaleY(m, _flipX) < 0);
				
				var p:Point, finishPoint:Point, i:int, handleInfo:Object, r:Number;
				for (i = _handles.length - 1; i > -1; i--) {
					handleInfo = _handles[i];
					p = m.transformPoint(handleInfo.point);
					handleInfo.handle.x = p.x;
					handleInfo.handle.y = p.y;
					r = rotation;
					if (flip) {
						r += handleInfo.flipRotation;
					}
					if (_flipX) {
						r += 180;
					}
					handleInfo.handle.rotation = r;
					if (i == 8) { 
						_selection.graphics.moveTo(p.x, p.y);
						_edges.graphics.moveTo(p.x, p.y);
						finishPoint = p;
					} else if (i > 4) {
						_selection.graphics.lineTo(p.x, p.y);
						_edges.graphics.lineTo(p.x, p.y);
					}
				}
				_selection.graphics.lineTo(finishPoint.x, finishPoint.y);
				_edges.graphics.lineTo(finishPoint.x, finishPoint.y);
				
				var elementInfo:Object, handle:Sprite, angle:Number, alignments:Object;
				
				alignments = (flip) ? _handleOrientationsFlipped : _handleOrientationsNormal;
				i = _selectionElements.length;
				while (--i > -1) {
					elementInfo = _selectionElements[i];
					handle = _handles[alignments[elementInfo.alignment]].handle;
					r = _dummyBox.rotation; //don't use the rotation from above (MatrixTools.getAngle()-based) because when scaleX and scaleY are negative, we actually want to leverage the fact that Flash alters the rotation in terms of reporting. It works best here.
					if (flip) {
						r += 180;
					}
					elementInfo.element.rotation = r;
					angle = elementInfo.element.rotation * _DEG2RAD + elementInfo.angle;
					elementInfo.element.x = handle.x + Math.cos(angle) * elementInfo.length;
					elementInfo.element.y = handle.y + Math.sin(angle) * elementInfo.length;
				}
				
			}
		}
		
		/**
		 * Attaches a DisplayObject of your choice to the selection box itself so that it appears to move
		 * with the selection box as the user interacts with it. This is a great way to add your own interface 
		 * elements, like a "delete" icon/button. You can set the alignment to any of the selection handles: 
		 * "topLeft", "top", "topRight", "right", "bottomRight", "bottom", "bottomLeft", "center" or "left" and you can 
		 * also define offset values so that the object doesn't sit right on top of the handle (or just alter 
		 * the registration point of your DisplayObject to accomplish something similar). For example, if I 
		 * want to attach a Sprite named "deleteButton" to the selection box in the upper right corner and 
		 * offset it by 40 pixels on the x-axis and 0 pixels on the y-axis, I'd do:<p><code>
		 * 
		 * myManager.addSelectionBoxElement(deleteButton, "topRight", 40, 0);</code></p>
		 * 
		 * @param element The DisplayObject to attach to the selection (it will be moved into the selection Sprite that TransformManager uses)
		 * @param alignment "topLeft", "top", "topRight", "right", "bottomRight", "bottom", "bottomLeft", "center" or "left"
		 * @param xOffset The number of pixels to offset the element on the x-axis (when the selection box isn't rotated)
		 * @param yOffset The number of pixels to offset the element on the y-axis (when the selection box isn't rotated)
		 * @param underHandles By default, the element will be placed above the scale/rotation handles, but if you prefer that the element is positioned under the handles, set <code>underHandles</code> to <code>true</code>
		 * @see #removeSelectionBoxElement()
		 */
		public function addSelectionBoxElement(element:DisplayObject, alignment:String="topRight", xOffset:Number=0, yOffset:Number=0, underHandles:Boolean=false):void {
			if (!(alignment in _handleOrientationsNormal)) {
				throw new Error(alignment + " not a valid alignment parameter in addSelectionBoxElement().");
			}
			removeSelectionBoxElement(element); //just in case it's already in the array
			_selectionElements.push( {element:element, alignment:alignment, angle:Math.atan2(yOffset, xOffset), length:Math.sqrt(xOffset * xOffset + yOffset * yOffset), underHandles:underHandles} );
			if (_selection != null) {
				if (underHandles) {
					_selection.addChildAt(element, 0);
				} else {
					_selection.addChild(element);
				}
				plotHandles();
				renderSelection();
			}
		}
		
		/**
		 * Releases a DisplayObject that was attached using <code>addSelectionBoxElement()</code>.
		 * 
		 * @param element The DisplayObject to release
		 * @see #addSelectionBoxElement()
		 */
		public function removeSelectionBoxElement(element:DisplayObject):void {
			var i:int = _selectionElements.length;
			while (--i > -1) {
				if (_selectionElements[i].element == element) {
					_selectionElements.splice(i, 1);
					if (element.parent == _selection) {
						_selection.removeChild(element);
					}
				}
			}
		}
		
		/** @private **/
		private function getSelectionRect():Rectangle {
			if (_selectedItems.length == 0) {
				return new Rectangle();
			}
			var i:int = _selectedItems.length - 1;
			var b:Rectangle = _selectedItems[i].targetObject.getBounds(_parent);
			while (i--) {
				b = b.union(_selectedItems[i].targetObject.getBounds(_parent));
			}
			return b;
		}
		
		/** @private **/
		private function initSelection():void {
			_selection = _isFlex ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite();
			_selection.name = "__selection_mc";
			_edges = new Sprite();
			_edges.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownSelection, false, 0, true);
			_selection.addChild(_edges);
			_dummyBox = _isFlex ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite();
			_dummyBox.name = "__dummyBox_mc";
			_dummyBox.visible = false;
			_handles = [];
			createHandle("c", "center", 0, 0, null);
			createHandle("t", "stretchV", -90, 0, "b");
			createHandle("r", "stretchH", 0, 0, "l");
			createHandle("b", "stretchV", 90, 0, "t");
			createHandle("l", "stretchH", 180, 0, "r");
			createHandle("tl", "corner", -135, -90, "br");
			createHandle("tr", "corner", -45, 90, "bl");
			createHandle("br", "corner", 45, -90, "tl");
			createHandle("bl", "corner", 135, 90, "tr");
			
			if (_selectionElements != null) {
				var i:int = _selectionElements.length;
				while (--i > -1) {
					if (_selectionElements[i].underHandles) {
						_selection.addChildAt(_selectionElements[i].element, 0);
					} else {
						_selection.addChild(_selectionElements[i].element);
					}
				}
			}
			
			redrawHandles();
			setCursorListeners(true);
		}
		
		/** @private **/
		private function createHandle($name:String, $type:String, $cursorRotation:Number, $flipRotation:Number = 0, $oppositeName:String = null):Object {
			var h:Sprite = new Sprite(); //container handle
			h.name = $name;
			var s:Sprite = new Sprite(); //Scale handle
			s.name = "scaleHandle";
			
			var handle:Object = {handle:h, scaleHandle:s, type:$type, name:$name, oppositeName:$oppositeName, flipRotation:$flipRotation, cursorRotation:$cursorRotation};
			_handlesDict[s] = handle; //To make lookups faster on cursor rollovers
			
			if ($type != "center") {
				var onPress:Function;
				if ($type == "stretchH") {
					onPress = onPressStretchH;
				} else if ($type == "stretchV") {
					onPress = onPressStretchV;
				} else {
					onPress = onPressScale;
					var r:Sprite = new Sprite(); //rotation hit area
					r.name = "rotationHandle"
					r.addEventListener(MouseEvent.MOUSE_DOWN, onPressRotate, false, 0, true);
					h.addChild(r);
					_handlesDict[r] = handle;
					handle.rotationHandle = r;
				}
				s.addEventListener(MouseEvent.MOUSE_DOWN, onPress, false, 0, true);
			} else {
				s.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownSelection, false, 0, true);
			}
			h.addChild(s);
			_selection.addChild(h);
			_handles.push(handle);
			return handle;
		}
		
		/** @private **/
		private function redrawHandles():void {
			var i:uint, s:Sprite, r:Sprite, handleName:String, rx:Number, ry:Number;
			var halfH:Number = _handleSize / 2;
			for (i = 0; i < _handles.length; i++) {
				s = _handles[i].scaleHandle;
				handleName = _handles[i].name;
				s.graphics.clear();
				if (_lineThickness) {
					s.graphics.lineStyle(_lineThickness, _lineColor, 1, false, "none");
				}
				s.graphics.beginFill(_handleColor, 1);
				s.graphics.drawRect(0 - (_handleSize / 2), 0 - (_handleSize / 2), _handleSize, _handleSize);
				s.graphics.endFill();
				if (_handles[i].type == "corner") {
					r = _handles[i].rotationHandle;
					if (handleName == "tl") {
						rx = ry = -halfH - _paddingForRotation;
					} else if (handleName == "tr") {
						rx = -halfH;
						ry = -halfH - _paddingForRotation;
					} else if (handleName == "br") {
						rx = ry = -halfH;
					} else {
						rx = -halfH - _paddingForRotation;
						ry = -halfH;
					}
					r.graphics.clear();
					r.graphics.lineStyle(0, _lineColor, 0);
					r.graphics.beginFill(0xFF0000, 0);
					r.graphics.drawRect(rx, ry, _handleSize + _paddingForRotation, _handleSize + _paddingForRotation);
					r.graphics.endFill();
				} else if (_handles[i].type == "center") {
					s.visible = !_hideCenterHandle;
				}
			}
		}
		
		/** @private **/
		private function plotHandles():void {
			var r:Rectangle = _dummyBox.getBounds(_dummyBox);
			_handles[0].point = new Point(r.x + r.width / 2, r.y + r.height / 2); //center
			_handles[1].point = new Point(r.x + r.width / 2, r.y); 				  //top
			_handles[2].point = new Point(r.x + r.width, r.y + r.height / 2);	  //right
			_handles[3].point = new Point(r.x + r.width / 2, r.y + r.height);	  //bottom
			_handles[4].point = new Point(r.x, r.y + r.height / 2); 			  //left
			_handles[5].point = new Point(r.x, r.y);							  //topLeft
			_handles[6].point = new Point(r.x + r.width, r.y); 					  //topRight
			_handles[7].point = new Point(r.x + r.width, r.y + r.height); 		  //bottomRight
			_handles[8].point = new Point(r.x, r.y + r.height);					  //bottomLeft
		}
		

//---- MOVE ------------------------------------------------------------------------------------------------------------------------

		/** @private **/
		private function onPressMove($e:Event):void {
			if (!_selLockPosition) {
				_isTransforming = true;
				_trackingInfo = {moved:false, offsetX:_parent.mouseX - _dummyBox.x, offsetY:_parent.mouseY - _dummyBox.y, x:_dummyBox.x, y:_dummyBox.y, mouseX:_parent.mouseX, mouseY:_parent.mouseY};
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveMove, false, 0, true);
				swapCursorIn(_moveCursor, null);
				lockCursor();
				onMouseMoveMove();
			}
		}
		
		/** @private **/
		private function onMouseMoveMove($e:MouseEvent = null):void {
			if (!_trackingInfo.moved && $e != null) {
				_trackingInfo.moved = true;
				dispatchInteractiveEvent(TransformEvent.START_INTERACTIVE_MOVE);
			}
			var x:Number = int(_parent.mouseX - (_dummyBox.x + _trackingInfo.offsetX));
			var y:Number = int(_parent.mouseY - (_dummyBox.y + _trackingInfo.offsetY));
			var totalX:Number = _parent.mouseX - _trackingInfo.mouseX;
			var totalY:Number = _parent.mouseY - _trackingInfo.mouseY;
			if (!isKeyDown(Keyboard.SHIFT)) {
				moveSelection(x, y);
			} else if (Math.abs(totalX) > Math.abs(totalY)) {
				moveSelection(x, _trackingInfo.y - _dummyBox.y);
			} else {
				moveSelection(_trackingInfo.x - _dummyBox.x, y);
			}
			if ($e != null) {
				$e.updateAfterEvent();
			}
		}
		
		/**
		 * Moves the selected items by a certain number of pixels on the x axis and y axis
		 * 
		 * @param $x Number of pixels to move the selected items along the x-axis (can be negative or positive)
		 * @param $y Number of pixels to move the selected items along the y-axis (can be negative or positive)
		 * @param $dispatchEvents If false, no MOVE Events will be dispatched
		 */
		public function moveSelection($x:Number, $y:Number, $dispatchEvents:Boolean = true):void {
			if (!_selLockPosition) {
				var safe:Object = {x:$x, y:$y};
				var m:Matrix = _dummyBox.transform.matrix;
				_dummyBox.x += $x;
				_dummyBox.y += $y;
				var i:int;
				if (_selMinBounds != null && !_selMinBounds.containsRect(_dummyBox.getBounds(_parent))) {
					for (i = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].moveCheck($x, $y, safe);
					}
					m.translate(safe.x, safe.y);
					_dummyBox.transform.matrix = m;
				}
				_ignoreEvents = true;
				for (i = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].move(safe.x, safe.y, false, $dispatchEvents);
				}
				_ignoreEvents = false;
				_origin.x = _dummyBox.x;
				_origin.y = _dummyBox.y;
				renderSelection();
				if (_dispatchMoveEvents && $dispatchEvents && (safe.x != 0 || safe.y != 0)) {
					dispatchEvent(new TransformEvent(TransformEvent.MOVE, _selectedItems.slice()));
				}
			}
		}
		
		/** @private **/
		private function onReleaseMove($e:Event):void {
			var clickTime:uint = getTimer();
			var mouseEvent:MouseEvent = ($e is MouseEvent) ? $e as MouseEvent : TransformEvent($e).mouseEvent;
			if (clickTime - _lastClickTime < 500 && _lastClickEvent != null && Math.abs(mouseEvent.stageX - _lastClickEvent.stageX) < 3 && Math.abs(mouseEvent.stageY - _lastClickEvent.stageY) < 3) {
				dispatchEvent(new TransformEvent(TransformEvent.DOUBLE_CLICK, _selectedItems.slice()));
			}
			_lastClickTime = clickTime;
			_lastClickEvent = mouseEvent;
			if (!_selLockPosition) {
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveMove);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseMove);
				unlockCursor();
				_isTransforming = false;
				if (_trackingInfo.moved) {
					dispatchInteractiveEvent(TransformEvent.FINISH_INTERACTIVE_MOVE);
				}
			}
		}


//---- SCALE ------------------------------------------------------------------------------------------------------------------------

		/** @private **/
		private function onPressScale($e:MouseEvent):void {
			if (!_selLockScale && (!_selHasTextFields || _selectedItems.length == 1)) {
				_isTransforming = true;
				setScaleOrigin($e.target as Sprite);
				captureScaleTrackingInfo($e.target as Sprite);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveScale, false, 0, true);
				_stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseScale, false, 0, true);
				lockCursor();
				onMouseMoveScale();
			}
		}
		
		/** @private **/
		private function setScaleOrigin($pressedHandle:Sprite):void {
			bringToFront($pressedHandle.parent);
			if (_scaleFromCenter) {
				centerOrigin();
			} else {
				var h:DisplayObject = _selection.getChildByName(_handlesDict[$pressedHandle].oppositeName);
				setOrigin(new Point(h.x, h.y));
			}
		}
		
		/** @private **/
		private function onMouseMoveScale($e:MouseEvent = null):void {
			if (!_trackingInfo.scaled && $e != null) {
				_trackingInfo.scaled = true;
				dispatchInteractiveEvent(TransformEvent.START_INTERACTIVE_SCALE);
			}
			updateScale(true, true);
			if ($e != null) {
				$e.updateAfterEvent();
			}
		}
		
		/** @private **/
		private function updateScale($x:Boolean = true, $y:Boolean = true):void {
			var ti:Object = _trackingInfo; //to speed things up
			var mx:Number = _parent.mouseX - ti.mouseOffsetX, my:Number = _parent.mouseY - ti.mouseOffsetY;
			
			if (_bounds != null) {
				if (mx >= _bounds.right) {
					mx = _bounds.right - 0.02;
				} else if (mx <= _bounds.left) {
					mx = _bounds.left + 0.02;
				}
				if (my >= _bounds.bottom) {
					my = _bounds.bottom - 0.02;
				} else if (my <= _bounds.top) {
					my = _bounds.top + 0.02;
				}
			}
			
			var dx:Number = mx - _origin.x; //Distance from mouse to origin (x)
			var dy:Number = _origin.y - my; //Distance from mouse to origin (y)
			var d:Number = Math.sqrt(dx * dx + dy * dy); //Distance from mouse to origin (total).
			var angleToMouse:Number = Math.atan2(dy, dx);
			
			var constrain:Boolean = (_selConstrainScale || isKeyDown(Keyboard.SHIFT));
			
			var newScaleX:Number, newScaleY:Number, xFactor:Number, yFactor:Number;
			if (constrain) {
				var angleDif:Number = (angleToMouse - ti.angleToMouse + Math.PI * 3.5) % (Math.PI * 2);
				if (angleDif < Math.PI) {
					d *= -1; //flip it when necessary to make the scaleX & scaleY negative.
				}
				newScaleX = d * ti.scaleRatioXConst;
				newScaleY = d * ti.scaleRatioYConst;
			} else {
				angleToMouse += ti.angle;
				newScaleX = ti.scaleRatioX * Math.cos(angleToMouse) * d;
				newScaleY = ti.scaleRatioY * Math.sin(angleToMouse) * d;
			}
			
			if (($x || constrain) && (newScaleX > 0.001 || newScaleX < -0.001)) {
				xFactor = newScaleX / _prevScaleX;
			} else {
				xFactor = 1;
			}
			if (($y || constrain) && (newScaleY > 0.001 || newScaleY < -0.001)) {
				yFactor = newScaleY / _prevScaleY;
			} else {
				yFactor = 1;
			}
			
			scaleSelection(xFactor, yFactor);
		}
		
		/**
		 * Scales the selected items along the x- and y-axis using multipliers. Keep in mind that these are
		 * not absolute values, so if a selected item's scaleX is 2 and you scaleSelection(2, 1), its new
		 * scaleX would be 4 because 2 &#42; 2 = 4. 
		 * 
		 * @param $sx Multiplier for scaling along the selection box's x-axis (which may or may not be the same as the selected item's y-axis, depending on whether or not multiple items are selected and if any are rotated)
		 * @param $sy Multiplier for scaling along the selection box's y-axis (which may or may not be the same as the selected item's y-axis, depending on whether or not multiple items are selected and if any are rotated)
		 * @param $dispatchEvents If false, no SCALE events will be dispatched
		 */
		public function scaleSelection($sx:Number, $sy:Number, $dispatchEvents:Boolean = true):void {
			if (!_selLockScale && (!_selHasTextFields || (_selectedItems.length == 1 && $sx > 0 && $sy > 0))) {
				var i:int;
				var m:Matrix = _dummyBox.transform.matrix;
				var m2:Matrix = m.clone(); //keep a fresh backup copy in case the bounds are violated and we need to re-apply the transformations after figuring out what's safe.
				
				var angle:Number = MatrixTools.getAngle(m, _flipX); //like _dummyBox.rotation * _DEG2RAD, but compatible with Flex
				var skew:Number = MatrixTools.getSkew(m);
				
				if (angle != -skew && Math.abs((angle + skew) % (Math.PI - 0.01)) < 0.01) { //protects against rounding errors in tiny decimals
					skew = -angle;
				}
				
				MatrixTools.scaleMatrix(m, $sx, $sy, angle, skew);
				
				_dummyBox.transform.matrix = m;
				
				var safe:Object = {sx:$sx, sy:$sy};
				if (_selHasSizeLimits || (_selMinBounds != null && !_selMinBounds.containsRect(_dummyBox.getBounds(_parent)))) {
					for (i = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].scaleCheck(safe, angle, skew, (_selConstrainScale || isKeyDown(Keyboard.SHIFT)));
					}
					MatrixTools.scaleMatrix(m2, safe.sx, safe.sy, angle, skew);
					_dummyBox.transform.matrix = m2;
				}
				_ignoreEvents = true;
				for (i = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].scaleRotated(safe.sx, safe.sy, angle, skew, false, $dispatchEvents);
				}
				_ignoreEvents = false;
				if (safe.sx < 0) {
					_flipX = !_flipX;
				}
				
				_prevScaleX *= safe.sx;
				_prevScaleY *= safe.sy;
				
				renderSelection();
				if (_dispatchScaleEvents && $dispatchEvents && (safe.sx != 1 || safe.sy != 1)) {
					dispatchEvent(new TransformEvent(TransformEvent.SCALE, _selectedItems.slice()));
				}
			}
		}
		
		/** Flips the selected items horizontally **/
		public function flipSelectionHorizontal():void {
			if (_enabled && _selectedItems.length != 0) {
				scaleSelection(-1, 1);
			}
		}
		
		/** Flips the selected items vertically **/
		public function flipSelectionVertical():void {
			if (_enabled && _selectedItems.length != 0) {
				scaleSelection(1, -1);
			}
		}
		
		/** @private **/
		private function onReleaseScale($e:MouseEvent):void {
			if (!_selLockScale) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseScale);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveScale);
				unlockCursor();
				centerOrigin();
				_isTransforming = false;
				if (_trackingInfo.scaled) {
					dispatchInteractiveEvent(TransformEvent.FINISH_INTERACTIVE_SCALE);
				}
			}
		}
		
		/** @private **/
		private function captureScaleTrackingInfo($handle:Sprite):void {
			var handlePoint:Point = _parent.globalToLocal($handle.localToGlobal(new Point(0, 0)));
			
			var mdx:Number = handlePoint.x - _origin.x; //Distance to mouse along the x-axis
			var mdy:Number = _origin.y - handlePoint.y; //Distance to mouse along the y-axis
			var distanceToMouse:Number = Math.sqrt(mdx * mdx + mdy * mdy);
			var angleToMouse:Number = Math.atan2(mdy, mdx);
			
			var m:Matrix = _dummyBox.transform.matrix;
			
			var angle:Number = MatrixTools.getAngle(m, _flipX); //like _dummyBox.rotation * _DEG2RAD, but compatible with Flex
			var skew:Number = MatrixTools.getSkew(m);
			var correctedAngle:Number = angleToMouse + angle; //Rotated (corrected) angle to mouse (as though we tilted everything including the mouse position so that the _dummyBox is at a 0 degree angle)
			
			var scaleX:Number = _prevScaleX = MatrixTools.getScaleX(m, _flipX);
			var scaleY:Number = _prevScaleY = MatrixTools.getScaleY(m, _flipX);
			
			_trackingInfo = {scaleRatioX:scaleX / (Math.cos(correctedAngle) * distanceToMouse),
							 scaleRatioY:scaleY / (Math.sin(correctedAngle) * distanceToMouse),
							 scaleRatioXConst:scaleX / distanceToMouse,
							 scaleRatioYConst:scaleY / distanceToMouse,
							 angleToMouse:positiveAngle(angleToMouse),
							 angle:angle,
							 skew:skew,
							 mouseX:_parent.mouseX,
							 mouseY:_parent.mouseY,
							 scaleX:scaleX,
							 scaleY:scaleY,
							 mouseOffsetX:_parent.mouseX - handlePoint.x,
							 mouseOffsetY:_parent.mouseY - handlePoint.y,
							 handle:$handle,
							 scaled:false};
		}
		

//---- STRETCH HORIZONTAL ------------------------------------------------------------------------------------------------------------
		
		/** @private **/
		private function onPressStretchH($e:MouseEvent):void {
			if (!_selLockScale) {
				_isTransforming = true;
				setScaleOrigin($e.target as Sprite);
				captureScaleTrackingInfo($e.target as Sprite);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveStretchH, false, 0, true);
				_stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseStretchH, false, 0, true);
				lockCursor();
				onMouseMoveStretchH();
			}
		}
		
		/** @private **/
		private function onMouseMoveStretchH($e:MouseEvent = null):void {
			if (!_trackingInfo.scaled && $e != null) {
				_trackingInfo.scaled = true;
				dispatchInteractiveEvent(TransformEvent.START_INTERACTIVE_SCALE);
			}
			updateScale(true, false);
			if ($e != null) {
				$e.updateAfterEvent();
			}
		}
		
		/** @private **/
		private function onReleaseStretchH($e:MouseEvent):void {
			if (!_selLockScale) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseStretchH);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveStretchH);
				unlockCursor();
				centerOrigin();
				_isTransforming = false;
				if (_trackingInfo.scaled) {
					dispatchInteractiveEvent(TransformEvent.FINISH_INTERACTIVE_SCALE);
				}
			}
		}
		
		
//---- STRETCH VERTICAL ------------------------------------------------------------------------------------------------------------
	
		/** @private **/
		private function onPressStretchV($e:MouseEvent):void {
			if (!_selLockScale) {
				_isTransforming = true;
				setScaleOrigin($e.target as Sprite);
				captureScaleTrackingInfo($e.target as Sprite);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveStretchV, false, 0, true);
				_stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseStretchV, false, 0, true);
				lockCursor();
				onMouseMoveStretchV();
			}
		}
		
		/** @private **/
		private function onMouseMoveStretchV($e:MouseEvent = null):void {
			if (!_trackingInfo.scaled && $e != null) {
				_trackingInfo.scaled = true;
				dispatchInteractiveEvent(TransformEvent.START_INTERACTIVE_SCALE);
			}
			updateScale(false, true);
			if ($e != null) {
				$e.updateAfterEvent();
			}
		}
		
		/** @private **/
		private function onReleaseStretchV($e:MouseEvent):void {
			if (!_selLockScale) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseStretchV);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveStretchV);
				unlockCursor();
				centerOrigin();
				_isTransforming = false;
				if (_trackingInfo.scaled) {
					dispatchInteractiveEvent(TransformEvent.FINISH_INTERACTIVE_SCALE);
				}
			}
		}
		
		

//---- ROTATE -------------------------------------------------------------------------------------------------------------------------

		/** @private **/
		private function onPressRotate($e:MouseEvent):void {
			if (!_selLockRotation) {
				_isTransforming = true;
				centerOrigin();
				
				var mdx:Number = _parent.mouseX - _origin.x; //Distance to mouse along the x-axis
				var mdy:Number = _origin.y - _parent.mouseY; //Distance to mouse along the y-axis
				var angleToMouse:Number = Math.atan2(mdy, mdx);
				var angle:Number = _dummyBox.rotation * _DEG2RAD;
				
				_trackingInfo = {angleToMouse:positiveAngle(angleToMouse),
								 angle:angle,
								 mouseX:_parent.mouseX,
								 mouseY:_parent.mouseY,
								 rotation:_dummyBox.rotation,
								 handle:$e.target,
								 rotated:false};
				
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveRotate, false, 0, true);
				_stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseRotate, false, 0, true);
				lockCursor();
				onMouseMoveRotate();
			}
		}
		
		/** @private **/
		private function onMouseMoveRotate($e:MouseEvent = null):void {
			var ti:Object = _trackingInfo; //to speed things up
			if (!ti.rotated && $e != null) {
				_trackingInfo.rotated = true;
				dispatchInteractiveEvent(TransformEvent.START_INTERACTIVE_ROTATE);
			}
			
			var dx:Number = _parent.mouseX - _origin.x; //Distance from mouse to origin (x)
			var dy:Number = _origin.y - _parent.mouseY; //Distance from mouse to origin (y)
			var angleToMouse:Number = Math.atan2(dy, dx);
			
			var angleDifference:Number = ti.angleToMouse - Math.atan2(dy, dx);
			var newAngle:Number = angleDifference + ti.angle;
			
			if (isKeyDown(Keyboard.SHIFT)) {
				var angleIncrement:Number = Math.PI * 0.25; //45 degrees
				newAngle = Math.round(newAngle / angleIncrement) * angleIncrement;
			}
			newAngle -= _dummyBox.rotation * _DEG2RAD;
			if (Math.abs(newAngle) > 0.25 * _DEG2RAD) {
				rotateSelection(newAngle % (Math.PI * 2));
			}
			if ($e != null) {
				$e.updateAfterEvent();
			}
		}
		
		/**
		 * Rotates the selected items by a particular angle (in Radians). This is NOT an absolute value, so if one
		 * of the selected items' rotation property is Math.PI and you <code>rotateSelection(Math.PI)</code>, the new
		 * angle would be Math.PI &#42; 2.
		 * 
		 * @param $angle Angle (in Radians) that should be added to the selected items' current rotation
		 * @param $dispatchEvents If false, no ROTATE events will be dispatched
		 */
		public function rotateSelection($angle:Number, $dispatchEvents:Boolean = true):void {
			if (!_selLockRotation) {
				var i:int;
				var m:Matrix = _dummyBox.transform.matrix;
				var m2:Matrix = m.clone(); //keep a fresh backup copy in case the bounds are violated and we need to re-apply the transformations after figuring out what's safe.
				m.tx = m.ty = 0;
				m.rotate($angle);
				m.tx = _origin.x, 
				m.ty = _origin.y;
				_dummyBox.transform.matrix = m;
				
				var safe:Object = {angle:$angle};
				if (_selMinBounds != null && !_selMinBounds.containsRect(_dummyBox.getBounds(_parent))) {
					for (i = _selectedItems.length - 1; i > -1; i--) {
						_selectedItems[i].rotateCheck(safe);
					}
					m2.tx = m2.ty = 0;
					m2.rotate(safe.angle);
					m2.tx = _origin.x, 
					m2.ty = _origin.y;
					_dummyBox.transform.matrix = m2;
				}
				_ignoreEvents = true;
				for (i = _selectedItems.length - 1; i > -1; i--) {
					_selectedItems[i].rotate(safe.angle, false, $dispatchEvents);
				}
				_ignoreEvents = false;
				renderSelection();
				if (_dispatchRotateEvents && $dispatchEvents && safe.angle % (Math.PI * 2) != 0) {
					dispatchEvent(new TransformEvent(TransformEvent.ROTATE, _selectedItems.slice()));
				}
			}
		}
		
		/** @private **/
		private function onReleaseRotate($e:MouseEvent):void {
			if (!_selLockRotation) {
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseRotate);
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveRotate);
				unlockCursor();
				_isTransforming = false;
				if (_trackingInfo.rotated) {
					dispatchInteractiveEvent(TransformEvent.FINISH_INTERACTIVE_ROTATE);
				}
			}
		}
	
		
//---- CURSOR FUNCTIONS ----------------------------------------------------------------------------------------------------------
		
		/**
		 * Facilitates the customization of the move cursor so that you can optionally define a Shape object
		 * to use as a cursor (if null, TransformManager will use its default move cursor), and also optionally
		 * hide the Mouse when the cursor is used and/or define x and y offset values (measured from the 
		 * Mouse position). For example, to use the default move cursor but have it act as a decorator for the 
		 * Mouse instead of replacing it, you could do this:<p><code>
		 * 
		 * TransformManager.customizeMoveCursor(null, false, 20, 24);</code></p>
		 * 
		 * @param cursor The custom Shape object that should be used for the cursor. If <code>null</code>, TransformManager will use its default move cursor Shape.
		 * @param hideMouse If <code>true</code>, the Mouse cursor will be hidden when the custom cursor is used.
		 * @param xOffset The number of pixels to offset the custom cursor horizontally, measured from the Mouse position.
		 * @param yOffset The number of pixels to offset the custom cursor vertically, measured from the Mouse position.
		 */
		public static function customizeMoveCursor(cursor:Shape=null, hideMouse:Boolean=true, xOffset:Number=0, yOffset:Number=0):void {
			_moveCursor = _applyCursor(_moveCursor, cursor || _createMoveCursor(0, 0), hideMouse, xOffset, yOffset, false);
		}
		
		/**
		 * Facilitates the customization of the scale cursor so that you can optionally define a Shape object
		 * to use as a cursor (if null, TransformManager will use its default scale cursor), and also optionally
		 * hide the Mouse when the cursor is used and/or define x and y offset values (measured from the 
		 * Mouse position). For example, to use the default scale cursor but have it act as a decorator for the 
		 * Mouse instead of replacing it, you could do this:<p><code>
		 * 
		 * TransformManager.customizeScaleCursor(null, false, 16, 26, false);</code></p>
		 * 
		 * @param cursor The custom Shape object that should be used for the cursor. If <code>null</code>, TransformManager will use its default scale cursor Shape.
		 * @param hideMouse If <code>true</code>, the Mouse cursor will be hidden when the custom cursor is used.
		 * @param xOffset The number of pixels to offset the custom cursor horizontally, measured from the Mouse position.
		 * @param yOffset The number of pixels to offset the custom cursor vertically, measured from the Mouse position.
		 * @param autoRotate To automatically rotate the cursor based on its position on the selection, set <code>autoRotate</code> to <code>true</code>.
		 */
		public static function customizeScaleCursor(cursor:Shape=null, hideMouse:Boolean=true, xOffset:Number=0, yOffset:Number=0, autoRotate:Boolean=true):void {
			_scaleCursor = _applyCursor(_scaleCursor, cursor || _createScaleCursor(0, 0), hideMouse, xOffset, yOffset, autoRotate);
		}
		
		/**
		 * Facilitates the customization of the rotation cursor so that you can optionally define a Shape object
		 * to use as a cursor (if null, TransformManager will use its default rotation cursor), and also optionally
		 * hide the Mouse when the cursor is used and/or define x and y offset values (measured from the 
		 * Mouse position). For example, to use the default rotation cursor but have it act as a decorator for the 
		 * Mouse instead of replacing it, you could do this:<p><code>
		 * 
		 * TransformManager.customizeRotationCursor(null, false, 15, 21, false);</code></p>
		 * 
		 * @param cursor The custom Shape object that should be used for the cursor. If <code>null</code>, TransformManager will use its default rotation cursor Shape.
		 * @param hideMouse If <code>true</code>, the Mouse cursor will be hidden when the custom cursor is used.
		 * @param xOffset The number of pixels to offset the custom cursor horizontally, measured from the Mouse position.
		 * @param yOffset The number of pixels to offset the custom cursor vertically, measured from the Mouse position.
		 * @param autoRotate To automatically rotate the cursor based on its position on the selection, set <code>autoRotate</code> to <code>true</code>.
		 */
		public static function customizeRotationCursor(cursor:Shape=null, hideMouse:Boolean=true, xOffset:Number=0, yOffset:Number=0, autoRotate:Boolean=true):void {
			_rotationCursor = _applyCursor(_rotationCursor, cursor || _createRotationCursor(0, 0), hideMouse, xOffset, yOffset, autoRotate);
		}
		
		/** @private **/
		private static function _applyCursor(cursor:CustomCursor, shape:Shape, hideMouse:Boolean, xOffset:Number, yOffset:Number, autoRotate:Boolean):CustomCursor {
			shape.visible = false;
			if (cursor == null) {
				return new CustomCursor(shape, hideMouse, xOffset, yOffset, autoRotate);
			}
			if (cursor.shape != null && cursor.shape.parent != null) {
				cursor.shape.parent.removeChild(cursor.shape);
			}
			cursor.shape = shape;
			cursor.hideMouse = hideMouse;
			cursor.xOffset = xOffset;
			cursor.yOffset = yOffset;
			cursor.autoRotate = autoRotate;
			return cursor;
		}
		
		/** @private **/
		private function swapCursorIn(cursor:CustomCursor, handle:Object):void {
			if (_currentCursor != cursor && _stage != null) {
				var hadCursorControl:Boolean;
				if (_currentCursor != null) {
					hadCursorControl = true;
					swapCursorOut(null);
				}
				_currentCursor = cursor;
				_cursorManager = this;
				if (_currentCursor.hideMouse) {
					Mouse.hide();
				}
				var parentRotation:Number = MatrixTools.getAngle(_parent.transform.concatenatedMatrix, false) * _RAD2DEG;
				_stage.addChild(_currentCursor.shape); //required because in some AIR applications that spawn multiple windows, there can be different stages.
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, snapCursor);
				if (handle != null && _currentCursor.autoRotate) {
					_currentCursor.shape.rotation = handle.handle.rotation + handle.cursorRotation + parentRotation;
				}
				_currentCursor.shape.visible = true;
				bringToFront(_currentCursor.shape);
				snapCursor();
				if (!hadCursorControl) {
					dispatchEvent(new TransformEvent(TransformEvent.SEIZE_CURSOR, _selectedItems.slice()));
				}
			}
		}
		
		/** @private **/
		private function swapCursorOut($e:Event = null):void {
			if (_currentCursor != null) {
				if (_lockCursor) {
					_onUnlock = swapCursorOut;
					_onUnlockParam = $e;
				} else if (_stage) {
					_stage.removeEventListener(MouseEvent.MOUSE_MOVE, snapCursor);
					if (_cursorManager == this) { //protects from errors when there are multiple TransformManager instances and the one releasing cursor control fires swapCursorOut() AFTER the one gaining control fires swapCursorIn()
						if (_currentCursor.hideMouse) {
							Mouse.show();
						}
						_currentCursor.shape.visible = false;
						_currentCursor = null;
						
						if (!this.mouseIsOverSelection(false)) {
							dispatchEvent(new TransformEvent(TransformEvent.RELEASE_CURSOR, _selectedItems.slice()));
						}
						
					}
				}
			}
		}
		
		/** @private **/
		private function snapCursor($e:MouseEvent = null):void {
			if (_currentCursor != null) {
				_currentCursor.shape.x = _currentCursor.shape.stage.mouseX + _currentCursor.xOffset;
				_currentCursor.shape.y = _currentCursor.shape.stage.mouseY + _currentCursor.yOffset;
			}
			if ($e != null) {
				$e.updateAfterEvent();
			}
		}
		
		/** @private **/
		private function onRollOverScale($e:MouseEvent):void {
			if (!_selLockScale && (!_selHasTextFields || _selectedItems.length == 1)) {
				if (_lockCursor) {
					_onUnlock = onRollOverScale;
					_onUnlockParam = $e;
				} else {
					swapCursorIn(_scaleCursor, _handlesDict[$e.target]);
				}
			}
		}
		
		/** @private **/
		private function onRollOverRotate($e:MouseEvent):void {
			if (!_selLockRotation) {
				if (_lockCursor) {
					_onUnlock = onRollOverRotate;
					_onUnlockParam = $e;
				} else {
					swapCursorIn(_rotationCursor, _handlesDict[$e.target]);
				}
			}
		}
		
		/** @private **/
		private function onRollOverMove($e:Event=null):void {
			if (!_selLockPosition) {
				if (_lockCursor) {
					_onUnlock = onRollOverMove;
					_onUnlockParam = $e;
				} else {
					swapCursorIn(_moveCursor, null);
				}
			}
		}
		
		/** @private **/
		private function onRollOverSelectedItem($e:TransformEvent):void {
			if (!_selLockPosition && !$e.items[0].hasSelectableText) {
				if (_lockCursor) {
					_onUnlock = onRollOverSelectedItem;
					_onUnlockParam = $e;
				} else {
					swapCursorIn(_moveCursor, null);
				}
			}
		}
		
		/** @private **/
		private function onRollOutSelectedItem($e:TransformEvent):void {
			swapCursorOut(null);
		}
		
		/** @private **/
		private function setCursorListeners($on:Boolean = true):void {
			var s:Sprite, r:Sprite, i:int;
			for (i = _handles.length - 1; i > -1; i--) {
				s = _handles[i].handle.getChildByName("scaleHandle");
				r = _handles[i].handle.getChildByName("rotationHandle");
				if (_handles[i].handle.name != "c") {
					if ($on) {
						s.addEventListener(MouseEvent.ROLL_OVER, onRollOverScale, false, 0, true);
						s.addEventListener(MouseEvent.ROLL_OUT, swapCursorOut, false, 0, true);
						if (r != null) {
							r.addEventListener(MouseEvent.ROLL_OVER, onRollOverRotate, false, 0, true);
							r.addEventListener(MouseEvent.ROLL_OUT, swapCursorOut, false, 0, true);
						}
					} else {
						s.removeEventListener(MouseEvent.ROLL_OVER, onRollOverScale);
						s.removeEventListener(MouseEvent.ROLL_OUT, swapCursorOut);
						if (r != null) {
							r.removeEventListener(MouseEvent.ROLL_OVER, onRollOverRotate);
							r.removeEventListener(MouseEvent.ROLL_OUT, swapCursorOut);
						}
					}
				} else {
					if ($on) {
						s.addEventListener(MouseEvent.ROLL_OVER, onRollOverMove, false, 0, true);
						s.addEventListener(MouseEvent.ROLL_OUT, swapCursorOut, false, 0, true);
					} else {
						s.removeEventListener(MouseEvent.ROLL_OVER, onRollOverMove);
						s.removeEventListener(MouseEvent.ROLL_OUT, swapCursorOut);
					}
				}
			}
			
			if ($on) {
				_edges.addEventListener(MouseEvent.ROLL_OVER, onRollOverMove, false, 0, true);
				_edges.addEventListener(MouseEvent.ROLL_OUT, swapCursorOut, false, 0, true);
			} else {
				_edges.removeEventListener(MouseEvent.ROLL_OVER, onRollOverMove);
				_edges.removeEventListener(MouseEvent.ROLL_OUT, swapCursorOut);
			}
		}
		
		/** @private **/
		protected function lockCursor():void {
			_lockCursor = true;
			_onUnlock = null;
			_onUnlockParam = null;
		}
		
		/** @private **/
		protected function unlockCursor():void {
			_lockCursor = false;
			if (_onUnlock != null) {
				_onUnlock(_onUnlockParam);
			}
		}
		
		/** @private **/
		protected function mouseIsOverSelection($ignoreSelectableTextItems:Boolean=false):Boolean {
			if (_selectedItems.length == 0 || _stage == null) {
				return false;
			} else if (_selection.hitTestPoint(_stage.mouseX, _stage.mouseY, true)) {
				return true;
			} else {
				for (var i:int = _selectedItems.length - 1; i > -1; i--) {
					 if (_selectedItems[i].targetObject.hitTestPoint(_stage.mouseX, _stage.mouseY, true) && !(_selectedItems[i].hasSelectableText && $ignoreSelectableTextItems)) {
						return true;
					}
				}
			}
			return false;
		}
		
		/** @private **/
		private static function _createScaleCursor(xOffset:Number=0, yOffset:Number=0):Shape {
			var ln:Number = 9; //length
			var s:Shape = new Shape();
			var g:Graphics = s.graphics;
			var clr:uint, lw:uint;
			for (var i:int = 0; i < 2; i++) {
				if (i == 0) {
					clr = 0xFFFFFF;
					lw = 5;
				} else {
					clr = 0x000000;
					lw = 2;
				}
				g.lineStyle(lw, clr, 1, false, null, "square", "miter", 3);
				
				g.beginFill(clr, 1);
				g.moveTo(xOffset - ln, 		yOffset);
				g.lineTo(xOffset + 2 - ln, 	yOffset - 1.5);
				g.lineTo(xOffset + 2 - ln, 	yOffset + 1.5);
				g.lineTo(xOffset - ln, 		yOffset);
				g.endFill();
				g.moveTo(xOffset + 2 - ln, 	yOffset);
				g.lineTo(xOffset - 2, 		yOffset);
				g.moveTo(xOffset - ln, 		yOffset);
				
				g.beginFill(clr, 1);
				g.moveTo(xOffset + ln, 		yOffset);
				g.lineTo(xOffset + ln - 2, 	yOffset - 1.5);
				g.lineTo(xOffset + ln - 2, 	yOffset + 1.5);
				g.lineTo(xOffset + ln, 		yOffset);
				g.endFill();
				g.moveTo(xOffset + 2, 		yOffset);
				g.lineTo(xOffset + ln - 2, 	yOffset);
				g.moveTo(xOffset + 2, 		yOffset);
			}
			return s;
		}
		
		/** @private **/
		private static function _createRotationCursor(xOffset:Number=0, yOffset:Number=0):Shape {
			var aw:Number = 2; //arrow width
			var sb:Number = 6; //space between arrows
			var s:Shape = new Shape();
			var g:Graphics = s.graphics;
			var clr:uint, lw:uint;
			for (var i:int = 0; i < 2; i++) {
				if (i == 0) {
					clr = 0xFFFFFF;
					lw = 5;
				} else {
					clr = 0x000000;
					lw = 2;
				}
				g.lineStyle(lw, clr, 1, false, null, "square", "miter", 3);
				
				g.beginFill(clr, 1);
				g.moveTo(xOffset, 		yOffset - sb);
				g.lineTo(xOffset, 		yOffset - sb - aw);
				g.lineTo(xOffset + aw, 	yOffset - sb - aw);
				g.lineTo(xOffset, 		yOffset - sb);
				g.endFill();
				
				g.beginFill(clr, 1);
				g.moveTo(xOffset, 		yOffset + sb);
				g.lineTo(xOffset, 		yOffset + sb + aw);
				g.lineTo(xOffset + aw, 	yOffset + sb + aw);
				g.lineTo(xOffset, 		yOffset + sb);
				g.endFill();
				
				g.lineStyle(lw, clr, 1, false, null, "none", "miter", 3);
				g.moveTo(xOffset + aw / 2, yOffset - sb - aw / 2);
				g.curveTo(xOffset + aw * 4.5, yOffset, xOffset + aw / 2, yOffset + sb + aw / 2);
				g.moveTo(xOffset, yOffset);
			}
			s.rotation = 45;
			return s;
		}
		
		/** @private **/
		private static function _createMoveCursor(xOffset:Number=0, yOffset:Number=0):Shape {
			var ln:Number = 8; //length
			var s:Shape = new Shape();
			var g:Graphics = s.graphics;
			var clr:uint, lw:uint, i:int;
			for (i = 0; i < 2; i++) {
				if (i == 0) {
					clr = 0xFFFFFF;
					lw = 5;
				} else {
					clr = 0x000000;
					lw = 2;
				}
				g.lineStyle(lw, clr, 1, false, null, "square", "miter", 3);
				
				g.beginFill(clr, 1);
				g.moveTo(xOffset - ln, 		yOffset);
				g.lineTo(xOffset + 2 - ln, 	yOffset - 1.5);
				g.lineTo(xOffset + 2 - ln, 	yOffset + 1.5);
				g.lineTo(xOffset + -ln, 	yOffset);
				g.endFill();
				g.beginFill(clr, 1);
				g.moveTo(xOffset + 2 - ln, 	yOffset);
				g.lineTo(xOffset + ln, 		yOffset);
				g.moveTo(xOffset + ln, 		yOffset);
				g.lineTo(xOffset + ln - 2, 	yOffset - 1.5);
				g.lineTo(xOffset + ln - 2, 	yOffset + 1.5);
				g.lineTo(xOffset + ln, 		yOffset);
				g.endFill();
				
				g.beginFill(clr, 1);
				g.moveTo(xOffset, 		yOffset - ln);
				g.lineTo(xOffset - 1.5, yOffset + 2 - ln);
				g.lineTo(xOffset + 1.5, yOffset + 2 - ln);
				g.lineTo(xOffset, 		yOffset - ln);
				g.endFill();
				g.beginFill(clr, 1);
				g.moveTo(xOffset, 		yOffset + 2 - ln);
				g.lineTo(xOffset, 		yOffset + ln);
				g.moveTo(xOffset, 		yOffset + ln);
				g.lineTo(xOffset - 1.5, yOffset + ln - 2);
				g.lineTo(xOffset + 1.5, yOffset + ln - 2);
				g.lineTo(xOffset, 		yOffset + ln);
				g.endFill();
			}
			return s;
		}
		
		
//---- KEYBOARD HANDLING ------------------------------------------------------------------------------------------------------
	
		/** @private **/
		private static function initKeyListeners($stage:DisplayObjectContainer):void {
			if (!($stage in _keyListenerInits)) {
				_keysDown = {};
				$stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
            	$stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
            	$stage.addEventListener(Event.DEACTIVATE, clearKeys);
            	_keyListenerInits[$stage] = $stage;
            }
		}
		
		/** @private **/
		public static function isKeyDown($keyCode:uint):Boolean {
            if (_keysDown == null) {
                throw new Error("Key class has yet been initialized.");
            }
            return Boolean($keyCode in _keysDown);
        }
        
        /** @private **/
		private static function onKeyPress($e:KeyboardEvent):void {
            _keysDown[$e.keyCode] = true;
            if ($e.keyCode == Keyboard.DELETE || $e.keyCode == Keyboard.BACKSPACE) {
            	_keyDispatcher.dispatchEvent(new KeyboardEvent("pressDelete"));
            } else if ($e.keyCode == Keyboard.SHIFT || $e.keyCode == Keyboard.CONTROL) {
            	_keyDispatcher.dispatchEvent(new KeyboardEvent("pressMultiSelectKey"));
            } else if($e.keyCode == Keyboard.UP || $e.keyCode == Keyboard.DOWN || $e.keyCode == Keyboard.LEFT || $e.keyCode == Keyboard.RIGHT) {
        		var kbe:KeyboardEvent = new KeyboardEvent("pressArrowKey", true, false, $e.charCode, $e.keyCode, $e.keyLocation, $e.ctrlKey, $e.altKey, $e.shiftKey);
        		_keyDispatcher.dispatchEvent(kbe);
            }
        }
        
        /** @private **/
		private static function onKeyRelease($e:KeyboardEvent):void {
        	if ($e.keyCode == Keyboard.SHIFT || $e.keyCode == Keyboard.CONTROL) {
        		_keyDispatcher.dispatchEvent(new KeyboardEvent("releaseMultiSelectKey"));
        	}
        	delete _keysDown[$e.keyCode];
        }
        
        /** @private **/
		private static function clearKeys($e:Event):void {
        	_keysDown = {};
        }
        
        /** @private **/
		private function onPressMultiSelectKey($e:Event=null):void {
        	if (_allowMultiSelect && !_multiSelectMode) {
        		_multiSelectMode = true;
        	}
        }
        
        /** @private **/
		private function onReleaseMultiSelectKey($e:Event=null):void {
        	if (_multiSelectMode && _allowMultiSelect) {
        		_multiSelectMode = false;
        	}
        }
        
//---- XML EXPORTING AND APPLYING ------------------------------------------------------------------------------
		
		/**
		 * A common request is to capture the current state of each item's scale/rotation/position and the TransformManager's
		 * settings in an easy-to-store format so that the data can be reloaded and applied later; <code>exportFullXML()</code> 
		 * returns an XML object containing exactly that. The TransformManager's settings and each item's transform data is
		 * stored in the following format:
		 * @example <listing version="3.0">
&amp;lt;transformManager&amp;gt;
  &amp;lt;settings allowDelete="1" allowMultiSelect="1" autoDeselect="1" constrainScale="0" lockScale="1" scaleFromCenter="0" lockRotation="0" lockPosition="0" arrowKeysMove="0" forceSelectionToFront="1" lineColor="3381759" handleColor="16777215" handleSize="8" paddingForRotation="12" hideCenterHandle="0"/&amp;gt;
  &amp;lt;items&amp;gt;
    &amp;lt;item name="mc1" level="1" a="0.9999847412109375" b="0" c="0" d="0.9999847412109375" tx="79.2" ty="150.5" xOffset="-23.4" yOffset="-34.35" rawWidth="128.6" rawHeight="110.69999999999999" scaleMode="scaleNormal" hasSelectableText="0" minScaleX="-Infinity" maxScaleX="Infinity" minScaleY="-Infinity" maxScaleY="Infinity"/&amp;gt;
    &amp;lt;item name="mc2" level="18" a="0.7987213134765625" b="0.2907257080078125" c="-0.2907257080078125" d="0.7987213134765625" tx="222.5" ty="92.25" xOffset="0" yOffset="0" rawWidth="287.85" rawHeight="215.8" scaleMode="scaleNormal" hasSelectableText="0" minScaleX="-Infinity" maxScaleX="Infinity" minScaleY="-Infinity" maxScaleY="Infinity"/&amp;gt;
    &amp;lt;item name="text_ti" level="4" a="1" b="0" c="0" d="1" tx="32" ty="303.95" xOffset="-2" yOffset="-2" rawWidth="188" rawHeight="37.2" scaleMode="scaleWidthAndHeight" hasSelectableText="1" minScaleX="-Infinity" maxScaleX="Infinity" minScaleY="-Infinity" maxScaleY="Infinity"/&amp;gt;
  &amp;lt;/items&amp;gt;
&amp;lt;/transformManager&amp;gt;
			</listing>
		 * 
		 * <p>You can use applyFullXML() to reapply the exported XML.</p>
		 * 
		 * @see #exportItemXML()
		 * @see #applyItemXML()
		 * @see #applyFullXML()
		 * @see #exportSettingsXML()
		 * @see #applySettingsXML()
		 * @return An XML representation of the current state of the TransformManager instance and all of the items it is managing.
		 */
		public function exportFullXML():XML {
			var xmlItems:XML = <items></items>
			var l:uint = _items.length;
			var i:int;
			for (i = 0; i < l; i++) {
				xmlItems.appendChild(exportItemXML(_items[i].targetObject));
			}
			var settings:XML = exportSettingsXML();
			var xml:XML = <transformManager></transformManager>
			xml.appendChild(settings);
			xml.appendChild(xmlItems);
			return xml;
		}
		
		/**
		 * Applies XML generated by <code>exportFullXML()</code> to the TransformManager instance including all settings
		 * and each item's scale/rotation/position. This does not load any external images/assets - you must do that separately. 
		 * Typically it's best to fully load the assets first and add them to the display list before calling <code>applyFullXML()</code>.
		 * When <code>applyFullXML()</code> is called, it attempts to find the targetObjects in the display list based on their names,
		 * but for each one that cannot be found, a new Sprite will be created and added as a placeholder, filled with the 
		 * <code>placeholderColor</code> and named identically. An array of those placeholders (if any) is returned by 
		 * <code>applyFullXML()</code> which makes it easy to loop through and load your images/assets directly into those 
		 * placeholder Sprites. Feel free to add visual preloaders, alter the look of the Sprites, etc.
		 * 
		 * @see #exportItemXML()
		 * @see #applyItemXML()
		 * @see #exportFullXML()
		 * @see #exportSettingsXML()
		 * @see #applySettingsXML()
		 * @param xml An XML object containing data about the settings and each item's position/scale/rotation. This XML is typically created using <code>exportFullXML()</code>.
		 * @param defaultParent If no items have been added to the TransformManager yet, it won't know which DisplayObjectContainer to look in for targetObjects, so it is important to explicitly tell TransformManager what default parent to use.
		 * @param placeholderColor If an item's targetObject cannot be found in the display list (based on its name), it will create a new Sprite and fill it with this color, using it as a placeholder.
		 * @return An array of placeholders that were created for missing targetObjects (if any). You can loop through these and load your assets accordingly. Keep in mind that the placeholders will have the same name as was defined in the XML (from the original targetObject).
		 */
		public function applyFullXML(xml:XML, defaultParent:DisplayObjectContainer, placeholderColor:uint=0xCCCCCC):Array {
			var node:XML, mc:DisplayObject;
			
			applySettingsXML(xml.settings[0]);
			
			var parent:DisplayObjectContainer = _parent || defaultParent;
			var missing:Array = [];
			var all:Array = [];
			var isMissing:Boolean;
			var list:XMLList = xml.items[0].item;
			for each (node in list) {
				isMissing = Boolean(parent.getChildByName(xml.@name) == null);
				mc = applyItemXML(node, parent, placeholderColor);
				all.push({level:Number(node.@level), mc:mc, node:node});
				if (isMissing) {
					missing.push(mc);
				}
			}
			all.sortOn("level", Array.NUMERIC | Array.DESCENDING);
			var numChildren:uint = parent.numChildren;
			var i:int = all.length;
			
			while (i--) {
				if (all[i].level < numChildren && all[i].mc.parent == parent) {
					if (parent.hasOwnProperty("setElementIndex")) { //for Flex compatibility (spark)
						(parent as Object).setElementIndex(all[i].mc, all[i].level);
					} else {
						parent.setChildIndex(all[i].mc, all[i].level);
					}
				}
			}
			
			return missing;
		}
		
		/**
		 * Exports transform data (scale/rotation/position) of a particular DisplayObject in XML format so that
		 * it can be saved to a database or elsewhere easily and then reapplied later. If you'd like to export all
		 * settings and every item's data, use the <code>exportFullXML()</code> instead. <code>exportItemXML()</code>
		 * returns an XML object in the following format:
		 * @example <listing version="3.0">
&amp;lt;item name="mc1" level="1" a="0.98" b="0" c="0" d="0.9" tx="79.2" ty="150.5" xOffset="-23.4" yOffset="-34.35" rawWidth="128.6" rawHeight="110.7" scaleMode="scaleNormal" hasSelectableText="0" minScaleX="-Infinity" maxScaleX="Infinity" minScaleY="-Infinity" maxScaleY="Infinity"/&amp;gt;
</listing>
		 * 
		 * @see #applyItemXML()
		 * @see #exportFullXML()
		 * @see #applyFullXML()
		 * @see #exportSettingsXML()
		 * @see #applySettingsXML()
		 * @param targetObject The DisplayObject whose transform data you'd like to export.
		 * @return An XML object describing the targetObject's transform data (scale/rotation/position) and a few other TransformManager-related settings.
		 */
		public function exportItemXML(targetObject:DisplayObject):XML {
			var xml:XML = <item></item>;
			var item:TransformItem = getItem(targetObject);
			var m:Matrix = targetObject.transform.matrix;
			var bounds:Rectangle = targetObject.getBounds(targetObject);
			xml.@name = targetObject.name;
			xml.@level = (targetObject.parent != null) ? targetObject.parent.getChildIndex(targetObject) : 0;
			xml.@a = m.a;
			xml.@b = m.b;
			xml.@c = m.c;
			xml.@d = m.d;
			xml.@tx = m.tx;
			xml.@ty = m.ty;
			xml.@xOffset = bounds.x;
			xml.@yOffset = bounds.y;
			xml.@rawWidth = bounds.width;
			xml.@rawHeight = bounds.height;
			xml.@scaleMode = (item != null) ? item.scaleMode : TransformManager.SCALE_NORMAL;
			xml.@hasSelectableText = (item != null) ? uint(item.hasSelectableText) : 0;
			xml.@minScaleX = (item != null) ? item.minScaleX : -Infinity;
			xml.@maxScaleX = (item != null) ? item.maxScaleX : Infinity;
			xml.@minScaleY = (item != null) ? item.minScaleY : -Infinity;
			xml.@maxScaleY = (item != null) ? item.maxScaleY : Infinity;
			xml.@lockScale = (item != null) ? uint(item.lockScale) : 0;
			xml.@lockPosition = (item != null) ? uint(item.lockPosition) : 0;
			xml.@lockRotation = (item != null) ? uint(item.lockRotation) : 0;
			xml.@constrainScale = (item != null) ? uint(item.constrainScale) : 0;
			xml.@minWidth = (item != null) ? item.minWidth : 1;
			xml.@maxWidth = (item != null) ? item.maxWidth : Infinity;
			xml.@minHeight = (item != null) ? item.minHeight : 1;
			xml.@maxHeight = (item != null) ? item.maxHeight : Infinity;
			return xml;
		}
		
		/**
		 * Applies XML generated by <code>exportItemXML()</code> to the TransformManager instance including all transform
		 * data like scale/rotation/position. This does not load any external images/assets - you must do that separately. 
		 * Typically it's best to fully load the asset first and add them to the display list before calling <code>applyItemXML()</code>.
		 * When <code>applyItemXML()</code> is called, it attempts to find the targetObject in the display list based on 
		 * its name, but if it cannot be found, a new Sprite will be created and added as a placeholder, filled with the 
		 * <code>placeholderColor</code> and named identically. To load all of the settings and every item's transform 
		 * data, use <code>applyFullXML()</code> instead.
		 * 
		 * @see #exportItemXML()
		 * @see #exportFullXML()
		 * @see #applyFullXML()
		 * @see #exportSettingsXML()
		 * @see #applySettingsXML()
		 * @param xml An XML object containing data about the item's position/scale/rotation. This XML is typically created using <code>exportItemXML()</code>.
		 * @param defaultParent If no items have been added to the TransformManager yet, it won't know which DisplayObjectContainer to look in for targetObject, so it is important to explicitly tell TransformManager what default parent to use.
		 * @param placeholderColor If the targetObject cannot be found in the display list (based on its name), it will create a new Sprite and fill it with this color, using it as a placeholder.
		 * @return The DisplayObject associated with the item (a placeholder Sprite if the targeObject wasn't found in the display list).
		 */
		public function applyItemXML(xml:XML, defaultParent:DisplayObjectContainer=null, placeholderColor:uint=0xCCCCCC):DisplayObject {
			var parent:DisplayObjectContainer = _parent || defaultParent;
			var mc:DisplayObject = parent.getChildByName(xml.@name);
			if (mc == null) {
				var i:int = _items.length;
				while (i--) {
					if (TransformItem(_items[i]).targetObject.name == xml.@name) {
						mc = TransformItem(_items[i]).targetObject;
						break;
					}
				}
			}
			if (mc == null) {
				mc = _isFlex ? new (getDefinitionByName("mx.core.UIComponent"))() : new Sprite();
				mc.name = xml.@name;
				var g:Graphics = (mc as Sprite).graphics;
				g.beginFill(placeholderColor, 1);
				g.drawRect(Number(xml.@xOffset), Number(xml.@yOffset), Number(xml.@rawWidth), Number(xml.@rawHeight));
				g.endFill();
				if (parent.hasOwnProperty("addElement")) { //for Flex compatibility (spark)
					(parent as Object).addElement(mc);
				} else {
					parent.addChild(mc);
				}
			}
			if (xml.@scaleMode == TransformManager.SCALE_WIDTH_AND_HEIGHT) { //important for TextFields whose width/height does not affect the transform.matrix values
				mc.width = Number(xml.@rawWidth);
				mc.height = Number(xml.@rawHeight);
			}
			var m:Matrix = mc.transform.matrix = new Matrix(Number(xml.@a), Number(xml.@b), Number(xml.@c), Number(xml.@d), Number(xml.@tx), Number(xml.@ty));
			if (parent.numChildren > xml.@level && mc.parent == parent) {
				if (parent.hasOwnProperty("setElementIndex")) { //for Flex compatibility (spark)
					(parent as Object).setElementIndex(mc, xml.@level);
				} else {
					parent.setChildIndex(mc, xml.@level);
				}
			}
			var item:TransformItem = this.addItem(mc, xml.@scaleMode, Boolean(uint(xml.@hasSelectableText)));
			item.minScaleX = Number(xml.@minScaleX);
			item.maxScaleX = Number(xml.@maxScaleX);
			item.minScaleY = Number(xml.@minScaleY);
			item.maxScaleY = Number(xml.@maxScaleY);
			item.lockScale = Boolean(uint(xml.@lockScale));
			item.lockPosition = Boolean(uint(xml.@lockPosition));
			item.lockRotation = Boolean(uint(xml.@lockRotation));
			item.constrainScale = Boolean(uint(xml.@constrainScale));
			item.minWidth = Number(xml.@minWidth) || 1;
			item.maxWidth = Number(xml.@maxWidth) || Infinity;
			item.minHeight = Number(xml.@minHeight) || 1;
			item.maxHeight = Number(xml.@maxHeight) || Infinity;
			mc.transform.matrix = m; //in case setting any of the properties like constrainScale, etc. affected the position
			return mc;
		}
		
		/**
		 * Exports the TransformManager's settings in XML format so that it can be saved to a database or elsewhere easily 
		 * and then reapplied later. <code>exportSettingsXML()</code>
		 * returns an XML object in the following format:
		 * @example <listing version="3.0">
&amp;lt;settings allowDelete="1" allowMultiSelect="1" autoDeselect="1" constrainScale="0" lockScale="1" scaleFromCenter="0" lockRotation="0" lockPosition="0" arrowKeysMove="0" forceSelectionToFront="1" lineColor="3381759" handleColor="16777215" handleSize="8" paddingForRotation="12" hideCenterHandle="0"/&amp;gt;
</listing>
		 * 
		 * @see #exportItemXML()
		 * @see #applyItemXML()
		 * @see #exportFullXML()
		 * @see #applyFullXML()
		 * @see #applySettingsXML() 
		 * @return An XML object containing settings data about the TransformManager.
		 */
		public function exportSettingsXML():XML {
			var settings:XML = <settings></settings>
			settings.@allowDelete = uint(this.allowDelete);
			settings.@allowMultiSelect = uint(this.allowMultiSelect);
			settings.@autoDeselect = uint(this.autoDeselect);
			settings.@constrainScale = uint(this.constrainScale);
			settings.@lockScale = uint(this.lockScale);
			settings.@scaleFromCenter = uint(this.scaleFromCenter);
			settings.@lockRotation = uint(this.lockRotation);
			settings.@lockPosition = uint(this.lockPosition);
			settings.@arrowKeysMove = uint(this.arrowKeysMove);
			settings.@forceSelectionToFront = uint(this.forceSelectionToFront);
			settings.@lineColor = this.lineColor;
			settings.@lineThickness = this.lineThickness;
			settings.@handleColor = this.handleFillColor;
			settings.@handleSize = this.handleSize;
			settings.@paddingForRotation = this.paddingForRotation;
			settings.@hideCenterHandle = uint(this.hideCenterHandle);
			settings.@hasBounds = (_bounds == null) ? 0 : 1;
			if (_bounds != null) {
				settings.@boundsX = _bounds.x;
				settings.@boundsY = _bounds.y;
				settings.@boundsWidth = _bounds.width;
				settings.@boundsHeight = _bounds.height;
			}
			return settings;
		}
		
		/**
		 * Applies settings XML generated by <code>exportSettingsXML()</code> to the TransformManager instance.
		 * This determines things like <code>allowDelete, autoDeselect, lockScale, lockPosition,</code> etc.
		 * 
		 * @see #exportItemXML()
		 * @see #applyItemXML()
		 * @see #exportFullXML()
		 * @see #applyFullXML()
		 * @see #exportSettingsXML()
		 * @see #applySettingsXML() 
		 * @param xml An XML object containing settings data about the TransformManager (typically exported by <code>exportSettingsXML()</code>).
		 */
		public function applySettingsXML(xml:XML):void {
			this.allowDelete = Boolean(uint(xml.@allowDelete));
			this.allowMultiSelect = Boolean(uint(xml.@allowMultiSelect));
			this.autoDeselect = Boolean(uint(xml.@autoDeselect));
			this.constrainScale = Boolean(uint(xml.@constrainScale));
			this.lockScale = Boolean(uint(xml.@lockScale));
			this.scaleFromCenter = Boolean(uint(xml.@scaleFromCenter));
			this.lockRotation = Boolean(uint(xml.@lockRotation));
			this.lockPosition = Boolean(uint(xml.@lockPosition));
			this.arrowKeysMove = Boolean(uint(xml.@arrowKeysMove));
			this.forceSelectionToFront = Boolean(uint(xml.@forceSelectionToFront));
			this.lineColor = uint(xml.@lineColor);
			this.lineThickness = Number(xml.@lineThickness);
			this.handleFillColor = uint(xml.@handleColor);
			this.handleSize = Number(xml.@handleSize);
			this.paddingForRotation = Number(xml.@paddingForRotation);
			this.hideCenterHandle = Boolean(uint(xml.@hideCenterHandle));
			if (Boolean(uint(xml.@hasBounds))) {
				this.bounds = new Rectangle(Number(xml.@boundsX), Number(xml.@boundsY), Number(xml.@boundsWidth), Number(xml.@boundsHeight));
			}
		}
        
		
//---- STATIC FUNCTIONS -------------------------------------------------------------------------------------------------
		
		/** @private **/
		private static function setDefault($value:*, $default:*):* {
			if ($value == undefined) {
				return $default;
			} else {
				return $value;
			}
		}
		
		/** @private **/
		private static function bringToFront($o:DisplayObject):void {
			if ($o.parent != null) {
				if ($o.parent.hasOwnProperty("setElementIndex")) { //for Flex compatibility (spark)
					($o.parent as Object).setElementIndex($o, $o.parent.numChildren - 1);
				} else {
					$o.parent.setChildIndex($o, $o.parent.numChildren - 1);
				}
			}
		}
		
		/** @private **/
		public static function positiveAngle($a:Number):Number {
			var revolution:Number = Math.PI * 2;
			return ((($a % revolution) + revolution) % revolution);
		}
		
		/** @private **/
		public static function acuteAngle($a:Number):Number {
			if ($a != $a % Math.PI) {
				$a = $a % (Math.PI * 2);
				if ($a < -Math.PI) {
					return Math.PI + ($a % Math.PI);
				} else if ($a > Math.PI) {
					return -Math.PI + ($a % Math.PI);
				}
			}
			return $a;
		}
		
		
//---- GETTERS / SETTERS -----------------------------------------------------------------------------------------------------
		
		/** Enable or disable the entire TransformManager. **/
		public function get enabled():Boolean {
			return _enabled;
		}
		public function set enabled($b:Boolean):void {
			_enabled = $b;
			updateItemProp("enabled", $b);
			if (!$b) {
				swapCursorOut();
				removeParentListeners();
			}
		}
		
		/** The scaleX of the overall selection box **/
		public function get selectionScaleX():Number {
			return MatrixTools.getScaleX(_dummyBox.transform.matrix, _flipX);
		}
		public function set selectionScaleX($n:Number):void {
			scaleSelection($n / this.selectionScaleX, 1);
		}
		
		/** The scaleY of the overall selection box **/
		public function get selectionScaleY():Number {
			return MatrixTools.getScaleY(_dummyBox.transform.matrix, _flipX);
		}
		public function set selectionScaleY($n:Number):void {
			scaleSelection(1, $n / this.selectionScaleY);
		}
		
		/** The rotation of the overall selection box **/
		public function get selectionRotation():Number {
			return _dummyBox.rotation;
		}
		public function set selectionRotation($n:Number):void {
			rotateSelection(($n - this.selectionRotation) * _DEG2RAD);
		}
		
		/** The x-coordinte of the overall selection box (same as the origin) **/
		public function get selectionX():Number {
			return _dummyBox.x;
		}
		public function set selectionX($n:Number):void {
			moveSelection($n - _dummyBox.x, 0, true);
		}
		
		/** The y-coordinate of the overall selection box (same as the origin) **/
		public function get selectionY():Number {
			return _dummyBox.y;
		}
		public function set selectionY($n:Number):void {
			moveSelection(0, $n - _dummyBox.y, true);
		}
		
		/** All of the TransformItem instances that are managed by this TransformManager (regardless of whether or not they're selected) **/
		public function get items():Array {
			return _items;
		}
		
		/** All of the targetObjects (DisplayObjects) that are managed by this TransformManager (regardless of whether or not they're selected) **/
		public function get targetObjects():Array {
			var a:Array = [];
			for (var i:uint = 0; i < _items.length; i++) {
				a.push(_items[i].targetObject);
			}
			return a;
		}
		
		/** The currently selected targetObjects (DisplayObjects). For the associated TransformItems, use <code>selectedItems</code>. **/
		public function get selectedTargetObjects():Array {
			var a:Array = [];
			for (var i:uint = 0; i < _selectedItems.length; i++) {
				a.push(_selectedItems[i].targetObject);
			}
			return a;
		}
		public function set selectedTargetObjects($a:Array):void {
			selectItems($a, false);
		}
		
		/** The currently selected TransformItems (for the associated DisplayObjects, use <code>selectedTargetObjects</code>) **/
		public function get selectedItems():Array {
			return _selectedItems;
		}
		public function set selectedItems($a:Array):void {
			selectItems($a, false);
		}
		
		
		/** To constrain items to only scaling proportionally, set this to true [default: <code>false</code>] **/
		public function get constrainScale():Boolean {
			return _constrainScale;
		}
		public function set constrainScale($b:Boolean):void {
			_constrainScale = $b;
			updateItemProp("constrainScale", $b);
			calibrateConstraints();
		}
		
		
		/** Prevents scaling [default: <code>false</code>] **/
		public function get lockScale():Boolean {
			return _lockScale;
		}
		public function set lockScale($b:Boolean):void {
			_lockScale = $b;
			updateItemProp("lockScale", $b);
			calibrateConstraints();
		}
		
		/** If true, scaling occurs from the center of the selection instead of the corners. [default: <code>false</code>] **/
		public function get scaleFromCenter():Boolean {
			return _scaleFromCenter;
		}
		public function set scaleFromCenter($b:Boolean):void {
			_scaleFromCenter = $b;
		}
		
		/** Prevents rotating [default: <code>false</code>] **/
		public function get lockRotation():Boolean {
			return _lockRotation;
		}
		public function set lockRotation($b:Boolean):void {
			_lockRotation = $b;
			updateItemProp("lockRotation", $b);
			calibrateConstraints();
		}
		
		/** Prevents moving [default: <code>false</code>] **/
		public function get lockPosition():Boolean {
			return _lockPosition;
		}
		public function set lockPosition($b:Boolean):void {
			_lockPosition = $b;
			updateItemProp("lockPosition", $b);
			calibrateConstraints();
		}
		
		/** If true, multiple items can be selected by holding down the SHIFT or CONTROL keys and clicking [default: <code>true</code>]. Just like in most modern operating systems, SHIFT always adds to the selection while CTRL toggles items in the selection.  **/
		public function get allowMultiSelect():Boolean {
			return _allowMultiSelect;
		}
		public function set allowMultiSelect($b:Boolean):void {
			_allowMultiSelect = $b
			if (!$b) {
				_multiSelectMode = false;
			}
		}
		
		/** If true, when the user presses the DELETE (or BACKSPACE) key, the selected item(s) will be deleted (except items with <code>hasSelectableText</code> set to true) [default: <code>false</code>] **/
		public function get allowDelete():Boolean {
			return _allowDelete;
		}
		public function set allowDelete($b:Boolean):void {
			_allowDelete = $b;
			updateItemProp("allowDelete", $b);
		}
		
		/** When the user clicks anywhere OTHER than on one of the TransformItems, all are deselected [default: <code>true</code>] **/
		public function get autoDeselect():Boolean {
			return _autoDeselect;
		}
		public function set autoDeselect($b:Boolean):void {
			_autoDeselect = $b;
		}
		
		/** Controls the line color of the selection box and handles [default: <code>0x3399FF</code>] **/
		public function get lineColor():uint {
			return _lineColor;
		}
		public function set lineColor($n:uint):void {
			_lineColor = $n;
			redrawHandles();
			updateSelection();
		}
		
		/** Controls the thickness of the selection box and handle lines [default: <code>1</code>] **/
		public function get lineThickness():Number {
			return _lineThickness;
		}
		public function set lineThickness($value:Number):void {
			_lineThickness = $value;
			redrawHandles();
			updateSelection();
		}
		
		/** Controls the fill color of the handle [default: <code>0xFFFFFF</code>] **/
		public function get handleFillColor():uint {
			return _handleColor;
		}
		public function set handleFillColor($n:uint):void {
			_handleColor = $n;
			redrawHandles();
		}
		
		/** Controls the handle size (in pixels) [default: <code>8</code>] **/
		public function get handleSize():Number {
			return _handleSize;
		}
		public function set handleSize($n:Number):void {
			_handleSize = $n;
			redrawHandles();
		}
		
		/** Determines the amount of space outside each of the four corner scale handles that will trigger rotation mode [default: <code>12</code>] **/
		public function get paddingForRotation():Number {
			return _paddingForRotation;
		}
		public function set paddingForRotation($n:Number):void {
			_paddingForRotation = $n;
			redrawHandles();
		}
		
		/** A Rectangle defining the boundaries for movement/scaling/rotation. [default:null] **/
		public function get bounds():Rectangle {
			return _bounds;
		}
		public function set bounds($r:Rectangle):void {
			_bounds = $r;
			if (_selectedItems.length != 0) {
				calibrateConstraints();
			}
			updateItemProp("bounds", $r);
		}
		
		
		/** When true, new selections are forced to the front (top) of the display list [default: <code>true</code>] **/
		public function get forceSelectionToFront():Boolean {
			return _forceSelectionToFront;
		}
		public function set forceSelectionToFront($b:Boolean):void {
			_forceSelectionToFront = $b;
		}
		
		/** If true, the arrow keys on the keyboard will move the selected items when pressed [default: <code>false</code>] **/
		public function get arrowKeysMove():Boolean {
			return _arrowKeysMove;
		}
		public function set arrowKeysMove($b:Boolean):void {
			_arrowKeysMove = $b;
		}
		
		/** If you want TransformManager to ignore clicks on certain DisplayObjects like buttons, color pickers, etc., add them to the ignoredObjects Array. The DisplayObject CANNOT be a child of a targetObject that is being managed by TransformManager. **/
		public function get ignoredObjects():Array {
			return _ignoredObjects.slice();
		}
		public function set ignoredObjects($a:Array):void {
			_ignoredObjects = [];
			for (var i:uint = 0; i < $a.length; i++) {
				if ($a[i] is DisplayObject) {
					_ignoredObjects.push($a[i]);
				} else {
					trace("TransformManager warning: An attempt was made to add " + $a[i] + " to the ignoredObjects Array but it is NOT a DisplayObject, so it was not added.");
				}
			}
		}
		
		/** To hide the center scale handle, set this to true [default: <code>false</code>] **/
		public function get hideCenterHandle():Boolean {
			return _hideCenterHandle;
		}
		public function set hideCenterHandle($b:Boolean):void {
			_hideCenterHandle = $b;
			redrawHandles();
		}
		
		/** If <code>true</code>, TransformManager is currently displaying a custom cursor (like the scale, rotate, or move cursor). **/
		public function get isShowingCustomCursor():Boolean {
			return Boolean(_currentCursor != null);
		}
		
		/** The Shape object that is being used for the move cursor. To customize the cursor, use the <code>customizeMoveCursor()</code> method. @see #customizeMoveCursor() **/
		public static function get moveCursor():Shape {
			return _moveCursor.shape;
		}
		
		/** The Shape object that is being used for the scale cursor. To customize the cursor, use the <code>customizeScaleCursor()</code> method. @see #customizeScaleCursor() **/
		public static function get scaleCursor():Shape {
			return _scaleCursor.shape;
		}
		
		/** The Shape object that is being used for the rotation cursor. To customize the cursor, use the <code>customizeRotationCursor()</code> method. @see #customizeRotationCursor() **/
		public static function get rotationCursor():Shape {
			return _rotationCursor.shape;
		}
	
	}
	
}

import flash.display.Shape;

internal class CustomCursor {
	public var shape:Shape;
	public var hideMouse:Boolean;
	public var xOffset:Number;
	public var yOffset:Number;
	public var autoRotate:Boolean;
	
	public function CustomCursor(shape:Shape, hideMouse:Boolean, xOffset:Number, yOffset:Number, autoRotate:Boolean) {
		this.shape = shape;
		this.hideMouse = hideMouse;
		this.xOffset = xOffset;
		this.yOffset = yOffset;
		this.autoRotate = autoRotate;
	}
	
}