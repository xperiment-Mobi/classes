package com.xperiment.behaviour.PastResults
{
	public class ComputeResults
	{
		
		private static var permittedCommands:Array = ['average','count','maxcount','top'];

		
		
		
		public static function DO(variables:Object,commands:Object):Object
		{
			var results:Object = {};
			
			for(var variable:String in variables){
				

				if(commands.hasOwnProperty(variable) == false) throw new Error("devel error");



				var params:String;
				var command:String = commands[variable].toLowerCase();
				
				
				if(command.indexOf("(")!=-1 && command.indexOf(")")!=-1){
					var obj:Object = extractParams(params,command);
					params = obj.params;
					command = obj.command;
				}
				
				
				if(permittedCommands.indexOf(command)==-1) throw new Error("whilst extracting past results, you asked for an unsupported command:"+commands[variable]);
				

				switch(command){
					//case 'average'	:results[variable]=average(variables[variable]); break;
				//	case 'count'	:results[variable]=count(variables[variable]); break;
				//	case 'maxcount'	:results[variable]=maxcount(variables[variable]); break;
					case 'top'		:results[variable]=getOrdered(variables[variable],params,'top',variable); break;
					case 'bottom'	:results[variable]=getOrdered(variables[variable],params,'bottom',variable); break;
					default: throw new Error('devel error');
				}		
			}
		
			return results;
		}
		
		
		private static function getOrdered(arr:Array, params:String,order:String,variable:String):Array
		{
			var countObj:Object = {};
			
			for each(var value:String in arr){	
				if(countObj.hasOwnProperty(value))countObj[value]++;
				else countObj[value]=1;
			}
			
			var countArr:Array=[];
			
			for(value in countObj){
				countArr.push({property:value, freq:countObj[value]});
			}
			
			countArr = countArr.sortOn("freq",Array.DESCENDING | Array.NUMERIC);	
			if(order!='top') countArr = countArr.reverse();
			
			var returnArr:Array=[];
			
			var obj:Object;
			var key:String;
			for(var i:int = 0 ; i<int(params); i++){
				obj={}
				key=order+String(i+1)+":"+variable;
				obj[key] = {}
				
				if(countArr.length>i && countArr[i].hasOwnProperty('property')){
					obj[key] =countArr[i].property
					returnArr.push(obj)
				}
					else break;	
					
			}	
			
			return returnArr;
		}		
		
	
		
		
		
		private static function extractParams(params:String, command:String):Object
		{
			command=command.substr(0,command.length-1);
			var arr:Array = command.split("(");
			command = arr[0];
			params= arr[1];
			return({command:command,params:params});
		}		
		
		
	}
}