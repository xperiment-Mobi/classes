package com.xperiment.script
{
	import com.xperiment.codeRecycleFunctions;
	
	import flash.utils.Dictionary;

	public class ProcessScript_comands
	{
		public static var commands:Dictionary;
		public static var shuffles:Object;
		

		commands=new Dictionary;
		commands.SHUFFLE_SOMETHING = function(stimulus:XML,command:String):void{
			
			function err(more:String):void{
				throw new Error("you have asked to SHUFFLE_SOMETHING ("+ command+ ") but have specified it wrongly ("+more+")");
			}

			var arr:Array=command.split(",");
			
			var shuffle:Object = {};
			var tempArr:Array;
			
			for each(var str:String in arr){
				tempArr=str.split("=");
				if(tempArr.length!=2)err('you must follow this protocol: x=y');
				shuffle[tempArr[0].toLowerCase()]=tempArr[1];
			}
			
			for each(str in ['what']){
				if(shuffle.hasOwnProperty(str)==false) err("you MUST have a 'what' [to shuffle] term");	
			}
			
			//what=colour,split=;,link=cols,linkIs=nonIdentical
			
			if(shuffle.hasOwnProperty('link')==true){
				if(shuffle.hasOwnProperty('linkis')==false)shuffle.linkis='same';
			}
			

			if(shuffle.hasOwnProperty('split')==false)shuffle.split = ';';
			
			if(stimulus.@[shuffle.what].toString().length>0){
				
				arr=stimulus.@[shuffle.what].toString().split(shuffle.split);
				
				arr= codeRecycleFunctions.arrayShuffle(arr);
				
				if(shuffle.hasOwnProperty('link')){
					shuffles ||= {};
					if(shuffles.hasOwnProperty(shuffle.link)){
					
						switch(shuffle.linkis){
							case 'same':
								arr=[];
								for(var i:int=0;i<shuffles[shuffle.link].length;i++){
									arr.push(shuffles[shuffle.link][i]);
								}
								break;
							case 'different':

								var contin:Boolean = true;
								while(contin){
									contin=false;
								
									for(i=0;i<shuffles[shuffle.link].length;i++){
										
										if(arr[i]==shuffles[shuffle.link][i]){
											contin=true;
											arr= codeRecycleFunctions.arrayShuffle(arr);
											break;
										}
										
									}
									
								}
								break;
							default: throw new Error();

						}
						
					}
					else{
						shuffles[shuffle.link]=arr;
					}
				}
					
				stimulus.@[shuffle.what]=arr.join(shuffle.split);
				

			}
			else ("the 'what' you specifed ["+shuffle.what+"] does not exist");
		}
	}
}