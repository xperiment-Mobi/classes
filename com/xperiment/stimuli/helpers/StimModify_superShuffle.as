package com.xperiment.stimuli.helpers
{
	import com.xperiment.codeRecycleFunctions;

	public class StimModify_superShuffle
	{
		public function StimModify_superShuffle()
		{
		}
		
		public static function DO(str:String, list:XMLList):void
		{

			test_doShuffle();

			var information:Object = codeRecycleFunctions.strToObj(str);
			
			var needed:Array = ["what","shuffleOver"];
			for each(var neededStr:String in needed){
				if(information.hasOwnProperty(neededStr)==false)throw new Error("you asked to SUPER_SHUFFLE_SOMETHING, but you have not specified "+neededStr+".");
			}
			
			
			var what:String=information.what;
			
			var split:String = information.shuffleOver;
			
			
			if(split==";"){
				list.@[what]=doShuffle(	list.@[what].toString(), information    ).join(split);	
			}
			else{
				var elements:Array = list.@[what].toString().split(";");
				
				
				
				for(var i:int=0;i<elements.length;i++){
					elements[i] = doShuffle(	elements[i], information	    ).join(split);
				}
				
				list.@[what] = elements.join(";");
				var a:String = list.@[what].toXMLString();
				//trace(111,a,a.indexOf("2_Corona_actual"))
			}
			

			
		}
		
		private static function test_doShuffle():void
		{
			var result:Array;
			
			for(var i:int=0;i<100;i++){
				result = doShuffle("1,2,3,4,5",{onlyOne:["1","2"],shuffleOver:","});
				if(result.indexOf('1')!=-1 && result.indexOf('2')!=-1)throw new Error("failed test");
			}
			
			for(i=0;i<100;i++){
				result = doShuffle("1,2,3,4,5",{mustHave:["1","2"],shuffleOver:","});
				if(result.indexOf('1')==-1 || result.indexOf('2')==-1)throw new Error("failed test");
			}
			
			
			for(i=0;i<100;i++){
				result = doShuffle("1,2,3,4,5",{mustNotHave:["1","2"],shuffleOver:","});
				if(result.indexOf('1')!=-1 || result.indexOf('2')!=-1)throw new Error("failed test");
			}

			for(i=0;i<100;i++){
				result = doShuffle("1,2,3,4,5",{mustHave:["1","2"],mustNotHave:["5"],onlyOne:["3","4"],shuffleOver:","});
				if(result.indexOf('3')!=-1 && result.indexOf('4')!=-1)throw new Error("failed test");
				if(result.indexOf('1')==-1 || result.indexOf('2')==-1)throw new Error("failed test");
				if(result.indexOf('5')!=-1)throw new Error("failed test");
			}
			
			
			var str:String = "10_SanLorenzo---11_Pintuco---12_Sika---13_Stertto---1_Corona_nuevo---2_Corona_actual---3_Alfa---4_Boccherini---5_Ceramica-Italia---6_easy---7_euroCeramica---8_Homecenter---9_Gricol";
			
			for(i=0;i<20;i++){
				result = doShuffle(str,{mustHave:"2_Corona_actual",shuffleOver:"---"});
				if(result.indexOf("2_Corona_actual")==-1)throw new Error();
			}
			
			for(i=0;i<20;i++){
				result = doShuffle(str,{mustHave:"2_Corona_actual",shuffleOver:"---",howMany:3});
				if(result.indexOf("2_Corona_actual")==-1)throw new Error();
			}
			
			for(i=0;i<20;i++){
				result = doShuffle(str,{mustHave:"2_Corona_actual",mustNotHave:"[1_Corona_nuevo]", shuffleOver:"---",howMany:9});
				if(result.indexOf("2_Corona_actual")==-1 || result.indexOf("1_Corona_nuevo")==1)throw new Error();				
			}
			
			for(i=0;i<20;i++){
				result = doShuffle(str,{mustHave:"2_Corona_actual",mustNotHave:"1_Corona_nuevo", shuffleOver:"---",howMany:9});
				if(result.indexOf("2_Corona_actual")==-1 || result.indexOf("1_Corona_nuevo")==1)throw new Error();		
			}
			
		}
		
		public static function doShuffle(listStr:String, information:Object):Array{
			var split:String = information.shuffleOver;
			var a:Array = listStr.split(split);
			if(information.hasOwnProperty("onlyOne")){
				var oneArr:Array = arrayerise(	information.onlyOne.concat()	);
				var one:String = codeRecycleFunctions.arrayShuffle(oneArr)[0];
				var index:int = a.indexOf(one);
				if(index!=-1){
					a.splice(index,1);
				}
			}
			
			if(information.hasOwnProperty("mustNotHave")){
				
				var mustNotHave:Array = arrayerise( information.mustNotHave );
				
				for each(var mustNot:String in mustNotHave){
					index = a.indexOf(mustNot);
					if(index!=-1){
						a.splice(index,1);
					}
				}
			}
			
			if(information.hasOwnProperty("mustHave")){
				var mustHave:Array = arrayerise( information.mustHave );
				
				
				
				var count:int;
				for each(var must:String in mustHave){
					count = a.indexOf(must);
					if(count==-1) throw new Error("you asked to SUPER_SHUFFLE_SOMETHING, you have specified a mustHave ('"+mustHave+"') but this mustHave is NOT in the list to super_shuffle!");
					a.splice(count,1);
				}
				codeRecycleFunctions.arrayShuffle(a); //else get same params each time
				for each(must in mustHave){
					a.unshift(must);
				}	
				
				if(information.hasOwnProperty('howMany')){
					var howMany:int = information.howMany;
					if(mustHave.length>howMany) throw new Error("you asked to SUPER_SHUFFLE_SOMETHING, you have specified more mustHaves ('"+mustHave+"') than the total number of objects you specifed via howMany ("+howMany+")!");
					codeRecycleFunctions.get_first_x_from_arr(a,howMany);
				}
				
			}
			
			

			return codeRecycleFunctions.arrayShuffle(a);
			
		}
		
		public static function arrayerise(what:*): Array{
			if(what is Array) return what;
			if(what.charAt(0)=="[") what = what.substr(1,what.length-2);
			return what.split(",");
		}
	}
}