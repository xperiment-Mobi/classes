package com.xperiment.script.ProcessScriptHelpers
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.helpers.StimModify;

	public class SpecialVariableActions
	{

		public static function process(script:XML):XML
		{
			var variables:XMLList = script..SETUP[0].variables;
			var variable:String;
			var value:String;
			
			StimModify.process(variables);
			
			for each(var variableXML:XML in variables.attributes()){
				variable= variableXML.name();
				value	= variableXML.toString();
				variables.@[variable] = compute(value);
		}

			return script;
	}
		
		private static function compute(value:String):String
		{
			var newVal:String;
			
			newVal = rand(value);
			if(newVal!=value)return newVal;
			
			
			
			return value;
		}
		

		
		private static function rand(value:String):String
		{
			var obj:Object = RegExp(/rand\(.+\:.+\)/).exec(value);
			
			if(!obj)return value;
			else{
			
				value=value.substr("rand(".length);
				value=value.substr(0,value.length-1);
				var arr:Array=value.split(":");
				var val:Number = (Math.random()+Number(arr[0]))*Number(arr[1]);
				if(arr.length==3){
					val=codeRecycleFunctions.roundToPrecision(val,arr[2]);
				}
				return String(val);
			}
			
			return value;
		}
		
	}
}