package com.xperiment.XMLstuff{

	
	import com.xperiment.Animation.MessageAnimation;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.Network.sendToPHP;
	import com.xperiment.RequiredActions.RequiredActions;
	import com.xperiment.Results.Results;
	import com.xperiment.Results.services.SoapService;
	import com.xperiment.Results.services.emailResults;
	import com.xperiment.DeviceQuery.DeviceQuery;
	import com.xperiment.stimuli.primitives.windows.AbstractModalWindow;
	import com.xperiment.stimuli.primitives.windows.ModalWindow_send;
	import com.xperiment.trial.Trial;
	
	import flash.display.Stage;

	public class saveResults implements ISaveResults{

		public var results:XML;

		public var requiredActions:RequiredActions;
		public var timeout:int = 20000;
		
		private var theStage:Stage;
		private var processingAnimation:MessageAnimation;
		private var exptResults:Results;
		
		private var emailMe:emailResults;
		private var saveToServerFile:sendToPHP;
		private var soapService:SoapService
		
		public function saveResults(theStage:Stage){
			this.theStage=theStage;
			this.exptResults = Results.getInstance();
			this.results=exptResults.composeXMLResults();
			DeviceQuery.wipeSessionUUID();
			setupActions();
		}
		
		public function setupActions():void{
			requiredActions = new RequiredActions(timeout,{success:[saveSucceeded,stopAnimation],fail:[__saveFailed,stopAnimation]});
		}
		
		public function save():void {				
			__queryHowSave();
			if(requiredActions.count()>0){
				if(theStage){ //added this for unit testing
					processingAnimation = new MessageAnimation(theStage, 'saving results...',timeout/1000);
				}
				requiredActions.start();
			}
		}
		
		public function __queryHowSave():Array{
			var toSave:Array = []; //for unit testing only
			var __saveArr:Array = (ExptWideSpecs.IS('save')).toLowerCase().split(",");
		
			if(__saveArr.indexOf('webfile')!=-1){
				
				requiredActions.add(8000,{action:saveToServer,retry:3},'saveToServerFile');
				toSave.push('webfile');
			}
			
			if(__saveArr.indexOf('email')!=-1){
				requiredActions.add(8000,{action:email,retry:3},'emailResults');
				toSave.push('email');
			}
			
			if(__saveArr.indexOf('cloud')!=-1){
				requiredActions.add(8000,{action:cloudSave,retry:3},'saveToCloud');
				toSave.push('cloud');
			}
			return toSave;
			
		}
		
		
		private function cloudSave(success:Function):void{
	
			soapService = new SoapService;
			
			var results:Object = exptResults.composeCloudResults();
			if(ExptWideSpecs.IS("course_id")!='')	ExptWideSpecs.addCourseInfo(results);
			
			results.final = true;
			results.ip = ExptWideSpecs.IS("ip");
			
			if(ExptWideSpecs.uuidSavedToCloud){
				soapService.send(results,SoapService.UUID_ALREADY_SAVED_TO_CLOUD,success);
			}
			else{
				soapService.send(results,SoapService.SAVE_RESULTS,success);
			}
		
		}
		
		
		private function saveToServer(success:Function):void
		{
			
			var phpLocation:String = ExptWideSpecs.getURL('saveXML.php');
			
			saveToServerFile = new sendToPHP(phpLocation,results,success);
		}
		
		public function email(success:Function):void
		{
			var myEmailAddress:String=ExptWideSpecs.IS("myAddress");
			var toWhomAddress:String=ExptWideSpecs.IS("toWhom");
			var subject:String=ExptWideSpecs.IS("subject");
			var tempResults:String = String(results);
			emailMe=new emailResults(tempResults,success);
			
		}
		
		private function saveSucceeded():void{
			
			var message:String = ExptWideSpecs.IS("saveSuccessMessage");
		
			var params:Object = {width:Trial.RETURN_STAGE_WIDTH*.9,height:Trial.RETURN_STAGE_HEIGHT*.7, sendButtonsVisible:false,textAreaVisible:false};

			var modalWindow:AbstractModalWindow = new AbstractModalWindow(theStage, params,ExptWideSpecs.IS("saveSuccessMessage"),'',params);
			
			requiredActions.kill();
			
		}
		
		public function __saveFailed():void{
			
			var errors:String = compileErrors();
			
			var params:Object = {width:Trial.RETURN_STAGE_WIDTH*.9,height:Trial.RETURN_STAGE_HEIGHT*.9};	
			
			var info:String = "following save errors reported:\n-----\n"+errors+"\n-----\n\n";
			
			var toWhom:String = ExptWideSpecs.IS("toWhom").toString();
			if(toWhom=='false')toWhom= ExptWideSpecs.IS("myAddress").toString();
			
			var message:String = ExptWideSpecs.IS("saveFailMessage").replace("EMAILADDRESS",toWhom);
			
			var modalWindow:AbstractModalWindow = new ModalWindow_send(theStage, params,message,info+results,params);
			requiredActions.kill();
		}	
		
		public function compileErrors(more:String=''):String
		{
			var errors:String=more;
			
			function wasError(what:String,err:String):void{
				if(errors)errors += "\n";
				else errors= '';
				
				errors += what+"\n"+err;
			}
			
			if(emailMe && emailMe.succeeded==false){
				wasError('email',emailMe.getLog());
			}
			if(saveToServerFile && saveToServerFile.succeeded==false){
				wasError('saveToServer',saveToServerFile.__myLog);
			}
			if(soapService && soapService.succeeded==false){
				wasError('cloud',soapService.myLog);
			}
			return errors;
		}
		
		private function stopAnimation():void{
			processingAnimation.kill();
		}
		
	}
}