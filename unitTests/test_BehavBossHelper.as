package unitTests
{

	import org.flexunit.Assert;
	import com.xperiment.behaviour.BehaviourBossHelper;
	
	
	
	public class test_BehavBossHelper
	{
	
		
		[Test( description="tests behaviourBossHelper" )]
		public function test3() : void
		{
						
			
			function test_behavToIf(action:String,toEqual:String, arrLength:int):Boolean{
			var test:Boolean = true;
			var res:Array=BehaviourBossHelper.fixBehavCommaIssue(action);
			test=test && res.toString()==toEqual;
			test = test && arrLength==res.length;
			return test;
			}
			
			
			Assert.assertTrue(test_behavToIf("onCli?B.start(),onClick?C.start()","onCli?B.start(),onClick?C.start()",2));
			Assert.assertTrue(test_behavToIf("onCli?B.start(),a=2,onClick?C.start()","onCli?B.start(),a=2,onClick?C.start()",2));		
			Assert.assertTrue(test_behavToIf("onCk?A.stop(),a=222","onCk?A.stop(),a=222",1)); 
		}
		
	
	

	}
}