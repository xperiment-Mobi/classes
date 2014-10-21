package com.xperiment.make.xpt_interface
{
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.events.GotoTrialEvent;
	import com.xperiment.runner.ComputeNextTrial.NextTrialBoss;

	public class Trial_Goto
	{
		private static var runner:runnerBuilder;
		public static var nextTrialBoss:NextTrialBoss;
		private static var hitLastTrial:Boolean = false;
		
		public static function fromJS(data:Object):void
		{		
			nextTrialBoss ||=runner.__nextTrialBoss;
			
			var trialNum:int=new int(nextTrialBoss.currentTrial);

			switch(data.command){
				case "first":
					if(nextTrialBoss.currentTrial>0){
						commandRunner(GlobalFunctionsEvent.GOTO_TRIAL,GotoTrialEvent.FIRST_TRIAL);
						trialNum=0;
					}
					break;
				case "last":
					trialNum = nextTrialBoss.trialList.length-1;
					commandRunner(GlobalFunctionsEvent.GOTO_TRIAL,GotoTrialEvent.LAST_TRIAL);
					break;
				case "prev":
					if(nextTrialBoss.currentTrial>=0){
							commandRunner(GlobalFunctionsEvent.GOTO_TRIAL,GotoTrialEvent.MAKER_PREV_TRIAL);
							trialNum--;
					}
					break;
				case "next":
					if(nextTrialBoss.currentTrial<nextTrialBoss.trialList.length-1 && hitLastTrial==false){
						if(nextTrialBoss.currentTrial == nextTrialBoss.trialList.length-2) hitLastTrial=true;
						commandRunner(GlobalFunctionsEvent.GOTO_TRIAL,GotoTrialEvent.MAKER_NEXT_TRIAL);
						trialNum++;
					}
					break;
				case "trialNumber":
					if(data.info.val>0 && data.info.val < nextTrialBoss.trialList.length){
						commandRunner(GlobalFunctionsEvent.GOTO_TRIAL,data.info.val);
						trialNum=int(data.info.val);
					}
					break;
				case "play":
					
					break;
				case "pause":
					
					break;
				
				default: throw new Error("unknown command");
			}
			if(data.command!='next')hitLastTrial=false;
			
			Info.DO(runner.theStage,"#"+(trialNum+1).toString());
		}
		
		
		private static function commandRunner(command:String,values:Object=null):void{
			if(values==null)values=""; //fairly rubbish this is necessary
			var e:GlobalFunctionsEvent = new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,command,values);
			runner.runCommand(e);
			runner.updateHelper.updateStuff(['Trial_Goto']);
			
		}
		
		public static function setup(r:runnerBuilder):void
		{
			runner=r;
			nextTrialBoss=null;
		}
		
	}
}
import com.greensock.TweenLite;

import flash.display.Sprite;
import flash.display.Stage;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class Info extends Sprite{
	static private var instance:Info;
	
	public static function DO(theStage:Stage,message:String):void{
		if(instance)instance.kill();
		instance = new Info(theStage,message);
	}
	
	public function Info(theStage:Stage, message:String):void{
		theStage.addChildAt(this,0);
		var col:int = Math.random()*0xffffff;
		var txt:TextField = new TextField();
		txt.defaultTextFormat=new TextFormat(null,80,0xffffff-col)
		txt.autoSize = TextFieldAutoSize.CENTER;
		txt.text=message;
		
		this.graphics.beginFill(col,.9);
		this.graphics.drawCircle(theStage.stageWidth*.5,theStage.stageHeight*.5,200);
		
		this.addChild(txt);
		txt.x = theStage.stageWidth*.5-txt.width*.5;
		txt.y = theStage.stageHeight*.5-txt.height*.5;
	
		TweenLite.to(this,.5,{alpha:0,onComplete:kill});
	}
	
	
	
	public function kill():void
	{
		if(this.parent)	this.parent.removeChild(this);
	}}