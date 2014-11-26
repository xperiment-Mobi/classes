package com.xperiment.behaviour
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.Animation.MessageAnimation;
	import com.xperiment.behaviour.PastResults.PastResultsLoader;
	import com.xperiment.events.StimulusEvent;
	
	import flash.utils.Dictionary;


	public class behavPastResults extends behav_baseClass
	{
		private var loader:PastResultsLoader;
		private var results:Object;
		
		override public function setVariables(list:XMLList):void {
			
			setVar("string","filenames","*");
			setVar("string","variables","top(3):approxDurationInSeconds");
			
			/*
			adds top3, top2, top1 to the object properties, all equalling ''
			
			*/
			
			super.setVariables(list);
			
			addVariablesToObj(getVar("variables"));
			
			loader = new PastResultsLoader(getVar("filenames"),getVar("variables"), null, loadedF);
			loader.load();

		}
		
		override public function nextStep(id:String=""):void{
			loader = new PastResultsLoader(getVar("filenames"),getVar("variables"), null, loadedF);
			loader.load();
		}
		

		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
		
			if(loader){
				var result:String = extractResult(prop);
				return function():String{	
					//trace("request colour",result);
					if (result) return result;
					return "'0'";
				}; 		
				
			}
			else{
				
				if(getVar("variables").indexOf(prop.substr(0,prop.length-1))!=-1){
					return function():String{ 
						var temp:String = extractResult(prop);
						
						if(temp)return codeRecycleFunctions.addQuots(extractResult(prop));
						return 'does not exist';
					};
				}
			}
			
			return null;
		}
		
		private function addVariablesToObj(variables:String):void
		{
			var pos:int;
			var nam:String;
			var prop:String;
			var count:int;
			var split:Array;
			for each(var variable:String in variables.split(",")){
				pos=variable.indexOf(":");
				if(pos!=-1){
					prop=variable.substr(pos+1,variable.length-1);					
					nam=variable.split(":")[0];
					if(nam.indexOf("(")!=-1 && nam.indexOf(")")!=-1){
						nam=nam.substr(0,nam.length-1);
						split=nam.split("(");
						if(split.length==1){
							setVar("string",nam+":"+prop,'');
						}
						else if(split.length==2){
							nam=split[0];
							if(isNaN(Number(split[1]))) throw new Error("you have provided a non-numerical parameter here: " + variable);
							else{
								count=int(split[1]);
								while(count>0){
									setVar("string",nam+String(count)+":"+prop,'');
									count--;
								}
							}
						}
						else throw Error("devel error");
					}					
				}
			}
		}		
		
		
		private function afterLoaded():void
		{
			//trace('loaded')
			results=loader.results;
			//trace("finished");
			pic.dispatchEvent(new StimulusEvent(StimulusEvent.ON_FINISH));
		}	
		
		private function extractResult(what:String):String{

			for each(var result:Object in results){
				for (var variables:String in result){
					for (var variable:String in result[variables]){
						if(variable.indexOf(what)!=-1){
							return hack(result[variables][variable]);
						}
					}
				}
			}
			
			return null;
		}
		
		private function hack(name:String):String
		{
			var colours:Array="0xffffff---0x808080---0x000000---0x99ffca---0x9eca3c---0xceff2d---0xffffa1---0xfddea2---0xa77320---0x753c2a---0xa33038---0xff928d---0xffd8f3---0xe4c2f4---0xff00e1---0x4f107a---0x0033b3---0xd3ffff---0xb3009e---0x00b0f0---0x00d906---0xfffc02---0xff7d00---0xf32837".split("---");
			
			var names:Array="A1---A2---A4---G1---F3---F2---E1---D1---D3---B4---B3---B1---J1---I1---J2---I3---H3---H1---I2---H2---G3---E2---D2---B2".split("---");
			
			name=codeRecycleFunctions.removeQuots(name);
			
			var pos:int = names.indexOf(name);
			
			
			if(pos==-1){
				return '0xffffff'
				//throw new Error('devel error');
			}

			return colours[pos];
		}
		
		private function loadingF(val:Number):void{
			trace('have loaded',val);
		}
		
		private function loadedF(success:Boolean):void{
			if(success){
				if(loader.fileCount==0){
					var s:MessageAnimation = new MessageAnimation(theStage,"no past data to load!",5,true);
				}
				else afterLoaded();
				
					
			}
			else	s = new MessageAnimation(pic,"could not load past data!",5,true);
				
		}		
		
	}
}