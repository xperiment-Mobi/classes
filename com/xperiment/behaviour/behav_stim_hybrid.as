package com.xperiment.behaviour
{
	import com.xperiment.uberSprite;

	public class behav_stim_hybrid extends behav_baseClass
	{
		
		//private var listenerArr:Array;
		/*
		var listenerObj:Object;
		listenerObj.event as String;
		listenerObj.funct as Function;
		listenerObj.target 
		
		*/	
		
		public function behav_stim_hybrid()
		{
			//killListeners();
			
			
			super();
		}
		
		/*private function killListeners():void
		{
			if(listenerArr){
				for each(var listenerObj:Object in listenerArr){
					listenerObj.target.removeEventListener(listenerObj.event,listenerObj.funct);
					listenerObj.target=null; listenerObj.event = null; listenerObj.funct = null;
					listenerObj=null;
				}
				listenerArr=null;
			}
		}*/
		
		protected function getStim(nam:String):uberSprite{
			
			var peg:String = getVar(nam);
			if(peg=="")return null;
			
			for(var i:int=0;i<behavObjects.length;i++){
				if(behavObjects[i].peg==peg)return behavObjects[i];
			}
			
			throw new Error("For a colourSelector (peg="+peg+"), you have specified an unknown stimulus to use as a '"+nam+"'");
			
			return null;
		}
		
		/*protected function waitTilOnStage(what:DisplayObject,event:String, funct:Function):void{
			if(what && what.stage){
				funct();
			}
			else{
				listenerArr ||= [];
				var listenerObj:Object = {};
				listenerObj.event = event;
				listenerObj.funct = funct;
				listenerObj.target= what;
				listenerArr.push(listenerObj);
				what.addEventListener(event, nowOnStage);
			}
		}
		
		protected function nowOnStage(e:Event):void
		{
			trace(1)
			for(var i:int=0;i<listenerArr.length;i++){
				
				if(listenerArr[i].target==e.currentTarget && listenerArr[i].event == e.type){
					listenerArr[i].funct();
					return
				}
			}
			throw new Error();
		}	*/
		
	}
}