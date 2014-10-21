package unitTests
{
	import com.xperiment.uberSprite;
	import com.xperiment.BehavLogicAction.PropValDict;
	import com.xperiment.behaviour.abstractBehaviourBoss;
	import com.xperiment.stimuli.test_stim;
	
	import org.flexunit.Assert;

	
	
	
	public class test_exptWideVars
	{
	
		
		/*[Test(  aycnc, description="tests loader" )]
		public function test1() : void
		{
			var mockScript:XML = new XML(
			<test>
				<a filename='2.flv'/>
				<b><c filename='1.jpg'><d filename='3.mp3'/></c></b>
			</test>
			);
				
			var loader:preloadFilesFromWeb = new preloadFilesFromWeb(mockScript,'test_Assets');
			

			Async.handleEvent(this,loader.queue,
		}*/
		
		[Test(  description="tests exptWideVars" )]
		public function test1() : void
		{
			var t:test_stim = new test_stim;
			t.peg = 'testPeg';
			t.textVal = 'fail';
			t.pic = new uberSprite;
			t.OnScreenElements['behaviours'] = "doNow:testPeg.text='success'";
			
			var tt:test_stim = new test_stim;
			tt.peg = 'testPeg2';
			tt.textVal = 'fail';
			tt.pic = new uberSprite;
			tt.OnScreenElements['behaviours'] = "doNow:testPeg2.text=banana";

			var a:abstractBehaviourBoss = new abstractBehaviourBoss;
			
			
			//a.propValDict.kill()
			//a.propValDict = new PropValDict();
			var propValDict:PropValDict = a.propValDict
			

			
			PropValDict.addExptProps('banana',"'success2'");
			
			
			
			a.objectAdded(t);
			a.objectAdded(tt);
			
			a.init();

			//trace(propValDict.propDict['banana'],3)
			//trace(222,t.textVal,tt.textVal);
			
			Assert.assertTrue(t.textVal=="'success'");
			Assert.assertTrue(tt.textVal=="'success2'");
			
			
			propValDict.kill();
			//Assert.assertTrue(propValDict.perTrialProps == null);
			


		}
			
				
		
	
	

	}
}