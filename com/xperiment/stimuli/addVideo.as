package  com.xperiment.stimuli{
	
	import com.dgrigg.minimalcomps.graphics.Shape;
	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	import com.xperiment.preloader.IPreloadStimuli;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	
	
	
	public class addVideo extends object_baseClass implements IgivePreloader {
		
		private var myVideo:Video;
		
		private var MyNS:NetStream;
		private var preloader:IPreloadStimuli;
		private var repeatCount:uint=0;
		private var localStorageLocation:Object;
		private var nc:NetConnection;
		private var videoLoadedTimer:Timer = new Timer(50,1);
		private var delayRun:Boolean = false;
		private var videoClient:Object;
		private var duration:int;
		private var vidObj:*;
		private var shown:Boolean = false;
		private var lengthOfVideo:int;
		private var started:Boolean = false;
		
		override public function kill():void{
			videoLoadedTimer.stop();
			videoLoadedTimer.removeEventListener(TimerEvent.TIMER,timerF);
			if(getVar("killVideoAfter") as Boolean && preloader)preloader.removeFileFromMemory(getVar("filename"));
			if(pic.hasEventListener(Event.ADDED_TO_STAGE))pic.removeEventListener(Event.ADDED_TO_STAGE, startVideoWhenNotAddedToStage);
			Listeners(false);
			myVideo = null;
			if(MyNS)MyNS.close();
			MyNS = null;
			if(nc)nc.close();
			nc = null;
		}
		
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('frame')==false){
				uniqueProps.frame= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null.
					if(!myVideo) return '';
					if(what) {
						var time:int = Number(to)/100*lengthOfVideo;
						MyNS.pause();
						MyNS.seek(time);
						return '1'
					}
					return '1'
				}; 	
			}
			
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		override public function myUniqueActions(action:String):Function{
			if(!uniqueActions){
				uniqueActions = new Dictionary;
				//uniqueActions.restart=function():void{restart();}; 
				uniqueActions.play=function():void{beginVideo();} ; 		
				uniqueActions.togglePause=function():void{MyNS.togglePause();
				}; 
			}
			if(uniqueActions.hasOwnProperty(action)) return uniqueActions[action]
			
			return null;
		}
		
