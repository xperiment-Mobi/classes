package unitTests
{

	
	import org.flexunit.Assert;
	import com.xperiment.trial.AbstractTrial;
	
	
	public class test_integrationOfLogicActions
	{
		[Test( description="test1" )]
		public function test1() : void
		{
			

			var testSortoutTiming:Function = function(input:Object, outputShould:Object, result:Boolean=true,err:String=""):Boolean{
				var t:AbstractTrial = new AbstractTrial;
				var caught:Boolean=true
				if(err!="")caught=false;
				try{
					var outputIs:Object = t.sortoutTiming(input.startStr, input.endStr, input.duration, input.peg);
				}
				catch (e:Error){
					//trace(e.message);
					if(e.message==err)return true;
					else return false;	
				}
				
				//trace("start:",outputIs.start, "		correct?:", outputIs.start === outputShould.start)  //should be number
				//trace("end:",outputIs.end,  "		correct?:", outputIs.end === outputShould.end) //should be number
				
				t.kill();
				
				if(caught==false)return false;
				return result == (outputIs.start === outputShould.start && outputIs.end === outputShould.end && outputIs.startNoLogic === outputShould.startNoLogic) ;
			}
		
			//input: startStr:String, endStr:String,duration:String,peg:String
			//output: start, end, startNoLogic
			
			Assert.assertTrue(testSortoutTiming({startStr:"1000",endStr:"2000",duration:"",peg:"banana"},{start:1000,end:2000}));			
			Assert.assertTrue(testSortoutTiming({startStr:"3000",endStr:"2000",duration:"",peg:"banana"},{start:3000,end:2000},false,"Timimg Error: 'banana' ends before it begins: start=3000 end=2000"));
			Assert.assertTrue(testSortoutTiming({startStr:"3000",endStr:"-3000",duration:"",peg:"banana"},{start:-3000,end:-4000},false,"Timimg Error: 'banana' starts/ends before time 0: starts at 3000, ends at -3000."));
			Assert.assertTrue(testSortoutTiming({startStr:"-3000",endStr:"3000",duration:"",peg:"banana"},{start:-3000,end:-4000},false,"Timimg Error: 'banana' starts/ends before time 0: starts at -3000, ends at 3000."));
			Assert.assertTrue(testSortoutTiming({startStr:"",endStr:"",duration:"",peg:""},{start:0,end:uint(0-1)})); //note that with no peg and no start time, assumes start time must be 0
			Assert.assertTrue(testSortoutTiming({startStr:"",endStr:"2000",duration:"",peg:"banana"},{start:-1,end:2000}));
			Assert.assertTrue(testSortoutTiming({startStr:"",endStr:"",duration:"",peg:"banana"},{start:-1,end:uint(0-1)}));
			Assert.assertTrue(testSortoutTiming({startStr:"",endStr:"1000",duration:"",peg:"banana"},{start:-1,end:1000}));
			Assert.assertTrue(testSortoutTiming({startStr:"abc",endStr:"1000",duration:"",peg:"banana"},{start:-1,end:1000},false, "Timimg Error: cannot process the start time of 'banana': start abc end 1000."));	
			Assert.assertTrue(testSortoutTiming({startStr:"1000",endStr:"",duration:"2000",peg:"banana"},{start:1000,end:3000}));
			Assert.assertTrue(testSortoutTiming({startStr:"1000",endStr:"",duration:"a",peg:"banana"},{start:1000,end:3000},false,"Timimg Error: cannot process duration of 'banana': a."));
		
		}
		
		[Test( description="test2" )]
		public function test2() : void
		{
			var testSortOutTimingWithBeforeAfter:Function = function():Boolean{
				var result:Boolean=true;
				
				var t:AbstractTrial = new AbstractTrial;
				
				var input:Object = {startStr:"1000",endStr:"2000",duration:"",peg:"banana"};
				t.sortoutTiming(input.startStr, input.endStr, input.duration, input.peg);
				
				input		     = {startStr:"withPrev",endStr:"withPrev",duration:"",peg:"banana"};
				var outputIs:Object=t.sortoutTiming(input.startStr, input.endStr, input.duration, input.peg);
				var outputShould:Object = {start:1000, end:1000};
				
				//trace("start:",outputIs.start, "		correct?:", outputIs.start === outputShould.start)  //should be number
				//trace("end:",outputIs.end,  "		correct?:", outputIs.end === outputShould.end) //should be number
				
				result=result && outputIs.start === outputShould.start && outputIs.end === outputShould.end;
				
				input		     = {startStr:"afterPrev-1",endStr:"afterPrev+1",duration:"",peg:"banana"};
				outputIs=t.sortoutTiming(input.startStr, input.endStr, input.duration, input.peg);
				outputShould = {start:1999, end:2001};
				
				//trace("start:",outputIs.start, "		correct?:", outputIs.start === outputShould.start)  //should be number
				//trace("end:",outputIs.end,  "		correct?:", outputIs.end === outputShould.end) //should be number
				
				var caught:Boolean=true;
				try{
					input		    = {startStr:"withPrevw",endStr:"withPrev",duration:"",peg:"banana"};
					outputIs		=t.sortoutTiming(input.startStr, input.endStr, input.duration, input.peg);
				}
				catch(e:Error){if(e.message=="Timimg Error: non number given in timeShift: w")caught=false;}
				
				if(caught)return false;
				try{
					input		    = {startStr:"withPrev+a",endStr:"withPrev",duration:"",peg:"banana"};
					outputIs		=t.sortoutTiming(input.startStr, input.endStr, input.duration, input.peg);
				}
				catch(e:Error){if(e.message=="Timimg Error: illegal maths operator in timeShift (allowed + - / * ): +a")caught=false;}
				if(caught)return false;
				
				result=result && outputIs.start === outputShould.start && outputIs.end === outputShould.end;
				
				t.kill();
				return result;
			}
				
			Assert.assertTrue(testSortOutTimingWithBeforeAfter());
		}

	}
}