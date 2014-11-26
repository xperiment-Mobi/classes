package testAW
{
	import flash.events.Event;
	
	public class TestEvent extends Event
	{
		public var message:String="";
		public function TestEvent(type:String, message:String)
		{
			this.message=message;
			super(type, bubbles, cancelable);
		}
	}
}