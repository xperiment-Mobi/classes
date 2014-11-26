package com.Start.MobileStart.ListExperiments
{
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class ExptInfo extends Sprite
	{
		public var file:File;
		public var exptName:String;
		public var nativePath:String;
		public var conditions:Vector.<String>; //this is null if there are no between SJ conditions
		public var expt:XML;
		public var valid:Boolean = true;
		
		
		public function kill():void
		{
			file.data.clear();
			file.cancel();
			file = null;
		}
		
		public function getExpt():void
		{

			file.addEventListener(Event.COMPLETE, function(e:Event):void{
				/////////////////////
				///anonymous function
				file.removeEventListener(Event.COMPLETE,arguments.callee);
				var byteArray:ByteArray = file.data;
				try{
					expt= new XML(byteArray.readUTFBytes(byteArray.length));
					valid=true;
					computeBS();	
				}
				catch(e:Error){
					//trace(123,e.errorID,e.message,e.name, file.nativePath)
					valid=false;
				}
				
				dispatchEvent(new Event(Event.COMPLETE));
				///anonymous function
				/////////////////////
			},false,0,true);
			//trace(file.nativePath)	
			file.load();		
			
		}
		
		private function computeBS():void
		{
			if(String(expt.name()).substr(0,4).toLowerCase()=="mult"){
				conditions = new Vector.<String>;
				var nam:String;
				for each(var cond:XML in expt.children()){
					nam=cond.name();
					if(nam.toLowerCase()!="multisetup"){
						conditions[conditions.length]=nam;
					}
				}
			}	
		}		
		
		public function forceCondition_updateFolder(condition:String):XML
		{
			//sort out condition stuff					
			if(condition!=''){
				expt.MULTISETUP.@forceCondition=condition;
			}
			////

			var updated_nativePath:String = this.nativePath.substr(0,this.nativePath.length-file.name.length);
						
			
			updateProperty('stimuliFolder',updated_nativePath);
			updateProperty('saveLocallySubFolder',updated_nativePath);

			function updateProperty(what:String, With:String):void{
				var parentInSETUP:String = ExptWideSpecs.IS_parent(what);
				//trace(expt,222,what);
				var loc:String=expt..SETUP[parentInSETUP].@[what];
				if(["/","\\"].indexOf(loc.substr(0))!=-1)loc=loc.substr(1);;
				loc=With+loc;
				expt..SETUP[parentInSETUP].@[what]=loc;
			}

			return expt;
		}
	}
}