package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;


	public class addUrlVariable extends object_baseClass
	
	{
		private var urlParams:Array;
		
		override public function setVariables(list:XMLList):void {
		
			super.setVariables(list);
			
			var val:String;
			for (var param:String in OnScreenElements){
				val=OnScreenElements[param];
				if(param.charAt(0)=="_"){
					if(!urlParams)urlParams=[];	
					urlParams[param.substr(1)]=val;			
					
				}
			}
		}
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		override public function storedData():Array {
			var tempData:Array = new Array();
			for(var s:String in urlParams){
				if(urlParams[s]!=""){
					objectData.push({event:s,data:urlParams[s]});
				}
			}
			return objectData;
		}
		

		override public function RunMe():uberSprite {

			var load:Object = theStage.loaderInfo.parameters;
			
			if(urlParams){
				for (var s:String in load){
					if(urlParams.indexOf(s)){
						urlParams[s]=load[s];
					}
				}
			}
			load=null;
			super.setUniversalVariables();
			pic.width=1;
			pic.height=1;
			pic.scaleX=1;
			pic.scaleY=1;
			pic.mouseEnabled=false;
			pic.alpha=0;
			
			return (pic);
		}
		
		
		
	}
}