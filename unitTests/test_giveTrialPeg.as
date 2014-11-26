package unitTests
{
	import com.xperiment.behaviour.BehaviourBoss;
	import com.xperiment.stimuli.test_stim;
	
	import org.flexunit.Assert;

	
	public class test_giveTrialPeg
	{
		
	
		
		[Test(  description="testspropWrapper, for getVar/setVar propertiess" )]
		public function test1() : void
		{
			
			var behaviourBoss:BehaviourBoss = new BehaviourBoss(null,null);
			
			var t1:test_stim = new test_stim
			
			
			t1.OnScreenElements['behaviours'] = "testPeg.doNow:this.timeStart=0";
			
			
			behaviourBoss.passObject(t1);
			
			
			var t2:test_stim = new test_stim
			t2.peg='testPeg';
		
			behaviourBoss.passObject(t2);
			
			behaviourBoss.__linkTOPS()
			
			Assert.assertTrue(behaviourBoss.propValDict.propDict['noPeg0.timeStart'] is Function);
			Assert.assertTrue(behaviourBoss.propValDict.propDict['testPeg.doNow']=='testPeg.doNow');
			
			var count:int=0;
			for(var s:String in behaviourBoss.propValDict.propDict){
				//trace(11,s,behaviourBoss.propValDict.propDict[s]);
				count++;
			}
			
			//Assert.assertTrue(count==2);
			

		}
		
		
		
	}
}