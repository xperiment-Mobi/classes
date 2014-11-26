package unitTests
{

	import com.xperiment.stimuli.object_baseClass;
	
	import org.flexunit.Assert;

	
	
	
	public class test_ObjectBaseClass
	{
	

		[Test]
		public function test1() : void
		{
			
			var bc:object_baseClass = new object_baseClass;
			var f:Function = bc.__correction;
			
			bc.duplicateTrialNumber = 1;
			Assert.assertTrue(f("a;b;c")=="b");
			bc.duplicateTrialNumber = 2;
			Assert.assertTrue(f("a;b;c")=="c");
			
			bc.iteration=0;
			Assert.assertTrue(f("a---a1;b---b1;c---c1")=="c");
			bc.iteration=1;
			Assert.assertTrue(f("a---a1;b---b1;c---c1")=="c1");
			
			bc.duplicateTrialNumber = 0;
			Assert.assertTrue(f("a---a1;b---b1;c---c1")=="a1");
			bc.iteration=0;
			Assert.assertTrue(f("a---a1;b---b1;c---c1")=="a");
			bc.duplicateTrialNumber = 1;
			Assert.assertTrue(f("a---a1;b---b1;c---c1")=="b");
			bc.iteration=1;
			Assert.assertTrue(f("a---a1;b---b1;c---c1")=="b1");
		}
			
				
		
	
	

	}
}