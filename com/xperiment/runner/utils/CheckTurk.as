package com.xperiment.runner.utils
{
	import com.greensock.TweenMax;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.stimuli.primitives.windows.WindowPrimitive;
	
	import flash.display.Stage;

	public class CheckTurk
	{
		static public function DO(script:XML, theStage:Stage):Boolean
		{
			
			//trys to detect if mechanical turk is used by first looking for addMechicalTurk, then seeing if the trials!=0
			//returns true if no mechical Turk
			
			
			
			var mTurkList:XMLList = script..*.addMechanicalTurk;

			if(mTurkList.length()==0) return true;
			else{
				
				var mTurk:XML=mTurkList[0];
				var trials:String=mTurk.parent().@trials.toString();
				if(trials=='0')return true;
				
				
				//So Mechanical Turk IS used here.  Important to test that the appropriate URLParams given!
				
				
				var assignmentId:String=ExptWideSpecs.IS('assignmentId');
				
				var id:String = assignmentId;
				if(id!='' && id!=null){
					return true;
				}
				else{
					
					//is devel?
					if(ExptWideSpecs.IS('isDebugger'))return true;
					
					//if not throw error
					var params:Object = {headerSize:26,closeButtonVisible:false,width:theStage.stageWidth*.9,height:theStage.stageHeight*.9, copyButtonVisible:false,textAreaVisible:false};
					var window:WindowPrimitive = new WindowPrimitive(params)
		
					
					var header:String='This study has been designed to run on Mechanical Turk. Unfortunately though, MTurk has not been provided enough information for us to proceed. ' +
						'A browser plugin may be stopping MTurk from passing this software information via the html address (url parameters). ' +
						'May we suggest though that you copy the url link for this study from MTurk (it should end with index.php?assignmentId=123 — the assignmentId bit at the end is what is missing at the moment) and paste this into an anonymous browser window, within which browser plugins are not normally enabled. ' +
						'Unfortunately, if this does not work you wont be able to do this study as there is insufficient information to link your efforts here with payment via MTurk. Sorry about that.'
					
					
					window.addMessage(header,'');	
					
					window.x=theStage.stageWidth*.05;
					window.y=theStage.stageHeight*.05;
					TweenMax.fromTo(window,1,{onStart:
						function():void{theStage.addChild(window)},x:-theStage.stageWidth, y:-theStage.stageHeight, alpha:0},{x:theStage.stageWidth*.05,y:theStage.stageHeight*.05,alpha:1});

				}	
			}	
			return false;
		}
	}
}