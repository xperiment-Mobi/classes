package com.xperiment.script
{
	public class CollateSJsPerCond
	{
		private const BS_ID:String = 'betweenSJ';
		
		
		public static function give(cond_sj:String, conds:Array):Array
		{			
			var SJsArr:Array = new Array(conds.length);
			//if no conditionOdds specified, assumed wants all conditions to be randomly chosen from

			var grandSplit:Array=[];
			var split:Array=cond_sj.split(',');
			var subsplit:Array;
			var str:String;
			var sj_count:int;
			for each(str in split){
				subsplit = str.split('=');
				if(subsplit.length!=2){
					ERR();
				}
				if(isNaN(Number(subsplit[1]))){
					ERR(' (you have not used numbers to specifiy your probabilities)');
				}
				sj_count=conds.indexOf(subsplit[0] as String);
				
				if(sj_count!=-1){
					SJsArr[sj_count]=Number(subsplit[1]);
				}
				else{
					ERR(' (the condition names where you define probabilities do not match your actual condition names');
				}
			}
			
			for(var i:int=0;i<SJsArr.length;i++){
				if(SJsArr[i]==undefined){
					SJsArr[i]=0;
				}
			}
			return SJsArr;
		}		
		
		private static function ERR(extra:String=''):void{
			throw new Error('your condition randomisation is wrong.  Should be e.g. a=.1,b=.3,c=.3)'+extra);
		}
	
	}
}