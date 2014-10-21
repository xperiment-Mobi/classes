package unitTests
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import org.flexunit.runner.Result;
	import org.flexunit.runner.notification.Failure;
	import org.flexunit.runner.notification.RunListener;
	
	public class FinishedListener extends RunListener
	{

		private var f:Function;

		
		public function passF(f:Function):void{
			this.f=f;
		}
		
		override public function testRunFinished(result:Result):void {
			if(result.successful){
				trace("tests successful :",result.successful)
				trace("duration	 :",result.runTime);
					
			}
			else{
				trace("test failures :",result.failureCount,"/",result.runCount);
			}
			
			super.testRunFinished(result);

			f();
					
		}
		
		override public function testFailure( failure:Failure ):void {
			trace("TEST FAILURE :");
			trace(failure.toString())
			trace("--------------");
			var mySound:Sound = new Sound();
			mySound.load(new URLRequest("assets/error.mp3"));
			mySound.addEventListener(Event.COMPLETE,function(e:Event):void{
				mySound.removeEventListener(Event.COMPLETE,arguments.callee);
				trace("finished")
				mySound.close();
				mySound = null;			
			});
			mySound.play();

			

		}
	}
}