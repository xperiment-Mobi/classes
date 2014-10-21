package testAW
{
	import flash.display.Sprite;
	
	public class AsyncTests extends Sprite
	{
		private var tests:Vector.<AsyncTest> = new Vector.<AsyncTest>;
		
		public function AsyncTests()
		{
		}
		
		public function test(dur:Number):AsyncTest{
			var asyncT:AsyncTest=new AsyncTest(dur);
			tests.push(asyncT);
			return asyncT;
		}

		private function dispatchBroken(message:String):void{
			this.dispatchEvent(new TestEvent("Broken",message));

		}
		
		private function allFinished():Boolean{
			for(var i:int=0;i<tests.length;i++){
				if(tests[i].finished==false) return false;
			}
			this.dispatchEvent(new TestEvent("True","all "+String(tests.length-1)+ " test(s) passed"));	
			return true;
			
		}
		
		public function kill():void{
			for each(var obj:Object in tests){
				obj = null;
			}
			tests = null;
		}
	}
}