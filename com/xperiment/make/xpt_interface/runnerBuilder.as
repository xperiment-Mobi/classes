package com.xperiment.make.xpt_interface
{
	import com.xperiment.make.OnScreenBoss.OnScreenBossMaker;
	import com.xperiment.make.comms.Communicator;
	import com.xperiment.make.helpers.ResizeHelper;
	import com.xperiment.make.richSync.RichXML;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.Bind.Bind_delStim;
	import com.xperiment.make.xpt_interface.Bind.Bind_processChanges;
	import com.xperiment.make.xpt_interface.Cards.Cards;
	import com.xperiment.make.xpt_interface.trialDecorators.CommandHelper;
	import com.xperiment.make.xpt_interface.trialDecorators.TrialDecorator;
	import com.xperiment.make.xpt_interface.trialDecorators.StimBehav.StimBehav;
	import com.xperiment.make.xpt_interface.trialDecorators.Timeline.Timeline;
	import com.xperiment.messages.XperimentMessage;
	import com.xperiment.preloader.PreloadStimuli;
	import com.xperiment.runner.runner;
	import com.xperiment.script.ProcessScript;
	import com.xperiment.script.ProcessScript_builder;
	import com.xperiment.trial.Trial;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;


	public class runnerBuilder extends runner
	{
		public var pos_scale:TrialDecorator;
		public var orientation:String;
		public var updateHelper:UpdateHelper;
		private var richXML:RichXML;
		private var inFocus:Boolean = false;
		private var _editMode:Boolean = true;
		
		override public function giveScript(scr:XML,remote_url:String=null):void{
			trace("initialising...");
			updateHelper = new UpdateHelper(this);
			scr = BindScript.setup(scr.copy(),updateHelper.updateStuff);
			if(Communicator._linked == false) initComms();
			
			CommandHelper.setup(this);
			Trial_Goto.setup(this);
			Timeline.setup(this,Communicator.pass,BindScript.depthOrderChanged, Bind_processChanges.timingChanged );
			StimBehav.setup(this, BindScript.addStimulus);
			Bind_delStim.setup(this);
			PropertyInspector.setup(BindScript.getStimScript,Communicator.pass,this);
			PlayHelper.setup(this);
			
			//Coder.setup(this);
			super.giveScript(scr);
			Cards.setup(Communicator.pass,updateHelper.updateStuff);
			Cards.generateInstructions();
			sendInitialParasJS();
		/*	if(!t){ t = new Timer(1000,0);
				t.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
					commandF('script', scr);
				});
				t.start();
			}*/
			
	
			//addStimuli(["t.png"]);
		}
		
		
		public function runnerBuilder(sta:Stage) {
			PreloadStimuli.preserveQueue=true;
			isBuilder=true;
			
			super(sta);
			checkFocus();
			hhhh();
			
			ResizeHelper.init(theStage,resize);
			
		}
		
		public function resize():void{			
			setDimensions();
			theStage.align='';
			restartTrial(false);
		}
		
		override protected function setDimensions():void{
			if(orientation == "vertical"){
				Trial.RETURN_STAGE_HEIGHT=1024;
				Trial.RETURN_STAGE_WIDTH=768;;

			}		
			else{
				Trial.RETURN_STAGE_HEIGHT=theStage.stageHeight;
				Trial.RETURN_STAGE_WIDTH=theStage.stageWidth;
			}
			
		}
		
		
		private function hhhh():void
		{
			
			var s:Sprite = new Sprite;
			s.graphics.beginFill(Math.random()*0xffffff,.4);
			s.graphics.drawRect(0,0,100,100);
			theStage.addChild(s);

			s.addEventListener(MouseEvent.CLICK,function(e:Event):void{
				
				//CommandHelper.command('editMode',!editMode);
		
				//resize();
				//Cards.generateInstructions();
				//StimBehav.addStimulus('lineScale',null);
				//pos_scale.setMode(true);
				//pos_scale.fromJS({info:{command:"snap-to-grid"}});
				//posScaleChanger();
				//var arr:Array = ['a','b'];
				//arr=codeRecycleFunctions.arrayShuffle(arr);
				//Timeline.timeChange({peg:'noPeg0',start:0,end:200});
				//OnScreenBossMaker.fromJS({command:"play"});
				//newScript(trialProtocolList.toString())
				PropertyInspector.propEdit({group:'noPeg0---noPeg1---noPeg2---noPeg3---noPeg4---noPeg5---noPeg6---noPeg7---noPeg8---noPeg9 — text',name:'width',value:'100%'});
				//StimBehav.addLoadableStimuli(["new.png"]);
				//Bind_delStim.stim([]);
				//[{"group":"text","info":"a","start":0,"end":"forever"},{"group":"text","info":"a","start":0,"end":"forever"},{"group":"button","info":"noPeg0","start":0,"end":"forever"}]
				//Timeline.depthChange(['noPeg','a','a']);
				//restartTrial()
				//Trial_Goto.fromJS({command:'first'});
			});
			
			
			s = new Sprite;
			s.graphics.beginFill(0xf222ff,.4);
			s.graphics.drawRect(0,0,100,100);
			theStage.addChild(s);
			s.x=theStage.stageWidth-s.width;
			s.addEventListener(MouseEvent.CLICK,function(e:Event):void{
				//pos_scale.setMode(false);
				//Cards.generateInstructions();
				Trial_Goto.fromJS({command:'last'});
			});
			
			theStage.addEventListener(KeyboardEvent.KEY_UP,function(e:KeyboardEvent):void{
				if(e.keyCode==81){
					pos_scale.hack();
				}
				else if(e.keyCode==87){
					pos_scale.hack1();
				}
			});
		}
		
		private function checkFocus():void
		{
			theStage.addEventListener(Event.ACTIVATE, l);
			theStage.addEventListener(Event.DEACTIVATE, l);
			
			function l(e:Event):void{
				if(e.type == Event.ACTIVATE)	inFocus=true;
				else inFocus=false;
			}
		}
		
		override protected function giveProcessScript():ProcessScript{
			return new ProcessScript_builder();
		}
	
	
/*		public function runTrial():void{
			//trace(runningTrial.pic,122)
				();
		}*/
		
		override public function runningExptNow_II(restartOtherStuff:Boolean):void{
			//runningTrial.ITI=0;
			//Cards.generateInstructions();
			commenceWithTrial();
			if(restartOtherStuff){
				PropertyInspector.newTrial(runningTrial as TrialBuilder);
				Timeline.update(runningTrial);
				posScaleChanger();
			}
			//ZYY

			//Timeline.update(runningTrial);
			//BindScript.giveProcessedScript(trialProtocolList);
			
			
			
			//commandF('goto_trialNumber','0');
			//commandF('goto_trialName','circle');
			
			
			
			//commandF('trial_icons','');
			
			//commandF('goto_trialNumber','0');
			//commandF('timePoint','0');	
			
			
			//TrialEdit.hack()
		}
		
		public function posScaleChanger():void
		{			
			if(pos_scale){
				pos_scale.newTrial(runningTrial);
			}
			else{
				pos_scale = new TrialDecorator(runningTrial,theStage, restartTrial);
			}
		}
		
	
		
		private function sendInitialParasJS():void{
//			/Communicator.pass('timePoint',script);
			Communicator.pass('setScript',BindScript.cleanScript());
			
			var params:Object = StimParams.collect();
			
			Communicator.pass('exptParams',params.params);
			//Communicator.pass('stimuliBehavs',params.stimuliBehavs);
			
			
		/*	var bytes:ByteArray = new ByteArray();
			var fileRef:FileReference=new FileReference();
			fileRef.save(paramsJSON, "fileName");
			*/
			
			//hack();			
		}
		
		override public function newTrial():Trial{
			return new TrialBuilder();
		}
		
		override protected function scaleMode():void{
			//theStage.scaleMode=StageScaleMode.NO_SCALE;
		}
		
		override protected function submitMTurk():void
		{
		}	

		
		override protected function commandF(what:String, data:* =null):void{
			//Communicator.pass('info',what+"___"+data.toString());
			//trace(23232,what)

			var found:Boolean = CommandHelper.command(what,data);
			if(found==false)	super.commandF(what,data);
		}
			

/*		
		public function syncRunnerScript_BindScript():void{
			trialProtocolList = BindScript.script;
			trace("syched");
		}
		
		*/
		public function restartTrial(restartOtherStuff:Boolean):void{
			//trialProtocolList = BindScript.script;
			runningTrial.generalCleanUp();
			runningTrial.ITI=0;
			runningExptNow_II(restartOtherStuff);							
		}
		


		public function log(... args):void{
			var message:Array = [];
			
			for(var i:int=0;i<args.length;i++){
				message[message.length]=String(args[i]);
			}
			var str:String =  "devel error/n"+ message.join("/n")
			XperimentMessage.message(theStage,str);
		
			throw new Error(str);
		}
		
		override public function kill():void{
			//if(pos_scale && pos_scale.hasEventListener(NeedsUpdating.NEEDS_UPDATE)) pos_scale.removeEventListener(NeedsUpdating.NEEDS_UPDATE,updateSomething);
			
			updateHelper.kill();
			super.kill();
		}
		
		override protected function problemWithNextTrial(action:String):void
		{
			Trial_Goto.fromJS({command:'first'});
		}

		public function newScript(data:String):void
		{
			try{
				var newScript:XML = XML(data);
				//trace(123,newScript);
				kill();
				
				while(theStage.numChildren>0){
					theStage.removeChildAt(0);
				}
				
				setNeedsDoing();
				giveScript(newScript);
			}
			catch(e:Error){
				trace("err",e);
			}
			
		}

		public function get editMode():Boolean
		{
			return _editMode;
		}

		public function set editMode(ON:Boolean):void
		{
			_editMode = ON;
			OnScreenBossMaker.isStill = ON;
		}

	}
}