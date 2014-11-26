package com.xperiment.behaviour.responses
{
	public class Responses
	{
		private var timeLogic:TimeLogic;
		private var responses:Array;
		
		public function Responses()
		{
			
			
			
			timeLogic=new TimeLogic();
			
			
			var logic:String="(500)";

			timeLogic.add(logic);
			
			
		}
		
		
		
		public function add(responseLogic:String):void{
			//split the responseLogic
			var arr:Array = responseLogic.split(":");
			//var caveat:String = processTimeLogic(arr[0],timeLogic.add);
			var name:String=arr[1];
		}
		
		
		//Takes the innermost brackets with stuff inside and passes that onto a given function
		//"Peg1(1000)&peg2(500)",t2F)=>		"Peg1<(1000)>&peg2<(500)>");
		//"Peg1(1000)&peg2",t2F)=>			"Peg1<(1000)>&peg2");
		//"(1000)&peg2",t2F)=>				"<(1000)>&peg2");
		//"(((1000)))&peg2",t2F)=>			"((<(1000)>))&peg2");
		public function processTimeLogic(caveatCopy:String,add:Function):String
		{
			var caveat:String="";
			var interim:String="";
			var logic:String="";
			var inLogic:Boolean=false;
			var peg:String="";
			var inPeg:Boolean=false;
			var isAlphaNumeric:RegExp= new RegExp("[A-Za-z0-9]");
			
			for(var i:int=caveatCopy.length;i>=0;i--){
				interim=caveatCopy.charAt(i);
				if(interim==")" && !inLogic){
					logic=interim+logic;
					inLogic=true;
				}
				else if(inLogic){
					if(interim==")"){
						caveat=logic+caveat;
						logic=interim;
					}
					
					else if(interim=="(" && !inPeg){
						logic=interim+logic
						inPeg=true;

					}
					else if (inPeg){
						if(isAlphaNumeric.test(interim))peg=interim+peg;

						else{
							inLogic=false;
							//storeLogic
							caveat=peg+add(logic,peg)+caveat;
							logic="";
							peg="";
							inPeg=false;
							caveat=interim + caveat;
						}
					}
					else logic=interim+logic;					
				}
					
				else caveat=interim + caveat;				
			}

			if(peg!="" && logic!=""){
				caveat=peg+add(logic,peg)+caveat;
				logic="";
				peg="";
			}
			return logic + caveat;
		}
		
	}
}