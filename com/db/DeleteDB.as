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
	
	public class DeleteDB extends MovieClip
	{
		//Send and load vars
		private var variables:URLVariables;
		private var request:URLRequest;
		private var loader:URLLoader;
		private var locA:String;
		//Query vars
		private var table1:String;
		private var whereA:Array;
		private var likeA:Array;
		private var whatA:Array;
		//Function vars
		private var returnFunction:Function;
		private var functionStrings:Array;
		
		public function DeleteDB(table:String,  
									selectWhere:Array, 
									selectLike:Array, 
									selectWhat:Array,
									resultsToFunction:Function, 
									passStringsToFunction:Array, loc:String){
			//Set function vars
			table1 = table;
			whereA = selectWhere;
			likeA = selectLike;
			whatA = selectWhat;
			locA = loc;
			returnFunction = resultsToFunction;
			functionStrings = passStringsToFunction;
			//call function
			sendAndLoad();
		}

		public function sendAndLoad(){
			request = new URLRequest(locA+"php/deleteDB.php");
			request.method = URLRequestMethod.POST;
			//Set variables to send out to php
			var variables:URLVariables = new URLVariables();
			variables.table1 = table1;
			
			
			variables.whereLength = whereA.length;
			for(var ii:Number=0; ii<whereA.length; ii++){
				variables["whereA"+ii] = whereA[ii];
				variables["likeA"+ii] = likeA[ii];
				variables["whatA"+ii] = whatA[ii];
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

