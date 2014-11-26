package unitTests
{	
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.XMLstuff.saveResults;
	
	import flexunit.framework.Assert;
	

	public class test_SaveResults
	{
		
		[Test]
		public function test1():void{
			
			ExptWideSpecs.__init();
			var s:saveResults = new saveResults(null);
			var saves:Array = s.__queryHowSave();
			Assert.assertTrue(saves.length==1 && saves[0]=='webfile')
			
		}	
	}
}