package com.xperiment.behaviour
{
	import com.mobile.Notifications.NotificationHelper;
	import com.xperiment.behaviour.behav_baseClass;

	public class behavFuture extends behav_baseClass
	{
		override public function kill():void{
			
			super.kill();
		}
		
		override public function setVariables(list:XMLList):void {
			setVar("string","title","experiment");
			setVar("string","body","can you do the study now please");
			setVar("string","when","1","","comma seperated times to do the study, in seconds, after this behaviour has run");
			setVar("int","radius",8);
			
			super.setVariables(list);	
		}
		
		
		override public function returnsDataQuery():Boolean{
			return true;
		}
		
		
		override public function nextStep(id:String=""):void{
			super.nextStep(id);
			
			var data:Object = NotificationHelper.data;
			if(!data)	NotificationHelper.future(getVar("title"),getVar("body"),getVar("when").split(","));
			else{
				for(var key:String in data){
					
					objectData.push(	{event:key,data:data[key]}	);
					
				}
			}

		}
		
		

	}
}


