package unitTests
{
	import com.xperiment.make.comms.Communicator;
	import com.xperiment.make.comms.services.MOCK_ExternalInterface;
	
	import flexunit.framework.Assert;

	public class test_Communicator
	{
		
		
		
		[Test]
		public function t1():void
		{
			

			var mock_ExternalInterface:MOCK_ExternalInterface = new MOCK_ExternalInterface
			Communicator.external_JS_Interface = mock_ExternalInterface;
			
			
			Communicator.pass("what","data");
			
			var backlog:Object=Communicator._backlog[0];

			Assert.assertTrue(Communicator._backlog.length==1 && backlog.what=='what' && backlog.data=='data');
		
			try{
				Communicator._runBacklog();
				Assert.assertTrue(false);
			}
			catch(e:Error){
				
			}
			
			Communicator._linked=true;
			
			Communicator._runBacklog();
			
			Assert.assertTrue(Communicator._backlog==null);
			Assert.assertTrue(mock_ExternalInterface.mockCallList.length==1);
			
			var obj:Object=mock_ExternalInterface.mockCallList[0];
			
		
			Communicator.pass("toJS_what","toJS_data");
			

			Assert.assertTrue(mock_ExternalInterface.mockCallList.length==2);
			Communicator._linked=false;
			//Communicator.kill();
		}
		
		[tTest]
		public function t2():void
		{
			
			var mock_ExternalInterface:MOCK_ExternalInterface = new MOCK_ExternalInterface
			Communicator.external_JS_Interface = mock_ExternalInterface;
			
			Communicator.setup();
			Assert.assertTrue(mock_ExternalInterface.mockCallBackList.length==1);
			
			Assert.assertTrue(Communicator._linked==false);
			mock_ExternalInterface.toAS3('linkedup','');
			
			Assert.assertTrue(Communicator._linked==true);
		}
	}
}