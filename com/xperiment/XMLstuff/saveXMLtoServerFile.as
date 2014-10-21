package com.xperiment.XMLstuff{

	import flash.events.*;
    import flash.net.*;

/*
works like this:
var filename:String = "saveXML.php";
var dummy:saveXMLtoServerFile = new saveXMLtoServerFile(myData, filename);

ps myData is XML
*/


	public class saveXMLtoServerFile {
		
		public var saveWasSuccess:Boolean = false as Boolean;

		public function saveXMLtoServerFile(exptResults:String, filename:String) {
			trace("ccccccc:"+filename);
			var xmlString:String="<?xml version='1.0' encoding='ISO-8859-1'?><root><value>63</value></root>";
			//var xmlURLReq:URLRequest=new URLRequest("saveXML.php");
			var xmlURLReq:URLRequest=new URLRequest(filename);
			xmlURLReq.data=exptResults;
			xmlURLReq.contentType="text/xml";
			xmlURLReq.method=URLRequestMethod.POST;
			var xmlSendLoad:URLLoader=new URLLoader  ;
			
			configureListeners(xmlSendLoad);
			xmlSendLoad.load(xmlURLReq);
		}

        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            trace("success saving data");
			saveWasSuccess=true;
        }

        private function openHandler(event:Event):void {
            trace("connection opened");
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("data sent:" + event.bytesLoaded + " out of: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("security Error: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
           // trace("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("problem saving file on server: " + event);
        }


		}


	}

