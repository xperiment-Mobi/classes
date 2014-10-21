package com.xperiment.LogicIf.components
{
	import com.xperiment.Logic.Logic;
	import com.xperiment.LogicIf.VariableDictionaries;

	public class LogicAction
	{

		private var _logicStr:String;
		private var _actionStr:String;
		private var _logic:Logic;
		
		public function get logic():Logic
		{
			return _logic;
		}

		public function set logic(value:Logic):void
		{
			_logic = value;
		}

		public function get logicStr():String
		{
			return _logicStr;
		}

		public function set logicStr(value:String):void
		{
			_logicStr = value;
		}

		static public function build(logicActionStr:String):LogicAction
		{
			var logicActionArr:Array = logicActionStr.split(":");
			
			if(logicActionArr.length==2){
				var LogicAction:LogicAction = new LogicAction;
				LogicAction.logicStr = logicActionArr[0];
				LogicAction.actionStr = logicActionArr[1];
				return LogicAction;
			}
				
			else {
				throw new Error("Incorrectly formatted if statement:" + logicActionStr);
				return null;
			}
		}
		
		public function get actionStr():String
		{
			return _actionStr;
		}

		public function set actionStr(value:String):void
		{
			_actionStr = value;
		}

		public function passDictionary(logDict:VariableDictionaries):void{
			_logic=new Logic(_logicStr,logDict);
		}

	}
}