
package com{
	import com.Logger.Logger;
	
	public class trialOrderFunctions {
		
		
		//static var blockSize:uint;
		//static var numBlocks:uint;
		private static var randFirstOrder:String;
		private static var randSecondOrder:String;
		private static var slotInTrials:Array;
		
		
		
		
		
		public static function computeOrder(trialProtocolList:XML,composeTrial:Function, trialList:Array,arrayOfSplices:Array, logger:Logger):Array{
			var counter:uint=0;
			var blockCounter:uint=0;
			var currentBlock:uint = 0;
			var blockStartVal:uint = 0;
			var NumTrials:uint= 0;
			var trialOrderSpecifier:Array=new Array  ;
			var newTrialOrder:Array=new Array  ;
			var trialIJvalues:Array=new Array;
			
			for (var i:uint=0; i<trialProtocolList.TRIAL.length(); i++) { //for each block of trials
				NumTrials=uint(trialProtocolList.TRIAL[i].numberTrials.text());
				
				if (currentBlock<i){
					currentBlock = i;
					blockStartVal = counter;
					blockCounter++;
				}
				
				logger.log(trialProtocolList.TRIAL[i].@TYPE+" x "+NumTrials);
				var tempType:String=trialProtocolList.TRIAL[i].blockGroup.@trialOrder;
				var tempBlockGroup:String=trialProtocolList.TRIAL[i].blockGroup.text();
				
				
				
				
				
				if(codeRecycleFunctionsdead.IsNumeric(tempBlockGroup)==false){
					if(!slotInTrials) slotInTrials= new Array();
					
					var arr:Array = new Array;
					arr.addOn=Math.pow(10,String(codeRecycleFunctionsdead.biggestInArray(trialProtocolList.TRIAL.blockGroup.*.toXMLString().split("\n"))).length);
					arr.blockToSlotInto=int(tempBlockGroup.split("(")[1].split(")")[0]);
					arr.newBlockGroup=arr.addOn+arr.blockToSlotInto;
					arr.slotInWhere=trialProtocolList.TRIAL[i].blockGroup.attribute("afterWhichTrial");
					slotInTrials.push(arr);
					tempBlockGroup=arr.newBlockGroup;
				}
				
				if (tempBlockGroup=="fixed") {
					trialOrderSpecifier.push("fixed");
				} else if (tempType=="") {
					trialOrderSpecifier.push("random");
				} else {
					trialOrderSpecifier.push(tempType);
				}
				
				for (var j:uint=0; j<NumTrials; j++) {
					//composeTrialArr[counter] = new Array;
					//composeTrialArr[counter]={i:i,j:j,counter:counter,tempBlockGroup:tempBlockGroup,tempType:tempType,blockStartVal:blockStartVal}
					trialIJvalues.push(composeTrial(i,j,counter,tempBlockGroup,tempType,blockStartVal));///
					counter++;
				}
			}
			
			var trialOrder:Array=new Array;
			var trialOrderBlocks:Array = new Array;
			var blockArray:Array=new Array;
			//var uberBlocks:Array;
			//var uberBlockGroupType:Array;
			for (var pp:uint=0; pp<trialIJvalues.length; pp++) {
				
				
				var tempStr:String=trialIJvalues[pp].blockGroup;
				
				
				/////////////////////////////////////////////
				/////////////////////////////////////////////
				
				var tempNam:String=trialIJvalues[pp].blockType;
				
				if (blockArray[tempStr]==undefined) {
					blockArray[tempStr]=new Array  ;
					blockArray[tempStr].push(tempNam);
				}
				
				blockArray[tempStr].push(pp); //bit crap here as the Array autofills all the missing values inbetween.
				//blockArray[tempStr].push(1);
				
				//UBERBLOCK2: parses uberblock stuff for later on.  See UBERBLOCK3.
				//if(trialIJvalues[pp].uberBlockGroupType!=undefined){
				//if(!uberBlocks)uberBlocks=[];
				//uberBlocks.push({blockName:tempStr,uberBlockGroups:trialIJvalues[pp].uberBlockGroup,uberBlockGroupsType:trialIJvalues[pp].uberBlockGroupType});
				//}
				
				
			}
			
			
			//for(var s:String in blockArray){
			//	trace(s,blockArray[s]);
			//}
			
			
			
			logger.log("blockArray: "+blockArray);
			//logger.log("newTrialOrder: "+newTrialOrder);
			////////////////////////this bit creates a randomly ordered script for the trials)
			/////future job: include, in XML input, whether a trial is 'fixed' in order or not, and sort out shuffle.
			
			var tempTrialOrder:Array=new Array(trialList.length);
			
			//var trialOrderSpecifierZeroRemoved:Array=new Array  ;
			
			for (i=0; i<tempTrialOrder.length; i++) {
				tempTrialOrder[i]=i;
			}
			
			//trailOrder contains a simple list of numbers that correspond to trial number.  
			//This used to determine which trial to run stored in trialList.
			
			var numberRandomTrialTypes:uint=blockArray.length;
			var ExptWideSpecs:Array=new Array  ;
			var shuffledTrials:Array=new Array  ;//might be best to call this 'nonShuffled Trials'.
			var arrayRandomTrials:Array=new Array  ;
			
			logger.log("---initial trialOrder--- ");
			for (i=0; i<blockArray.length; i++) {//
				if (blockArray[i]!=undefined) {
					var newTrials:Array=new Array  ;
					var tempBlockArr:Array=blockArray[i];
					var tempTrialType:String=tempBlockArr[0];
					tempBlockArr.shift();
					if (tempTrialType=="random") {
						newTrials=shuffleArray(tempBlockArr);
					} else if (tempTrialType=="fixed") {
						newTrials=tempBlockArr;
					} else if (tempTrialType.substring(0,23)=="repeatRandBlocksDifEnds") {
						newTrials=trialOrderFunctions.repeatRandBlocksDifEnds(tempBlockArr,extractVariables(tempTrialType));
					}
					
					if(!slotInTrials || i<slotInTrials[0].addOn){//if the blockArray is not a special 'slot into' block array...
						logger.log("trials: "+newTrials);
						for (var num:uint=0;num<newTrials.length;num++){
							trialOrderBlocks.push(i);
						}
						trialOrder=trialOrder.concat(newTrials);
					}
						
						////////////////////////////////////////////////////////////////////////////////////
						//////////////////////////////////sorts out the 'slot into' stuff
					else{
						for (var bg:uint=0; bg<slotInTrials.length; bg++){
							if(slotInTrials[bg].newBlockGroup==i){
								var newPosition:uint = codeRecycleFunctionsdead.findStart(trialOrderBlocks,slotInTrials[bg].blockToSlotInto);
								var endPosition:uint=codeRecycleFunctionsdead.findEnd(trialOrderBlocks,slotInTrials[bg].blockToSlotInto);
								var addOn:Array=(slotInTrials[bg].slotInWhere.split(";")as Array).sort();
								logger.log("slot in trials: '"+newTrials+"' into Block '"+slotInTrials[bg].blockToSlotInto+"' after these locations: '"+addOn+"'.");
								for (var jj:uint=0; jj<addOn.length; jj++){
									if(newPosition+uint(addOn[jj])<=endPosition){	
										
										trialOrder.splice(uint(newPosition+uint(addOn[jj])),0,newTrials.shift());
										trialOrderBlocks.splice(uint(newPosition+uint(addOn[jj])),0,slotInTrials[bg].blockToSlotInto);
									}
									else trace("could not slot in this trial as the exceeded block limit:"+newPosition+uint(addOn[jj]));
								}
								break;
							}
						}
					}
					
				} 
			}
			
			for (i=0;i<trialOrder.length;i++){
				var zeros:uint=String(trialOrder[i]).length-String(trialOrderBlocks[i]).length;
				switch(zeros)
				{
					case 1:
						trialOrderBlocks[i]=" "+trialOrderBlocks[i];
						break;
					
					case 2:
						trialOrderBlocks[i]=" "+trialOrderBlocks[i];
						break;
					
				}
			}
			/*			
			UBERBLOCK3 Need search through trialOrderBlocks and trialOrder(see vars below) for all instances of a uberBlock.blockName, extract instances
			and then apply to THESE found trials the necessary shuffle (uberBlock.uberBlockGroupsType).
			Then need to reinsert.
			
			//SORTING UBERBLOCKS HERE
			if(uberBlocks){
			var blocks:Array;
			var recogBlocks:Array;
			
			for(var uberBlock:Object in uberBlocks){
			for(i=0;i<trialOrderBlocks.length;i++){
			if(trialOrderBlocks[i]==uberBlock.blockName){
			
			}
			}
			
			
			}
			}
			*/
			
			//uberBlock.push({blockName:tempStr,uberBlockGroups:trialIJvalues[pp].uberBlockGroup,uberBlockGroupsType:trialIJvalues[pp].uberBlockGroupType});
			
			
			
			////////////////////////	
			
			//trace(trialOrderBlocks);
			//trace(trialOrder);
			
			
			logger.log("trial block order       : "+trialOrderBlocks);
			logger.log("trialOrder after shuffle: "+trialOrder);
			////////////////////////////////////////////////////////////////////////////////////
			
			
			
			for (i=0; i<arrayOfSplices.length; i++) {
				var SplicVars:Array=arrayOfSplices[i];
				var funct:Array=SplicVars[0].split(" ");
				if (funct[0]=="rand") {
					var randNum:Number=Math.random()*100;
					if (randNum>Number(funct[1])) {
						var tempArr:Array=trialOrder.splice(SplicVars[1],SplicVars[2]);
						trialOrder.splice(SplicVars[3],0,tempArr);
						//logger.log("splice [" + SplicVars+ "] was done as random number ("+(Math.round(randNum))+") exceeded your threshold ("+funct[1]+")");
					} else {
						//logger.log("splice [" + SplicVars+ "] was not done as random number ("+(Math.round(randNum))+") did not exceed your threshold ("+funct[1]+")");
					}
					
				}
				
				//logger.log("trialOrder after splice: "+trialOrder);
			}
			
			return trialOrder;
			////////////////////////////////////////////////////////////////////////////////////
		}
		
		
		
		private static function extractVariables(str:String):Array {
			str=str.substring(str.indexOf("[")+1,str.indexOf("]"));
			return (str.split(","));
		}
		
		private static function shuffleArray(a:Array):Array {
			var a2:Array=[];
			while (a.length>0) {
				a2.push(a.splice(Math.round(Math.random()*a.length-1),1)[0]);
			}
			return a2;
		}
		
		
		
		private static function genRepetition(num:uint):Array {
			var repArray:Array=new Array  ;
			for (var i:uint=0; i<num; i++) {
				repArray.push(i+1);
			}
			return repArray;
		}
		
		public static function repeatRandBlocksDifEnds(trials:Array,rawParameters:Array):Array {
			///trace("eee "+trials);
			var parameters:Array=extractparameters(rawParameters);
			var newTrials:Array=new Array  ;
			var blockSize:uint=parameters[0];
			var numBlocks:uint=parameters[2];
			randFirstOrder=parameters[1];
			randSecondOrder=parameters[3];
			
			if (randSecondOrder=="R") {
				newTrials=shuffleWithRepeats(trials,blockSize,numBlocks);
				trials=escalateSecondOrderTrialNumbers(trials,newTrials,blockSize,numBlocks);
			}
			if (randFirstOrder=="S") {
				newTrials=shuffleWithNoRepeats(trials,blockSize,numBlocks);
			} else if (randFirstOrder=="R") {
				newTrials=shuffleWithRepeats(trials,blockSize,numBlocks);
			} else {
				newTrials=noShuffle(trials,blockSize,numBlocks);
			}
			
			return escalateFirstOrderTrialNumbers(trials,newTrials,blockSize,numBlocks);
		}
		
		
		private static function extractparameters(raw:Array):Array {
			var tempString1:String;
			var tempString2:String;
			var returnArray:Array=new Array  ;
			for (var i:uint=0; i<raw.length; i++) {
				tempString1=String(raw[i].substring(0,1));
				tempString2=String(raw[i].substring(1,2));
				if (isANumber(tempString1)) {
					returnArray.push(tempString1);
					if (tempString2.length==0) {
						returnArray.push("F");
					} else {
						returnArray.push(tempString2);
					}
				} else {
					returnArray.push(tempString2);
					if (tempString2.length==0) {
						returnArray.push("F");
					} else {
						returnArray.push(tempString1);
					}
				}
			}
			return returnArray;
		}
		
		private static function isANumber(__str:String):Boolean {
			return ! isNaN(Number(__str));
		}
		
		private static function noShuffle(trials:Array,blockSize:uint,numBlocks:uint):Array {
			var newTrials:Array=new Array  ;
			var tempRep:Array;
			for (var i:uint=0; i<numBlocks; i++) {
				tempRep=genRepetition(blockSize);
				newTrials=newTrials.concat(tempRep);
			}
			return newTrials;
		}
		
		private static function shuffleWithRepeats(trials:Array,blockSize:uint,numBlocks:uint):Array {
			var newTrials:Array=new Array  ;
			var tempRep:Array;
			for (var i:uint=0; i<numBlocks; i++) {
				tempRep=shuffleArray(genRepetition(blockSize));
				newTrials=newTrials.concat(tempRep);
			}
			return newTrials;
		}
		
		private static function shuffleWithNoRepeats(trials:Array,blockSize:uint,numBlocks:uint):Array {
			var newTrials:Array=new Array  ;
			var tempRep:Array;
			newTrials=shuffleArray(genRepetition(blockSize));
			for (var i:uint=1; i<numBlocks; i++) {
				tempRep=shuffleArray(genRepetition(blockSize));
				while (tempRep[blockSize-1]!=newTrials[newTrials.length-1]) {
					tempRep=shuffleArray(genRepetition(blockSize));
				}
				newTrials=newTrials.concat(tempRep);
			}
			return newTrials;
		}
		
		private static function escalateSecondOrderTrialNumbers(trials:Array, newTrials:Array,blockSize:uint,numBlocks:uint):Array {
			
			var splitIntoDataTypes:Array=new Array  ;
			var groupsArray:Array=new Array  ;
			var singleGroup:Array=new Array  ;
			var returnTrials:Array=new Array  ;
			
			for (var i:uint=0; i<numBlocks; i++) {//size of each group / block
				for (var j:uint=0; j<blockSize; j++) {// number of groups / blocks
					singleGroup.push(trials[(i*blockSize)+j]);// e.g. abcd efgh ijkl mnop
					//singleGroup.push((j*blockSize)+i);
				}
				groupsArray.push(singleGroup);
				singleGroup=new Array  ;
			}
			
			
			groupsArray=shuffleArray(groupsArray);
			
			
			for (i=0; i<groupsArray.length; i++) {
				for (j=0; j<groupsArray[i].length;j++){
					returnTrials.push(groupsArray[i][j]);
				}
			}
			return returnTrials;
		}
		
		
		
		
		
		private static function escalateFirstOrderTrialNumbers(trials:Array, newTrials:Array,blockSize:uint,numBlocks:uint):Array {
			
			var splitIntoDataTypes:Array=new Array  ;
			var groupsArray:Array=new Array  ;
			var singleGroup:Array=new Array  ;
			var returnTrials:Array=new Array  ;
			
			
			
			for (var i:uint=0; i<numBlocks; i++) {//size of each group / block
				for (var j:uint=0; j<blockSize; j++) {// number of groups / blocks
					singleGroup.push(trials[(i*blockSize)+j]);// e.g. abcd efgh ijkl mnop
					//singleGroup.push((j*blockSize)+i);
				}
				groupsArray.push(singleGroup);
				singleGroup=new Array  ;
			}
			
			for (i=0; i<newTrials.length; i++) {
				var trialPos:uint=newTrials[i]-1;
				var blockPos:uint=(i-(i%blockSize))/blockSize;
				//trace("groupsArray:"+groupsArray+" trialPos:"+(trialPos)+" blockPos:"+blockPos);
				returnTrials.push(groupsArray[blockPos][trialPos]);
				
			}
			
			trace("newTrials:"+newTrials);
			trace("returnTrials:"+returnTrials);
			
			return returnTrials;
		}
		
		private static function inverseArray(arr:Array):Array {
			var tempArr:Array=new Array  ;
			var returnArray:Array=new Array  ;
			for (var i:uint=0; i<arr[0].length; i++) {
				tempArr=new Array  ;
				for (var j:uint=0; j<arr.length; j++) {
					
					tempArr.push(arr[j][i]);
					
				}
				returnArray.push(tempArr);
			}
			return returnArray;
		}
		
	}
}