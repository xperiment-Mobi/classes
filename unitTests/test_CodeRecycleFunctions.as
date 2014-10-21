package unitTests
{
	import com.xperiment.codeRecycleFunctions;
	
	import org.flexunit.Assert;

	public class test_CodeRecycleFunctions
	{
		
		
		
		
		[Test]
		public function test1():void
		{
			var str:String = ''
			Assert.assertTrue(codeRecycleFunctions.giveUpperLevelSplit(str,';')[0].length == 0 );
			
			str="'";
			try{
				codeRecycleFunctions.giveUpperLevelSplit(str,';');
				Assert.assertTrue(false);
			}
			catch(e:Error){
				Assert.assertTrue(true);
				//throws error if uneven number of quotation marks
			}
			
			str="a;a';;;'a;a";
			Assert.assertTrue(codeRecycleFunctions.giveUpperLevelSplit(str,';').toString() == "a,a';;;'a,a");
			
			
			str="doNow:trialNum=trialNum+1;doBefore:this.text=trialNum+'/52 trials completed'";
	
			Assert.assertTrue(codeRecycleFunctions.giveUpperLevelSplit(str,';').toString() == "doNow:trialNum=trialNum+1,doBefore:this.text=trialNum+'/52 trials completed'");	
				
		}
		
		
		[Test] //crude, but should detect if the function has been mucked up
		public function test2():void
		{
			var results:Object={};
			var resStr:String;
	
			for(var i:int=0;i<10000;i++){
				resStr=codeRecycleFunctions.arrayShuffle(['a','b','c']).join();
				results[resStr] ||=0;
				results[resStr] ++;
			}
			
			var arr:Array = [];
			var av:Number=0;
			var max:int=0;
			var min:int=10000;
			
			for(resStr in results){
				arr.push(results[resStr]);
				av+=results[resStr];
				
				if(results[resStr]>max)max=results[resStr];
				if(results[resStr]<min)min=results[resStr];
			}
			
			av/=Number(arr.length);
			Assert.assertTrue(200> max-av && 200 > av-min && 1666 == int(av));
				
				
			
			var id1:String=codeRecycleFunctions.arrayShuffle(['a','b','c','d','e','f','g'],'id1').join();
			var id2:String=codeRecycleFunctions.arrayShuffle(['a','b','c','d','e','f','g'],'id2').join();
			
			Assert.assertTrue(id1==codeRecycleFunctions.arrayShuffle(['a','b','c','d','e','f','g'],'id1').join());
			Assert.assertTrue(id2==codeRecycleFunctions.arrayShuffle(['a','b','c','d','e','f','g'],'id2').join());
			
			codeRecycleFunctions.kill();
			//below are very unlikely to ever be true anyway
			Assert.assertTrue(id1!=id2); 
			Assert.assertTrue(id1!=codeRecycleFunctions.arrayShuffle(['a','b','c','d','e','f','g'],'id1').join());
			Assert.assertTrue(id2!=codeRecycleFunctions.arrayShuffle(['a','b','c','d','e','f','g'],'id2').join());
			
		}
	}
}