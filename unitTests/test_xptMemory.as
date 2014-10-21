package unitTests
{
	import com.xperiment.DeviceQuery.DeviceQuery;
	
	import org.flexunit.asserts.assertTrue;
	
	public class test_xptMemory
	{
		
		
		

		[Test]
		public function test1() : void
		{
			DeviceQuery.init();
			
			assertTrue(	DeviceQuery.__memory		);
			
			var uuid:String = DeviceQuery.getUUID()
			assertTrue( uuid && uuid.length == 32 )
			
			DeviceQuery.init();
			var uuid2:String = DeviceQuery.getUUID();
				
			/*assertTrue(uuid == uuid2);
			
			XptMemory.wipeSessionUUID();
			assertTrue(XptMemory.__memory.EXISTS(uuid)==false);
			
			uuid2 = XptMemory.getUUID();
			assertTrue(uuid != uuid2);*/
		}
		
	
	}
}