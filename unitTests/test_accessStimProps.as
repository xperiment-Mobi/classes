package unitTests
{

	import com.xperiment.behaviour.BehaviourBoss;
	import com.xperiment.stimuli.test_stim;
	
	import org.flexunit.Assert;

	
	
	
	public class test_accessStimProps
	{
	
		
		
		[Test(  description="testspropWrapper, for getVar/setVar propertiess" )]
		public function test1() : void
		{
			var t:test_stim = new test_stim
			
			t.OnScreenElements['testProp'] = 'mock';
			t.OnScreenElements['behaviours'] = "doNow:thistestPropt='success'";
	
			var behaviourBoss:BehaviourBoss = new BehaviourBoss(null,null);
			
			var funct:Function = behaviourBoss.propWrapper(t,'testProp');
			
			Assert.assertTrue(funct != null);
			
			funct('testProp','changed');
			
			
			//trace(111,t.OnScreenElements['testProp']);
			Assert.assertTrue(t.OnScreenElements['testProp']=='changed');			
		}
	
	

	}
}