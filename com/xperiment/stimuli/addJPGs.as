package  com.xperiment.stimuli{
	
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import flash.display.*;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.*;

	import flash.net.URLRequest;
	import com.xperiment.preloader.IPreloadStimuli;
	
	public class addJPGs extends object_baseClass implements IgivePreloader {
		
		private var pictURLReq:URLRequest;
			
		private var preloader:IPreloadStimuli;
		private var bmp:Bitmap;
		private var orderSoFar:Array;
		private var fileNames:Array;
		private var order:Array;
		private var alphas:Array;
		private var useJPG:Array;
		private var jpg:Sprite;
		private var imagesLoaded:Array;
		
		override public function setVariables(list:XMLList):void {
			
			setVar("uint","size",10);
			setVar("string","filename","");
			setVar("boolean","showOutlineBeforeLoaded",false);
			setVar("string","alpha","1");
			setVar("string","order","1");
			setVar("string","useJPG","1");
			

			super.setVariables(list);
			if(theStage){
				
				fileNames=(getVar("filename") as String).split(",");
				alphas=(getVar("alpha") as String).split(",");
				order=(getVar("order") as String).split(",");
				useJPG=(getVar("useJPG") as String).split(",");
				
				if (preloader && preloader.progress()==1) {	
					
					var pics:Array=new Array;
					jpg=new Sprite;
					
					
					var bmp:Bitmap;
					var bmd:BitmapData;

					for(var i:uint=0;i<fileNames.length;i++){
						if(useJPG[i]=="1"){
							jpg=new Sprite;

							bmp=(preloader.give(fileNames[i])as Bitmap);

							//note, an annoying hack to make a deep copy of the image, not a shallow copy.  Allows the object to appear more than once at a time.
				
							bmd=bmp.bitmapData;							
							bmp=new Bitmap(bmd);
							////////////////////
							if(bmp){
								jpg.addChild(preloader.give(fileNames[i]));
								jpg.alpha=Number(alphas[i%alphas.length]);
								pic.addChild(jpg);
								//pic.addChildAt(jpg,determineOrder(int(order[i%order.length])));
							}
							
						}
					}
					setUniversalVariables();
					if (getVar("showBox"))showBox();
				}
				else {
					imagesLoaded = [];
					for(i=0;i<fileNames.length;i++){
						if(useJPG[i]=="1"){
							imagesLoaded[fileNames[i]]=null;
							loadPic(fileNames[i]);
							
						}
					}
				}
			}
		}

		
		public function loadedEvent(e:Event):void {
			var pictLdr:Loader = (e.target as LoaderInfo).loader;
			listeners(pictLdr,false);
			var bmp:Bitmap = new Bitmap();
			bmp = pictLdr.content as Bitmap;
			jpg=new Sprite;
			jpg.addChild(bmp);
			imagesLoaded[pictLdr.name]=jpg;
			
			var pass:Boolean=true;
			for each(var loaded:Sprite in imagesLoaded){
				if(!loaded){pass=false;break;}
			}
			if(pass){
				
				for(var i:int=fileNames.length-1;i>=0;i--){
					pic.addChild(imagesLoaded[fileNames[i]]);
				}
				
				
				setUniversalVariables();
				if (getVar("showBox"))showBox();
			}
		}
		

	
		private function loadPic(fileName:String):void{
			var pictLdr:Loader = new Loader  ;
			var localStorageLocation:String= ExptWideSpecs.IS("computer.stimuliFolder");
			if (localStorageLocation!="" && localStorageLocation!="assets/")localStorageLocation=localStorageLocation+"/";
			//note that the above 'assets/' logic is for the DESKTOP version 
			listeners(pictLdr,true);
			pictLdr.name=fileName;
			pictLdr.load(new URLRequest((getVar("directory")+localStorageLocation+fileName)));	
		}
		
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("addJPG problem: securityErrorHandler: " + event);
		}
		
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("addJPG problem: ioErrorHandler: " + event);
		}
		

		
		
		private function determineOrder(ord:int):int
		{
			if(!orderSoFar){orderSoFar=[ord];return 0;}
			else{
				for (var i:int=orderSoFar.length;i>=0;i--){
					if(ord<orderSoFar[i]){
						orderSoFar.spice(i,0,ord);
						return i;
						break;
					}
				}
			}
			return 0;
		}
		
		public function passPreloader(preloader:IPreloadStimuli):void {
			this.preloader=preloader;
		}
		
		private function listeners(pictLdr:Loader, on:Boolean):void{
			if(on){
				pictLdr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				pictLdr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				pictLdr.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				pictLdr.contentLoaderInfo.addEventListener(Event.INIT,loadedEvent);
			}
			else{
				pictLdr.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				pictLdr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				pictLdr.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				pictLdr.contentLoaderInfo.removeEventListener(Event.INIT,loadedEvent);
			}
		}
		
		
		override public function kill():void {
			super.kill();
		}
	}
}