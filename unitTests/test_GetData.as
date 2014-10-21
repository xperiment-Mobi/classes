package unitTests
{
	
	
	import com.xperiment.stimuli.helpers.GetData;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.asserts.assertTrue;


	public class test_GetData
	{

		
		[Test]
		public function test05() : void{
		
		assertTrue(GetData.__av([1,2,3])==2);
		assertTrue(GetData.__stderr([1,2,3])==0.5773502691896258);
		assertTrue(GetData.__stdev([1,2,3])==1);

		}
		
		
		
		[Test]
		public function test1() : void{
			
			
			var xml:XML = 	<a>
						<b name="abc1">
							<a>1</a>
							<b>2</b>
							<c>1</c>
						</b>
						<b name="abc2">
							<a>2</a>
							<b>2</b>
							<c>2</c>
						</b>
						<b name="abd1">
							<a>1</a>
							<b>2</b>
							<c>1</c>
						</b>
						<b name="abd2">
							<a>1</a>
							<b>2</b>
							<c>2</c>
						</b>
					</a>
			
			var arr:Array;
			var params:Object;

			params = {trialNames:"abc1",maths:"average,stderr",dv:"c"};
			
			arr = GetData.retrieve(params,xml.children());
			Assert.assertTrue(arr.abc1.average==1);
			Assert.assertTrue(arr.abc1.stderr==0); // this is NaN but returns 0 as defualt.
			
			params = {trialNames:"abc*,abd*",maths:"average,stderr,stdev",dv:"c"};
			arr = GetData.retrieve(params,xml.children());
			Assert.assertTrue(arr['abc*'].stdev==0.7071067811865476);
			Assert.assertTrue(arr['abc*'].average==1.5);
			Assert.assertTrue(arr['abc*'].stderr==.5);
			Assert.assertTrue(arr['abd*'].stdev==0.7071067811865476);
			Assert.assertTrue(arr['abd*'].average==1.5);
			Assert.assertTrue(arr['abd*'].stderr==.5);
			
			params = {trialNames:"abc*,abd*",maths:"average,stderr,stdev",dv:"c", criteria:"a!=2,c>=1"};
			
			arr = GetData.retrieve(params,xml.children());
			Assert.assertTrue(arr['abc*'].average==1);
			Assert.assertTrue(arr['abd*'].average==1.5);
		}
		
		[Test]
		public function test02() : void{
			var f:Function 
			
			f = GetData.__processCriteria("a==2").f;
			Assert.assertTrue(f('2'));
			Assert.assertFalse(f('3'));
			
			f = GetData.__processCriteria("a!=2").f;
			Assert.assertTrue(f('3'));
			Assert.assertFalse(f('2'));
			
			f = GetData.__processCriteria("a>=2").f;
			Assert.assertTrue(f('3'));
			Assert.assertTrue(f('2'));
			Assert.assertFalse(f('1'));
			
			f = GetData.__processCriteria("a<=2").f;
			Assert.assertTrue(f('1'));
			Assert.assertTrue(f('2'));
			Assert.assertFalse(f('3'));
			
			f = GetData.__processCriteria("a>2").f;
			Assert.assertFalse(f('2'));
			Assert.assertTrue(f('3'));
			
			f = GetData.__processCriteria("a<2").f;
			Assert.assertFalse(f('2'));
			Assert.assertTrue(f('1'));

			
		}
		

	
		/*[Test]
		public function test2() : void{
			
			var xml:XML = 	<a>
								<b>
									<r1>1</r1>
									<r2>2</r2>
									<r3>3</r3>
								</b>
								<c>
									<r11>1</r11>
									<r12>2</r12>
									<r13>3</r13>
								</c>
								<d>
									<r21>1</r21>
									<r22>2</r22>
									<r23>3</r23>
								</d>
							</a>

			var arr:Array = [];
			GetData.__XMLListToList(xml.children(),arr);
			Assert.assertTrue(arr.length==3);
			
			var obj:Object;
			var len:int;
			for(var i:int=0;i<arr.length;i++){
				len=0;
				obj=arr[i];
				assertTrue(obj.hasOwnProperty(GetData.TRIAL_NAME));
				for(var key:String in obj){	
					len++;
				}
				Assert.assertTrue(len==4);
			}
		}*/
	}
}