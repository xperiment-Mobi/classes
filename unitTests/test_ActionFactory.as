package unitTests
{

	
	import com.xperiment.BehavLogicAction.Action.ActionFactory;
	
	import org.flexunit.Assert;

	public class test_ActionFactory
	{
		
		[Test]
		public function test1() : void
		{
			Assert.assertTrue(ActionFactory.__isCommand.test("rrr.rrr()"))
			Assert.assertTrue(ActionFactory.__isCommand.test("rrr.rrr(22)"))
			Assert.assertTrue(false==ActionFactory.__isCommand.test("rrr()"))
			Assert.assertTrue(false==ActionFactory.__isCommand.test("rrr(2)"))
			Assert.assertTrue(false==ActionFactory.__isCommand.test("C=2+sqrt(9)"))
		}
		
		[Test]
		public function test2() : void
		{
			var action:String;
			var bracketContents:Array;
			
			action=''
			bracketContents = ActionFactory.__encasingBrackets.exec(action);
			Assert.assertTrue(bracketContents==null);
			
			action='123344'
			bracketContents = ActionFactory.__encasingBrackets.exec(action);
			Assert.assertTrue(bracketContents==null);
			
			action='123344()'
			bracketContents = ActionFactory.__encasingBrackets.exec(action);
			Assert.assertTrue(bracketContents.length==1);
			
			action='123344(111)'
			bracketContents = ActionFactory.__encasingBrackets.exec(action);
			Assert.assertTrue(bracketContents.length==1 && bracketContents[0]=='(111)');
			
		}
	}
}