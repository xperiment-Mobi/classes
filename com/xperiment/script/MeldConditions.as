package com.xperiment.script
{

	public class MeldConditions
	{
		private static const BS_ID:String = 'betweenSJ';
		
		public static function DO(script:XML, cond:int):XML{
			
			if(script.children()[0].name()=="start" && cond!=0){
				delete script.start
				cond--;
			}

			
			if (cond==0) return script.*[cond]
			if ((cond>script.*.length()-1)) throw new Error('should be impossible to reach here and to have too few between sj conditions');
			
			var subScript:XML=script.*[cond];
			var myScript:XML;
			
			
			
			//if <CBCondition2 exptType="WEB" leaveAlone="true"> , do nothing to this between SJs condition.
			if(subScript.@leaveAlone.toString().toLowerCase()=="true"){
				return script.*[cond]
			}
				
			else myScript=script.*[0];//note that for BetweenSJs experiments, the first script is the 'boss'/generic script.
			
			myScript.setName(subScript.name());
			
			var label:String;
			
			//below replace end Jan 2013 as it sometimes returned null when fetching parent.
			//for each(var offspringStim:XML in subScript..@[BS_ID].parent()) {
			for each(var offspringStim:XML in subScript..*.(hasOwnProperty("@"+BS_ID))) {
				label=offspringStim.@[BS_ID];
				for each(var parentStim:XML in myScript..*.(hasOwnProperty("@"+BS_ID))) {			
					if(parentStim.@[BS_ID]==label){
						
						__conbobulate(offspringStim,parentStim);
						delete parentStim.@[BS_ID];
					}
					
				}
			}
			
			//trace(myScript);
			return myScript;
		}
		
		public static function __conbobulate(offspringStim:XML, parentStim:XML):void
		{
			/*
			<a betweenSJ='abc'>
			<addAttributes/>   //note doe not override, must use edit
			<editAttributes/> 
			<removeAttributes/>
			<addStimuli></addStimuli>
			<removeStimuli></removeStimuli>
			</a>
			*/
						
			for each(var attrib:XML in offspringStim.addAttributes.attributes()){
				if(parentStim.hasOwnProperty('@'+attrib.name()) == false ) parentStim.@[attrib.name()]=attrib;
			}
			
			for each(attrib in offspringStim.editAttributes.attributes()){
				parentStim.@[attrib.name()]=attrib;
			}
			
			if(offspringStim.hasOwnProperty('removeAttributes')){
				var attribsStr:String = offspringStim.removeAttributes.toString();
				
				for each(var attribStr:String in attribsStr.split(",")){
					delete parentStim.@[attribStr];
				}
			}
			
			for each(attrib in offspringStim.addChild.children()){
				parentStim.appendChild(attrib);
			}
			
			if(offspringStim.hasOwnProperty('removeChildren')){
				for each(attrib in parentStim.children()){
					__deleteNode(attrib);
				}
			}
			
			if(offspringStim.hasOwnProperty('removeChild')){
				var pegs:String = offspringStim.removeChild.toString();
				for each(var peg:String in pegs.split(",")){
					for each(attrib in parentStim..*.(hasOwnProperty("@peg") && @peg.toString()==peg)){		
						__deleteNode(attrib);
					}
					
				}
			}
			
			if(offspringStim.hasOwnProperty('remove')){
				//crazy method but necessary: https://bottomupflash.wordpress.com/2008/03/26/deleting-xml-nodes-harder-than-it-looks/#comment-194
				__deleteNode(parentStim);
			}	
		}	
		
		private static function __deleteNode(node:XML):void{
			delete node.parent().children()[node.childIndex()]
		}
		
		/*private static function descendingMerge(subScript:XML,bossTrial:XML):void{
		for each(var attribArr:XML in subScript.@*){
		bossTrial.@[String(attribArr.name())]=attribArr;
		}
		
		for each(var subsubTrial:XML in subScript.*) {
		if(bossTrial[String(subsubTrial.name())]==undefined){
		bossTrial[String(subsubTrial.name())]=subsubTrial;
		}
		else{
		descendingMerge(subsubTrial,XML(bossTrial[String(subsubTrial.name())]));
		}
		}
		}	*/
	}
}