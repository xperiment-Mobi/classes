package com.mobile{
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.net.URLRequest;
	import flash.events.*;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import com.xperiment.Network.sendToPHP;
	import com.xperiment.Results.services.emailResults;
	import com.xperiment.Network.sendToPHP;

	public class sendInternalResults extends Sprite {
		var folder:File;
		var file:File;
		var fileStream:FileStream;
		var webdir:String;
		var delArray:Array;
		var instructions:Object;

		public var storageLocation:String;

		public function postToURL(instructions:Object) {
			this.instructions=instructions;
			folder=File.applicationStorageDirectory.resolvePath(instructions.storageFolder);
			this.webdir=instructions.saveDataURL;
			storageLocation=folder.nativePath;

			if (! folder.exists) {
				trace("folder '"+storageLocation+"' does not exist!  Nothing to do!");
			}
			else if (instructions.saveDataURL!="") {
				delArray=new Array;
				trace("Commencing upload...");
				uploadData(bulkeriseFiles());
			}
			else if(!instructions.toWhom && instructions.toWhom!=""){
				
			}
			
			else if(instructions.deleteAll){
				deleteAll();
			}
		}
		
		public function postToEmail(instructions:Object){
			sendTheEmail(bulkeriseFiles());
		}
		
		private function sendTheEmail(tempResults:String){
			trace("Commencing bulk email of data...");
			var emailXML:emailResults=new emailResults(null,tempResults);
		}
		
		private function deleteAll(){
			var files:Array=folder.getDirectoryListing();
				if (files.length==0) {
					trace("'"+storageLocation+"' folder exists BUT nothing in it! Nothing to do!");
				}
				else{
					trace("("+files.length+" x SJ data)");
					for (var i:uint=0; i<files.length; i++) {
						deleteFile(files[i]);
					}
				}
		
		}
		
		public function bulkeriseFiles():String { //the string return to ensure that this function completes before the next
			var returnStr:String="";
			try {
				var files:Array=folder.getDirectoryListing();
				if (files.length==0) {
					trace("'"+storageLocation+"' folder exists BUT nothing in it! Nothing to do!");
				}
				else{
					trace("("+files.length+" x SJ data)");
					for (var i:uint=0; i<files.length; i++) {
						if (files[i].isDirectory==false) {
							returnStr=returnStr+"\n"+compileBulkDataFile(files[i]);
						}
						else {
							trace("unexpected sub-directory (leaving it along and doing nothing with the contents):"+storageLocation+"/"+files[i]);
						}
					}
				}
				
			} catch (error:Error) {
				trace("PROBLEM: combining SJ data into one file was NOT successful.  Could not access internal data: "+error);
			}
			return returnStr;
		}

		private function compileBulkDataFile(file:File):String {
			var returnStr:String="";
			try {
				fileStream=new FileStream();
				fileStream.open(file,FileMode.READ);
				returnStr=fileStream.readUTFBytes(fileStream.bytesAvailable);
				fileStream.close();
				trace("retrieved:"+file.nativePath);
				if (delArray)delArray.push(file);

			} catch (error:Error) {
				trace("PROBLEM: file not retrieved:"+file.nativePath);
			}
			return returnStr;
		}

			private function deleteFile(F:File){

			try {
				if (F.exists) {
					F.deleteFile();
					trace("            deleted:"+F.nativePath);
				}
				else {
					trace("            PROBLEM: cannot delete this file as it does not exist anymore!: "+F.nativePath);
				}
			} catch (error:Error) {
				trace("            PROBLEM: cannot delete this file: " + F.nativePath+" error:"+error);
			}
				
		}
		
		private function saveXMLtoServerFile_saved(e:Event) {
			saveXMLtoServerFile_combined(e);
			if (instructions.del) {
				trace("            success at uploading participant data. Deleting redundant data...");
				for each (var F:File in delArray) {
					deleteFile(F);
				}
			}
		}
		
		private function uploadData(str:String) { //the string only included to make sure that the prev funciton was ran before this was ran
			if(str.length!=0){
			var saveToServerF:sendToPHP = new sendToPHP(webdir+"saveXML.php",str);
			saveToServerF.addEventListener("saveXMLtoServerFile_saved",saveXMLtoServerFile_saved,false,0,true);
			saveToServerF.addEventListener("saveXMLtoServerFile_fail",saveXMLtoServerFile_fail,false,0,true);
			
			if (instructions.toWhom){
				trace("in here:" + instructions.toWhom);
				sendTheEmail(str);
			}
			}
		}
		
		private function saveXMLtoServerFile_fail(e:Event) {
			if (instructions.del)trace("            not deleting data as it was NOT successfully uploaded.");
			saveXMLtoServerFile_combined(e);
		}


		private function saveXMLtoServerFile_combined(e:Event) {
			e.target.removeEventListener("saveXMLtoServerFile_saved",saveXMLtoServerFile_saved);
			e.target.removeEventListener("saveXMLtoServerFile_fail",saveXMLtoServerFile_fail);
		}



		public function deleteDirectory(dir:String) {
			folder=File.applicationStorageDirectory.resolvePath(dir);
			if (! folder.exists) {
				trace("cannot delete this folder as it does not exist!");
			}
			else {
				try {
					folder.deleteDirectory(true);
				} catch (error:Error) {
					trace("PROBLEM: could not delete this directory for some reason: "+folder);
					trace("here's the error message: "+error);
				}
				trace("folder "+dir+" deleted");
			}
		}
	}
}