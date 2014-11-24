package com.xperiment.script
{

	import com.Logger.Logger;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.Animation.MessageAnimation;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.Results.services.AccessPastResults;
	
	import flash.system.Capabilities;
	
	public class BetweenSJs extends abstractBetweenSJs
	{

		private var multisetup:XMLList;
		private var logger:Logger;
		private var expt_id:String = '1';
		private var gateway:String;
		public var __conditions:Array;
	
		
		private function extractConditions(kids:XMLList):Array
		{
	
			var conds:Array = [];
			for each(var attrib:XML in kids){
				conds.push ( attrib.name().toString() );
			}
			return conds;
		}
		


		//does not need unit testing		
		override public function __getCondFromServer(SJsPercondPerStep:Array):void
		{	

			var processingAnimation:MessageAnimation;
			var accessPastResults:AccessPastResults = new AccessPastResults();
			
			var e:Function = function(condition:String):void{
				trace('running this condition:',condition);
	
				if(condition!=''){
					ExptWideSpecs.uuidSavedToCloud=true;
					forceConditionF(condition);
				}
				else{
					__randomCondition(__conditions);
				}
				
				processingAnimation.kill();
				processingAnimation=null;
				accessPastResults.kill();
			}
			
			processingAnimation = new MessageAnimation(this, 'loading',10);
			
			if(script) expt_id=script..SETUP[0].info.@id;
			if(script..*.@cloudURL.toString().length!=0) gateway = script..*.@cloudURL.toString();
			
			if(expt_id){
				//note that AccessPastResults timesout after 10s if nothing
				
				var cutOffTime:String = script..*.@cutOffTime
				if(cutOffTime.length==0)cutOffTime='30';

				
				var info:Object = {};
				info.expt_id = 	expt_id;
				info.uuid = 	ExptWideSpecs.getSJuuid();
				info.os =  		Capabilities.os;
				info.resX = 	Capabilities.screenResolutionX;
				info.resY = 	Capabilities.screenResolutionY;
				info.DPI = 		Capabilities.screenDPI;
				info.CPU = 		Capabilities.cpuArchitecture;
				info.version = 	Capabilities.version;
				info.timeZone = new Date().getTimezoneOffset()/60;		
				
				accessPastResults.init(info,gateway,SJsPercondPerStep,__conditions,cutOffTime,e);
				
			}
			else{
				throw new Error('have not specified cloudURL which is needed to access past data currently');
			}

		}
		
		public function __randomCondition(conditions:Array):void
		{
			trace('full quota or problem contacting server so running random condition');
			randomlySelectCond();
		}		
		
		override protected function randomlySelectCond():void
		{
			if(!__conditions)__conditions = extractConditions(script.children());
			var selected:String = codeRecycleFunctions.arrayShuffle(__conditions)[0];
			forceConditionF(selected);
		}	

		
		override public function getCondOverSJquants(steps:XMLList):void{
						
			__conditions = extractConditions(script.children());
			
			var SJsPercondPerStep:Array = [];


			for each(var step:XML in steps){
				SJsPercondPerStep.push(__singleMultiStep(step.attributes()));
			}
			
			if(SJsPercondPerStep.length>0){
				__getCondFromServer(SJsPercondPerStep);
			}
			else{
				throw new Error;
			}
			
/*			for each(var obj:Object in condPerStep){
				trace(obj.accumSJs, obj.chosen, rand);
			}
*/		
			//pass on resulting object above to server
		}
		
		
		//is passed a single 'step'
		override public function __singleMultiStep(attribs:XMLList):Array
		{
			var params:Object = {};
			params['howdeterminecondition'] = '';
			params['conditionsjs'] = '';
			params['sjs']=''
				
			var attribStr:String;
			

			
			if(attribs==null){
				throw new Error('attribs equals null!');
			}
			var len:int=0;
			for each(var attrib:XML in attribs){
				//trace(attrib.name().toString().toLowerCase(),attrib,22)
				attribStr=attrib.name().toString().toLowerCase();
				if(params.hasOwnProperty(attribStr)){
					params[attribStr]=attrib.toString();
				}
				else {
					throw new Error('you have entered an unknown parameter in a multistep: '+attrib.name()+" = '"+attrib+"'");
				}
				len++;
			}
			
			if(len==0){
				throw new Error('there are no children in attribs');
			}

			if(params.howdeterminecondition=='' && params.conditionsjs==''){
				throw new Error("howdeterminecondition and conditionsjs equal ''");	
			}

			switch (params.howdeterminecondition) {
				case 'random':
					//trace(1111,params.conditionsjs, __conditions);
					return CollateSJsPerCond.give(params.conditionsjs, __conditions);
					break;
					
				default:
					throw new Error("have not set up other condition determine ways yet.  Only 'random'.")
			}
			
			throw new Error();
			return null;
		}
		
		public static function forceCond(orig_script:XML, cond:String):XML
		{

			if(orig_script.hasOwnProperty('MULTISETUP')){
				orig_script.MULTISETUP[0].@forceCondition=cond;
				
				return orig_script;
			}
			return null;
		}
	}
}