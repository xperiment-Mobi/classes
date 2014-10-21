package  com.xperiment.admin{
	import com.Logger.Logger;
	import com.mobile.dataInfo;
	import com.xperiment.Network.sendToPHP;
	import com.xperiment.uberSprite;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.Results.services.emailResults;
	import com.xperiment.stimuli.primitives.simpleMenu;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import com.xperiment.interfaces.IgiveTrialInfo;

	public class adminData extends admin_baseClass implements IgiveTrialInfo {
		private var folder:File;
		private var file:File;
		private var fileStream:FileStream;
		private var webdir:String;
		private var delArray:Array;
		private var menu:simpleMenu;
		private var myInfo:dataInfo;
		private var trialObjs:Object;

		public var storageLocation:String;
		private var conditionList:Array;
		private var trialInfo:Object;
		
		public function giveTrialInfo(trialInfo:Object):void{
			this.trialInfo=trialInfo;
		}

		override public function setVariables(list:XMLList):void {
			super.setVariables(list);
			setVar("boolean","deleteAfter",false);
			setVar("boolean","email",false);
			setVar("string","saveToWeb","false");
			setVar("string","toWhom","");
			setVar("string","from","");
			setVar("string","subject","");
			setVar("uint","distanceBetweenNames",60);
			setVar("Number","buttonColour",0x626262);
			setVar("Number","buttonLineColour",0x422f54);
			setVar("int","buttonLineThickness",1);
			setVar("uint","textSize",16);
			setVar("Number","textColour",0xFFFFFF);
			
			conditionList=["data -> email","data -> web db","delete all data"];

			var obj:Object=new Object  ;
			obj.distanceBetweenNames=getVar("distanceBetweenNames");
			obj.buttonColour=getVar("buttonColour");
			obj.buttonLineColour=getVar("buttonLineColour");
			obj.buttonLineThickness=getVar("buttonLineThickness");
			obj.textSize=getVar("textSize");
			obj.textColour=getVar("textColour");
			obj.behaviourName="Data menu"
			obj.conditionList=conditionList;

			if(exptScript){
				myInfo=new dataInfo(ExptWideSpecs.ExptWideSpecs.results.saveToPortableDevice+"/results/");
				pic.addChild(myInfo);			
				menu=new simpleMenu(obj);
				menu.addEventListener("nextStep",nextStepp,false,0,true);
				pic.addChild(menu);
				
				myInfo.x=menu.giveButtonWidth();
			}
			//myInfo.y=menu.y;
		}
		
		
		
		override public function nextStep(id:String=""):void{
			
			
		}

		private function nextStepp(e:Event):void {
			var command:String=conditionList[e.target.nextStep()];
			logger.log(command);
			if (e.target.nextStep()==0) {
				sortFolder();
				logger.log("email");
				postToEmail();
			}
			else if (e.target.nextStep()==1) {
				sortFolder();
				logger.log("db");
				postToURL();
			}
			
			else if (e.target.nextStep()==2){
				sortFolder();
				logger.log("delete");
				deleteAll();
			}

		}

		override public function setUpTrialSpecificVariables(trialObjs:Object):void {
			this.trialObjs=trialObjs;
			super.setUpTrialSpecificVariables(trialObjs);
		}



		public function postToURL():void {
			
			this.webdir=ExptWideSpecs.ExptWideSpecs.results.@saveDataURL[0] +"/";
			storageLocation=folder.nativePath;

			if (! folder.exists) {
				logger.log("folder '"+storageLocation+"' does not exist!  Nothing to do!");
			}
			else if (trialInfo.storageFolder!="") {
				delArray=new Array  ;
				logger.log("Commencing upload...");
				uploadData(bulkeriseFiles());
			}

		}
	

		public function postToEmail():void {
			sendTheEmail(bulkeriseFiles());
		}

		private function sendTheEmail(tempResults:String):void {
			logger.log("Commencing bulk email of data...");
			var emailXML:emailResults=new emailResults(null,tempResults);
					
				
		}
			
		private function deleteAll():void {
			var files:Array=folder.getDirectoryListing();
			if (files.length==0) {
				logger.log("'"+storageLocation+"' folder exists BUT nothing in it! Nothing to do!");
			}
			else {
				logger.log("("+files.length+" x SJ data)");
				for (var i:uint=0; i<files.length; i++) {
					deleteFile(files[i]);
				}
				myInfo.updateTxt();
			}

		}
		

		public function bulkeriseFiles():String {//the string return to ensure that this function completes before the next
			var returnStr:String="";
			try {
				var files:Array=folder.getDirectoryListing();
				if (files.length==0) {
					logger.log("'"+storageLocation+"' folder exists BUT nothing in it! Nothing to do!");
				}
				else {
					logger.log("("+files.length+" x SJ data)");
					for (var i:uint=0; i<files.length; i++) {
						if (files[i].isDirectory==false) {
							returnStr=returnStr+"\n"+compileBulkDataFile(files[i]);
						}
						else {
							logger.log("unexpected sub-directory (leaving it along and doing nothing with the contents):"+storageLocation+"/"+files[i]);
						}
					}
				}

			} catch (error:Error) {
				logger.log("PROBLEM: combining SJ data into one file was NOT successful.  Could not access internal data: "+error);
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
				logger.log("retrieved:"+file.nativePath);
				if (delArray) {
					delArray.push(file);

				}
			} catch (error:Error) {
				logger.log("PROBLEM: file not retrieved:"+file.nativePath);
			}
			return returnStr;
		}

		private function deleteFile(F:File):void {

			try {
				if (F.exists) {
					F.deleteFile();
					logger.log("            deleted:"+F.nativePath);
				}
				else {
					logger.log("            PROBLEM: cannot delete this file as it does not exist anymore!: "+F.nativePath);
				}
			} catch (error:Error) {
				logger.log("            PROBLEM: cannot delete this file: " + F.nativePath+" error:"+error);
			}

		}

		private function saveXMLtoServerFile_saved(e:Event):void {
			saveXMLtoServerFile_combined(e);
			
		}

		private function uploadData(str:String):void {//the string only included to make sure that the prev funciton was ran before this was ran
			if (str.length!=0) {
				var saveToServerF:sendToPHP = new sendToPHP(webdir+"saveXML.php",str,logger);
				saveToServerF.addEventListener("saveXMLtoServerFile_saved",saveXMLtoServerFile_saved,false,0,true);
				saveToServerF.addEventListener("saveXMLtoServerFile_fail",saveXMLtoServerFile_fail,false,0,true);

			}
		}

		private function saveXMLtoServerFile_fail(e:Event):void {
			saveXMLtoServerFile_combined(e);
		}


		private function saveXMLtoServerFile_combined(e:Event):void {
			e.target.removeEventListener("saveXMLtoServerFile_saved",saveXMLtoServerFile_saved);
			e.target.removeEventListener("saveXMLtoServerFile_fail",saveXMLtoServerFile_fail);
		}


		override public function RunMe():uberSprite {
			setUniversalVariables();
			return (super.pic);
		}

		override public function setUniversalVariables():void {
			sortOutScaling();
			sortOutWidthHeight();
			setContainerSize();
			setRotation();
			setPosPercent();
			sortOutPadding();
			if(getVar("opacity")!=1)pic.alpha=getVar("opacity");
		}

		override public function setContainerSize():void {

			myInfo.x=menu.giveButtonWidth();
			myInfo.y=menu.y;

			pic.myWidth=pic.width-25+getVar("padding-left")+getVar("padding-right");
			pic.myHeight=pic.height-50+getVar("padding-top")+getVar("padding-bottom")+getVar("distanceBetweenNames");
			
			if (pic.myWidth<myInfo.x+myInfo.width)pic.myWidth=myInfo.x+myInfo.width;
			if (pic.myHeight<myInfo.y+myInfo.height)pic.myHeight=myInfo.y+myInfo.height;
		}


		private function sortFolder():void{
			folder=File.applicationStorageDirectory.resolvePath(ExptWideSpecs.ExptWideSpecs.results.@saveToPortableDevice[0]+"/results/");
		}


		public function deleteDirectory(dir:String):void {
			if (! folder.exists) {
				logger.log("cannot delete this folder as it does not exist!");
			}
			else {
				try {
					folder.deleteDirectory(true);
				} catch (error:Error) {
					logger.log("PROBLEM: could not delete this directory for some reason: "+folder);
					logger.log("here's the error message: "+error);
				}
				logger.log("folder "+dir+" deleted");
			}
		}

		override public function kill():void {
			menu.removeEventListener("nextStep",nextStepp);
			pic.removeChild(menu);
			menu.kill();
			menu=null;
			myInfo.kill();
			myInfo=null;
			super.kill();
		}


	}
}