package unitTests
{
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	import org.flexunit.Assert;
	
	public class test_cloudLocationUpdater
	{
		
		
		
		[Test]
		public function test1():void
		{

			var p:Object = {}
			ExptWideSpecs.__init();
			
			ExptWideSpecs.__ExptWideSpecs.computer = {}
			
			ExptWideSpecs.__ExptWideSpecs.computer.stimuliFolder = 'bbb'
			p.studyUrl='abc'
			
			try{
				ExptWideSpecs.__updateStimuliFolderWithCloudUrl(p)
				Assert.assertTrue(false);
			}
			catch(e:Error){
				Assert.assertTrue(true)
			}
			
			p.studyUrl='abc/'
			ExptWideSpecs.__updateStimuliFolderWithCloudUrl(p)
			Assert.assertTrue(ExptWideSpecs.__ExptWideSpecs.computer.stimuliFolder == 'abc/bbb')
			
			ExptWideSpecs.__ExptWideSpecs.computer.stimuliFolder = '/bbb'
			ExptWideSpecs.__updateStimuliFolderWithCloudUrl(p)
			Assert.assertTrue(ExptWideSpecs.__ExptWideSpecs.computer.stimuliFolder == 'abc/bbb')
			
			ExptWideSpecs.kill();
			
		}
		
		
		
		
	}
}