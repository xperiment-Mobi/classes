package com.xperiment.stimuli.helpers
{
	public class GetData
	{
		public static var TRIAL_NAME:String = "name";
		
		public static function retrieve(params:Object,results:XMLList):Array
		{

			var grouped:Array = [];
			var filtered:XMLList;
			
			if(params.hasOwnProperty("trialNames")==false)throw new Error("devel error");
			if(params.hasOwnProperty("maths")==false)throw new Error("devel error");
			if(params.hasOwnProperty("dv")==false)throw new Error("devel error");
			
			var maths:String = params.maths;
			var dv:String = params.dv;
			var processedCriteria:Object;
			if(params.hasOwnProperty("criteria"))	processedCriteria = computeCriteria(params.criteria);
			var absent:int=0;
			if(params.hasOwnProperty("absent"))absent=Number(params.absent);
	
			
			
			for each(var trialname:String in params.trialNames.split(",")){
				grouped[trialname]=__compute(trialname, results,maths,dv,processedCriteria,absent);
			}

			
			
			//var data:Array = [];
			/*data.push(new BarData("January", 60,10));
			data.push(new BarData("February", 100,5));
			data.push(new BarData("March", 30,15));// TODO Auto Generated method stub
			*/

			return grouped;
		}
		
		private static function computeCriteria(criteria:String):Object
		{
			var processedCriteria:Object;
			var obj:Object;
			for each(var str:String in criteria.split(",")){
				processedCriteria ||={};
				obj=__processCriteria(str);
				processedCriteria[obj.name]=obj.f;
			}
			return processedCriteria;
		}
		
		public static function __processCriteria(criteria:String):Object
		{
			var param:String;
			var value:String;
			var arr:Array;

			
			function test(what:String):Boolean{
				if(criteria.indexOf(what)!=-1){
					arr=criteria.split(what);
					param=arr[0];
					value=arr[1];
					return true;
				}
				else return false;
			}
			
			function equals(a:String):Boolean{
				return a==value;
			}
			
			function not_equals(a:String):Boolean{
				return a!=value;
			}
			
			function greaterEqualThan(a:String):Boolean{
				return a>=value;
			}
			
			function smallerEqualThan(a:String):Boolean{
				return a<=value;
			}
			
			function greaterThan(a:String):Boolean{
				return a>value;
			}
			
			function smallerThan(a:String):Boolean{
				return a<value;
			}
			

			if(test("=="))return {name:param,f:equals};
			if(test("!="))return {name:param,f:not_equals};
			if(test(">="))return {name:param,f:greaterEqualThan};
			if(test("<="))return {name:param,f:smallerEqualThan};
			if(test(">"))return {name:param,f:greaterThan};
			if(test("<"))return {name:param,f:smallerThan};

			throw new Error("unknown comparators in this comparison: "+criteria);
			return null;
		}
		

		
		private static function smallerEqualThan(a:String,b:String):Boolean{
			return a<b;
		}
		
		public static function __compute(trialname:String,results:XMLList, maths:String, dv:String,criteria:Object,absent:Number):Object{

			var mathsObj:Object = {};
			var exact:Boolean = true;
			var filtered:Array = [];
			
			for each(var math:String in maths.split(",")){
				mathsObj[math] = [];
			}
			
			if(trialname.indexOf("*")!=-1){
				exact=false;
				if(trialname.charAt(trialname.length-1)!="*")throw new Error("only allowed * at the end of trialnames "+trialname);
				trialname=trialname.substr(0,trialname.length-1);
			}
	
			var nam:String;
			for each(var trial:XML in results){
				if(trial.hasOwnProperty("@"+TRIAL_NAME)){
					nam=trial.@[TRIAL_NAME].toString();
					if(exact && nam == trialname) filtered.push(trial.copy());
					else if(exact==false && nam.indexOf(trialname)!=-1){
						filtered.push(trial.copy());
					}
				}
			}
			
			return doMath(maths,dv,filtered,criteria,absent);
		}
		
		private static function doMath(maths:String, dv:String, filtered:Array,criteria:Object,absent:Number):Object
		{

			function checkCriteria(trial:XML):Boolean{

				for(var param:String in criteria){

					if(trial.hasOwnProperty(param)==false)return false;
					if((criteria[param] as Function)(trial[param].toString())==false)return false;
				}
				
				return true;
			}
			
			var data:Array = [];
			for each(var trial:XML in filtered){
				if(trial.hasOwnProperty(dv)){
					if(!criteria || checkCriteria(trial)){
						data.push(Number(trial[dv].toString()));
						
					}
				}
			}
			
			var obj:Object = {};
			var mathArr:Array = maths.split(",");
			var result:Number;
			
			for each(var m:String in mathArr){
				result = __calc(data,m);
				obj[m] = result;
				if(!result) obj[m]=absent;
			}
			
			return obj;
		}		
		
		public static function __calc(data:Array, m:String):Number
		{
			
			
			if(m=="average") 	return __av(data);
			if(m=="count") 		return __count(data);
			if(m=="stderr" ) 	return __stderr(data);
			if(m=="stdev" ) 	return __stdev(data);
			if(m=="2*stderr" ) 	return 2*__stderr(data);
			throw new Error("unknown maths operator: "+m);
			return 0;
		}
		
		public static function __stderr(data:Array):Number
		{
			return __stdev(data)/Math.sqrt(__count(data));
		}
		
		public static function __count(data:Array):Number{
			return data.length;
		}
		
		public static function __stdev(data:Array):Number{
			var av:Number = 0;
			for(var i:int=0;i<data.length;i++){
				av+=data[i];
			}
			av = av/data.length;
			
			var sumSquares:Number=0;
			for(i=0;i<data.length;i++){
				sumSquares+=(data[i]-av)*(data[i]-av)
			}
			return Math.sqrt(sumSquares/(data.length-1));
		}
		
		public static function __av(data:Array):Number{
			var av:Number = 0;
			for(var i:int=0;i<data.length;i++){			
				av+=data[i];
			}			
			return av/__count(data);
		}
		
		
		/*public static function __XMLListToList(list:XMLList,arr:Array):void{
			var obj:Object;
			var trial:XML;
			var result:XML;
			for each(trial in list){
				obj = {};
				obj[TRIAL_NAME]=trial.name();
				for each(result in trial.children()){
					obj[result.name()] = result.toString();
				}
				arr.push(obj);
			}
		}*/
	}
}