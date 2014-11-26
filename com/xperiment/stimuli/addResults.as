package com.xperiment.stimuli
{
	import flash.utils.Dictionary;
	
	public class addResults extends object_baseClass
	{		
		public var __mID:String = "Results";
		private var copyOver:Boolean = false;
		
		public function addResults(){
			this.peg=__mID.toLowerCase();
			OnScreenElements=[];
		}
		

		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
	
			return function(what:String=null,to:String=null):String{
					if(what){
						if(to && to.charAt(0)=="'" && to.charAt(to.length-1)=="'")to=to.substr(1,to.length-2);
						var value:String=getValue(to);
						if(value){
							safeStore(what.split(".")[1],value);
							return value;
						}
					}
					return OnScreenElements[what];
				}
		}
		
		private function safeStore(param:String, value:String):void
		{
			
			
			if(!OnScreenElements.hasOwnProperty(param) || copyOver==true){
				OnScreenElements[param]=value;
			}
			else{
				var i:int=1;
				while(true){
					if(!OnScreenElements.hasOwnProperty(param+i.toString())){
						OnScreenElements[param+i.toString()]=value;
						break;
						
					}
					i++;
				}						
			}
		}
		
		public function getValue(to:String):String
		{
			return to;
		}
		
		override public function setVariables(list:XMLList):void{
			
			if(list.@copyOver.toString().toLowerCase()=="true")	copyOver=true;
			delete list.@copyOver;
			
			pic=this;
			this.ran=true;
			if(list.@timeStart.toString().length==0 && list.@peg.toString().length!=0){
				throw new Error("you have an 'add"+__mID+"' stimulus but you must specify timeStart for this");
			}
			
			XMLListObjectPropertyAssigner(list);

			if(OnScreenElements.hasOwnProperty('peg'))this.peg=OnScreenElements.peg;
			else this.peg=__mID.toLowerCase();
			pic.peg=peg;
		}
		

		
		override public function returnsDataQuery():Boolean{
			return true;
		}

		override public function storedData():Array {
					
			var tempData:Array
				
			for(var result:String in OnScreenElements){
				if(['if', 'behaviours','peg','timeStart'].indexOf(result)==-1){
					tempData = new Array();
					tempData.event=result; 
					tempData.data=OnScreenElements[result];
					objectData.push(tempData);
					
				}
			}


			return objectData;
		}
		
		override public function kill():void{
			OnScreenElements=null;
			super.kill();
		}
		
		
	}
}