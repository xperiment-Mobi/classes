package unitTests
{
	
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	import org.flexunit.Assert;


	public class test_exptWideSpecs
	{
	
		[Test]
		public function test1():void
		{
			var e:Array = new Array;
			e.computer = new Array;
			e.computer.num = 123.1
			e.urlParams = [];			
			e.urlParams.test=[1,2,3] as Array;
			e.defaults=[];
			e.defaults.restart=true;	
			e.defaults.restartNot=false;	
			e.screen=[];
			e.screen.align = "center";
			e.results = [];
			e.results.emptyStr = ''
			

			Assert.assertTrue(ExptWideSpecs.__retrieveParam('test',e).toString()==[1,2,3].toString())
			Assert.assertTrue(ExptWideSpecs.__retrieveParam('num',e)==123.1)
			Assert.assertTrue(ExptWideSpecs.__retrieveParam('align',e)=='center')
			Assert.assertTrue(ExptWideSpecs.__retrieveParam('restart',e)==true)
			Assert.assertTrue(ExptWideSpecs.__retrieveParam('restartNot',e)==false)
			Assert.assertTrue(ExptWideSpecs.__retrieveParam('emptyStr',e)=='')
			Assert.assertTrue(ExptWideSpecs.__retrieveParam('unknown',e)==null)	
				
			ExptWideSpecs.kill();
		}
		
		
		
		[Test]
		public function test2():void
		{
	
			
			try{
				ExptWideSpecs.__checkSaveGood();
				Assert.assertTrue(false);
			}
			catch(e:Error){
				Assert.assertTrue(true);
			}
			

			ExptWideSpecs.__init();
			ExptWideSpecs.__ExptWideSpecs.results.save = 'wrong'
				
			try{
				ExptWideSpecs.__checkSaveGood();
				Assert.assertTrue(false);
			}
			catch(e:Error){
				Assert.assertTrue(true);
			}
	
			ExptWideSpecs.__ExptWideSpecs.results.save = 'email';
				
			try{
				ExptWideSpecs.__checkSaveGood();
				Assert.assertTrue(false);
			}
			catch(e:Error){
				Assert.assertTrue(true);
			}	
			
			ExptWideSpecs.__ExptWideSpecs.email.toWhom="test";
			try{
				ExptWideSpecs.__checkSaveGood();
				Assert.assertTrue(true);
			}
			catch(e:Error){
				Assert.assertTrue(false);
			}
			
			ExptWideSpecs.kill();
		}
	}
}