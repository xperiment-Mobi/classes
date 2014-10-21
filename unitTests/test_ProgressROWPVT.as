package unitTests
{
	import com.xperiment.runner.ComputeNextTrial.Progress.Progress_ROWPVT;
	import com.xperiment.runner.ComputeNextTrial.Progress.Progress_Staircase;
	import org.flexunit.asserts.assertTrue;

	
	
	public class test_ProgressROWPVT
	{
		
		private function init():Progress_ROWPVT
		{
			var p:Progress_ROWPVT = new Progress_ROWPVT(null);
			p.initDefaults();
			p._positionOfLastTrial=189;
			p._positionOfFirstTrial=0;
			return p;
		}
		
		[Test]
		public function test1():void
		{		
			var p:Progress_ROWPVT = init();
			var f:Function = p.__findNextNotYetRunTrial;
			
			p._trialsHaveRun[0]=true;
			p._trialsHaveRun[10]=true;
			p._trialsHaveRun[189]=true;
			
			assertTrue(f(0,Progress_Staircase.UP)==1);
			assertTrue(f(1,Progress_Staircase.UP)==2);
			assertTrue(f(188,Progress_Staircase.UP)==190);
			
			assertTrue(f(0,Progress_Staircase.DOWN)==190);
			assertTrue(f(-100,Progress_Staircase.DOWN)==190);
			
			assertTrue(f(2,Progress_Staircase.DOWN)==1);
			assertTrue(f(11,Progress_Staircase.DOWN)==9);			
		}
		

		
		[Test]
		public function test2():void
		{	
			var p:Progress_ROWPVT = init();
			var f:Function = p.__correctCounter;
			
			f(true);
			assertTrue(p._correctLog.length==1 && p._correctLog[0]==true);
			
			f(true);
			assertTrue(p._correctLog.length==2 && p._correctLog[1]==true);
			
			p._correctLog= new <Boolean>[true,true,true,true,true,true,true,true];
			f(true);
			assertTrue(p._correctLog.length==8);
			
			f(false);
			f(false);
			f(true);
			
			assertTrue(p._correctLog[0]==true && p._correctLog[1]==false && p._correctLog[2]==false);
		}
		
		[Test]
		public function test3():void{
						
			function check(start_ord:int, ans:Array, correct:Array):Boolean{
				var p:Progress_ROWPVT = init();
				var f:Function = p.__calcNextTrial;
				
				var nextTrial:int = start_ord;
				for(var i:int=0;i<correct.length;i++){
					nextTrial=	f(ans[i],nextTrial);
					if(nextTrial!=correct[i])return false;
				}
				return true;
			}
			
			assertTrue(		check(0,[true],[1])		);
			assertTrue(		check(0,[false],[190])		);
			assertTrue(		check(1,[false],[0])		);
			
			assertTrue(		check(10,[false,true,true,true],[9,8,7,6])		);
			assertTrue(		check(10,[false,true,true,true,true,true,true,true,true],[9,8,7,6,5,4,3,2,11])		);
			
			assertTrue(		check(40,[false,true,true,true,true,true,true,true,false,true,true,true,true,true,true,true,true],[39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,41])		);
			
			assertTrue(		check(40,[true,true,true,true,true,true,true,true],[41,42,43,44,45,46,47,48])		);
		}

	
	}
}