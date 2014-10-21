package com.xperiment.P2P
{
	public class P2P_grandResults
	{
		private var grandResults:Object;
		public var ping:Function;
		
		public function P2P_grandResults()
		{
			grandResults = {};
		}
		
		public function giveData(sj:String, result:XML):void{
			
			grandResults[sj] ||= XML(<Experiment/>);
			
			(grandResults[sj] as XML).appendChild(result);
			
			if(ping) ping(sj, result);
			//trace("was given data", sj, result.length(),result.toXMLString());

			
		}
	}
}