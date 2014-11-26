package  com.xperiment.stimuli{
	import flash.media.Video;
	import flash.media.Camera;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.ActivityEvent;
	import flash.events.TimerEvent;
	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
//import flash.display.StageScaleMode;
//import flash.display.StageAlign;
	import com.xperiment.uberSprite;

	public class addWebCam extends object_baseClass {
		
		var cam:Camera=Camera.getCamera();
		var vid:Video;
		

		override public function setVariables(list:XMLList) {
			setVar("uint","xRes",200);
			setVar("uint","yRes",200);
			setVar("uint","fps",10);

			//setVar("string","filename","");
			super.setVariables(list);
			
			if (getVar("xRes")==0) setVar("uint","xRes",theStage.stageWidth);
			if (getVar("yRes")==0) setVar("uint","yRes",theStage.stageHeight);
				//theStage.align=StageAlign.TOP_LEFT;
				//theStage.scaleMode=StageScaleMode.NO_SCALE;
		}


		override public function RunMe():uberSprite {
			CameraViewer();			
			super.setUniversalVariables();
			return super.pic;
		}


		public function CameraViewer() {
			cam.setMode(getVar("xRes"),getVar("yRes"),getVar("fps"),true);
			vid=new Video;
			
			if ((cam==null)) {
				logger.log("Unable to locate available cameras.");
			}
			else {
				logger.log(("Found camera: "+cam.name));
				cam.addEventListener(ActivityEvent.ACTIVITY,statusHandler);
				vid.attachCamera(cam);
			}

		}

		public function statusHandler(event:ActivityEvent):void {
			if (cam.muted) {
				logger.log("Unable to connect to active camera.");
			}
			else {
				// Resize Video object to match camera settings and  
				// add the video to the display list. 
				vid.width=cam.width;
				vid.height=cam.height;
				super.pic.addChild(vid);

			}
			// Remove the status event listener. 
			cam.removeEventListener(StatusEvent.STATUS,statusHandler);
		}





	}
}