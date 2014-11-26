package com.xperiment.XMLstuff{

	import com.mobile.saveFilesInternally;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.XMLstuff.saveResults;
	
	import flash.display.Stage;
	import flash.filesystem.File;

	
	/*
	works like this:
	var filename:String = "saveXML.php";
	var dummy:saveXMLtoServerFile = new saveXMLtoServerFile(myData, filename);
	
	ps myData is XML
	*/


	public class saveResultsAndroid extends saveResults implements ISaveResults{
		
		private var saveLocally:saveFilesInternally
		
		public function saveResultsAndroid(theStage:Stage){
			super(theStage);
		}
		
		override public function save():void{


			if(ExptWideSpecs.IS('saveLocallySubFolder')
				&& (
					ExptWideSpecs.IS("app").indexOf("Xperimenter")!=-1
					||
					ExptWideSpecs.IS("app").indexOf("XperimentLab")!=-1
					)
				) //dont what saving to local dir when the app is 'Player'
			{
				requiredActions.add(8000,{action:saveXMLtoLocalFile,retry:3});
			}
			
			super.save();
		}
	
		override public function compileErrors(more:String=''):String
		{
			if(saveLocally && saveLocally.succeeded==false){				
				more += "saveLocallySubFolder\n"+saveLocally.getLog();
			}
			
			return super.compileErrors(more);
		}

		
		public function saveXMLtoLocalFile(success:Function):void{
			success(true);
			
			
			var theDate:Date = new Date();
			var saveName:String=theDate.getFullYear()+"_M"+theDate.getMonth()+"_D"+theDate.getDate()+"_H"+theDate.getHours()+"_M"+theDate.getMinutes()+"_S"+theDate.getSeconds()+"_R"+Math.floor(Math.random()*1000)+".sav";
			
			//throw new Error('for the future, make sure that the file saved has some unique characteristic; note above 2 lines are not used!  Note, sort out success below');
			if(ExptWideSpecs.IS("app").indexOf("XperimentLab")!=-1)	saveLocally=new saveFilesInternally(getFolder());
			else 													saveLocally=new saveFilesInternally();
			
			saveLocally.saveFile(saveName,results,success);
		}
		
		private function getFolder():File
		{
			// TODO Auto Generated method stub
			var locat:String=ExptWideSpecs.IS("saveLocallySubFolder") as String;
			return File.documentsDirectory.resolvePath(locat);
		}
	}

}