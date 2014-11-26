package com.xperiment.stimuli{

	import flash.display.*;
	import fl.video.FLVPlayback;
	import com.xperiment.uberSprite;
	import flash.events.*;
	import flash.utils.Timer;
	import fl.video.VideoEvent;
	import com.xperiment.stimuli.addVideo;

	public class addMergingSounds extends addVideo {

		var mySounds:Array;
		var currentSound:int;
		var nextSound:int;
		var snd:FLVPlayback;
		var fadeInSteps1:uint=10;
		var firstTrial:Boolean=true;
		var somethingPlaying:Boolean=false;
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList) {

			setVar("uint","bufferTime",.1);
			setVar("number","scaleX",0);
			setVar("number","scaleY",0);
			//setVar("string","soundTransform","");
			setVar("number","startVideoAtTime",0);
			setVar("string","filenames","");
			setVar("uint","fadeInDur","");
			setVar("uint","fadeOutDur","");
			setVar("uint","crossFadeDuration","");
			setVar("uint","percentFadeSteps",5);
			super.setVariables(list);
		}

		//update="id=S1,updateWith=Minorharmony,fadeOver=500,fadeInSteps=10;id=S1,updateWith=Disharmony,fadeOver=500,fadeInSteps=10;id=S1,updateWith=Majorharmony,fadeOver=500,fadeInSteps=10"


		override public function updateMe(str:String) {

			var parameters:Array=str.split(",");
			var updateWith:String;
			var tempParam:Array;
			var actionToRun:String="fadeAcross";
			var crossFadeDuration:int=100;
			for (var i:uint=0; i<parameters.length; i++) {
				tempParam=parameters[i].split("=");


				updateWith=tempParam[1];

				for (var j:uint=0; j<mySounds.length; j++) {
					if (mySounds[j].nam==updateWith) {
						nextSound=j;
					}
				}

				switch (tempParam[0]) {
					case "stopAll" :
						mySounds[currentSound].sound.stop();
						mySounds[nextSound].sound.stop();
						somethingPlaying=false;
						logger.log("stopped all Merging Sounds");
						break;

					case "nothing" :
						logger.log("not updating with anything!");
						break;

					case "updateWith" :


						if (firstTrial) {
							firstTrial=false;
							mySounds[nextSound].sound.volume=1;
							mySounds[nextSound].sound.dataRetriever();
							somethingPlaying=true;
							//mySounds[currentSound]=mySounds[nextSound];
							currentSound=nextSound;
							logger.log("very first trial, therefore no sound updating)");
						} else if (nextSound!=currentSound||somethingPlaying==false) {
							if (somethingPlaying) {
								mySounds[currentSound].sound.stop();
							}
							mySounds[nextSound].sound.dataRetriever();
							somethingPlaying=true;
							mySounds[nextSound].sound.volume=1;
							currentSound=nextSound;
						}//mySounds[currentSound]=mySounds[nextSound];

						break;

					case "fadeOver" :

						if (firstTrial) {
							firstTrial=false;
							mySounds[nextSound].sound.volume=1;
							mySounds[nextSound].sound.dataRetriever();
							somethingPlaying=true;
							//mySounds[currentSound]=mySounds[nextSound];
							currentSound=nextSound;
							logger.log("very first trial, therefore no sound updating)");
						} else {


							crossFadeDuration=tempParam[1];
							mySounds[nextSound].sound.dataRetriever();
							somethingPlaying=true;
							soundFadeInTimer=new Timer(crossFadeDuration/fadeInSteps1,fadeInSteps1*2-1);
							soundFadeInTimer.addEventListener("timer",fadeAcross);
							soundFadeInTimer.start();
							break;

						}
				}


			}
		}


		private function fadeAcrossFirstTrial(e:TimerEvent) {
			logger.log("fading");


			if (mySounds[nextSound].sound.volume<=1) {
				mySounds[nextSound].sound.volume+=1/(fadeInSteps1);
			} else {
				mySounds[nextSound].sound.volume=1;
				currentSound=nextSound;
				soundFadeInTimer.stop();
			}
		}


		private function fadeAcross(e:TimerEvent) {


			if (mySounds[nextSound].sound.volume<=1-1/(fadeInSteps1) && mySounds[nextSound].sound.playing) {
				mySounds[nextSound].sound.volume+=1/(fadeInSteps1);

			}

			//logger.log("newSoundVol="+mySounds[nextSound].sound.volume);
			if (mySounds[nextSound].sound.volume>=.99&&mySounds[currentSound].sound.volume>0) {
				mySounds[currentSound].sound.volume-=1/(fadeInSteps1);
			}
			//logger.log("currentSoundVol="+mySounds[currentSound].sound.volume);
			if (mySounds[currentSound].sound.volume<=0) {
				mySounds[currentSound].sound.volume=0;
				mySounds[currentSound].sound.stop();
				mySounds[nextSound].sound.volume=1;
				currentSound=nextSound;
				nextSound=999;
				soundFadeInTimer.stop();
				//soundFadeInTimer.removeEventListener("timer",fadeAcross+1);
			}
		}

		private function fadeAcrossOLD(e:TimerEvent) {//where the volume for BOTH sounds goes 100 to 50 to 100%...
			logger.log("fading");
			mySounds[currentSound].sound.volume-=1/(fadeInSteps1-1);
			mySounds[nextSound].sound.volume+=1/(fadeInSteps1-1);

			if (mySounds[currentSound].sound.volume<=0) {
				mySounds[currentSound].sound.volume=0;
				mySounds[currentSound].sound.stop();
			}

			if (mySounds[nextSound].sound.volume>=1) {
				mySounds[nextSound].sound.volume=1;
			}
			if (mySounds[currentSound].sound.volume<=0&&mySounds[nextSound].sound.volume>=1) {
				currentSound=nextSound;
				soundFadeInTimer.stop();
				soundFadeInTimer.removeEventListener("timer",fadeAcross);
				logger.log("stopped old sound");
			}
			logger.log("currentSoundVol="+mySounds[currentSound].sound.volume);
			logger.log("newSoundVol="+mySounds[nextSound].sound.volume);


		}

		function loop(event:VideoEvent):void {
			event.target.play();
		}


		override public function RunMe():uberSprite {
			mySounds=new Array();
			var fileNames:Array=getVar("filenames").split(",");
			for (var i:uint = 0; i< fileNames.length; i++) {
				var obj:Object=new Object  ;
				obj.nam=fileNames[i];
				var snd=new FLVPlayback  ;
				snd.fullScreenTakeOver=false;
				snd.source=fileNames[i];
				snd.autoPlay=false;
				snd.autoRewind=true;
				snd.volume=0;
				logger.log("source: "+fileNames[i]);
				snd.bufferTime=getVar("bufferTime");
				snd.addEventListener("complete", loop);


				obj.sound=snd;
				mySounds.push(obj);
			}

			currentSound=0;

			super.pic.width=1;
			super.pic.height=1;

			if (getVar("fadeInDur")!="") {
				mySounds[currentSound].sound.volume=0;
				soundFadeInTimer=new Timer(getVar("fadeInDur"),100/getVar("percentFadeSteps"));
				soundFadeInTimer.addEventListener("timer",fadeIn);

			}

			if (getVar("fadeOutDur")!="") {
				mySounds[currentSound].sound.volume=0;
				soundFadeOutTimer=new Timer(getVar("fadeInDur"),20);
				soundFadeOutTimer.addEventListener("timer", fadeOut);
			}



			mySounds[currentSound].sound.addEventListener("complete", removeVideo);
			super.pic.addEventListener(Event.REMOVED_FROM_STAGE, stopVideo);
			super.pic.addEventListener(Event.ADDED_TO_STAGE, startVideo);
			mySounds[currentSound].sound.pause();


			super.pic.addChild(mySounds[currentSound].sound);
			super.setUniversalVariables();
			return super.pic;
		}

		private function removeVideo(event) {
			super.pic.removeChild(mySounds[currentSound].sound);
			mySounds[currentSound].sound.removeEventListener("complete", removeVideo);
		}

		private function fadeIn(e:TimerEvent) {
			mySounds[currentSound].sound.volume+=1/20;
			if (mySounds[currentSound].sound.volume>=1) {
				soundFadeInTimer.removeEventListener("timer",fadeIn);
			}
		}

		private function fadeOut(e:TimerEvent) {
			mySounds[currentSound].sound.volume-=1/20;
		}

		private function stopVideo(event) {
			mySounds[currentSound].sound.stop();
			mySounds[currentSound].sound.removeEventListener(Event.REMOVED_FROM_STAGE, stopVideo);
		}

		private function startVideo(event) {



			//mySounds[currentSound].sound.play();
			mySounds[currentSound].sound.removeEventListener(Event.REMOVED_FROM_STAGE, stopVideo);

			if (getVar("fadeInDur")!="") {
				soundFadeInTimer.start();
			} else {
				mySounds[currentSound].sound.volume=1;
			}

		}

	}
}