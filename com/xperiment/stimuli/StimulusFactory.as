package com.xperiment.stimuli
{
	import com.xperiment.behaviour.behavAnd;
	import com.xperiment.behaviour.behavAssignRank;
	import com.xperiment.behaviour.behavBackgroundImage;
	import com.xperiment.behaviour.behavBevel;
	import com.xperiment.behaviour.behavBlur;
	import com.xperiment.behaviour.behavCollage;
	import com.xperiment.behaviour.behavColour;
	import com.xperiment.behaviour.behavCursor;
	import com.xperiment.behaviour.behavDrag;
	import com.xperiment.behaviour.behavDragToShiftingArea;
	import com.xperiment.behaviour.behavFinishStudy;
	import com.xperiment.behaviour.behavFullScreen;
	import com.xperiment.behaviour.behavGotoCond;
	import com.xperiment.behaviour.behavGotoTrial;
	import com.xperiment.behaviour.behavGradientFill;
	import com.xperiment.behaviour.behavHide;
	import com.xperiment.behaviour.behavLanguage;
	import com.xperiment.behaviour.behavNextTrial;
	import com.xperiment.behaviour.behavOpacity;
	import com.xperiment.behaviour.behavOr;
	import com.xperiment.behaviour.behavOutline;
	import com.xperiment.behaviour.behavPause;
import com.xperiment.behaviour.behavPixelEater;
import com.xperiment.behaviour.behavRT;
	import com.xperiment.behaviour.behavRand;
	import com.xperiment.behaviour.behavRandPos;
	import com.xperiment.behaviour.behavRestart;
	import com.xperiment.behaviour.behavRotate;
	import com.xperiment.behaviour.behavSave;
	import com.xperiment.behaviour.behavSaveData;
	import com.xperiment.behaviour.behavSaveImage;
	import com.xperiment.behaviour.behavScheduleStuff;
	import com.xperiment.behaviour.behavScroll;
	import com.xperiment.behaviour.behavSequence;
	import com.xperiment.behaviour.behavShadow;
	import com.xperiment.behaviour.behavShake;
	import com.xperiment.behaviour.behavShufflePropertiesOfObjects;
	import com.xperiment.behaviour.behavSize;
	import com.xperiment.behaviour.behavSwap;
	import com.xperiment.behaviour.behavTransform;
	import com.xperiment.behaviour.behavTransformDragCopy;
	import com.xperiment.behaviour.behavTrial;
	import com.xperiment.behaviour.behavTrialOrder;
	import com.xperiment.stimuli.addBarGraph;
	import com.xperiment.stimuli.addButton;
	import com.xperiment.stimuli.addComboBox;
	import com.xperiment.stimuli.addInputTextBox;
	import com.xperiment.stimuli.addJPG;
	import com.xperiment.stimuli.addKeyPress;
	import com.xperiment.stimuli.addLoadingIndicator;
	import com.xperiment.stimuli.addMechanicalTurk;
	import com.xperiment.stimuli.addMultiNumberSelector;
	import com.xperiment.stimuli.addMultipleChoice;
	import com.xperiment.stimuli.addNumberSelector;
	import com.xperiment.stimuli.addQAs;
	import com.xperiment.stimuli.addSaveDataLocally;
	import com.xperiment.stimuli.addScreen;
	import com.xperiment.stimuli.addSequentialCounter;
	import com.xperiment.stimuli.addShapeMatrix;
	import com.xperiment.stimuli.addSlider;
	import com.xperiment.stimuli.addText;
	import com.xperiment.stimuli.addVideo;
	
	import flash.utils.Dictionary;
	

	public class StimulusFactory
	{
		
		public static var stimuli:Dictionary;
		
		public static function processStimName(stimName:String):String{

			//a hack to allow add and behav prefixes in the script
			if(stimName.substr(0,3).toLowerCase()=="add")stimName=stimName.substr(3);
			else if (stimName.substr(0,5).toLowerCase()=="behav"){
				
				stimName=stimName.substr(5);
			}
			
				
			//so, behaviours can be suffixed with B for simplicity
			//else if (stimName.substr(0,1)=="B")stimName=stimName.substr(1);	
			
			return stimName.toLowerCase();
		}
		
		
		public static function Stimulus(stimName:String):IStimulus
		{

			if(!stimuli)setupDict();
			
			stimName=processStimName(stimName);
			if(stimuli.hasOwnProperty(stimName)) return new stimuli[stimName];

			
			return null;
		}
		
		public static function getName(origNam:String):String{
			var nam:String = origNam;
			if(!stimuli)setupDict();
			nam=processStimName(nam);
			if(stimuli.hasOwnProperty(nam)){
				nam=stimuli[nam].toString();
				nam=nam.substr(7,nam.length-8);
				return nam;
			}
			return origNam;
		}
		
		public static function setupDict():void
		{

			stimuli = new Dictionary;
			
			//stimuli['twodimensionalemotionscale'] = addTwoDimensionalEmotionScale;
			stimuli['shape'] = addShape;
			stimuli['bargraph'] = addBarGraph;
			stimuli['button'] = addButton;
			//stimuli['code'] = addCode;
			//stimuli['colourarray'] = addColourArray;
			//stimuli['colourarrayxgoodxbad'] = addColourArrayXgoodXbad;
			stimuli['combobox'] = addComboBox;
			//stimuli['dropdownlist'] = addDropDownList;
			stimuli['inputtextbox'] = addInputTextBox;
			stimuli['input'] = stimuli['inputtextbox'];
			stimuli['inputbox'] = stimuli['inputtextbox'];
			stimuli['jpg'] = addJPG;
			//stimuli['jpgs'] = addJPGs;
			stimuli['keypress'] = addKeyPress;
			stimuli['loadingindicator'] = addLoadingIndicator;
			stimuli['mechanicalturk'] = addMechanicalTurk;
			stimuli['multinumberselector'] = addMultiNumberSelector;
			stimuli['multiplechoice'] = addMultipleChoice;
			stimuli['numberselector'] = addNumberSelector;
			stimuli['qas'] = addQAs;
			stimuli['savedatalocally'] = addSaveDataLocally;
			stimuli['counter'] = addSequentialCounter;
			stimuli['shapematrix'] = addShapeMatrix;
			stimuli['linescale'] = addSlider;
			stimuli['slider'] = stimuli['linescale'];
			stimuli['vas'] = stimuli['linescale'];
			stimuli['lms'] = addLMS;
			stimuli['lams'] = addLAMS;
			stimuli['screen'] = addScreen;
			stimuli['sound'] = addSound;
			stimuli['tone'] = addTone;
			stimuli['text'] = addText;
			stimuli['video'] = addVideo;
			stimuli['venndiagram'] = addVennDiagram;
			stimuli['urlvariable'] = addUrlVariable;
			stimuli['results'] = addResults;
			stimuli['hidemouse'] = addHideMouse;
			stimuli['framerate'] = addFrameRate;
			stimuli['clickablejpg'] = addClickableJPG;
			//stimuli['checkvolume'] = addCheckVolume;
			stimuli['audiocaptcha'] = addAudioCaptcha;
			//stimuli['p2p'] = addP2P;
			stimuli['time'] = addTime;
			stimuli['vibrate'] = addVibrateFake;
			stimuli['clickarea'] = addClickArea;
			//stimuli['3d'] = add3D;
			stimuli['live'] = addLive;
			stimuli['trialcounter'] = addTrialCounter;
			stimuli['motionpatch'] = addMotionPath	;
			
			//stimuli['draw'] = behavDraw;
			//stimuli['colourselector'] = behavColourSelector;
			//stimuli['colorselector'] = stimuli['colourselector']
			stimuli['trialorder'] = behavTrialOrder;
			stimuli['backgroundimage'] = behavBackgroundImage;
			stimuli['bevel'] = behavBevel;
			stimuli['blur'] = behavBlur;
			stimuli['collage'] = behavCollage;
			stimuli['color']= behavColour;
			stimuli['colour']= stimuli['color'];
			stimuli['cursor']= behavCursor;
			stimuli['drag'] = behavDrag;
			stimuli['dragtoshiftingarea'] = behavDragToShiftingArea;
			stimuli['dragtolinescale'] = behavDragTolineScale;
			stimuli['gototrial'] = behavGotoTrial;
			stimuli['gradientfill'] = behavGradientFill;
			stimuli['hide'] = behavHide;
			stimuli['language'] = behavLanguage;
			//stimuli['load'] = behavLoad;
			stimuli['nexttrial'] = behavNextTrial;
			stimuli['opacity'] = behavOpacity;
			stimuli['outline'] = behavOutline;
			stimuli['pause'] = behavPause;
			stimuli['rand'] = behavRand;
			stimuli['restart'] = behavRestart;
			stimuli['rotate'] = behavRotate;
			stimuli['rt'] = behavRT;
			stimuli['save'] = behavSave;
			stimuli['savedata'] = behavSaveData;
			stimuli['saveimage'] = behavSaveImage;
			//stimuli['search'] = behavSearch;
			stimuli['shadow'] = behavShadow;
			stimuli['shake'] = behavShake;
			stimuli['shufflepropertiesofobjects'] = behavShufflePropertiesOfObjects;
			stimuli['size'] = behavSize;
			stimuli['swap'] = behavSwap;
			//stimuli['textfilter'] = behavTextFilter;
			stimuli['timer'] = behavTimer;	
			stimuli['trial'] = behavTrial;
			stimuli['randpos'] = behavRandPos;
			stimuli['transform'] = behavTransform;
			stimuli['transformdragcopy'] = behavTransformDragCopy;
			stimuli['fullscreen'] = behavFullScreen;
			stimuli['sequence'] = behavSequence;
			stimuli['finishstudy'] = behavFinishStudy;
			stimuli['scroll'] = behavScroll;
			stimuli['assignrank'] = behavAssignRank;
			stimuli['schedule'] = behavScheduleStuff;
			stimuli['gotocond'] = behavGotoCond;
			stimuli['and'] = behavAnd;
			stimuli['or'] = behavOr;
			stimuli['pixeleater'] = behavPixelEater;
				
	

		}
	}
}



