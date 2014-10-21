package com.xperiment.behaviour.PastResults
{
	import com.xperiment.AirRelated.Computer;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.exptWideAction.ExptWideAction;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;


	public class PastResultsLoader
	{
		private var filenames:String;
		private var loadingF:Function;
		private var loadedF:Function;

		private var files:Array;
		private var variables:Object = {};
		private var commands:Object  = {};
		
		public var results:Object;
		
		public var fileCount:int=0;
		
		
		public function PastResultsLoader(filenames:String,variables_commands:String,loadingF:Function,loadedF:Function)
		{
			this.filenames=filenames;
			this.loadingF =loadingF;
			this.loadedF  =loadedF;
			
			if(variables=="")throw new Error("you want to retrieve info from past results but you have not specified the variables to retreive. E.g. variables='x,y,timeStart'")
			
			else{
				
				var split:Array;
				for each(var command_variable:String in variables_commands.split(",")){
					
					split=command_variable.split(":");
					
					if(split.length!=2)throw new Error('whilst extracting past results, encountered a wrongly formatted command:varaible:'+command_variable);
					
					if(variables.hasOwnProperty(split[1])==false)variables[split[1]]=[];

					variables[split[1]]=[];
					
					commands[split[1]]=split[0];	
				}
			}
		}
		
		public function load():void
		{
			var folder:File=Computer.storageFolder();
				
		

			if(folder.exists == false){
				//throw new Error("the folder where you want to get past results from does not exist!");
			}
			else{
				files = folder.getDirectoryListing()
					
				//remove files from Array that are not xml	
				var count:Number=0;
				for(var fileName:String in files){
					if(files[fileName].extension!='xml'){
						delete files[fileName];
					}
					else {	
						extractVariables(files[fileName]);
						if(loadingF)loadingF(count++/files.length);	
					}
				}
				
				fileCount=files.length;
	
				results = ComputeResults.DO(variables,commands);
			}
			
			loadedF(true);
		}
		
		
		private function extractVariables(file:File):void
		{
			var fileStream:FileStream = new FileStream();
			
			fileStream.open(file, FileMode.READ);

			
			
			try{
				var xml:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			}
			catch(e:Error){
				throw new Error("could not load this results file for some reason:"+file.url+". The error was:"+e.errorID+".");
			}

			fileStream.close();

			var prop:String;
			for (var variable:String in variables){
				prop = xml.descendants(variable)
				variables[variable].push(prop);
			}
		}		
	}
}