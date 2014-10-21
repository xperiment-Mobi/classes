package com.xperiment.Results
{
	public class TimeZone
	{
		//taken from https://gist.github.com/thanksmister/1268863
		
		/**
		 * Return local system timzezone abbreviation.
		 * */
		public static function getTimeZone():String
		{
			var nowDate:Date = new Date();
			var DST:Boolean = isObservingDTS();
			var GMT:String = buildTimeZoneDesignation(nowDate, DST);
			
			return GMT
		}
		
		/**
		 * Determines if local computer is observing daylight savings time for US and London.
		 * */
		private static function isObservingDTS():Boolean
		{
			var winter:Date = new Date(2011, 01, 01); // after daylight savings time ends
			var summer:Date = new Date(2011, 07, 01); // during daylight savings time
			var now:Date = new Date();
			
			var winterOffset:Number = winter.getTimezoneOffset();
			var summerOffset:Number = summer.getTimezoneOffset();
			var nowOffset:Number = now.getTimezoneOffset();
			
			if((nowOffset == summerOffset) && (nowOffset != winterOffset)) {
				return true;
			} else {
				return false;
			}	
		}
		

		/**
		 * Method to build GMT from date and timezone offset and accounting for daylight savings.
		 * 
		 * Originally code befor modifications:
		 * http://flexoop.com/2008/12/flex-date-utils-date-and-time-format-part-i/
		 * */
		private static function buildTimeZoneDesignation( date:Date, dts:Boolean  ):String 
		{
			if ( !date ) {
				return "";
			}
			
			var timeZoneAsString:String = "GMT";
			var timeZoneOffset:Number;
			
			// timezoneoffset is the number that needs to be added to the local time to get to GMT, so
			// a positive number would actually be GMT -X hours
			if ( date.getTimezoneOffset() / 60 > 0 && date.getTimezoneOffset() / 60 < 10 ) {
				timeZoneOffset = (dts)? ( date.getTimezoneOffset() / 60 ):( date.getTimezoneOffset() / 60 - 1 );
				timeZoneAsString += "-0" + timeZoneOffset.toString();
			} else if ( date.getTimezoneOffset() < 0 && date.timezoneOffset / 60 > -10 ) {
				timeZoneOffset = (dts)? ( date.getTimezoneOffset() / 60 ):( date.getTimezoneOffset() / 60 + 1 );
				timeZoneAsString += "+0" + ( -1 * timeZoneOffset ).toString();
			} else {
				timeZoneAsString += "+00";
			}
			
			// add zeros to match standard format
			timeZoneAsString += "00";
			return timeZoneAsString;
		}
		
	}
}