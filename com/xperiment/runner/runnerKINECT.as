/*package {
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import com.trialOrderFunctions;
	import overExperiment;
	//import flash.desktop.NativeApplication;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import com.Logger.Logger;

	public class runnerKINECT extends runner {

		private var _dummyTrialAndroid:TrialKINECT;

		override public function initialise(sta:Stage) {

			theStage=sta;
			logger.passStage(theStage);
			theStage.scaleMode=StageScaleMode.SHOW_ALL;
			nerdStuff="Web appID:"+getAppInfo();

			scrWidth=theStage.stageWidth;
			scrHeight=theStage.stageHeight;


			myScript=new importExptScript("myScriptKinect.xml");
			myScript.addEventListener("dataLoaded",continueStudyAfterLoadingPause,false,0,true);
		}
	}
}*/

/*
 * Copyright (c) 2012 AS3NUI
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is furnished to
 * do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies
 * or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
 * FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package com.xperiment.runner{

	import flash.display.*;
	import fl.controls.Button;

	//import com.as3nui.airkinect.demos.away3d.ElevationDemo;
	import com.as3nui.airkinect.demos.basic.BasicDemo;
	import com.as3nui.airkinect.demos.core.BaseDemo;
	//import com.as3nui.airkinect.demos.mapping.SpaceMappingDemo;
	import com.as3nui.airkinect.demos.mask.MaskDemo;
	//import com.as3nui.airkinect.demos.mask.MaskMappingDemo;
	//import com.as3nui.airkinect.demos.pointcloud.PointCloudDemo;
	//import com.as3nui.airkinect.demos.sound.ThereminDemo;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;

	import com.xperiment.uberSprite;


	public class runnerKINECT extends Sprite {

		private var _devMode:Boolean=false;
		private var _currentDemoIndex:int;
		private var _demos:Vector.<Class>;
		private var _demoText:TextField;

		public var theStage:Stage;



		 public function initialise(sta:Stage) {
			theStage=sta;
			var spr:BasicDemo= new BasicDemo();
			theStage.addChild(spr);


			loadDemo()
		}

		private function loadDemo():void {
			theStage.addChild(new BasicDemo());
			//theStage.addChild(new CompositeDemo());
			//this.addChild(new ThresholdDemo());
			//this.addChild(new ElevationDemo());
			//this.addChild(new SpaceMappingDemo());
			//this.addChild(new PointCloudDemo());
			//this.addChild(new ThereminDemo());
			//this.addChild(new MaskDemo());
			//this.addChild(new MaskMappingDemo());
			//this.addChild(new CorrectionProblemDemo());
		}


	}
}