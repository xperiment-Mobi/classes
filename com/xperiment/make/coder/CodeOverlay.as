package com.xperiment.make.coder
{

	import com.xperiment.trial.Trial;
	
	import flash.display.Stage;

	public class CodeOverlay
	{
		
		private var theStage:Stage;
		private var currentStimuli:CurrentStimuli;
		private var display:Display;
		
		public function CodeOverlay(theStage:Stage)
		{
			this.theStage = theStage;
			display = new Display;
			this.theStage.addChild(display);
			displayOnTop();
		}
		
		private function displayOnTop():void
		{
			theStage.addChild(display); //same as re-specifying as on top;
			
		}
		
		public function update(runningTrial:Trial):void
		{
			currentStimuli = new CurrentStimuli(runningTrial.OnScreenElements);
			displayOnTop();
			display.add(	currentStimuli.generateIcons()	);
			
		}
		
		public function kill():void{
			currentStimuli.kill();
		}
		
	
	}
}
import com.xperiment.behaviour.behav_baseClass;
import com.xperiment.stimuli.object_baseClass;
import flash.display.Sprite;

class CurrentStimuli{
	
	private var stimuli:Vector.<Stimulus> = new Vector.<Stimulus>;
	
	public function CurrentStimuli(stimOrig:Vector.<object_baseClass>){
		for each(var stim:object_baseClass in stimOrig){

			if(stimuli is behav_baseClass) stimuli[stimuli.length] = new Behaviour(stim);
			else stimuli[stimuli.length] = new Stimulus(stim);
		}

	}
	
	public function generateIcons():Array{

		var icons:Array = [];
		for each(var stim:Stimulus in stimuli){
			
			icons[icons.length] = stim.generateIcon();
		}
		return icons;
	}
	
	public function kill():void
	{
		for each(var stim:Stimulus in stimuli){
			stim.kill();
		}
		
	}
}

class Stimulus{
	
	private var width:int = 100;
	private var height:int=70;
	
	protected var stim:object_baseClass;

	public function Stimulus(stim:object_baseClass){
		this.stim=stim;		
	}
	
	
	public function kill():void
	{
		stim=null;
		
	}
	
	public function generateIcon():Sprite
	{
		var spr:Sprite = new Sprite;
		spr.graphics.beginFill(0xffffff*Math.random(),1);
		spr.graphics.drawRoundRect(stim.myX,stim.myY,width,height,5,5);
		return spr;
	}
}

class Behaviour extends Stimulus{
	
	public function Behaviour(stim:object_baseClass){
		super(stim);
	}
	
}

