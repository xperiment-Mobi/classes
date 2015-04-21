package com.xperiment.stimuli.helpers
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.object_baseClass;

	public class StimModify
	{
		
		private static var splitChar:String = " ";
		private static var listActions:Array = ['choice_task','toOverTrials','toWithinTrial','jitter','shuffle_somethings','shuffle_something','randomly_swap','pick_ones','prune_somethings','add_somethings','shuffle_somethings_unique','shuffle_somethings_super_unique','flip_something'];
		
		
		
		public static function sortOutOverExptMods(script:XML):XML{
			
			var xml:XML;
			var found:Array;
			var uppercaseAction:String;

			for each(var action:String in listActions){
 
				uppercaseAction = action.toUpperCase();
				
				for each(xml in script..*.(hasOwnProperty("@"+uppercaseAction)==true)){
				//trace(xml.@[uppercaseAction].toString(),22)
					if(!StimModify[action])throw new Error("unknown action in StimModify:"+action);
					StimModify[action](xml.@[uppercaseAction].toString(),XMLList(xml));
				
				}
				
			}
			
			
			return script;
		}
		
		public static function process(list:XMLList, params:Object):void{
				
			var found:Array = [];
			var actionStr:String;
			//test_sortMultiples();
			for each(var action:String in listActions){

				if(list.@[action].toString().length!=0){
					if(!StimModify[action])throw new Error("unknown action in StimModify:"+action);
					actionStr = _sortMultiples(list, action, params);
					StimModify[action](actionStr,list);
					found.push(action);
				}
			}
			/*for each(action in found){
				delete list.@[action];
			}*/
			

		}
		
		
		
		private static function test_sortMultiples():void
		{
			trace('0' ==_sortMultiples(XMLList(<a a0="1" a="0"/>),'a',null));
			trace('01'==_sortMultiples(XMLList(<a a0="1" a="0"/>),'a',{iteration:99,trial:0}));
			trace('01'==_sortMultiples(XMLList(<a a0="1" a="0---1"/>),'a',{iteration:0,trial:0}));
			trace('11'==_sortMultiples(XMLList(<a a0="1" a="0---1"/>),'a',{iteration:1,trial:0}));
			trace('12'==_sortMultiples(XMLList(<a a0="1---2" a="0---1"/>),'a',{iteration:1,trial:0}));
			trace('12'==_sortMultiples(XMLList(<a a0="1;2" a="0;1"/>),'a',{iteration:1,trial:1}))
			trace('11'==_sortMultiples(XMLList(<a a0="1---2" a="0;1"/>),'a',{iteration:0,trial:1}))
		}
		
		public static function _sortMultiples(list:XMLList, action:String, params:Object):String
		{
			var actionStr:String = processIterationsTrials(		list.@[action].toString()	)
			//if(params == null) return actionStr;
			
			var count:int=0;
			
			var next:String;
			while(	true  ){
				next = list.@[action+count.toString()];
				count++;
				if(next.length!=0){
					actionStr+=processIterationsTrials(next);
				}
				else if(count>1) break;

			}
			
			function processIterationsTrials(str:String):String{
				if(!params) return str;
				//trace(111,params)
				
				var symbol:String = object_baseClass.multTriCorSym;	
				if (str.indexOf(symbol)!=-1)	str=codeRecycleFunctions.multipleTrialCorrection(str,symbol,params.trial);
				
				symbol= object_baseClass.multObjCorSym;
				if (str.indexOf(symbol)!=-1)	str=codeRecycleFunctions.multipleTrialCorrection(str,symbol,params.iteration);
				
				return str;
			}

			return actionStr;
		}
		
		public static function choice_task(prop:String, list:XMLList):void{
			ChoiceTask.DO(prop,list);
			
		}
		
			
		

		
		
		public static function toOverTrials(str:String, list:XMLList):void{
			convert(str,list,";","---");
			
			
		}
		
		public static function toWithinTrial(str:String, list:XMLList):void{
			convert(str,list,"---",";");
		}
		
		private static function convert(str:String, list:XMLList, to:String, from:String):void{
			for each(var toMod:String in str.split(",")){
				if(list.@[toMod].toString().length==0)throw new Error("You have wrongly specified a 'to____' action (swapping --- and ;).  This parameter does not exist: "+toMod);
				list.@[toMod] = list.@[toMod].toString().split(from).join(to);
			}
		}
		
		
		
		
		
		
		public static function jitter(str:String, list:XMLList):void{
			
			var jitters:Array = codeRecycleFunctions.arrayStr2Str(str);
			for each(var jitterStr:String in jitters){
				do_jiter(jitterStr,list);
			}
		}
		
		
		private static function do_jiter(jitterStr:String, list:XMLList):void{
			var jitterObj:Object = codeRecycleFunctions.strToObj(jitterStr);
			
			function prob(extra:String):void{
				throw new Error("problem in your jitter in this line of script (must have element colon value to jitter by, e.g. [prop:y,amount:8%,random:false],[prop:x,amount:8%]):"+"\n"+jitterStr+"\n"+list.toXMLString()+extra);
			}
			
			if(jitterObj.hasOwnProperty('prop')==false)	prob("'prop' not specified");
			if(jitterObj.hasOwnProperty('max')==false)	prob("'max' not specified");
            if(jitterObj.hasOwnProperty('min')==false)	jitterObj.min='0';

			var prop:String = jitterObj.prop;
			var jit_max:String = jitterObj.max;
            var jit_min:String = (jitterObj.min as String).split("%").join("");

            var isPercent_mod:Boolean = jit_max.indexOf("%")!=-1;
			if(isPercent_mod)	jit_max = jit_max.split("%").join("");
			
			var curVal:String;
			
			curVal = list.@[prop].toString();
			var isPercent_orig:Boolean = curVal.indexOf("%")!=-1;
			if(isPercent_orig)	curVal = curVal.split("%").join("");
			
			if(isPercent_mod != isPercent_orig) throw new Error("You have asked to Jitter something but the Jitter value and the to-be-jittered are not both % or not %: "+list.toXMLString());
	
			if(curVal=="" && ["x","y","width","height"].indexOf(prop)!=-1){
				curVal = "50";
				isPercent_mod=true;
			}

			
			if(curVal.length==0) prob(" (there is no default value of " + prob + " to modify).");
			
			var val:Number = Number(curVal);

			if(jitterObj.hasOwnProperty('random') == true && jitterObj.random == false){
				val +=  Number(jit_max);
			}
			else val += getRandValRange(jit_max,jit_min)

			val = codeRecycleFunctions.roundToPrecision(val,2);
			
			if(isPercent_mod) list.@[prop] = val.toString()+"%";
			else		  list.@[prop] = val.toString();
			
		}

        private static function getRandValRange(maxStr:String, minStr:String):Number {
            var val:Number = Number(minStr);
            var range:Number = Number(maxStr)-val;
            return val + range * Math.random();
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
			trace(222,defined)
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
			if(list.@[param].toString().length==0)	throw new Error("you asked to SHUFFLE_SOMETHING, but the parameter you specifed ("+param+") does not exist.  SHUFFLE_SOMETHING='"+str+"'");
			
			function doShuffle(bla:String):Array{
				var a:Array = bla.split(split);
				return codeRecycleFunctions.arrayShuffle(a)

			}
			
			var split:String = ";"
			if(arr.length>1)split=arr[1];
			
			if(split==";"){
				list.@[param]=doShuffle(	list.@[param].toString()    ).join(split);	
			}
			else{
				var elements:Array = list.@[param].toString().split(";");
				
				for(var i:int=0;i<elements.length;i++){
					elements[i] = doShuffle(	elements[i]	    ).join(split);
				}
				
				list.@[param] = elements.join(";");
			}
		}
	}
	
}