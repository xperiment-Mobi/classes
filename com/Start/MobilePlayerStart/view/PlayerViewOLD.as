package com.Start.MobilePlayerStart.view
{


	import com.danielfreeman.madcomponents.UI;
	import com.danielfreeman.madcomponents.UIButton;
	import com.danielfreeman.madcomponents.UIScrollVertical;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class PlayerViewOLD extends Sprite {
		
		public var scroll:UIScrollVertical;
		public var doContinue:UIButton;
		
		private var screen:XML = <vertical alignH="fill">
							<label>Xperiment lets you take part in research from all corners of the world.  Simply click on the research-link you received. Material for the study will download and the experiment will start automatically.
You are seeing this screen as you have run the app but have not given it a study to run.  May we suggest you take part in one of these studies:
</label>

			<scrollVertical  id = "scroll" mask="true" colour = "#ff0000" background = "#ffffff, #ffffff" gapV = "100" gapH = "100" alignH = "right"  visible = "true" border = "true" autoLayout = "true"> 	
				
			</scrollVertical>

			<button id="doContinue">Continue</button>

						</vertical>
		private var theStage:Stage;
		
		public function PlayerViewOLD(stage:Stage) {
			this.theStage=stage;	
			theStage.addChild(this);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
	
			UI.create(this, screen);
			
			scroll= UI.findViewById("scroll") as UIScrollVertical;
			doContinue = UI.findViewById("doContinue") as UIButton;
			
			
			doContinue.height=50;
				
			doContinue.y=theStage.stageHeight=doContinue.height;
			
			
		}
		
		public function experiments(exptStrVec:Vector.<String>):void
		{
			trace(exptStrVec)
			// TODO Auto Generated method stub
			
		}
	}
}