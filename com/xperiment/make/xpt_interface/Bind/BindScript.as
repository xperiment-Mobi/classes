package com.xperiment.make.xpt_interface.Bind
{
	import com.xperiment.script.ProcessScript;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.Dictionary;

	public class BindScript
	{
		public static var script:XML;
		public static var counter:int;
		public static var bindLabel:String = '__BIND';
		public static var templateBindLabel:String = '__T_BIND';
		public static var xmlBODY:String = 'IS_BODY';
		
		private static var tagDictionary:Dictionary;
		private static var scriptName:String;
		private static var callBackF:Function;
		
		private static const SETUP:String = 'SETUP';
		private static const TRIAL:String = "TRIAL";
		private static const TEMPLATE:String = "TEMPLATE";
		
		private static var bind_regexp:RegExp = /\_\_BIND=\".*?\"/g;
		private static var templateBind_regexp:RegExp = /\_\_T\_BIND=\".*?\"/g;

		
		public static function setup(scr:XML, _callBackF:Function):XML
		{
			script = scr

			tagDictionary = new Dictionary;
			counter = 0;
			scriptName=script.name();
			callBackF=_callBackF;
			linkup(script);
			//trace(script)
			//bind.tagDictionary[1].@id='123'
			//trace(script,233);
			
			
			//delete tagDictionary['TRIAL_8'];
			
			//trace(scr,tagDictionary[3].@saveToCloud=123)
			//trace(tagDictionary[2].attributes(),22)
			return script.copy();
		}
		
		public static function assembleType(type:String):Array{
			var arr:Array = [];
			for(var bind_id:String in tagDictionary){
				if((tagDictionary[bind_id] as XML).name()==type)	arr.push(tagDictionary[bind_id]);
			}
			return arr;
		}
		
/*		public static function assembleTypeFromScript(type:String):Array{
			var arr:Array = [];
			for(var bind_id:String in tagDictionary){
				if((tagDictionary[bind_id] as XML).name()==type)	arr.push(tagDictionary[bind_id]);
			}
			return arr;
		}*/
		
		/*public static function giveProcessedScript(_processedScript:XML):void
		{
			processedScript = _processedScript;	
			

			//updateAttrib('TRIAL_12,Bouba2_13,Bouba2_15', 'tt',3);
		}*/
		
		public static function StimulusUpdate(bind_id:String, updates:Object):void{
			var stim:XML = tagDictionary[bind_id];
			
			for(var key:String in updates){
				stim.@[key]= updates[key];
			}
			
		}

		
																									//depth = -1
		public static function updateAttrib(bind_id:String, attrib:String, val:*, multiSpecs:Object, depth, updateInfo:Array, update:Boolean=true):Boolean{
			var binds:Array = bind_id.split(",");
			var newVal:String;
			//trace(111,bind_id)
			//trace(123,JSON.stringify(multiSpecs),attrib,val);
			if(binds.length==1 || depth==0){
				//trace(bind_id,23232,attrib)
				
				//if(attrib!=xmlBODY){
					
				newVal= MultiTrialCorrection.sortMultiSpecs(val,tagDictionary[binds[0]].@[attrib],multiSpecs,attrib);

				tagDictionary[binds[0]].@[attrib] = newVal;
				//trace((tagDictionary[binds[0]] as XML).toXMLString());
					/*}
				else{
				
					//note that have not yet decided how to encompass multistuff with below
					newVal=val.toString(); //sortMultiSpecs(val.toString(),(tagDictionary[binds[0]] as XML).toString(),multiSpecs);
					(tagDictionary[binds[0]] as XML).replace("*",  new XML("<![CDATA[" + newVal + "]]>") );
				}*/
				
				if(update)	updated(updateInfo);
				//trace(cleanScript(),222)
				return true;
			}
			else{
				if(depth==-1){
					
					var copyOverID:String = tagDictionary[binds[0]].@[ProcessScript.COPYOVER_ID];
					for(var i:int=0;i<binds.length;i++){	
						if(searchTemplates(copyOverID, attrib, binds[i], val,multiSpecs)==true) {
							
							if(update)	updated(updateInfo);
							return true;
						}
					}
				}
				else if(searchTemplates(copyOverID, attrib, binds[depth], val,multiSpecs)==true){
					if(update)	updated(updateInfo);
					return true;
				}
				
			}
			
			return false;
		}
		
		private static function searchTemplates(copyOverID:String, attrib:String, bindID:String, val:*,multiSpecs:Object=null):Boolean
		{
			var bind:XML = tagDictionary[bindID];
			var newVal:String;
			for each(var xml:XML in bind..*.(hasOwnProperty('@'+ProcessScript.COPYOVER_ID) && attribute(ProcessScript.COPYOVER_ID)==copyOverID)){
				if(xml.hasOwnProperty("@"+attrib)){
					newVal = MultiTrialCorrection.sortMultiSpecs(val.toString(),xml.@[attrib].toString(),multiSpecs);
					xml.@[attrib]=val.toString();
					return true;
				}
			}
			return false;
		}
		
		public static function addStimulus(parentID:String, xml:XML, doUpdate:Boolean=true):void{
			var parent:XML = tagDictionary[parentID];
			
			var bind_id:String = TRIAL+"_"+counter.toString();
			xml.@[bindLabel] = bind_id;
			counter++;
			
			tagDictionary[bind_id] = xml;
			
			parent.prependChild(xml);

			if(doUpdate) {
				updated(['BindScript.addStimulus']);
			}
		}
		

		
		public static function addTrial(xml:XML):String{
			return linkup(xml,"TRIAL");
		}
		
		public static function updated(updatedFrom:Array):void
		{
			if(callBackF)	callBackF(updatedFrom);
		}
		
		public static function deleteX(bind_id:String,doUpdate:Boolean=true):void{
			if(tagDictionary.hasOwnProperty(bind_id)){
				var pos:int = (tagDictionary[bind_id] as XML).childIndex();
				delete((tagDictionary[bind_id] as XML).parent().children()[pos])
				tagDictionary[bind_id]=null;
				if(doUpdate)	updated(['BindScript.deleteTrial']);
			}
			else{
				trace("devel error: cannot locate a bind:",bind_id);
			}
		}
		
		public static function deleteXs(arr:Array):void{
			for(var i:int=0;i<arr.length;i++){
				deleteX(arr[i],false);
			}
			updated(['BindScript.deleteTrials']);
		}
		
		private static function getParentType(id:String):String{
			var arr:Array = id.split("_");
			if(arr.length==1)return SETUP;
			if(arr[0]=="TRIAL")return TRIAL;
			return TEMPLATE;
		}

		private static function linkup(xml:XML,parent:String=''):String {

			xml.@[bindLabel] = [parent+"_"+counter];
			
			var isBody:Boolean = xml.name() == null;
			
			if(isBody == false && [SETUP,TRIAL].indexOf(xml.name().toString())==-1 &&  parent==scriptName){
				xml.@[templateBindLabel] = [parent+"_"+counter]; 
			}
				
			if(isBody){
				tagDictionary[parent+"_"+xmlBODY] = xml;
			}
			else{
				tagDictionary[parent+"_"+counter.toString()] = xml;
				counter++;
	
				for each (var item:XML in xml.children()) {
					linkup(item, xml.name());
				}
			}
			return xml.@[bindLabel];
		}
		
/*		public static function stimChanged(changed:Object):void
		{
			for(var prop:String in changed){
				
			}
			
		}*/
		
		public static function getOrigVal(bind_id:String, what:String):String
		{
			var xml:XML = tagDictionary[bind_id];
			
			if(xml.hasOwnProperty(what))			return xml[what].toString();
			else if (xml.hasOwnProperty("@"+what))	return xml["@"+what].toString();
			return '';
		}
		
		public static function cleanScript():String
		{
			//trace("****************"+script.toString().replace(bind_regexp,""));
			return script.toString().replace(bind_regexp,"").replace(templateBind_regexp,"");
		}
		
		public static function getSelectedCode(selected:Array):String
		{
			var code:Array = [];
			var bind_id:String;
			
			for each(var stim:object_baseClass in selected){
				bind_id=stim.getVar(bindLabel);
				code.push(tagDictionary[bind_id].toXMLString())
			}
			
			return code.join("\n");
		}
		
		public static function getStimScript(bind_id:String):XML
		{
			if(tagDictionary.hasOwnProperty(bind_id))	return tagDictionary[bind_id];
			return null;
		}
		
		public static function depthOrderChanged(newOrder:Array):void{
			
			
			var parent:XML = tagDictionary[newOrder[0]].parent();
			//trace(888,newOrder)
			var xml:XML;
			var bind_id:String;
			
			var binds:Array=[];
			for(var i:int=0;i<parent.children().length();i++){
				xml = parent.children()[i];
				binds.push(xml.@[bindLabel].toString());
			}
			
			//below used to add elements that are not apart of the study eg aaJPG as opposed to addJPG
			var pos:int;
			for(i=0;i<binds.length;i++){
				pos=newOrder.indexOf(binds[i]);
				if(pos==-1){
					newOrder.splice(i,0,binds[i]);
				}
			}
			
			for(i=0;i<newOrder.length;i++){
				bind_id=newOrder[i];
				xml = tagDictionary[bind_id];
				parent.appendChild(xml);
			}
			//trace("depth order updated",parent.toXMLString());
			updated(['BindScript.depthOrderChanged']);
		}		
	}
}