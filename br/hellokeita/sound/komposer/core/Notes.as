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

package br.hellokeita.sound.komposer.core 
{
	
	/**
	 * ...
	 * @author keita keita.kun_at_gmail.com
	 */
	public class Notes 
	{
		
		public static const A1_FREQUENCY:Number = 27.5;
		
		public static const A:int = 0;
		public static const A_SHARP:int = 1;
		public static const B:int = 2;
		public static const C:int = 3;
		public static const C_SHARP:int = 4;
		public static const D:int = 5;
		public static const D_SHARP:int = 6;
		public static const E:int = 7;
		public static const F:int = 8;
		public static const F_SHARP:int = 9;
		public static const G:int = 10;
		public static const G_SHARP:int = 11;
		
		public static const OCTAVE_0:int = 1;
		public static const OCTAVE_1:int = 2;
		public static const OCTAVE_2:int = 3;
		public static const OCTAVE_3:int = 4;
		public static const OCTAVE_4:int = 5;
		public static const OCTAVE_5:int = 6;
		public static const OCTAVE_6:int = 7;
		public static const OCTAVE_7:int = 8;
		
		public static function toFrequency(note:int, octave:int = 5):Number {
			return (Math.pow(2, note / 12) * A1_FREQUENCY) * Math.pow(2, octave - 1);
		}
	}
	
}