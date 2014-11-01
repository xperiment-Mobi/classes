package com.xperiment.make.xpt_interface.trialDecorators
{
	import com.xperiment.make.Photo;
	import com.xperiment.make.OnScreenBoss.OnScreenBossMaker;
	import com.xperiment.make.comms.Communicator;
	import com.xperiment.make.xpt_interface.MessageMaker;
	import com.xperiment.make.xpt_interface.PropertyInspector;
	import com.xperiment.make.xpt_interface.SortOrientation;
	import com.xperiment.make.xpt_interface.TrialHelpers;
	import com.xperiment.make.xpt_interface.Trial_Goto;
	import com.xperiment.make.xpt_interface.runnerBuilder;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.Bind.Bind_delStim;
	import com.xperiment.make.xpt_interface.Bind.MultiTrialCorrection;
	import com.xperiment.make.xpt_interface.Cards.Cards;
	import com.xperiment.make.xpt_interface.ClipboardETC.ClipboardETC;
	import com.xperiment.make.xpt_interface.trialDecorators.Helpers.EditText;
	import com.xperiment.make.xpt_interface.trialDecorators.StimBehav.StimBehav;
	import com.xperiment.make.xpt_interface.trialDecorators.Timeline.Timeline;

	public class CommandHelper
	{

		private static var r:runnerBuilder;
		
		
		public static function command(what:String, data:* =null):Boolean
		{
				
			switch(what){
				case 'propEdit':
					PropertyInspector.propEdit(data);
					return true;
				case 'cards_orderChanged':
					Cards.change(data as Array);
					return true;
				case 'cards_deleted':
					Cards.deleteTrials(data as Object);
					return true;
				case 'cards_runTrial':
					TrialHelpers.goto_TrialCardID(data,r);
					return true;	
					
				case 'codeChanged':
					MessageMaker.refresh(r.theStage, function():void{
						Communicator.pass('requestScript',null);
					});
					//Bind_codeMirrorChange.changed(data as Object);
					break;
				case 'script':
					r.newScript(data.toString());
					break;
				case 'loadableStim':
					StimBehav.addLoadableStimuli(data as Array);
					break;
				case 'stimBehav':
					StimBehav.addStimulus(data as String);
					break;
				/*				case 'library':
				addStimulus(data as String);
				break;*/
				case 'goto_trialNumber':
					TrialHelpers.goto_TrialNumber(data,r);
					break;
				case 'goto_trialName':
					TrialHelpers.goto_TrialName(data,r);
					break;
				case 'timePoint':
					if(!r.runningTrial.pic)r.log("requested to set the timepoint in a trial but trial not loaded yet",'what: '+what,'data: '+data);
					if(!r.runningTrial.CurrentDisplay)r.log("requested to set the timepoint in a trial but currentDisplay not loaded yet",'what: '+what,'data: '+data);
					else{
						//NOT DONE YET
						//runningTrial.CurrentDisplay
					}	
					break;
				case 'editMode':
					r.pos_scale.setMode(data);
					break;
				case 'editModeType':
					trace(1)
					MultiTrialCorrection.setMode(data);
					break;
				case 'timeChange':
					trace("received command change");
					Timeline.timeChange(data);
					break;
				case 'orderChange':
					Timeline.depthChange(data);
					break;
				case 'posScale':
					r.posScaleChanger();
					break;
				case 'textEdit':
					EditText.fromJS(data);
					break;
				case 'cards_add':
					Cards.addTrials(data.info);
					break;
				case 'trial_toolbar':
					Trial_Goto.fromJS(data);
					break;
				case 'playPauseReset_toolbar':
					OnScreenBossMaker.fromJS(data);
					break;
				case 'sizeEdit':
				case 'positionEdit':
					r.pos_scale.fromJS(data);
					//trace(data.info.command,data.info.val,232)
					break;
				case 'photo':
					Photo.take(r.theStage,Communicator.pass);
					break;
				case 'clipboard':
					var selected:Array = r.pos_scale.anySelected(); 
					if(selected.length>0)	ClipboardETC.SET(	BindScript.getSelectedCode(selected)		);
					break;
				case 'pageAlignment':
					r.orientation = data as String;
					SortOrientation.DO(r.orientation,r.trialProtocolList);
					
					//Trial.RETURN_STAGE_HEIGHT=r.theStage.stageHeight;
					//Trial.RETURN_STAGE_WIDTH=r.theStage.stageWidth;
					Communicator.pass('setScript',BindScript.cleanScript());
					r.resize();
					break;
				case 'deletePegs':
					Bind_delStim.delPegs(data as Array, r);
					break;
				
				default:
					return false;
					
					
			}	
			return true;
		}
		

		
		public static function setup(runner:runnerBuilder):void
		{
			r = runner;
			
		}
}
}