package com.xperiment{

	import flash.events.*;
	import flash.net.*;
	import flash.events.EventDispatcher;
    import flash.events.Event;
	import flash.display.*;
	import com.mobile.saveFilesInternally;
	import com.xperiment.saveXML;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	/*
	works like this:
	var filename:String = "saveXML.php";
	var dummy:saveXMLtoServerFile = new saveXMLtoServerFile(myData, filename);
	
	ps myData is XML
	*/


	public class saveXML_ANDROID extends saveXML{


		override public function sendEmergencyEmail():void {
			
			var connector:String = "&";
			if (results.nerdStuff[0].indexOf("Windows")==-1) connector="?";
			
			if (ExptWideSpecs.results.emergencyEmailForMobile && ExptWideSpecs.results.emergencyEmailForMobile!="" && emergencyEmailSentAlready==false) {
				logger.log("   ---sending emergency data in email---");
				logger.log("			to:		 " + ExptWideSpecs.results.emergencyEmailForMobile)
				logger.log("			subject:	 " + ExptWideSpecs.results.emergencyEmailForMobileSubject);
				logger.log("   ---sending emergency data in email---");
				emergencyEmailSentAlready=true
				var urlString:String = "mailto:";
                urlString += ExptWideSpecs.results.emergencyEmailForMobile;
                urlString += connector+"subject=";
                if(ExptWideSpecs.results.emergencyEmailForMobileSubject.length==0)  urlString+="data"
			    else urlString +=ExptWideSpecs.results.emergencyEmailForMobileSubject;
                urlString += "&body=";
				urlString +="There was a problem when trying to save your results.  We hope you don't mind, but could you send this email to us. It contains a backup copy of your results. Thanks!\n\n"  
                urlString += escape(String(super.results));
                navigateToURL(new URLRequest(urlString));
				listOfRequiredSaves.FORCEemergencyEmailForMobile=String(true);
				super.everythingSaved();

			}
		}
		
		override public function saveXMLtoLocalFile(locat:String):void{

			var theDate:Date = new Date();
			var saveName:String=theDate.getFullYear()+"_M"+theDate.getMonth()+"_D"+theDate.getDate()+"_H"+theDate.getHours()+"_M"+theDate.getMinutes()+"_S"+theDate.getSeconds()+"_R"+Math.floor(Math.random()*1000)+".xml";
			
			var saveLocally:saveFilesInternally=new saveFilesInternally(locat,logger);
			
			listOfRequiredSaves.saveToPortableDevice = String(saveLocally.saveFile(saveName,super.results,"results"));
			
			if(listOfRequiredSaves.saveToPortableDevice){
				logger.log("have successfully saved your data to your portable device");
				logger.log("-----------------------------------------------");
				} else{
                logger.log('Unable to save data to internal device');
				logger.log("-----------------------------------------------");
				
			}
			super.everythingSaved();
		}
	}

}