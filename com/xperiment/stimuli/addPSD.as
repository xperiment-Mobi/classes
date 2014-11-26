package  com.xperiment.stimuli{
	
	import com.PSDParser.PSDLayer;
	import com.PSDParser.PSDParser;
	import com.xperiment.preloader.PreloadStimuli;
	import com.graphics.pattern.Box;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.uberSprite;
	
	import flash.display.*;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class addPSD extends object_baseClass {
		
		private var pictURLReq:URLRequest;
		private var pictLdr:Loader;
		private var preloader:PreloadStimuli;
		private var psdParser				: PSDParser;
		private var layersLevel				: Sprite;
		
		override public function setVariables(list:XMLList):void {

			setVar("uint","size",10);
			setVar("string","filename","");
			setVar("string","directory","","","specify without the ending backslash");
			setVar("boolean","showOutlineBeforeLoaded",false);
			super.setVariables(list);
			if(theStage){
				if (preloader) {
					psdParser = PSDParser.getInstance();
					psdParser.parse(preloader.giveBinary(getVar("filename")));
		

					layersLevel = new Sprite();
					this.addChild(layersLevel);
					
					for (var i : Number = 0;i < psdParser.allLayers.length; i++) 
					{
						var psdLayer 		: PSDLayer			= psdParser.allLayers[i];
						var layerBitmap_bmp : BitmapData 		= psdLayer.bmp;
						var layerBitmap 	: Bitmap 			= new Bitmap(layerBitmap_bmp);
						layerBitmap.x 							= psdLayer.position.x;
						layerBitmap.y 							= psdLayer.position.y;
						layerBitmap.filters						= psdLayer.filters_arr;
						layersLevel.addChild(layerBitmap);
					}
					
					var compositeBitmap:Bitmap = new Bitmap(psdParser.composite_bmp);
					layersLevel.addChild(compositeBitmap);
					pic.addChild(layersLevel);
					
					//trace(bmp.width+" hhhhh")
					//if(bmp)pic.addChild(bmp);
					setUniversalVariables();
					if (getVar("showBox"))showBox();
				}
				else {
					var localStorageLocation:String= ExptWideSpecs.ExptWideSpecs.defaults.stimuliFolder;
					if (localStorageLocation!="" && localStorageLocation!="assets/")localStorageLocation="file://"+localStorageLocation+"/";
					//note that the above 'assets/' logic is for the DESKTOP version 
					//trace("ffff:"+localStorageLocation);
					pictLdr=new Loader  ;
					pictLdr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
					pictLdr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					pictLdr.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					pictLdr.contentLoaderInfo.addEventListener(Event.INIT,loadedEvent,false,0,true);
					pictLdr.load(new URLRequest((getVar("directory")+localStorageLocation+getVar("filename"))));	
					
				}
			}
			
		}		
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("addJPG problem: securityErrorHandler: " + event);
		}
		

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("addJPG problem: ioErrorHandler: " + event);
		}
		
		public function loadedEvent(event:Event):void {
			pictLdr.contentLoaderInfo.removeEventListener(Event.INIT,loadedEvent);
			var bmp:Bitmap = new Bitmap();
			bmp = pictLdr.content as Bitmap;
			pic.addChild(bmp);
			
			setUniversalVariables();
			if (getVar("showBox"))showBox();
		}
		
		public function passPreloader(preloader:PreloadStimuli):void {
			this.preloader=preloader;
		}
		
		
		override public function kill():void {
			pictURLReq=null;
			pictLdr=null;
			super.kill();
		}
	}
}