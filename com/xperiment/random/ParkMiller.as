/**
 *	Implementation of the Park Miller (1988) "minimal standard" linear
 *	congruential pseudo-random number generator.
 *
 *	The generator uses a modulus constant (m) of 2^31 - 1 which is a
 *	Mersenne Prime number and a full-period-multiplier of 16807.
 *
 *	@author Michael Baczynski, http://www.polygonal.de
 *
 *	Modified version, visit polygonal labs for original source.
 */

/**
 *	Implementation of the Marsaglia polar method for generation of
 *	standard normal pseudo-random numbers.
 *
 *	@author hdachev, http://blog.controul.com
 */

package com.xperiment.random
{
	/**
	 *	Park–Miller PRNG.
	 */
	
	public class ParkMiller
	{
		private static var instance:ParkMiller;
		
		public static function randNormal():Number{
			if(!instance){
				instance = new ParkMiller;
				instance.seed = Math.random() * 2147483647;
			}
			
			return hack(instance.standardNormal());
		}
		
		private static var arr:Array;
		private static var count:int;
		
		private static function hack(num:Number):Number
		{
			if(!arr){
				arr = [];
				for(var i:int=0;i<10;i++){
					arr[i]=0;
				}
			}
			
			for(i=0;i<arr.length;i++){
				if(num<=(i+1)/10){
					arr[i]++;
					break;
				}
			}
			
			trace(num,JSON.stringify(arr))
		
			return num;;
		}		
		
		private var s : int;
		
		public function ParkMiller ( seed : uint = 1 )
		{
			s = seed > 0 ? seed % 2147483647 : 1;
		}
		
		public function get seed () : uint
		{
			//	Clear the cache to make sure that a synched
			//	prng will produce the expected output.
			
			ready = false;
			return s;
		}
		
		public function set seed ( seed : uint ) : void
		{
			//	Clear the cache to make sure that a synched
			//	prng will produce the expected output.
			
			ready = false;
			s = seed > 0 ? seed % 2147483647 : 1;
		}
		
		/**
		 *	Returns a Number ~ U(0,1)
		 */
		public function uniform () : Number
		{
			return ( ( s = ( s * 16807 ) % 2147483647 ) / 2147483647 );
		}
		
		/**
		 *	Returns a Number ~ N(0,1);
		 */
		public function standardNormal () : Number
		{
			if ( ready )
			{
				ready = false;
				return cache;
			}
			
			var x : Number,
			y : Number,
			w : Number;
			
			do
			{
				x = ( s = ( s * 16807 ) % 2147483647 ) / 1073741823.5 - 1;
				y = ( s = ( s * 16807 ) % 2147483647 ) / 1073741823.5 - 1;
				w = x * x + y * y;
			}
			while ( w >= 1 || !w );
			
			w = Math.sqrt ( -2 * Math.log ( w ) / w );
			
			ready = true;
			cache = x * w;
			
			return y * w;
		}
		private var ready : Boolean;
		private var cache : Number;
		
		/**
		 *	Returns true with probability p
		 */
		public function bernoulli ( p : Number = 0.5 ) : Boolean
		{
			return ( s = ( s * 16807 ) % 2147483647 ) < p * 2147483647;
		}
		
	}
	
}
