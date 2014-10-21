/**
 * 
 * Copyright (c) 2009 Keita Kuroki
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *  
 * This is an example code created for the 
 * "Flash 10, Making music" presentation.
 * 
 * For more information:
 * 	http://labs.hellokeita.com/
 * 	code@hellokeita.in
 * 
 **/

package br.hellokeita.graphics 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author keita
	 */
	public class BezierValue extends EventDispatcher
	{
		
		static private const CHANGE_EVENT:Event = new Event(Event.CHANGE);
		private var _value:Number;
		
		public function BezierValue(value:Number) 
		{
			_value = value;
		}
		
		public function get value():Number { return _value; }
		
		public function set value(value:Number):void 
		{
			_value = value;
			dispatchEvent(CHANGE_EVENT);
		}
		
		public function valueOf():Object 
		{
			return _value;
		}
		
	}
	
}