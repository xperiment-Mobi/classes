package unitTests
{
	import com.xperiment.behaviour.abstractBehaviourBoss;
	
	import org.flexunit.Assert;

	
	public class test_behavBoss
	{
		[Test( description="tests LogicExpression function in Logic" )]
		public function test1() : void
		{
			var a:abstractBehaviourBoss= new abstractBehaviourBoss;
			
			var behavToIf:Function = a.testFunct("behavToIf");
			
			Assert.assertTrue(behavToIf("banana","onCk:A.stop()"),"banana.onCk?A.stop()")
			Assert.assertTrue(behavToIf("banana","onClick:B.togglevisible()"),"banana.onClick?B.togglevisible()")
			Assert.assertTrue(behavToIf("banana","onClick:E.text=E.text+'t'"),"banana.onClick?E.text=E.text+'t'")
			Assert.assertTrue(behavToIf("banana","onCli:B.start()"),"banana.onCli?B.start()")
			Assert.assertTrue(behavToIf("banana","onCli:E1.hide()"),"banana.onCli?E1.hide()")
			Assert.assertTrue(behavToIf("banana","onCli&&e==24:pear.run()"),"banana.onCli&&e==24?pear.run()")
		}
		
		

	}
}