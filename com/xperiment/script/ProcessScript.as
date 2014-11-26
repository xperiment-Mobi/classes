
package com.xperiment.script{
	
	import com.xperiment.script.ProcessScriptHelpers.SpecialVariableActions;
	import com.xperiment.stimuli.helpers.StimModify;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class ProcessScript extends Sprite {

		private var specialObjs:Array = ["objects","blockGroup","numberTrials"];
		public var script:XML;
		public static var COPYOVER_ID:String='copyOverID';

		
		public function process(parentScript:XML):void {
			script=parentScript;


			//is the experiment 'mock' value set to true?
			if(script..*.(hasOwnProperty("@mock") && @mock=='true').length()==1){
				script=replaceAllInstancesOfAttribWithSuffixedAttrib("mock",script);
			}
		
			if(['multi','betweensjs'].indexOf(script.name().toString().toLowerCase())!=-1){
				var betweenSJs:BetweenSJs = new BetweenSJs;
				this.addChild(betweenSJs);
				betweenSJs.addEventListener(Event.COMPLETE, function(e:Event):void{
					e.stopPropagation();
					betweenSJs.removeEventListener(Event.COMPLETE, arguments.callee);
					removeChild(betweenSJs);
					script=betweenSJs.script;
					//trace(111,script)
					betweenSJs=null;
					next();
				},false,0,false);
			
				betweenSJs.sortOutMultiExperiment(script,urlParam_cond());
			
			}
			else next();

		}
		
		private function urlParam_cond():String
		{
			if(!this.parent)	return '';
			var cond:String = this.parent.loaderInfo.parameters.cond;
			if(cond) return cond;
			return '';
		}
		
		private function next():void{
			script=sortOutTemplates(script);
			script=sortOutETCs(script);
			script=sortOutSpecialVariables(script);
			script=StimModify.sortOutOverExptMods(script);


			/*for(var command:String in ProcessScript_comands.commands){
				script=sortOutCommands(script,command,ProcessScript_comands.commands[command]);
			}*/
			//script=SortoutPREVandNEXT.now(script);
		

			//trace('dispatch processScript',script);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function sortOutCommands(script:XML,command:String,f:Function):XML
		{
			
			for each(var stimulus:XML in script..*.(hasOwnProperty("@"+command))){
				var prop:String = stimulus.@[command];
				f(stimulus,prop);	
			}
			return script;
		}
		
		private function sortOutSpecialVariables(script:XML):XML
		{
			
			script = SpecialVariableActions.process(script);

			
			var variables:XMLList = script..SETUP[0].variables;
			var variable:String;
			var value:String;
			
			for each(var variableXML:XML in variables.attributes()){
				variable= variableXML.name();
				value	= variableXML.toString();
	
				//only uppercase are considered		
				if(variable==variable.toUpperCase()){
					
					replaceAttribValue(script, variable,value);
					delete variables.@[variable];
				}
			}
			//trace(script)
			return script;
		}		
		
		private function replaceAttribValue(script:XML, variable:String, value:String):void
		{
			for each(var stimulus:XML in script..*.(attributes().toString().indexOf(variable)!=-1)){
				
				for each(var attribute:XML in stimulus.attributes()){
					if(attribute.toString().indexOf(variable)!=-1){
						stimulus[attribute.name()]=attribute.toString().split(variable).join(value);
					}
				}
			}
		}		

		/*private function sortOutOverExptStuff(script:XML):XML
		{
			var joinedAttribs:Array = [];
			var temp:String;
			var arr:Array;
			var i:int;
			var accordingTo:String;
			var max:int=0;
			for each (var stimulus:XML in script..@SHUFFLE) {
				// SHUFFLE="text-LINK-name,;" where after the comma is what to seperated the shuffled  attributes according to.
				
				temp=stimulus.toString();
				
				
				if(temp.indexOf(",")!=-1){
					accordingTo=",";
					temp=temp.split(",")[0];
				}
				else if(temp.indexOf(";")!=-1){
					accordingTo=";";
					temp=temp.split(";")[0];
				}

				else accordingTo="---";
				
				
				arr=temp.split("-LINK-");
				
				for(i=0;i<arr.length;i++){
					temp=stimulus.parent().@[arr[i]];
					if(temp.length!=0){
						joinedAttribs[arr[i]]=[]
						joinedAttribs[arr[i]]=temp.split(accordingTo);
						if(joinedAttribs[arr[i]].length>max){			
							max=joinedAttribs[arr[i]].length;
						}
					}
				}
				
				//joinedAttribs.text="111---222---333"
				//joinedAttribs.name="a---b---c"
				
				var shuffleArr:Array=[];
				for(i=0;i<max;i++)shuffleArr.push(i);
				shuffleArr=codeRecycleFunctions.arrayShuffle(shuffleArr);
				
				for (var attrib:String in joinedAttribs){
					//trace(attrib,"  ",joinedAttribs[attrib]);
					arr=joinedAttribs[attrib]
					//trace(222,arr);
					joinedAttribs[attrib]=[];
					for (i=0;i<shuffleArr.length;i++){
						joinedAttribs[attrib][i]=arr[shuffleArr[i]%arr.length];
					}
					stimulus.parent().@[attrib]=(joinedAttribs[attrib] as Array).join(accordingTo);
					
				
				}
				delete stimulus.parent().@SHUFFLE;
			}
		
			//trace(script);
			return script;
		}*/
		
		private function sortOutETCs(script:XML):XML
		{
			var startingVal:String;
			var etcArr:Array;
			var num:uint;
			var initEtcArrLen:uint;
			var difArr:Array;
			var etcSuffix:String="";
			var etcPrefix:String="";
			var prefix:String="";
			var tempnum:int;
			
			/*
			In a nutshell, search throughout all of script looking for both ---etc--- and ,,,etc,,,
			---etc--- is for multiple objects per trial, where objects seperated by ---
			,,,etc,,, is for BOTH:
									object variations over trial
									AND also for any numbered sequence seperated by ,
			
			Objects are iterated by:
			---etc--- howMany in the object
			,,,etc,,, by specifying 'etcHowMany' parameter.
			
			note that ---etc--- howMany value can be overwritten by etcHowMany.
			
			Note that patterns can be picked up.  E.g. 1,4,5 will have a starting value of 1 and subsequent numbers will be 3 and then 1 bigger.
			
			Note that for both, you can specify etcPrefix and etcSuffix.
			
			Note that ,,,etc,,, works with behaviours, stripping out stuff before : and adding at the end.  
			NOTE THO, only works with ONE behaviour type currently.		
			NOOOOOTE THO that just use multiple behaviours to specify :) e.g. behaviours="a" behaviours2="b" etc etc
			*/
			var list:Array=["---etc---",",,,etc,,,",";;;etc;;;"];
			for each(var splitter:String in list){
				
				for each (var stimulus:XML in script..*.(attributes().toString().indexOf(splitter)!=-1)) {
					//need this loop within a loop as whole objects above are retrieved.  Need to isolate the attribute in the second loop.
					
					for each (var attrib:XML in stimulus.attributes()) {
						startingVal=attrib.toString();
						var isPercent:String = "";
					
						if(startingVal.substr(startingVal.length-9,9)==splitter){
							if(startingVal.indexOf("%")!=-1){
								startingVal=startingVal.split("%").join("");
								isPercent="%";
							}
							
							startingVal=startingVal.replace(splitter,"");
							
							if(splitter=="---etc---")etcArr=startingVal.split("---");
							else etcArr=startingVal.split(splitter.substr(0,1));
							
							num=uint(stimulus.@howMany.toString());
							
					
							if(splitter==";;;etc;;;")num=stimulus.parent().parent().@numberTrials.toString();
							if(stimulus.@etcHowMany.toString()!="")num=stimulus.@etcHowMany.toString();
							//trace(num);
							//if all the elements in the Array are numbers, only then perform 'etc' operation
							
							//////////////////////////////////MONSTROUS FILTER FUNCTION
							//
							
							//////////////MAKE THIS COMPATIBLE WITH TEXT TOO
							if(etcArr.filter(function(element:*, index:int, arr:Array):Boolean{
								if((tempnum=arr[index].indexOf(":"))!=-1){
									prefix=arr[index].split(":")[0]+":";
									arr[index]=arr[index].split(":")[1];
								}
								arr[index]=Number(arr[index]);//sneakily convert elements to Numbers while we are at it
								//trace(type,!isNaN(arr[index]),etcArr.length,num);
								return !isNaN(arr[index]);								
								
							}).length==etcArr.length && num>1){
								var pos1:Number=etcArr.shift();
								//etcArr.unshift(0);
								difArr=new Array;
								difArr[0]=etcArr[0]
								for(var i:uint=1;i<etcArr.length;i++){
									difArr.push(etcArr[i]-etcArr[i-1]+pos1);
					
								}
								
								
								
								if(difArr[0]==0)difArr.shift();
								
								etcArr.unshift(pos1);
								for(i=etcArr.length-1;i<num;i++){
									etcArr.push(etcArr[etcArr.length-1]+difArr[(i+1)%difArr.length]-pos1);
								}
								
								
								
								etcSuffix=(stimulus.@etcSuffix.toString());
								etcPrefix=(stimulus.@etcPrefix.toString());
								
								//trace(111,etcArr)
								if(splitter=="---etc---") stimulus.@[attrib.name()]=prefix+etcArr.join(etcSuffix+isPercent+"---"               +etcPrefix);
								else					  stimulus.@[attrib.name()]=prefix+etcArr.join(etcSuffix+isPercent+splitter.substr(0,1)+etcPrefix);
								
								/////////////////
							
							}
							//
							//////////////////////////////////
							//////////////////////////////////
						}			
					}
				}
			}
		
			return script;
		}
		
		
	
	/*	
		private function replaceAllInstancesOfSpecificAttrib(attribute:String, val:String, script:XML,logger:Logger):void{
			var child:XML;
			for each(child in script..@[attribute]){
				logger.log("---The '"+ child.name() +"' object has had attribute '"+attribute+"' changed to '"+val+"'.");
				child.parent().@[attribute]=val;
			};
			
			if (!child) logger.log("Problem: you have asked to change all attributes called '"+attribute+"' with '"+val+"' but I could not find any objects with such an attribute.");
		}
		
		
		private function overwriteAttributeFromID(id:String, attribute:String, val:String, script:XML,idTag:String,logger:Logger):void{
			var child:XML;
			for each(child in script..*.(hasOwnProperty("@"+idTag) && @[idTag]==id)){
				logger.log("---The '"+ child.name() +"' object with id '"+id+"' has had attribute '"+attribute+"' added/changed to '"+val+"'.");
				child.@[attribute]=val;
			}
			if (!child) logger.log("Problem: you have asked to change the attribute all objects of id '"+id+"' with an attribute called '"+attribute+"' with '"+val+"' but I could not find any objects with that given id.");
		}
		
		private function overwriteValueFromID(id:String, val:String, script:XML,idTag:String,logger:Logger):void{
			var child:XML;
			for each(child in script..*.(hasOwnProperty("@"+idTag) && @[idTag]==id)){
				logger.log("---The '"+ child.name() +"' object with id '"+id+"' has had its actualValue added/changed to '"+val+"'.");
				child.setChildren(val);	
			}
			if (!child) logger.log("Problem: you have asked to change the actualValue of objects with id '"+id+"' with '"+val+"' but I could not find any objects with that given id.");
		}
			*/

		private function sortOutTemplates(script:XML):XML {
			var buriedTrial:XML;
			var TrialSnapShot:XML;
			var templateName:String;
			var listToDelete:Array=new Array;
			var templateList:Array=new Array;
			for each (var Trial:XML in script..*.(hasOwnProperty("@template"))) {
				templateList=Trial.@template.toString().split(",");
				for each(templateName in templateList){
					if(listToDelete.indexOf(listToDelete)==-1)listToDelete.push(templateName);
					var templates:XMLList=script[templateName];
					for each(var template:XML in templates){
						giveTraits(Trial,template.copy());
					}	
				}
			}
			for each(templateName in listToDelete){delete(script[templateName]);}
			//trace(script)
		return script;
	}
		
		
		private function giveTraitsSpecialNodes(childMain:XML,template:XML,specialNodeName:String):void {
			var childObjs:XML=childMain..*.(name()==specialNodeName)[0];
			var templateObjs:XML=template..*.(name()==specialNodeName)[0];
			
			//below, first attempt at making it possible to not hv objects buried in 'objects' node.  Would need this for templateObjs too.
			if(templateObjs && templateObjs.toString().length!=0){//add this later: childObjs && 
				/*if(!childObjs){
				//search through childMain and establish if top level contains add/behav/admin etc.  If so, childObjs is the top level
				if(childObjs.*.(name().toString().length!=0 && ["add","beh","adm"].indexOf(name().toString().substr(0,3))!=-1).length()>0){ //if the childObjs contain add, beh, adm
				childObjs=childMain.children();
				}
				//else create objects node and pass this
				}*/
				if(!childObjs)childMain.appendChild(templateObjs);
				else {giveTraits(childObjs,templateObjs,1);
				}
				delete(template..*.(name()==specialNodeName)[0]);
			}
		}
		
		//sep function for Builder
		protected function setVal(templateAttribs:XMLList, childMain:XML):void
		{
			for each(var attribute:XML in templateAttribs) {
				if(childMain.hasOwnProperty("@"+attribute.name())==false)childMain.@[attribute.name()]=attribute;
			}
			
		}
	
		private function giveTraits(childMain:XML,template:XML,depth:uint=0):void {
			// if "objects","blockGroup","numberTrials" allow iterate
			if(depth==0){
				for each(var special:String in specialObjs){
					giveTraitsSpecialNodes(childMain,template,special);
				}
			}
//trace(template)
			var templateAttribs:XMLList=template.attributes();
			//top level attribute merging (childMain overrides template)
			setVal(templateAttribs,childMain);
			
			//////////////
			var counter:uint;
			var node:XML
			//var stimDepths:Array = [];
	
			for each(node in template.children()){	
				
				//if(node.childIndex()!=-1)	stimDepths.push({copyOverID:node.@["copyOverID"].toString(),depth:node.childIndex()});
				// if copyOverID same, merge
				if(node.hasOwnProperty("@"+COPYOVER_ID)){					

					counter=0;
					var childChildMainList:XMLList=childMain..*.(hasOwnProperty("@"+COPYOVER_ID) && @copyOverID==node.@[COPYOVER_ID]);
					for each(var childChildMain:XML in childChildMainList){
						giveTraits(childChildMain,node,depth+1);
						delete(template[node.name()]);
						counter++
					} 
					if(counter==0){
						//delete node.@copyOverID; do not do this as one may want to apply multiple templates which feed off each other
					
						childMain.appendChild(node.copy());
					}
				}
					// else append
				else {
					if(node.name()!=null){
						if(specialObjs.indexOf(node.name().toString())==-1)childMain.appendChild(node.copy());
						else{ //is a special property and this can only exist ONCE.  So, much check if already exists, if not, append, else, do nothing.
							if(!childMain.hasOwnProperty(node.name())){
								childMain.appendChild(node.copy());	
							}
						}
					}
					
				}
			}

/*			stimDepths.sortOn("depth");
			var depthObj:Object;
			for(var i:int=0;i<stimDepths.length;i++){
				depthObj = stimDepths[i];
				trace(depthObj.depth,22)
			}*/
					
			
		}
		

		
		//used to replace language in runner class
		public static function replaceAllInstancesOfAttribWithSuffixedAttrib(attributeSuffix:String, script:XML):XML{

			var bossAttrib:String="";
			var bossValue:String;
			var newValue:String;
			
			for each (var stimulus:XML in script..*.attributes()) {
				bossAttrib=stimulus.name().toString();
				if(bossAttrib.indexOf("."+attributeSuffix)!=-1 && bossAttrib.length>attributeSuffix.length+1){
					newValue=stimulus.toString();

					bossAttrib=bossAttrib.split(".")[0];
					bossValue=stimulus.parent().attribute(bossAttrib).toString();
					if(bossValue.length!=0){
						if(stimulus.parent().attribute(bossAttrib+".default").toString().length==0)
						{
							//creates a backup of the default value like so: @bla.default (where bla is val of bossAttrib)
							stimulus.parent().@[bossAttrib+".default"]=bossValue;
						}
					}	
					//below line was one bracket up before 13/5/2013.  Moved when adding 'mock' feature for behaviour stim.
					stimulus.parent().@[bossAttrib]=newValue;
				}	
			}
			return script;	
		}



	}

}