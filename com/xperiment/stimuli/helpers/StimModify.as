package com.xperiment.stimuli.helpers
{
	import com.xperiment.codeRecycleFunctions;

	public class StimModify
	{
		
		private static var splitChar:String = " ";
		private static var listActions:Array = ['shuffle_somethings','shuffle_something','randomly_swap','pick_ones','prune_somethings','add_somethings','shuffle_somethings_unique','shuffle_somethings_super_unique','flip_something'];
		
		
		public static function sortOutOverExptMods(script:XML):XML{
			
			var xml:XML;
			var found:Array;
			var uppercaseAction:String;
			
			for each(var action:String in listActions){
 
				uppercaseAction = action.toUpperCase();
				
				for each(xml in script..*.(hasOwnProperty("@"+uppercaseAction))){
				//trace(xml.@[uppercaseAction].toString(),22)
					if(!StimModify[action])throw new Error("unknown action in StimModify:"+action);
					StimModify[action](xml.@[uppercaseAction].toString(),XMLList(xml));
				
				}
				
			}
			
			
			return script;
		}
		
		public static function process(list:XMLList):void{
				
			var found:Array = [];
			
			for each(var action:String in listActions){

				if(list.@[action].toString().length!=0){
					if(!StimModify[action])throw new Error("unknown action in StimModify:"+action);
					StimModify[action](list.@[action].toString(),list);
					found.push(action);
				}
			}
			for each(action in found){
				delete list.@[action];
			}
			

		}
		
		public static function randomly_swap(str:String, list:XMLList):void
		{
			var swapParams:Array = [];
			var swapValues:Array = [];
			
			for each(var paramToSwap:String in str.split(splitChar)){
				if(list.@[paramToSwap].toString().length==0)throw new Error("You have wrongly specified a 'randomly_swap' action.  This parameter does not exist: "+paramToSwap);
				
				swapParams.push(paramToSwap)
				swapValues.push(list.@[paramToSwap].toString());
			}
			
			codeRecycleFunctions.arrayShuffle(swapValues);
			
			for(var i:int=0;i<swapParams.length;i++){
				list.@[swapParams[i]]=swapValues[i];
			}
	
		}
		
		public static function pick_ones(str,list:XMLList):void{
			
			shuffle_somethings(str, list);
			var arr:Array=str.split(splitChar);
			var split:String = arr.pop();
			for each(var param:String in arr){
				list.@[param] = list.@[param].toString().split(split)[0];
			}
		}
		
		public static function flip_something(str:String, list:XMLList):void{
			getParams(str,list,'flip_something');
		}
		
		
		public static function shuffle_somethings(str:String, list:XMLList):void
		{
			getParams(str,list,'shuffle');
		}
		
		public static function shuffle_somethings_unique(str:String, list:XMLList):void
		{
			getParams(str,list,'shuffleUnique');
		}
		
		public static function shuffle_somethings_super_unique(str:String, list:XMLList):void
		{
			ShuffleSuperUnique.DO(str,list);
		}
		
		public static function prune_somethings(str:String, list:XMLList):void
		{
			getParams(str,list,'prune');
		}
		
		public static function add_somethings(str:String, list:XMLList):void
		{
			
			var defined:Array=str.split(splitChar);
			var newParam:String = defined.pop();
			var split:String = defined.pop();
			
			var raw:String;
			
			var combined:Array = [];
			
			for each(var param:String in defined){
				raw=list.@[param].toString()
				if(raw.length>0){
					combined.push(raw);
				}
				else err("add","This 'what' does not exist: "+param)
			}
			
			list.@[newParam]=combined.join(split);
		}
		
		private static function err(action:String, str:String):void{
			throw new Error("Error in "+action+"Somethings='str' command. "+str)
		}
		
		
		private static function getParams(str:String,list:XMLList,action:String):void{
		
			
			var defined:Array=str.split(splitChar);
			
			//below necessary if Prune
			if(!isNaN(Number(defined[defined.length-1]))){
				var count:int = defined.pop();
				if(defined.length>=count)err(action,"your 'count' is bigger than the list of stuff you want pruned");
			}
			var split:String = defined.pop();

			
			var params:Array = []; 
			var len:int = 0;
			var raw:String;
			
			for each(var param:String in defined){
				raw=list.@[param].toString()
	
				if(raw.length>0){
					
					params[param]=raw.split(split);
					if(len==0)	len=params[param].length;
					if(params[param].length!=len)err(action,"all of your 'joined' properties must be the same length. This one is not: "+param);
				}
				else err(action,"This 'what' does not exist: "+param)
			}
			

			switch(action){
				case 'shuffle':
					var shuffArr:Array = [];
					for(var i:int=0;i<len;i++) shuffArr.push(i);
					
					codeRecycleFunctions.arrayShuffle(shuffArr);
					
					var updated:Array;
					for each(param in defined){
					updated=[];
					for(i=0;i<params[param].length;i++){
						//trace(shuffArr[i])
						updated.push( params[param][shuffArr[i]] );
					}
					list.@[param]=updated.join(split);
					
					}		
					break;
				case 'shuffleUnique':
					
					shuffArr = [];
					for each(param in defined){
						shuffArr[shuffArr.length]=[];
						for(i=0;i<len;i++) shuffArr[shuffArr.length-1].push(i);
					}
					codeRecycleFunctions.uniqueShuffle(shuffArr);
				
					for(i=0;i<defined.length;i++){
						param=defined[i];
						updated=[];

						for(var shuff_i:int=0;shuff_i<shuffArr[i].length;shuff_i++){
							updated.push(params[param][shuffArr[i][shuff_i]]);
						}
						list.@[param]=updated.join(split);
					}
					
					break;
				case 'prune':
					var reducedArr:Array;
				
					for each(param in defined){
						reducedArr=params[param];
						while(reducedArr.length>count)	reducedArr.pop();	
						list.@[param]=reducedArr.join(split);
					}
					break;
				case 'flip_something':
					list.@[param] = (params[param] as Array).reverse().join(split);			
			}
		}
		
		
		
	
		
		public static function shuffle_something(str:String, list:XMLList):void
		{
			var arr:Array=str.split(splitChar);
			var param:String=arr[0];
			var split:String = ";"
			if(arr.length>1)split=arr[1];
			
			if(list.@[param].toString().length>0){
				arr=list.@[param].toString().split(split);
				arr=codeRecycleFunctions.arrayShuffle(arr)
				list.@[param]=arr.join(split);
			}
				
			else throw new Error("you asked to SHUFFLE_SOMETHING, but the parameter you specifed ("+param+") does not exist.  SHUFFLE_SOMETHING='"+str+"'");			
		}
	}
	
}