package com.xperiment.stimuli
{
	import com.xperiment.preloader.PreloadStimuli;
	import com.lorentz.SVG.display.SVGDocument;
	import com.lorentz.SVG.events.SVGEvent;
	import com.lorentz.processing.ProcessExecutor;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.uberSprite;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	
	public class addSVG extends object_baseClass
	{

		private var svgDocument:SVGDocument;
		private var preloader:PreloadStimuli;
		private var pictURLReq:URLRequest;
		private var svgLdr:URLLoader;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","filename","");
			setVar("string","directory","","","specify without the ending backslash");

			super.setVariables(list);
			
		
			
			if(theStage){
				if (preloader && preloader.isFinished()) {
					ProcessExecutor.instance.initialize(theStage);
					ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
					svgDocument = new SVGDocument();
					svgDocument.parse(getVar("filename"));
					svgDocument.addEventListener(SVGEvent.RENDERED,loadedSVGEvent);	
				}
				else {
		
					//if (localStorageLocation!="" && localStorageLocation!="assets/")localStorageLocation="file://"+localStorageLocation+"/";
					var localStorageLocation:String= ExptWideSpecs.ExptWideSpecs.defaults.stimuliFolder;
					if (localStorageLocation!="" && localStorageLocation!="assets/")localStorageLocation=localStorageLocation+"/";
					//note that the above 'assets/' logic is for the DESKTOP version 
					svgLdr=new URLLoader(new URLRequest((getVar("directory")+localStorageLocation+getVar("filename"))));	
					svgLdr.addEventListener(Event.COMPLETE,loadedEvent,false,0,true);
					svgLdr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					svgLdr.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				}
			}
		}		
		
		public function loadedEvent(e:Event):void {
			svgLdr.removeEventListener(Event.INIT,loadedEvent);
			ProcessExecutor.instance.initialize(theStage);
			ProcessExecutor.instance.percentFrameProcessingTime = 0.9;
			svgDocument = new SVGDocument();
			svgDocument.parse(e.currentTarget.data as String);
			svgDocument.addEventListener(SVGEvent.RENDERED,loadedSVGEvent);		
		}
		
		public function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("addSVG problem: securityErrorHandler: " + event);
		}
		
		
		public function ioErrorHandler(event:IOErrorEvent):void {
			trace("addSVG problem: ioErrorHandler: " + event);
		}
		
		
		private function loadedSVGEvent(e:SVGEvent):void {
			
			pic.addChild(e.target as SVGDocument);
			setUniversalVariables();
			if (getVar("showBox"))showBox();
		}
		
		override public function kill():void{
			svgDocument.removeEventListener(SVGEvent.RENDERED,loadedSVGEvent);
			svgDocument=null;
		}
	}
}