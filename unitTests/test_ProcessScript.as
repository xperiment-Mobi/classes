package unitTests
{

	
	import com.xperiment.script.ProcessScriptHelpers.SortoutPREVandNEXT;
	
	import flexunit.framework.Assert;
	
	
	public class test_ProcessScript
	{
		
		[Test]
		public function test1():void{
			
			
			Assert.assertTrue(	SortoutPREVandNEXT.__computeSiblingIndex(1,0)==0 );
			//Assert.assertTrue(	SortoutPREVandNEXT.__computeSiblingIndex(1,1)==1 );
			//Assert.assertTrue(	SortoutPREVandNEXT.__computeSiblingIndex(2,1)==1 );
			//Assert.assertTrue(	SortoutPREVandNEXT.__computeSiblingIndex(3,2)==2 );
			//Assert.assertTrue(	SortoutPREVandNEXT.__computeSiblingIndex(2,-1)==1 );

		}
		
		[Test]
		public function test2():void{
			
			var script:XML=	<expt>
								<a a='0'/>
								<b a='PREV+1'/>
							</expt>
						
			
			SortoutPREVandNEXT.now(script);


			Assert.assertTrue(	1==1	);
		}
	
		
	}
}