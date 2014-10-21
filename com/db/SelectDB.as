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
	
	public class SelectDB extends MovieClip
	{
		//Send and load vars
		private var variables:URLVariables;
		private var request:URLRequest;
		private var loader:URLLoader;
		private var locA:String;
		//Query vars
		private var table1:String;
		private var selectRows:Array;
		private var whereA:Array;
		private var likeA:Array;
		private var whatA:Array;
		private var orderBy:Array;
		private var ASC:Array;
		//Function vars
		private var returnFunction:Function;
		private var functionStrings:Array;
		
		private var cA:Array;
		private var sr1:String;
		
		public function SelectDB(table:String, 
									tableRows:Array, 
									selectWhere:Array, 
									selectLike:Array, 
									selectWhat:Array, 
									orderResultsBy:Array, 
									ASC_DESC:Array, 
									resultsToFunction:Function, 
									passStringsToFunction:Array, loc:String){
			//Set function vars
			table1 = table;
			selectRows = tableRows;
			whereA = selectWhere;
			likeA = selectLike;
			whatA = selectWhat;
			locA = loc;
			orderBy = orderResultsBy;
			ASC = ASC_DESC;
			returnFunction = resultsToFunction;
			functionStrings = passStringsToFunction;
			//call function
			sendAndLoad();
		}

		public function sendAndLoad(){
			request = new URLRequest(locA+"php/selectDB.php");
			request.method = URLRequestMethod.POST;
			//Set variables to send out to php
			var variables:URLVariables = new URLVariables();
			variables.table1 = table1;
			variables.orderBy = orderBy;
			variables.ASC = ASC;
			variables.selectRowsLength = selectRows.length;
			for(var i:Number=0; i<selectRows.length; i++){
				variables["selectRows"+i] = selectRows[i];
				cA = selectRows[i].split(".");
				sr1 = cA[1];
				if(sr1 != null){
					selectRows[i] = sr1;
				}
			}
			
			variables.whereLength = whereA.length;
			for(var ii:Number=0; ii<whereA.length; ii++){
				variables["whereA"+ii] = whereA[ii];
				variables["likeA"+ii] = likeA[ii];
				variables["whatA"+ii] = whatA[ii];
			}
			
			variables.ASCLength = ASC.length;
			for(var iii:Number=0; iii<ASC.length; iii++){
				variables["orderBy"+iii] = orderBy[iii];
				variables["ASC"+iii] = ASC[iii];
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
			this.returnFunction(vars, selectRows, functionStrings);
		}
	}
}