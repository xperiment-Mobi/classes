package com.xperiment.Results
{
	public class XMLMaths
	{
		private static const logicSymbols:Array = ["||","&&"];
		
		public static function dataListFromTrialNames(dataset:XMLList,instructions:Object):Array
		{
			//returns Object:
			//trialName1 = r r r r k k
			//trialName2 = r r r r r k

			var returnData:Array= new Array;
			var endResults:Array;

			
			//for each(var trialName:String in instructions.trialNames as Array){
				//if(!returnData[trialName])returnData[trialName]=new Array;
			
				endResults=processConditionals(dataset,instructions);

				//for each(var xml:XML in tempXMLList){
					//trace(4444444,xml.toString(),trialName,instructions.object,5555);
				//	returnData[trialName].push(xml.toString());	
				//}
			//}

			switch(instructions.what as String){
				case "count":
					returnData=calcCount(endResults);
					//returns object
					//trialName1 
						//r = 4
						//k = 2
					//trialName2 
						//r = 3
						//k = 3
					break;
				case "mean":
				default:
					returnData=calcMean(endResults);
					break;
			}
			return returnData;
		}
		
		private static function processConditionals(dataset:XMLList,instructions:Object):Array
		{
			var unprocessedConditionals:Array=instructions.conditionals as Array;
			var unprocessedDataObjects:Array=instructions.dataObjects as Array;
			var DVs:Array = instructions.DVs as Array;//note that all DVs must be numerical
			var results:Array = new Array;
			
			
		//	var subset:XMLList = dataset.(hasOwnProperty("@name") && @name==trialName)[instructions.object];

			for (var i:uint=0; i<unprocessedConditionals.length;i++){//dataObjects.length = conditionals.length
				
				var conditionals:Array = parseLogic(unprocessedConditionals[i],"cond");
				var dataObjects:Array = parseLogic(unprocessedDataObjects[i],"objs");
			

				conditionals=conditionals.concat(dataObjects);
				
				var resultsXMLList:XMLList =  processConditional(dataset,dataset,conditionals);
				results.push(extractData(resultsXMLList,DVs[i]));
			}
			return results;
		}
		
		private static function extractData(results:XMLList, dv:String):Array
		{		
			return (results[dv].text().toXMLString() as String).split("\n"); //this works, despite flashbuilder claiming there is a prob.
		}
		
		private static function processConditional(dataset:XMLList,OrigDataset:XMLList, conditions:Array):XMLList
		{
			
			var subset:XMLList;
			if(dataset==null)trace("!! No data in the dataset");
			else{
				var conditionInfo:Object = copyFirstObjectInArray(conditions);			conditions.shift(); //could get shift to give me an object!  Hence this function.
				if(!conditionInfo.logicBeforeString)conditionInfo.logicBeforeString="&&";
				//trace(conditionInfo.what,444);
				switch(conditionInfo.what){
					//////////////////////////////////////////////////////////Excludes according to trial names
					//////////////////////////////////////////////////////////
					case ("cond"): 
					//////////////
						if(conditionInfo.logicBeforeString=="||"){
							//COMBINES VALID TRIALS WITH THOSE IDENTIFIED PREV
							//trace("--------------OR condition",conditionInfo.variable,"=",conditionInfo.isVal)
							//trace(2222,conditionInfo.isVal);
							subset=OrigDataset.(hasOwnProperty("@"+conditionInfo.variable) && @name==conditionInfo.isVal);
							//trace(conditionInfo.isVal,subset,"xxxxx");
							subset+=dataset;
						}
						else {		
							//FILTERS VALID TRIALS FROM THOSE IDENTIFIED PREV
							//trace("--------------AND condition",conditionInfo.variable,"=",conditionInfo.isVal);
							subset=dataset.(hasOwnProperty("@"+conditionInfo.variable) && @name==conditionInfo.isVal);
						}
						//trace("subset:",conditionInfo.isVal,subset);
						
						
						break;
					//////////////////////////////////////////////////////////Excludes according to data results in OTHER DVs
					//////////////////////////////////////////////////////////
					case ("objs"):
					//////////////
						if(conditionInfo.logicBeforeString=="||"){
							//COMBINES VALID TRIALS WITH THOSE IDENTIFIED PREV
							//trace("--------------OR condition",conditionInfo.variable,"=",conditionInfo.isVal)
							subset=OrigDataset.(hasOwnProperty(conditionInfo.variable) && child(conditionInfo.variable)==conditionInfo.isVal);
							subset+=dataset;
						}
						else {
							//FILTERS VALID TRIALS FROM THOSE IDENTIFIED PREV
							//trace("--------------AND condition",conditionInfo.variable,"=",conditionInfo.isVal);
							subset=dataset.(hasOwnProperty(conditionInfo.variable) && child(conditionInfo.variable)==conditionInfo.isVal);

						}
						//trace("subset:"+subset);
						break;
				}
	
				
				//var subset:XMLList = dataset.*.(hasOwnProperty("@"+condition.variable) && @[condition.variable]==condition.isVal);
	

				if(conditions.length!=0){
					return processConditional(subset, OrigDataset, conditions);
				}
			}

			return subset;
		}
		
		private static function copyFirstObjectInArray(conditions:Array):Object
		{
			var obj:Object = new Object;
			for (var str:String in conditions[0]){
				obj[str]=conditions[0][str];
			}
			return obj;
		}
		
		
		private static function parseLogic(conditional:String,what:String):Array //what = objs || cond || dvs
		{
/*		
			//needs expanding to use != 
			//needs expanding to also include other types of linking logic
			
			returns:
			arr[0].variable = name
			arr[0].logicBeforeString = AND or OR
			arr[0].logic = "=" or ... //need more operationals in the future
			arr[0].isVal = hello*/

			var logicElements:Array = new Array;
			var givenLogicElement:Object = new Object;
			var logicSymbolLocations:Array = new Array;
			var tempArr:Array;
			
			for each(var log:String in logicSymbols){
				tempArr=findAllStringsInString(log, conditional);
				for (var tempPos:uint=0;tempPos<tempArr.length;tempPos++){
					logicSymbolLocations.push({logic:log,position:tempPos});
				}
			}
			logicSymbolLocations.sortOn("position", Array.NUMERIC);
	
			logicSymbolLocations.unshift({logic:"",position:-1}); //need a null at the start for the below for statement to be synched properly.
			
			if(conditional){
				var intermedCondList:Array=conditional.split(/&&|\|\|/g); //where | equals 'and'.  Note that this \|\| is equiv of || but | is a reserved character...
				for (var pos:uint=0;pos<intermedCondList.length;pos++){
					givenLogicElement=new Object;
					givenLogicElement.logicBeforeString = logicSymbolLocations[pos].logic;
					givenLogicElement.logicAfterString = "";
					givenLogicElement.what = what;
					if(logicSymbolLocations.length<=pos)givenLogicElement.logicAfterString = logicSymbolLocations[pos+1].logic;
					switch(what){
						case "cond": //acts like an or statement, this lack of break in a switch.
						case "objs":
							tempArr=intermedCondList[pos].split("=");
							//trace("4444442s",tempArr);
							givenLogicElement.variable = tempArr[0];
							givenLogicElement.logic = "=";
							givenLogicElement.isVal = tempArr[1];
							//trace(2222,givenLogicElement.variable,givenLogicElement.logicBeforeString,givenLogicElement.logic,"isVAL:",givenLogicElement.isVal);
							break;
						/*case "dvs":
							givenLogicElement.variable=intermedCondList[pos]
							//trace(2222,	givenLogicElement.variable);
							break;*/
					}	
					logicElements.push(givenLogicElement);
				}	
			}
			return logicElements;
		}
		
		private static function findAllStringsInString(searchFor:String,searchIn:String,caseSensitive:Boolean=true):Array{   
			var a:Array = new Array();
			if(searchFor && searchIn && searchIn.indexOf(searchFor)!=-1){
				if(!caseSensitive){             
					searchFor = searchFor.toLocaleLowerCase();        
					searchIn = searchIn.toLocaleLowerCase();   
				}       
				       
				var i:int = -1;     
				while ((i = searchIn.indexOf(searchFor, i+1)) != -1) a.push(i);      
			}
			return a;
		}
				
/*		private static function combineDataOverTrials(data:Object):Object{
			var newData:Array = new Array;
			var Obj:Object = new Object;
			Obj.arr = new Array;
			for(var trial:String in data){
				for each(var dat:String in data[trial]){
					//trace(999999,dat,trial);
					Obj.arr.push(dat);
				}
			}
			
			return Obj;
		}*/
		
		private static function calcMean(data:Array):Array
		{
			var newData:Array = new Array;
			for(var cond:uint=0; cond<data.length;cond++){
				newData.push(doAv(data[cond]));
			}
			//trace(newData);
			return newData;
		}
		
		private static function calcCount(data:Array):Array
		{
			var newData:Array = new Array;
			var problem:Boolean=false;
			var counter:uint;
			for(var cond:uint=0; cond<data.length;cond++){
				counter=0;
				for(var i:uint=0;i<data[cond].length;i++){
					if(!isNaN(data[cond][i]) && data[cond][i]!=""){
						counter++;
					}
				}
				newData.push(counter);
			}
			/*if(problem)//////////////////////////////////////a sloppy bodge which looks to see if no data has been collected (all 1s).  All 1s cooooooould arise though.
				for(var i:uint=0;i<data.length;i++){
					newData[i]=-1;
				}	*/
		
			return newData;
		}
		
		private static function doAv(list:Array):Number{
			var tally:int=0;
			var sum:Number=0;
			
			for each(var dataPoint:String in list){

				if(!isNaN(Number(dataPoint))&& dataPoint!="")
				{
					sum+=Number(dataPoint);
					tally++;
				}
			}
	
			if(sum==0 || tally==0)return undefined;
			return sum/tally;
		}
		
		
	}
}