/*		private function restart():void{
		//NB BROKEN
			if(started){
				MyNS.seek(0)
				MyNS.play(null)
			}
		}*/
		
		override public function returnsDataQuery():Boolean {
			return getVar("save");
		}
		
		override public function storedData():Array {			
			if(shown)objectData.push({event:getVar("save"),data:getVar("filename")});
			return objectData;
		}

		
		override public function appearedOnScreen(e:Event):void{
			started=true;
			super.appearedOnScreen(e);
		}
		
		
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList):void {
			
			//setVar("string","soundTransform","");
			/*setVar("string","startVideoAt",'90%');*/
			setVar("number","volume",1,"0 to 1");
			setVar("string","filename","");
			setVar("boolean","destroyStimulusAfter",false);
			setVar("string","onFinish","hide","can equal hide,restart,repeatx2,repeatx3 etc");  
			setVar("string","save",'',"set to whatever value you want (will be saved in the results) if you want to save the filename if the video is run");
			setVar("boolean","exactSize",true);
			setVar("string","filenamePrefix","","");
			setVar("string","filenameSuffix","","");
			super.setVariables(list);
			setVariables_loadingSpecific();
			
			if(getVar("filename").indexOf(".mp4")!=-1)throw new Error("cannot use mp4!! https://forums.adobe.com/message/4008099");
			
			videoLoadedTimer.addEventListener(TimerEvent.TIMER,timerF);
			
			if(!preloader){
				initVideo(false);
			}
			if(preloader){
				if(preloader.fileLoaded(getVar("filename"))==1){
					initVideo(true);
				}
				else{
					
					var loading:Shape = new Shape;
					loading.graphics.beginFill(0x616161,.5);
					loading.graphics.drawRect(theStage.stageWidth*.5-50,theStage.stageHeight*.5-50,100,100);
					pic.addChild(loading);
					
					//TweenLite.fromTo(loading, .2, {alpha:1}, {alpha:.1, tint:0xFF0000,repeat:-1,ease:Quad.easeOut});
					
					
					var pingMeWhenLoaded:Function = function():void{ //passes a function to Preloader which is called when prelaoder is finished
						//TweenLite.killTweensOf(loading);
						initVideo(true);
						preloader.cleanupFunctsListeners(pingMeWhenLoaded,null,null);
						pic.removeChild(loading);
						loading = null;
					}
					
					//preloader not finished so must listen and wait...
					preloader.listenFileLoad(pingMeWhenLoaded,null,null,getVar("filename"))
				}
			}
			//trace(peg,2)
		}
		
		public function setVariables_loadingSpecific():void{
			
			setVar("boolean","destroyStimulusAfter",false);
			
			if(OnScreenElements.hasOwnProperty("extension")==false)	setVar("string","extension","",'do not use a dot here, e.g. jpg, nb this is optional');
			
			if(getVar("extension")!="" && getVar("filename").indexOf(".")==-1)	{
				
				OnScreenElements.filename=OnScreenElements.filename+"."+getVar("extension");
			}
			OnScreenElements.filename = OnScreenElements.filenamePrefix + OnScreenElements.filename + OnScreenElements.filenameSuffix;
		}
		
		protected function timerF(event:TimerEvent):void
		{	
			if(delayRun)beginVideo();
		}
		
		public function getTime():String{	
			var tim:String=String(MyNS.time*1000);
			if(tim.indexOf(".")!=-1)tim=tim.substr(0,tim.indexOf("."));// on the very rare occasion, tim goes bananas and ends up with loads of digits.  Stupid flash bug.
			return tim;
		}
		
		public function passPreloader(preloader:IPreloadStimuli):void {
			this.preloader=preloader;
		}
		
		override public function RunMe():uberSprite {
			pic.graphics.beginFill(0x000000,0);
			pic.graphics.drawRect(0,0,1,1);
			if(myVideo)commence();
			return (pic);
		}
		
		private function commence():void
		{
			shown=true;
			pic.visible=true;
			beginVideo();
			super.setUniversalVariables();
		}		
		
		private function beginVideo():void{
			if(started==true)	MyNS.resume();
		}
		
		private function Listeners(ON:Boolean):void{
			if(MyNS){
				var has:Boolean = MyNS.hasEventListener(NetStatusEvent.NET_STATUS);
				
				if(ON && !has)MyNS.addEventListener(NetStatusEvent.NET_STATUS, detectEvents);
				else if(has) MyNS.removeEventListener(NetStatusEvent.NET_STATUS, detectEvents);
			}
		}
		
		
		private function detectEvents(e:NetStatusEvent):void {
			
			e.stopPropagation();

			if(pic.stage && e.info.code=="NetStream.Play.Stop" || e.info.code=="NetStream.Buffer.Empty" )
			{
				if(ran)pic.dispatchEvent(new Event(StimulusEvent.ON_FINISH));
				
				
				var fin:String=getVar("onFinish");
				switch(fin.substr(0,4)){
					case "rest":
						MyNS.seek(0);
						break;
					case "repe":
						
						if((fin.split(["x"] as Array).length)>1){
							if(!isNaN(fin.split("x")[1]) && int(fin.split("x")[1])<repeatCount) {
								MyNS.seek(0);
								repeatCount++;
							}
						}
						break;
					default:
						myVideo.visible=false;
						break;		
				}
			}
		}
		
		
		private function initVideo(isLoaded:Boolean):Boolean{
			
			if(preloader)vidObj = preloader.give(getVar("filename"))

	
				
			//annoying race condition in the stimulus loader
			if(vidObj == null){			
				var raceCondTimer:Timer = new Timer(50);
				raceCondTimer.addEventListener(TimerEvent.TIMER,
					function(e:TimerEvent):void{
						vidObj = preloader.give(getVar("filename"));
						if(vidObj!=null){
							raceCondTimer.stop();
							raceCondTimer.removeEventListener(e.type,arguments.callee);
							initVideo(true);
						}
					}
				);
				if(preloader)raceCondTimer.start();
				return false;
			}
			
			
			myVideo=new Video;
			
			nc = new NetConnection ();
			nc.connect (null);
			
			MyNS = new NetStream(nc)
			Listeners(true);
			MyNS.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errL); 
	
			videoClient = new Object();
			videoClient.onMetaData = function(infoObject:Object):void{
				lengthOfVideo = int(infoObject.duration * 1000)+1;
				if(getVar("exactSize") || getVar("width")=="0"){pic.width = myVideo.width = infoObject.width;setVar("string","width",pic.width);}
				if(getVar("exactSize") || getVar("height")=="0"){pic.height = myVideo.height = infoObject.height;setVar("string","height",pic.height);}
				duration = int(infoObject.duration) * 1000 +1;
				setUniversalVariables();
			}
			
			MyNS.client = videoClient;
			
			myVideo.attachNetStream(MyNS);
			
			MyNS.play(null)
			
	
			if(isLoaded == true){
				MyNS.appendBytes(vidObj);
				videoLoadedTimer.start();
				MyNS.pause();
			}
			
		
			
			if(getVar("volume") as Number!=1) volume(getVar("volume") as Number);
			
			pic.visible=false;
			pic.addChild(myVideo);	
			
			
			if(!pic.stage){
				pic.addEventListener(Event.ADDED_TO_STAGE, startVideoWhenNotAddedToStage);
			}
			else {
				commence();
			}	
			
			return true;
		}
		
		private function volume(vol:Number):void{
			var videoVolumeTransform:SoundTransform = new SoundTransform();
			videoVolumeTransform.volume = vol;
			MyNS.soundTransform = videoVolumeTransform;
		}
		
		
		private function errL(event:Event):void 
		{
			trace("error in addVideo: "+event);
		}
		
		
		
		private function removeVideo(event:Event):void {
			super.pic.removeChild(myVideo);
			myVideo.removeEventListener("complete", removeVideo);
		}
		
		
		private function startVideoWhenNotAddedToStage(e:Event):void {
			commence();
		}
		
		
	}
}