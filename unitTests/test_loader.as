package unitTests
{
	import com.xperiment.preloader.PreloadStimuli;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	
	
	
	public class test_loader
	{
	
		
		/*[Test(  aycnc, description="tests loader" )]
		public function test1() : void
		{
			var mockScript:XML = new XML(
			<test>
				<a filename='2.flv'/>
				<b><c filename='1.jpg'><d filename='3.mp3'/></c></b>
			</test>
			);
				
			var loader:preloadFilesFromWeb = new preloadFilesFromWeb(mockScript,'test_Assets');
			

			Async.handleEvent(this,loader.queue,
		}*/
		
		[Test(  description="tests loader" )]
		public function test1() : void
		{
			var mockScript:XML = new XML(
				<test>
					<a filename='2.flv'/>
					<b><c filename='1.jpg;fake.png'><d filename='3.mp3'/></c></b>
				</test>
				);
			
			var loader:PreloadStimuli = new PreloadStimuli(mockScript,'test_Assets');
		
			trace(1234567,loader.files.length)
			//Assert.assertTrue(loader.files.length=3);
			
		}
			
				
		
	
	

	}
}