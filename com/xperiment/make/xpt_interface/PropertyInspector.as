package com.xperiment.make.xpt_interface
{
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.stimuli.object_baseClass;
	
	public class PropertyInspector
	{

		private static var getTrial:Function;
		private static var currentTrialXML:XML;
		private static var currentTrial_bindID:String;
		private static var toJS:Function;
		private static var runningTrial:TrialBuilder;
		private static var bindLabel:String;
		private static var ODD_PEG_DIVIDE:String = ' — ';
		
		public static function setup(g:Function,j:Function):void
		{
			getTrial=g;
			toJS = j;
			bindLabel = BindScript.bindLabel;
		}
		
		public static function newTrial(r:TrialBuilder):void
		{
			runningTrial=r;
			var b:String = (runningTrial as TrialBuilder).bind_id;

			currentTrialXML = getTrial(b);

			var rows:Array = [];
			var stim:XML;
			var stimObj:Object;
			var name:String;
			for(var i:int=0;i<currentTrialXML.children().length();i++){
				
				stim = currentTrialXML.children()[i];
				name = sortName(stim.name().toString());
				
				if(name!=""){
					stimObj = {};
					appendAttribs(rows,stim,name,stim.name().toString());	
				}
				
				
			}
			
			var combined:Object = {};
			combined.total=rows.length;
			combined.rows = rows;
			toJS('propertyInspector',combined);
			
		}
		
		private static function appendAttribs(rows:Array, stim:XML, group:String, detailedName:String):void
		{
			var key:String;
			var row:Object;
			var peg:String;
			var pegRow:Object;
			var bind_id:String = stim.@[BindScript.bindLabel];
			
			if(stim.hasOwnProperty('@peg')==false){
				peg = getPeg(stim.@[bindLabel].toString())
			}
			else{
				peg=stim.@peg.toString();
			}
			
			group = peg+ ODD_PEG_DIVIDE+group;
			
			for each(var a:XML in stim.@*) 
			{
				
				key = a.name().toString();
				if(key!=bindLabel){
					if(key!=peg) rows.push({group:group, name:key, value:a.toString(), detailedName:detailedName,bind_id:bind_id});
				}
			} 

			rows.unshift({group:group, name:'peg', value:peg, detailedName:detailedName, bind_id:bind_id});

			
			/*for (var i:int=0;i<rows.length;i++){
				for(key in rows[i]){
					trace(123,i,group,key,rows[i][key]);
				}
			}*/
		}
		
		private static function getPeg(bind_id:String):String
		{
			var pegs:Array = [];
			
			for(var i:int=0;i<runningTrial.OnScreenElements.length;i++){
				
				if((runningTrial.OnScreenElements[i] as object_baseClass).getVar(bindLabel) == bind_id){
					pegs.push((runningTrial.OnScreenElements[i] as object_baseClass).peg);
				}
			}
			return pegs.join("---");
		}
		
		private static function sortName(name:String):String{
			if(name.substr(0,3)!="add" &&  name.substr(0,5)!="behav")	return '';
			
			name = name.split("add").join("").split("behav").join("");
			return name.charAt(0).toLowerCase() + name.substr(1);
		}
		
		public static function propEdit(data:Object):void{
			var bind_id:String = data.bind_id;
			if(bind_id!=""){
				var prop:String = data.prop;
				var val:String = data.val;
				BindScript.updateAttrib(bind_id,prop,val,null,-1,['PropertyInspector']);
			}
		}
	}
}