package com.xperiment.runner.utils
{
	import com.xperiment.Results.Results;

	public class ListTools
	{

		static public function extract(exptScript:XML,results:Results):void{

			var listName:String; //nb for all intents and purposes, this is the same as 'prefix' in e.g. addText
			var val:String;
			var length:uint=0;
			var str:String;
			var template:String;
			var i:uint;
			
			for each(var list:XML in exptScript..LIST){
				template="";
				listName=list.@name.toString();
				
				str=list.toString();
				str=str.replace(new RegExp(String.fromCharCode(13),"/g"),""); //fixes this silly XML issue of inserting linebreaks EVERYWHERE
				str=str.replace(new RegExp(String.fromCharCode(34),"/g"),""); //removes all quotation marks
				var QBlocks:Array=str.split(String.fromCharCode(10)+String.fromCharCode(10));
				if((QBlocks[0] as String).substr(0,3)=="As:"){
					template=QBlocks.shift(); //only create a template if there is one specified at the very top of the string.
					results.storeVariable({name:listName+"<~~TEMPLATE~~>",data:template});
				}
				//trace(QBlocks[1],111);
				
				if(list.@length.toString().length!=0 && !isNaN(Number(list.@length.toString())))length=uint(list.@name.toString());
				else length=QBlocks.length;
								
	
					
					
				for(i=0;i<QBlocks.length;i++){
					results.storeVariable({name:listName+String(i+1),data:QBlocks[i%(length-1)]});
				}
				
				
			}
		}
	}
}