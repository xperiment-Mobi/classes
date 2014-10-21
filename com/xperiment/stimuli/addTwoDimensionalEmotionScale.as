package  com.xperiment.stimuli{


	import com.xperiment.uberSprite;
	import com.xperiment.events.StimulusEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class addTwoDimensionalEmotionScale extends object_baseClass {

		private var j:uint;
		private var padding:uint=10;
 
		public var verticalSpacing:uint=30;
		public var track:Sprite=new Sprite  ;
		public var trackBG:Sprite=new Sprite  ;
		public var face:Sprite=new Sprite  ;
		public var lowVal:Number=0;
		public var axisLength:Number;
		public var range:Number;
		public var startVal:Number;
		public var changeProp:String;
		public var triangleTLD:uint;
		public var triangleHeight:uint;
		public var flipPointerFix:int;
		public var startTime2D:Date;
		public var endTime2D:Date;
		public var timeWhenMouseReleased:Array=new Array  ;
		private var _XlabelList:Array;
		private var _XlabelLocation:Array;
		private var _YlabelList:Array;
		private var _YlabelLocation:Array;
		private var _myTextFormat:TextFormat=new TextFormat  ;
		private var scale:Sprite=new Sprite  ;
		private var ghostsArray:Array;
		private var myTextFormat:TextFormat=new TextFormat  ;
		private var eyes:Sprite=new Sprite  ;
		private var mouth:Sprite=new Sprite  ;
		private var my2DTimer:Timer;
		private var startingTime:Number;
		private var eyeSize:int;
		private var eyePositionShift:int=0;
		private var shiftEyesUp:Number=0;
		private var flipAxes:Boolean;
		private var adjustEyeSize:Number=1;
		private var Mouth:Number=1;
		private var mouthSize:uint;
		private var shiftMouthUp:int;
		private var mouthRatio:Number;

		private var thicknessofEyesLine:int;
		private var eyeLinerColour:int;
		private var thicknessofMouthLine:int;
		private var mouthColour:int;
		private var eyeColour:Number;
		private var slowDownTail:uint;
		
		private var borderToAxis:Number;
		private var graphics:Sprite = new Sprite;
		
		private var counter:Vector.<String> = new Vector.<String>;
		private var xPos:Vector.<String> = new Vector.<String>;
		private var yPos:Vector.<String> = new Vector.<String>;
		private var time:Vector.<String> = new Vector.<String>;

		private var myText:TextField;
		
		
		override public function kill():void{
			my2DTimer.stop();
			face.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
			my2DTimer.removeEventListener(TimerEvent.TIMER, logData);
			
			graphics.removeChild(track);
			graphics.removeChild(scale);
			graphics.removeChild(trackBG);
			graphics.removeChild(face);
			
			pic.removeChild(graphics);
			if(myText)pic.removeChild(myText);
			
			super.kill();
		}

		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList):void {
			setVar("string","axisLength",'90%');
			setVar("number","startVal",-1);
			setVar("uint","lineThickness",2);
			setVar("string","XlabelList","");
			setVar("string","XlabelLocation","0&&100");
			setVar("string","YlabelList","");
			setVar("string","YlabelLocation","0&&100");
			setVar("uint","distBetweenLabelsAndScale",10);
			setVar("number","colour",0x111999);
			setVar("uint","size",10);
			setVar("string","alignment","LEFT");
			setVar("uint","tagLength",5);
			setVar("number","faceColour",0x2147AB);
			setVar("boolean","dontRecordWhenNoResponseMade",true);
			setVar("boolean","hidePointerAtStart",true);
			setVar("uint","backgroundClickBoxSize",30);
			setVar("uint","textColour",0x000000);
			setVar("uint","textBackgroundColour",0xFFFFFF);
			setVar("uint","textFontSize",15);
			setVar("string","resultFileName","setMeNextTime");
			setVar("uint","numberTailSegments",10);
			setVar("number","tailDecayRate",96);
			setVar("uint","tickFreq",500);
			setVar("uint","thicknessofFaceLine",1);
			setVar("uint","thicknessofEyesLine",1);
			setVar("uint","thicknessofMouthLine",1);
			setVar("number","eyeColour",0x000000);
			setVar("number","mouthColour",0x000000);
			setVar("number","faceLineColour",0x000000);
			setVar("number","eyeLinerColour",0x000000);
			setVar("uint","eyeSize",10);
			setVar("int","shiftEyesRight",0);
			setVar("int","shiftEyesApart",20);
			setVar("string","flipTheAxes","no");
			setVar("uint","faceSize",20);
			setVar("uint","faceLocationX",0);
			setVar("uint","faceLocationY",0);
			setVar("uint","mouthSize",40);
			setVar("uint","shiftMouthUp",-20);
			setVar("uint","shiftEyesUp",-20);
			setVar("number","mouthRatio",1);
			setVar("uint", "slowDownTail", 1);
			setVar("number", "lineColour",0x000000);
			setVar("string", "showLocationOverTime", "false");
			setVar("number", "tailColour",0xFFF000);
			setVar("string","neatLabels","false");
			super.setVariables(list);
			//startTime=Date();

		}


		override public function returnsDataQuery():Boolean {
			return true;
		}


		
		private function logData(event:TimerEvent):void {
			
			//currentCount,x %, y%, time
			counter[counter.length] = 	String(		my2DTimer.currentCount					);
			xPos[xPos.length] = 		String(		int(((face.x)/axisLength)*1000)/10		);
			yPos[yPos.length] = 		String(		int((1-((face.y)/axisLength))*1000)/10	);
			time[time.length] = 		String(		getTimer()-startingTime					);
			

			if (myText) {
				myText.text=("@" + counter[counter.length-1] + " count" + ",X" + xPos[xPos.length-1]+",Y"+yPos[yPos.length-1]);
			}
		}




		override public function storedData():Array {//ppp
			my2DTimer.stop();
			var tempData:Array=new Array  ;
			
			var nam:String = getVar("peg");
			
			objectData.push({event:nam+'_counter',data:counter.join(",")});
			objectData.push({event:nam+'_x',data:xPos.join(",")});
			objectData.push({event:nam+'_y',data:yPos.join(",")});
			objectData.push({event:nam+'_time',data:time.join(",")});


			//super.theStage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);

			return super.objectData;
			//return objectData;
		}



		override public function RunMe():uberSprite {
			super.setUniversalVariables();
			pic.scaleX=1;
			pic.scaleY=1;
			
			myTextFormat.color=getVar("textColour");
			myTextFormat.size=getVar("textFontSize");
			eyePositionShift=getVar("shiftEyesApart");
			mouthRatio=getVar("mouthRatio");
			eyeSize=getVar("eyeSize");
			mouthSize=getVar("mouthSize");
			shiftMouthUp=-1*getVar("shiftMouthUp");
			eyeColour=getVar("eyeColour");
			slowDownTail=getVar("slowDownTail");

			if (getVar("flipTheAxes")=="no") {
				flipAxes=false;
			} else {
				flipAxes=true;
			}
			shiftEyesUp=getVar("shiftEyesUp");
			assignVariables();

			createTrack();
		
			createFace();
			composeLabels();
			
			graphics.addChild(track);
			graphics.addChild(scale);
			graphics.addChild(trackBG);
			graphics.addChild(face);


			
			pic.addChild(graphics)
			graphics.y=graphics.x=borderToAxis;
			
			
			this.addEventListener(StimulusEvent.DO_AFTER_APPEARED,onAppear)

			return pic;

		}
		
		
		private function onAppear(e:Event):void{
			this.removeEventListener(StimulusEvent.DO_AFTER_APPEARED,onAppear);
			my2DTimer=new Timer(getVar("tickFreq"));
			my2DTimer.addEventListener(TimerEvent.TIMER, logData);
			my2DTimer.start();
			startingTime=getTimer();

				if (getVar("showLocationOverTime")=="true") {

					myText = new TextField;
					myText.text="hello";
					myText.background=true;
					myText.background=0xffffff
					myText.x=0;
					myText.y=0;
					myText.width=200;
					myText.autoSize=TextFieldAutoSize.LEFT;
					myText.setTextFormat(myTextFormat);
					pic.addChild(myText);
				}
		}


		public function assignVariables():void {

			_myTextFormat.color=getVar("textColour");
			_myTextFormat.size=getVar("size");
			

			_XlabelList=generateArray(getVar("XlabelList"),"&&");
			_YlabelList=generateArray(getVar("YlabelList"),"&&");

			var tempText:String=getVar("XlabelLocation");
			_XlabelLocation=tempText.split("&&");
			tempText=getVar("YlabelLocation");
			_YlabelLocation=tempText.split("&&");
			
			axisLength=Number(getVar("axisLength").split("%").join("")) *.01* pic.myWidth;
			borderToAxis=(pic.myWidth-axisLength)*.5;
			startVal=getVar("startVal");

			thicknessofEyesLine=getVar("thicknessofEyesLine");
			eyeLinerColour=getVar("eyeLinerColour");
			thicknessofMouthLine=getVar("thicknessofMouthLine");
			mouthColour=getVar("mouthColour");


		}


		public function generateArray(t:String,divider:String):Array {
			return t.split(divider);
		}



		private function createFace():void {

			face.graphics.lineStyle(getVar("thicknessofFaceLine"),getVar("faceLineColour"));
			face.graphics.beginFill(getVar("faceColour"));
			face.graphics.drawCircle(0, 0, getVar("faceSize"));

			range=axisLength;
			face.buttonMode=true;

			if (getVar("startVal")==-1) {
				startVal=Math.random()*100;
			}
			startVal=axisLength*startVal/100;

			face.x=.5*axisLength+getVar("faceLocationX");
			face.y=.5*axisLength-getVar("faceLocationY");
			face.addChild(eyes);
			face.addChild(mouth);
			addEyesAndMouth();
			//face.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
			super.theStage.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);


		}


		public function createTrack():void {//xxx


			track.graphics.lineStyle(getVar("lineThickness"),getVar("lineColour"));
			trackBG.graphics.lineStyle(getVar("backgroundClickBoxSize"),0,0);

			track.graphics.moveTo(0,axisLength/2);
			trackBG.graphics.moveTo(0,axisLength/2);


			track.graphics.lineTo(axisLength,axisLength/2);
			trackBG.graphics.lineTo(axisLength,axisLength/2);

			track.graphics.moveTo(axisLength/2,0);
			trackBG.graphics.moveTo(axisLength/2,0);

			track.graphics.lineTo(axisLength/2,axisLength);
			trackBG.graphics.lineTo(axisLength/2,axisLength);

		}


		private var Tail:Array=new Array  ;
		private var tailCounter:uint=1;

		private function addTail():void {

			if (my2DTimer.running && (tailCounter==slowDownTail||slowDownTail==1)) {


				for (var i:uint=0; i<Tail.length; i++) {

					if (i>=getVar("numberTailSegments")) {
						graphics.removeChild(Tail[i]);
						Tail.pop();
					} else {
						var xshift:uint=Tail[i].width;
						var yshift:uint=Tail[i].height;
						Tail[i].scaleX=Tail[i].scaleX*getVar("tailDecayRate")/100;
						Tail[i].scaleY=Tail[i].scaleY*getVar("tailDecayRate")/100;

						Tail[i].alpha=Tail[i].alpha-(1-getVar("tailDecayRate")/100);

						xshift =(xshift- Tail[i].width) / 2;
						yshift =(yshift- Tail[i].height) / 2;
						Tail[i].x=Tail[i].x+xshift;
						Tail[i].y=Tail[i].y+yshift;
					}
				}

				var segment:Sprite=new Sprite  ;

				segment.graphics.lineStyle(2);
				segment.graphics.beginFill(getVar("tailColour"),.5);
				segment.graphics.drawCircle(0, 0, getVar("faceSize"));
				segment.alpha=.9;
				segment.graphics.endFill();
				//segment.scaleX=.05*getVar("faceSize");
				//segment.scaleY=.05*getVar("faceSize");
				segment.x=face.x;
				segment.y=face.y;

				Tail.unshift(segment);
				graphics.addChildAt(segment,0);


			}

			if (slowDownTail!=1) {
				tailCounter++;
			}


			if (tailCounter>slowDownTail&&slowDownTail!=1) {
				tailCounter=1;
			}
		}

		private function updateFace(e:MouseEvent):void {
			addTail();
			addEyesAndMouth();
		}

		private function addEyesAndMouth():void {
			if (flipAxes) {
				addEyes(face.x/axisLength);
				addMouth(face.y/axisLength);

			} else {
				addEyes(1-(face.y/axisLength));
				addMouth(face.x/axisLength);

			}
		}


		private function addEyes(adjust:Number):void {

			eyes.graphics.clear();

			eyes.graphics.lineStyle(thicknessofEyesLine,eyeLinerColour);
			eyes.graphics.beginFill(eyeColour);
			//eyes.graphics.drawEllipse(45+eyePositionShift,shiftEyesUp+47-(adjustEyeSize*.5),eyeSize,adjustEyeSize);
			//eyes.graphics.drawEllipse(124+eyePositionShift,shiftEyesUp+47-(adjustEyeSize*.5),eyeSize,adjustEyeSize);
			eyes.graphics.drawEllipse(-(eyePositionShift/2)-(.5*eyeSize),0-(.5*eyeSize*adjust)-shiftEyesUp,eyeSize,eyeSize*adjust);
			eyes.graphics.drawEllipse(+(eyePositionShift/2)-(.5*eyeSize),0-(.5*eyeSize*adjust)-shiftEyesUp,eyeSize,eyeSize*adjust);

			//eyes.graphics.drawEllipse(+eyePositionShift/2,shiftEyesUp,eyeSize,adjustEyeSize);
			eyes.graphics.endFill();

		}

		private function addMouth(mouthShift:Number):void {
			mouth.graphics.clear();
			mouth.graphics.lineStyle(thicknessofMouthLine,mouthColour);
			mouth.graphics.moveTo(-mouthSize/2,shiftMouthUp);
			mouth.graphics.curveTo(0,(mouthShift-.5)*mouthSize+shiftMouthUp,mouthSize/2,shiftMouthUp);
		}


		private function handleMouseDown(evt:MouseEvent):void {
			face.startDrag(false,new Rectangle(0,0,axisLength,axisLength));
			super.theStage.addEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
			super.theStage.addEventListener(MouseEvent.MOUSE_MOVE, updateFace);

		}


		private function handleMouseUp($evt:MouseEvent):void {
			face.stopDrag();
			super.theStage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
			super.theStage.removeEventListener(MouseEvent.MOUSE_MOVE, updateFace);
		}


		public function composeLabels():void {
			scale.graphics.lineStyle(getVar("lineThickness"))//,getVar("lineColour"));

			var tagL:int=getVar("tagLength");


			var txtF:TextField;
			var ver:Array = [];
			var hor:Array = [];
			
			
			for (var i:int=0; i<_XlabelList.length; i++) {
				txtF=scaleLabel(_XlabelList[i]);
				scale.addChild(txtF);
				txtF.y=axisLength*.5-txtF.height*.5
				txtF.x=i*axisLength/(_XlabelList.length-1)-txtF.width*.5;
				hor.push(txtF);
			}

			for (i=0; i<_YlabelList.length; i++) {
				txtF=scaleLabel(_YlabelList[i]);
				txtF.background=true;
				
				txtF.y=i*axisLength/(_YlabelList.length-1)-txtF.height*.5;
				txtF.x=axisLength*.5-txtF.width*.5
				scale.addChild(txtF);
				ver.push(txtF);
			}

			if(getVar("neatLabels")=="true"){
				txtF=hor[0];
				txtF.x+=txtF.width*.5+5;
				
				txtF=hor[_XlabelList.length-1];
				txtF.x-=txtF.width*.5+5;
				
				txtF=ver[0];
				txtF.y+=txtF.height*.5+5;
				
				txtF=ver[_YlabelList.length-1];
				txtF.y-=txtF.height*.5+5;
			}
			
		}



		public function scaleLabel(t:String):TextField {
			var tt:TextField=new TextField  ;
			tt.background=true;
			tt.autoSize = "left";
			tt.backgroundColor=getVar("textBackgroundColour");
			tt.text=t;
			tt.selectable=false;
			tt.setTextFormat(myTextFormat);
			return tt;
		}
	}
}