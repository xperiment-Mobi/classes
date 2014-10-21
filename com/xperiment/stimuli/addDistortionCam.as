package  com.xperiment.stimuli{
	import com.xperiment.uberSprite;
	import flash.media.Video;
	import flash.media.Camera;
	import flash.events.Event;
	import flash.events.ActivityEvent;
	import flash.text.TextField;
	import flash.geom.*;
	import flash.filters.*;
	import flash.display.BitmapData;
	import flash.filters.DisplacementMapFilter;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.display.BitmapDataChannel;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.events.ActivityEvent;
	import flash.events.TimerEvent;
	import flash.events.StatusEvent;
	import flash.utils.Timer;
	import flash.display.Stage;

	public class addDistortionCam extends addWebCam {
		var type:String=GradientType.LINEAR;
		var xMatrix:Matrix=new Matrix  ;
		var yMatrix:Matrix=new Matrix  ;
		var verRect:Shape=new Shape  ;
		var horRect:Shape=new Shape  ;
		var map:BitmapData;
		var myTimer:Timer;// 1 second
		var baseStepValue:Number;
		var counter:uint;
		var magSizeInitialValue:uint=0;
		var magSizecurrentValue:uint=0;

		override public function setVariables(list:XMLList) {

			setVar("uint", "boxWidth",200);
			setVar("uint", "boxHeight",200);
			setVar("uint","skew",0);
			setVar("uint","relativeXpos",0);
			setVar("uint","relativeYpos",0);
			setVar("boolean","seeDistortion",false);
			setVar("number","seeDistortionAlpha",.5,"0-1");
			setVar("string","horDistortionColours","0xFF0000,0x000000","number,number");
			setVar("string","horDistortionAlphas","1,1");
			setVar("string","horDistortionRatios","0,255","int,int");
			setVar("string","verDistortionColours","0x0000FF,0x000000","number,number");
			setVar("string","verDistortionAlphas","1,1","0-1,0-1");
			setVar("string","verDistortionRatios","0,255","int,int");
			setVar("string","orientation","horizontal","vertical||horizontal||both");
			setVar("uint","numberOfSteps",1);
			setVar("uint","durationOfSteps",20);
			setVar("string","listen","","unknown");
			setVar("uint","magnification",100);

			super.setVariables(list);

			if (getVar("skew")==0) {
				setVar("uint", "skew",360);
			}
			if (getVar("boxHeight")==0) {
				setVar("uint", "boxHeight",getVar("yRes"));
			}
			if (getVar("boxWidth")==0) {
				setVar("uint", "boxWidth",getVar("xRes"));
			}
		}


		override public function RunMe():uberSprite {
			yMatrix.createGradientBox(getVar("boxWidth"),getVar("boxHeight"), Math.PI / 2);
			xMatrix.createGradientBox(getVar("boxWidth"),getVar("boxHeight"));
			CameraViewer();

			super.setUniversalVariables();
			return super.pic;
		}

		override public function CameraViewer() {


			/*var blueColors:Array=[0x0000FF,0x0000FF,0x000000];
			var blueAlphas:Array=[1,1,0];
			var blueRatios:Array=[0,100,255];*/

			verRect.graphics.lineStyle(0,0,0);
			verRect.graphics.beginGradientFill(type,getVar("verDistortionColours").split(","),getVar("verDistortionAlphas").split(","),getVar("verDistortionRatios").split(","),yMatrix);
			verRect.graphics.drawRect(0,0,getVar("boxWidth"),getVar("boxHeight"));


			horRect.graphics.lineStyle(0,0,0);
			horRect.graphics.beginGradientFill(type,getVar("horDistortionColours").split(","),getVar("horDistortionAlphas").split(","),getVar("horDistortionRatios").split(","),xMatrix);
			horRect.graphics.drawRect(0,0,getVar("boxWidth"),getVar("boxHeight"));
			map=new BitmapData(horRect.width,horRect.height,false,0x7F7F7F);
			map.draw(horRect);
			var xMap:BitmapData=new BitmapData(verRect.width,verRect.height,false,0x7F7F7F);
			xMap.draw(verRect);
			map.copyChannel(xMap,xMap.rect,new Point(0,0),BitmapDataChannel.BLUE,BitmapDataChannel.BLUE);

			xMap.dispose();
			super.CameraViewer();
			
		}
		
		override public function statusHandler(event:ActivityEvent):void{
			super.statusHandler(event);
			if (getVar("seeDistortion")) {
				var tempBMP:Bitmap=new Bitmap(map);
				tempBMP.alpha=getVar("seeDistortionAlpha");
				super.pic.addChild(tempBMP);
				tempBMP.x=getVar("relativeXpos");
				tempBMP.y=getVar("relativeYpos");
			}
			sliderChanged();
		}


		// This function creates the displacement map filter at the mouse location.
		function magnify(val:Number):void {
			magSizecurrentValue=val;
			// Position the filter.
			var xyFilter:DisplacementMapFilter=new DisplacementMapFilter  ;


			xyFilter.mapBitmap=map;
			xyFilter.mapPoint=new Point(getVar("relativeXpos"),getVar("relativeYpos"));
			// The red in the map image will control x displacement.
			xyFilter.componentX=BitmapDataChannel.RED;
			// The blue in the map image will control y displacement.
			xyFilter.componentY=BitmapDataChannel.BLUE;
			//xyFilter.scaleX=35;
			if (getVar("orientation")=="vertical") {
				xyFilter.scaleY=magSizecurrentValue;
			}
			if (getVar("orientation")=="horizontal") {
				xyFilter.scaleX=magSizecurrentValue;
			}
			if (getVar("orientation")=="both") {
				xyFilter.scaleY=magSizecurrentValue;
				xyFilter.scaleX=magSizecurrentValue;
			}
			//xyFilter.mode=DisplacementMapFilterMode.CLAMP;
			//xyFilter.mode=DisplacementMapFilterMode.WRAP;
			
			
/*			var myBlur:BlurFilter = new BlurFilter();
			myBlur.quality = 3;
			myBlur.blurX = 10;
			myBlur.blurY = 10;
			vid.filters=[myBlur];*/
			
			vid.filters=[xyFilter];

		}

		// This function is called when the mouse moves. If the mouse is
		// over the loaded image, it applies the filter.


		function sliderChanged():void {
			magSizeInitialValue=magSizecurrentValue;

			counter=1;
			baseStepValue=(Number(getVar("magnification"))-magSizeInitialValue)/Number(getVar("numberOfSteps"));
			myTimer=new Timer(getVar("durationOfSteps"),getVar("numberOfSteps"));
			myTimer.addEventListener(TimerEvent.TIMER,timerMagnify);
			
			if (getVar("listen")=="")myTimer.start();
			else theStage.addEventListener(getVar("listen"), runEvent);
		}
		
		function runEvent(e:Event){
			theStage.removeEventListener(getVar("listen"), runEvent);
			myTimer.start();
		}
			

		function timerMagnify(event:TimerEvent) {
			magnify((magSizeInitialValue+(baseStepValue*counter)));
			counter++;
			if (counter==getVar("numberOfSteps")) {
				myTimer.removeEventListener(TimerEvent.TIMER,timerMagnify);
			}
		}
	}
}