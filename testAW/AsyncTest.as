package testAW
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AsyncTest
	{
		private var dur:Number;
		public var finished:Boolean = false;
		private var expected:*;
		private var t:Timer;
	
		public function AsyncTest(dur:Number){
			this.dur=dur;
			t = new Timer(dur);
			t.addEventListener(TimerEvent.TIMER_COMPLETE,tEvent);
		}

		private function tEvent(e:TimerEvent):void{
			result(null);
		}
		
		public function result(got:*):Boolean{
			if(!expected) throw new Error("you must specify your expected result before providing the result of the test!  That is, run start(expected:String)");
			t.removeEventListener(TimerEvent.TIMER_COMPLETE, tEvent)
			t.stop();
			finished= true;
			return got===expected;
		}
		public function start(expected:*):void{
			this.expected=expected;	
			t.start();
		}	
	}
}