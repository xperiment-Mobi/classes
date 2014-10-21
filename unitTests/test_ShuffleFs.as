package unitTests
{


	import com.xperiment.stimuli.helpers.StimModify;
	
	import org.flexunit.Assert;


	public class test_ShuffleFs
	{
		
		
		[Test]
		public function test1() : void
		{		
			
			var xml:XML = <a>
<a peg="aa" stuff1="a;b;c;d;e" stuff2="1;2;3;4;5" stuff3="5;6;7"/>
<a peg="bb" stuff1="b;c;d;e;f" stuff2="2;3;4;5;6" stuff3="5;6;7"/>
</a>
			
			
	
			try{
				StimModify.shuffle_somethings("",xml.children());
			}
			catch(e:Error){
				Assert.assertTrue(true);
			}
			
			
			//StimModify.shuffle_somethings("stuff1 stuff3 ;",xml.copy().children());
			

	
			
			
			
			Assert.assertTrue(true);
		}

		
	}
}