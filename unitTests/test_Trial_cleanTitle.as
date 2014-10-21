package unitTests
{

	
	import org.flexunit.Assert;
	import com.xperiment.trial.Trial;
	
	public class test_Trial_cleanTitle
	{
		
		
		
		[Test]
		public function test1():void
		{
			
			var t:Trial = new Trial();
			
			Assert.assertTrue(t.__clean('123',"2","_")=="1_3");
			Assert.assertTrue(t.__clean('212232',"2","_")=="_1__3_");	


		}
	}
}