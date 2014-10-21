
package com.xperiment.stimuli{

	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.events.GlobalFunctionsEvent;
	import com.xperiment.stimuli.addText;
	
	import flash.display.Sprite;
	import flash.events.Event;



	public class addMechanicalTurk extends addText {
		
	
		
		private var passcode:String;
		private var spr:Sprite;
		private var doFinisBehav:Boolean = false;
		private var box:Sprite;
		private var assignmentId:String;
		
		public static var MTURK_SUBMIT:String='https://www.mturk.com/mturk/externalSubmit';
		public static var MTURK_SANDBOX_SUBMIT:String='https://workersandbox.mturk.com/mturk/externalSubmit';
		public static var phpLoc:String = "https://www.xperiment.mobi/MTurk/mTurkSubmit.php"

		override public function setVariables(list:XMLList):void {
			
			assignmentId=ExptWideSpecs.IS('assignmentId');
			
			var id:String = assignmentId;
			if(id!='' && id!=null){
				id=getPasscode(id);
			}
			else{
				id="Error! Please email andy@xperiment.mobi!"
			}
		
			
			list.@text=id;
			
			super.setVariables(list);
			
		}
		

		override public function appearedOnScreen(e:Event):void{
			theStage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.MTURK_SUBMIT));
			super.appearedOnScreen(e);
		}
		
		
		override public function kill():void{
			
			
		}
		
		override public function returnsDataQuery():Boolean {return true;}

		override public function storedData():Array {
			var tempData:Array=new Array  ;
			
			objectData.push({event:"mTurkID",data:assignmentId});
			objectData.push({event:"workderID",data:getVar("workerId")});
			return super.objectData;
		}
		

		public function getPasscode(id:String):String
		{			
			var s1:int = 0;
			var s2:int = 0;
			var tempInt:int;
			for (var i:uint=0; i<id.length; i++)
			{
				tempInt = id.charCodeAt(i);
				s1+=Math.floor(tempInt/10);
				s2+=tempInt-(Math.floor(tempInt*.1)*10);
			}
			return String(s1+s2);
		}
		
		
		
		
		public static function attempt(response:String):void
		{

		
			
			
		}
	}
}


	
	
