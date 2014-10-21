package com.Logger {
	
	import flash.external.ExternalInterface;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	
	public class ChromeAddOn {
		
		// USAGE:
		//
		// Log.info(anything)
		// Log.warning(anything)
		// Log.error(anything)
		// Log.dump(anything)
		//
		// Logged object will appear in both the trace window and in the Firebug console (if it's enabled)
		
		
		static public var enabled:Boolean = true;
		static private var prefix_:String = null;
		static private var logWindow_:Sprite;
		static private var logWindowHeight_:Number;
		static private var logTextField_:TextField;
		static private var closeLogWindowButton_:TextField;
		static private var logWindowMaximized_:Boolean = false;
		static private var outputTextField_:TextField = null;
		
		
		static public function get outputTextField():TextField {
			return outputTextField_;
		}
		
		
		static public function set outputTextField(v:TextField):void {
			if (outputTextField_ === v) return;
			outputTextField_ = v;
		}
		
		
		static private function log(s:*, type:String = null, param:* = null):void {
			if (!enabled) return;
			
			var logString:String = String(s);
			var serializedObject:* = null;
			var serializedObjectString:String = null;
			
			if (type == "Dump") {
				serializedObject = serializeObject_(s);
				serializedObjectString = dump_(serializedObject, param.asString, param.maxDepth);
				if (logTextField_) logTextField_.appendText(dump_(serializedObject, true, param.maxDepth) + "\n");
				if (outputTextField_) outputTextField_.appendText(dump_(serializedObject, true, param.maxDepth) + "\n");
			} else {
				if (type) logString = '[' + type + '] ' + logString;
				if (prefix) logString = '[' + prefix + '] ' + logString;
				trace(logString);
				if (outputTextField_) outputTextField_.appendText(logString + "\n");
				
				//              if (logTextField_) {
				//                  var i1:int = logTextField_.text.length - 1;
				//                  logTextField_.appendText(logString + "\n");
				//                  var i2:int = logTextField_.text.length - 1;
				//                  var logColor:uint = 0x000000;
				//                  if (type == "Info") logColor = 0xffffff;
				//                  if (type == "Warning") logColor = 0xECEC00;
				//                  if (type == "Error") logColor = 0xFF3535;
				//                  var tf:TextFormat = logTextField_.getTextFormat(i1, i2);
				//                  tf.color = logColor;
				//                  logTextField_.setTextFormat(tf, i1, i2);
				//              }
			}   
			
			if (logWindow_) logWindow_.parent.addChild(logWindow_);
			if (outputTextField_) outputTextField_.scrollV = outputTextField_.maxScrollV;
			
			if (ExternalInterface.available) {
				try {
					var c:String = "console.info";
					var v:* = s;
					if (prefix) v = '[' + prefix + '] ' + v;
					if (type == "Warning") {
						c = "console.warn";
					} else if (type == "Error") {
						c = "console.error";    
					} else if (type == "Dump") {
						if (param.asString) {
							c = "console.info";
							v = serializedObjectString ? serializedObjectString : s;
						} else {
							c = "console.dir";  
							var h:String = "Dump";
							if (prefix) h = prefix + "_" + h;
							v = {};
							v[h] = (serializedObject ? serializedObject : s);
						}
					}
					ExternalInterface.call(c, v);                   
				} catch(e:*) {
					// ignore   
				}
			}
		}   
		
		
		static public function info(s:*):void {
			log(s, 'Info');
		}
		
		
		static public function warning(s:*):void {
			log(s, 'Warning');
		}
		
		
		static public function error(s:*):void {
			log(s, 'Error');
		}
		
		
		static public function dump(s:*, asString:Boolean = false, maxDepth:int = -1):void {
			log(s, "Dump", { asString:asString, maxDepth:maxDepth });   
		}
		
		
		static public function get prefix():String {
			return prefix_; 
		}
		
		
		static public function set prefix(v:String):void {
			var validCharacters:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";
			var output:String = "";
			for (var i:int = 0; i < v.length; i++) {
				var c:String = v.charAt(i);
				if (validCharacters.indexOf(c) < 0) continue;
				output += c;    
			}
			if (output.length == 0) output = "a";
			
			prefix_ = output;
		}
		
		
		static public function showLogWindow(parent:*):void {
			if (!logWindow_) {
				logWindow_ = new Sprite();
				
				logTextField_ = new TextField();
				var tf:TextFormat = new TextFormat();
				tf.font = "Arial";
				tf.size = 10;
				logTextField_.defaultTextFormat = tf;
				logTextField_.multiline = true;
				logTextField_.wordWrap = true;
				logTextField_.border = true;
				logTextField_.borderColor = 0xffffff;
				
				closeLogWindowButton_= new TextField();
				closeLogWindowButton_.text = "[Minimize]";
				closeLogWindowButton_.autoSize = "left";
				closeLogWindowButton_.selectable = false;
				tf = new TextFormat();
				tf.font = "Arial";
				tf.size = 10;
				tf.color = 0xffffff;
				closeLogWindowButton_.setTextFormat(tf);
				closeLogWindowButton_.defaultTextFormat = tf;
				closeLogWindowButton_.addEventListener("click", closeLogWindowButton_click);
				
				logWindow_.addChild(logTextField_);
				logWindow_.addChild(closeLogWindowButton_);
				
				logWindowMaximized_ = true;
			}
			
			logWindowHeight_ = 240;
			
			updateLogWindowLayout(320, logWindowHeight_);
			
			parent.addChild(logWindow_);
			
			logWindow_.addEventListener("enterFrame", logWindow_enterFrame);
		}
		
		
		static public function hideLogWindow():void {
			if (!logWindow_) return;
			if (logWindow_.parent) logWindow_.parent.removeChild(logWindow_);
			logWindow_.removeEventListener("enterFrame", logWindow_enterFrame);
		}
		
		
		static public function minimizeLogWindow():void {
			if (!logWindowMaximized_) return;
			closeLogWindowButton_click(null);
		}
		
		
		static public function logWindow_enterFrame(event:*):void {
			if (logWindow_.parent) logWindow_.parent.addChild(logWindow_);
		}
		
		
		static private function updateLogWindowLayout(width:Number, height:Number):void {
			var m:Number = 8;
			closeLogWindowButton_.x = m;
			logTextField_.x = m;
			logTextField_.y = closeLogWindowButton_.height;
			logTextField_.width = width - 2 * m;
			logTextField_.height = Math.max(height - logTextField_.y - m, 0);
			
			logWindow_.graphics.clear();
			logWindow_.graphics.lineStyle(1, 0xffffff);
			logWindow_.graphics.beginFill(0x000000);
			logWindow_.graphics.drawRect(0,0,width,height);
			logWindow_.graphics.endFill();
		}
		
		
		static private function closeLogWindowButton_click(event:*):void {
			var doShow:Boolean = !logWindowMaximized_;
			var h:Number = doShow ? logWindowHeight_ : 10;
			
			logWindowMaximized_ = doShow;
			
			updateLogWindowLayout(doShow ? 320 : 10, h);
			
			closeLogWindowButton_.text = doShow ? '[Minimize]' : '  ';
			if (!doShow) {
				closeLogWindowButton_.x = 0;
				closeLogWindowButton_.y = 0;    
			}
			
			logTextField_.visible = doShow;
		}
		
		
		
		
		
		
		static private function serializeObject_(object:*, maxDepth:int = 8):* {
			
			var objectReferences:Dictionary = new Dictionary();
			var objectReferenceIndex:int = 0;
			var depth:int = 0;
			var inputObjectReferenceCount:int = 0;
			
			function serialize(o:*):* { 
				
				if (o === object) inputObjectReferenceCount++;
				
				depth++;
				var objectIndex:int;
				var output:*;
				
				if (maxDepth >= 0 && depth > maxDepth) {
					
					output = '<Max depth>';
					
				} else {
					
					var i:int;
					
					if (objectReferences[o]) {
						output = '<#' + objectReferences[o] + '>';
					} else if (o === object && inputObjectReferenceCount > 1) {
						output = '<#0>';
					} else if (o === null || o === undefined || o is String || typeof(o) == "number" || o === true || o === false) {
						output = o;
					} else if (o is Array) {
						
						output = [];
						objectIndex = objectReferenceIndex++;
						objectReferences[o] = objectIndex;
						
						for (i = 0; i < o.length; i++) {
							output.push(serialize(o[i]));
						}
						
					} else if (o is Object) {
						
						output = {};
						
						objectIndex = objectReferenceIndex++;
						objectReferences[o] = objectIndex;
						
						var xml:XML = describeType(o);
						var typeName:String = xml.@name.toString();
						var twoDots:int = typeName.indexOf("::");
						if (twoDots >= 0) typeName = typeName.substr(twoDots + 2, typeName.length);
						var isDynamic:Boolean = xml.@isDynamic.toString() == "true";
						
						var v:*;
						
						if (!isDynamic) {
							var propertyNames:XMLList = xml..accessor.@name;
							var properyName:String;
							
							for (i = 0; i < propertyNames.length(); i++) {
								properyName = propertyNames[i].toString();
								try {
									v = o[properyName];
								} catch(e:*) {
									continue;
								}
								output[properyName] = serialize(v);
							}
							
							propertyNames = xml..variable.@name;
							
							for (i = 0; i < propertyNames.length(); i++) {
								properyName = propertyNames[i].toString();
								try {
									v = o[properyName];
								} catch(e:*) {
									continue;
								}
								output[properyName] = serialize(v);
							}
							
						} else {
							for (var n:String in o) {
								v = o[n];
								output[n] = serialize(v);
							}
						}
						
					} else {
						output = o;   
					}
					
				}
				
				depth--;
				return output;
			}    
			
			var finalOutput:* = serialize(object);
			return finalOutput;
		}
		
		
		
		
		
		static private function dump_(object:*, asString:Boolean = false, maxDepth:int = 8):* {
			
			var objectReferences:Dictionary = new Dictionary();
			var objectReferenceIndex:int = 0;
			var depth:int = 0;
			
			var inputObjectReferenceCount:int = 0;
			
			function objectToString(o:*, indent:Number = 1):String {    
				
				if (o === object) inputObjectReferenceCount++;
				
				depth++;
				var objectIndex:int;
				
				if (maxDepth >= 0 && depth > maxDepth) {
					
					output = '<Max depth>';
					
				} else {
					
					var spaces:String = '';
					var i:Number;
					for (i = 0; i < indent; i++) spaces += '    ';
					
					var output:String = '';
					
					if (objectReferences[o]) {
						output = '<#' + objectReferences[o] + '>';
					} else if (o === object && inputObjectReferenceCount > 1) {
						output = '<#0>';
					} else if (o === null) {
						output = "null";
					} else if (o === undefined) {
						output = "undefined";
					} else if (o is String) {
						output = '"' + o + '"';
					} else if (typeof(o) == "number") {
						output = o.toString();
					} else if (o === true) {
						output = "true";
					} else if (o === false) {
						output = "false";
					} else if (o is Array) {
						
						objectIndex = objectReferenceIndex++;
						objectReferences[o] = objectIndex;
						
						output += '(Array #' + objectIndex + ')';
						
						if (o.length > 0) {
							output += '\n';
						} else {
							output += '[]';   
						}
						indent++;
						for (i = 0; i < o.length; i++) {
							if (i > 0) output += '\n';
							output += spaces + '[' + i + '] ' + objectToString(o[i], indent);
						}
						
					} else if (o is Object) {
						
						var v:*;
						objectIndex = objectReferenceIndex++;
						objectReferences[o] = objectIndex;
						indent++;
						var propCount:int = 0;
						output += '(' + 'Object' + ' #' + objectIndex + ')';
						
						for (var n:String in o) {
							v = o[n];
							output += '\n';
							output += spaces + n + ': ' + objectToString(v, indent);
							propCount++;
						}
						
						if (propCount == 0) output += '{}';
						
					} else {
						output += o;   
					}
					
				}
				
				depth--;
				return output;
			}    
			
			var s:String = objectToString(object);
			
			if (asString) return s;
			
			trace(s);       
		}
		
		
	}
	
}