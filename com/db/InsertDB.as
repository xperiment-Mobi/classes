/*
---------------------------------------------------------------------
---------------------------------------------------------------------
This code was created by Peak Studios.
To learn more about this class please go to http://peakstudios.com

©2008 Peak Studios

To learn more about the allowed usage of this copy right  go to http://peakstudios.com
---------------------------------------------------------------------
---------------------------------------------------------------------
*/
package com.db
{
	import flash.display.MovieClip;
	import flash.net.*;
	import flash.events.*;     
	
	public class InsertDB extends MovieClip
	{
		//Send and load vars
		private var variables:URLVariables;
		private var request:URLRequest;
		private var loader:URLLoader;
		private var locA:String;
		//Query vars
		private var table1:String;
		private var selectRows:Array;
		private var tableValuesA:Array;
		//Function vars
		private var returnFunction:Function;
		private var functionStrings:Array;
		
		public function InsertDB(table:String, 
									tableRows:Array, 
									tableValues:Array,  
									resultsToFunction:Function, 
									passStringsToFunction:Array, loc:String){
			//Set function vars
			table1 = table;
			selectRows = tableRows;
			tableValuesA = tableValues;
			locA = loc;
			returnFunction = resultsToFunction;
			functionStrings = passStringsToFunction;
			//call function
			sendAndLoad();
		}

		public function sendAndLoad(){
			request = new URLRequest(locA+"php/insertDB.php");
			request.method = URLRequestMethod.POST;
			//Set variables to send out to php
			var variables:URLVariables = new URLVariables();
			variables.table1 = table1;
			variables.selectRowsLength = selectRows.length;
			for(var i:Number=0; i<selectRows.length; i++){
				variables["selectRows"+i] = selectRows[i];
				variables["valueRows"+i] = tableValuesA[i];
			}
			//send data
			request.data = variables;
			//set recieve function
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, dataLoaded);
			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.load(request);
		}
		
		//recieve data
		private function dataLoaded(e:Event):void{
			var loader:URLLoader = URLLoader(e.target);
			var vars:URLVariables = new URLVariables(loader.data);
			this.returnFunction(vars, functionStrings);
		}
	}
}