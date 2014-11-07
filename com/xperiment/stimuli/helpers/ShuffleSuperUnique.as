package com.xperiment.stimuli.helpers
{
	import com.xperiment.codeRecycleFunctions;

	public class ShuffleSuperUnique
	{
		
		private static function err(str:String):void{
			throw new Error('problem with shuffle_somethings_super_unique. '+str);
		}
		
		public static function DO(info:String, list:XMLList):void
		{
			var split:String;
			var pattern:String;
			var str1:String;
			var str2:String;
			
			var arr:Array = info.split(" ");
			pattern = arr.pop();
			split = arr.pop();
			
			//just get the names of the strings here
			if(arr.length!=2) err('you must define TWO variables (these are defined:'+arr+')');
			str2 = arr.pop();
			str1 = arr.pop();
			
			if(list.@[str2].toString().length==0 || list.@[str1].toString().length==0){
				err('One/both of the properties to modify ('+str1+','+str2+') is not present.');
			}
	
			var result:Object = process(	getParams(pattern), list.@[str1], list.@[str2]	);
			
			list.@[str1] = result.arr1.join(split);
			list.@[str2] = result.arr2.join(split);
			
		}
		
		
		private static function process(params:Object, str1:String, str2:String):Object
		{
			var split1:Array = getSplit(params,str1.split(";"));
			var	split2:Array = getSplit(params,str2.split(";"));
			
			uniqueShuffle(split1,split2,'ident');
			
			
			
			randomlySelect(split1);
			randomlySelect(split2);
			
			
			return {arr1:split1, arr2:split2}
		}
		
		private static function randomlySelect(arr:Array):void
		{
			for(var i:int=0;i<arr.length;i++){
				arr[i] = codeRecycleFunctions.arrayShuffle(arr[i].stimuli)[0];
			}
		}		
		
		
		/*		trace(	test_uniqueShuffle([{ident:'a'},{ident:'b'},{ident:'c'}],[{ident:'a'},{ident:'b'},{ident:'c'}],'ident') );
		trace(	test_uniqueShuffle([{ident:'a'},{ident:'b'}],[{ident:'a'},{ident:'b'}],'ident') );*/
		private static function test_uniqueShuffle(arr1:Array, arr2:Array,param:String):Boolean
		{
			for(var iii:int=0;iii<10;iii++){  //does test 10 times for luck
				uniqueShuffle(arr1,arr2, param );
				trace(JSON.stringify(arr1));
				trace(JSON.stringify(arr2));
				trace("--");
				for(var i:int=0;i<arr1.length;i++){
					if(arr1[i][param]==arr2[i][param])	return false
				}
			}
			return true;
		}		
		
		private static function uniqueShuffle(split1:Array, split2:Array, param:String):void
		{
			var a:Array = [];
			var b:Array = [];			
			
			codeRecycleFunctions.arrayShuffle(split1);
			codeRecycleFunctions.arrayShuffle(split2);
			var maxTries:int=10;
			var count:int=0;
			
			while(split1.length>0){
				count=0;
				while(split1[0][param] == split2[0][param]){
					codeRecycleFunctions.arrayShuffle(split2);
					count++;
					if(count>=maxTries){
						for(var i:int=0;i<a.length*.5;i++){ //if fails, add half the stim back in again
							split1.push ( a.shift() );
							split2.push ( b.shift() );
						}
					}
				}
				a.push( split1.shift() );
				b.push( split2.shift() );
			}
			
			while(a.length>0){
				
				split1.push( a.shift() )
				split2.push( b.shift() );
			}
			
		}
		
		
		
		
		
		/*	trace(test_getSplit({start:2,num:2},['abcd','bbcd','cccd','abdd','bbdd','ccdd'],'[{"stimuli":["abcd","abdd"],"ident":"ad"},{"stimuli":["bbcd","bbdd"],"ident":"bd"},{"stimuli":["cccd","ccdd"],"ident":"cd"}]'));
		
		trace(test_getSplit({start:1,num:2},['abcd','bbcd','cccd','abdd','bbdd','ccdd'],'[{"stimuli":["abcd","bbcd","cccd"],"ident":"cd"},{"stimuli":["abdd","bbdd","ccdd"],"ident":"dd"}]'));		
		private function test_getSplit(params:Object,stim:Array,result:String):Boolean
		{
		var arr:Array = getSplit(params,stim);
		arr.sortOn('ident');
		return JSON.stringify(arr) == result;
		}*/
		
		private static function getSplit(params:Object, stim:Array):Array
		{
			var obj:Object = {};
			
			var stimInfo:Object;
			
			for(var i:int=0;i<stim.length;i++){
				stimInfo = getType(stim[i],params);
				obj[stimInfo.ident] ||= [];
				obj[stimInfo.ident].push( stimInfo.name );
			}
			
			var list:Array = [];
			for(var ident:String in obj){
				list.push(	{	ident:ident,stimuli:obj[ident]		}	)
			}
			
			return list;
		}		
		
		/*		trace(test_getType('1234567',{start:2,num:3},'1567','234'));
		trace(test_getType('1234567',{start:3,num:1},'124567','3'));
		private function test_getType(extract:String,params:Object,result:String,type:String):Boolean{
		var obj:Object = getType(extract,params);
		trace(1,obj.ident,obj.type)
		if(obj.type!=type)return false;
		
		if(obj.ident!=result)return false;
		return true;
		}*/
		
		
		private static function getType(str:String, params:Object):Object
		{
			var obj:Object = {};
			//obj.type = str.substr(params.start-1,params.num);
			obj.ident= str.substr(0,params.start-1) + str.substr(params.start+params.num-1);
			obj.name = str;
			return obj;
		}
		
		/*trace(test_getParams("??x??","12345","3"));
		trace(test_getParams("??xx?","12345","34"));
		trace(test_getParams("?xxx?","12345","234"));
		private function test_getParams(pattern:String,extract:String,res:String):Boolean{
		
		var obj:Object = getParams(pattern);
		return (extract.substr(obj.start,obj.num)==res);
		}*/
		
		
		private static function getParams(shf:String):Object
		{
			var obj:Object = {};
			var found:Boolean = false;
			
			for(var i:int=0;i<shf.length;i++){
				
				if(shf.charAt(i)=='x'){
					if(found == false)	obj.start = i;
					found=true;
				}
				else if(found){
					break;
				}
				
			}
			obj.num = i-obj.start;
			
			return obj;
		}
	}
}