package unitTests
{
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.trialDecorators.Timeline.Timeline;
	
	import org.flexunit.Assert;

	public class test_timeline
	{

		
		
		
		[Test]
		public function test1() : void 
		{		

			var pegs:Array = ['a','b','c','d'];
			var unitTestStim:Array = generateStim(pegs);

			var newOrder:Array = ['b','a','c','d'];
			var result:Array = processResults(  Timeline.depthChange(newOrder,unitTestStim)  );

			Assert.assertTrue(compareArrs(newOrder,result));

			
		}
		
		
		
		/*
		[Test]
		public function test2() : void 
		{
			var pegs:Array = ['a','b','c','d'];
			var newOrds:Array = [7,8,9,10];
			var unitTestStim:Array = generateStim(pegs,newOrds);
			unitTestStim[0].bind="myBind";
			
			Timeline.__propChanged = function(bind:String,prop:String,val:String, fake:Object):void{
				Assert.assertTrue(unitTestStim[0].bind==bind);
				Assert.assertTrue("depth"==prop);
				Assert.assertTrue(val==newOrds.join("---"));
			}

			var r:Object = Timeline.__processMultiStim(unitTestStim);
			
			Assert.assertTrue(r.newOrd == 7);
			
			
			
			pegs = ['a','b','c','d'];
			newOrds = [10,9,8,7];
			unitTestStim = generateStim(pegs,newOrds);
			unitTestStim[0].bind="myBind";
			
			Timeline.__propChanged = function(bind:String,prop:String,val:String, fake:Object):void{
				Assert.assertTrue(unitTestStim[0].bind==bind);
				Assert.assertTrue("depth"==prop);
				Assert.assertTrue(val==newOrds.join("---"));
			}

			r = Timeline.__processMultiStim(unitTestStim);
		
			Assert.assertTrue(r.newOrd == 10);
	
		}
		*/
		
		
		
		private function processResults(arr:Array):Array{
			
			for(var i:int=0;i<arr.length;i++){
				arr[i]=arr[i].split("b_").join("");
			}
			
			
			return arr;
		}
		
		
		
		
		
		
		private function generateStim(pegs:Array,newOrds:Array=null):Array
		{
			var stim:Array = [];
			
			var mockStim:Object;
			
			for(var i:int=0;i<pegs.length;i++){
				mockStim = {};
				mockStim.peg = pegs[i];
				mockStim.OnScreenElements = {};
				mockStim.OnScreenElements[BindScript.bindLabel] = 'b_'+pegs[i];
				
				if(newOrds)mockStim.newOrd=newOrds[i];
				stim.push(mockStim);
			}
			// TODO Auto Generated method stub
			return stim;
		}		
		
	

		private function compareArrs(origOrder:Array, newOrder:Array):Boolean
		{
			if(origOrder.length!=newOrder.length)throw new Error();
			for(var i:int=0;i<origOrder.length;i++){
				if(origOrder[i]!=newOrder[i])return false;
			}
			
			return true;
		}
	}
}