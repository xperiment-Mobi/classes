package unitTests
{
	import com.xperiment.make.xpt_interface.Bind.MultiTrialCorrection;	
	import org.flexunit.Assert;


	public class test_MultiSpecsCorrection
	{
		
		[Test]
		public function test1() : void 
		{		
			Assert.assertTrue(MultiTrialCorrection.__duplicateUp([1,2,3],4,'1')[3]==1);
			Assert.assertTrue(MultiTrialCorrection.__duplicateUp([1,2,3],5,'2')[4]==2);
			Assert.assertTrue(MultiTrialCorrection.__duplicateUp([1,2,3],6,'3')[5]==3);	
		}
		
		
		
		[Test]
		public function test2() : void 
		{			
			Assert.assertTrue('x'==MultiTrialCorrection.sortMultiSpecs("x","h",{trialNum:0,itemNum:0,numItems:1,numTrials:1,defaults:{}}));
			Assert.assertTrue('x---0'==MultiTrialCorrection.sortMultiSpecs("x","h---0",{trialNum:0,itemNum:0,numItems:1,numTrials:1,defaults:{}}));		
			Assert.assertTrue('h---x'==MultiTrialCorrection.sortMultiSpecs("x","h---0",{trialNum:0,itemNum:1,numItems:1,numTrials:1,defaults:{}}));		
			Assert.assertTrue('x---0;0'==MultiTrialCorrection.sortMultiSpecs("x","h---0;0",{trialNum:0,itemNum:0,numItems:1,numTrials:1,defaults:{}}));		
			Assert.assertTrue('h---x;0'==MultiTrialCorrection.sortMultiSpecs("x","h---0;0",{trialNum:0,itemNum:1,numItems:1,numTrials:1,defaults:{}}));		
			Assert.assertTrue('h---0;x'==MultiTrialCorrection.sortMultiSpecs("x","h---0;0",{trialNum:1,itemNum:0,numItems:1,numTrials:1,defaults:{}}));		
			
			//Assert.assertTrue('h---0;0---x'==MultiTrialCorrection.sortMultiSpecs("x","h---0;0---0---0",{trialNum:1,itemNum:1,numItems:1,numTrials:1,defaults:{}}));		
			//note above had to be updated to below when we added CrunchUp utility
			Assert.assertTrue('h---0;0---x'==MultiTrialCorrection.sortMultiSpecs("x","h---0;0---0---0",{trialNum:1,itemNum:1,numItems:1,numTrials:1,defaults:{}}));		
			
			Assert.assertTrue('h---0;0---0---0---x'==MultiTrialCorrection.sortMultiSpecs("x","h---0;0---0---0",{trialNum:1,itemNum:3,numItems:4,numTrials:1,defaults:{}}));	
			Assert.assertTrue('h---0;0---0---0---x'==MultiTrialCorrection.sortMultiSpecs("x","h---0;0---0---0",{trialNum:1,itemNum:3,numItems:4,numTrials:1,defaults:{}}));	
			Assert.assertTrue('h---0;1---2---3---x---2---3'==MultiTrialCorrection.sortMultiSpecs("x","h---0;1---2---3",{trialNum:1,itemNum:3,numItems:6,numTrials:1,defaults:{}}));
			
			
		}
		
		
		[Test]
		public function test3() : void 
		{
			//trace(111)
			Assert.assertTrue('x'==MultiTrialCorrection.sortMultiSpecs("x","",{trialNum:0,itemNum:0,numItems:1,numTrials:1,defaults:{}}));
			Assert.assertTrue('x---y'==MultiTrialCorrection.sortMultiSpecs("x","",{trialNum:0,itemNum:0,numItems:2,numTrials:1,defaults:{x:'y'}},'x'));
			Assert.assertTrue("x;y"==MultiTrialCorrection.sortMultiSpecs("x","",{trialNum:0,itemNum:0,numItems:1,numTrials:2,defaults:{x:'y'}},'x'));
			Assert.assertTrue("y;y---x",MultiTrialCorrection.sortMultiSpecs("x","",{trialNum:1,itemNum:1,numItems:3,numTrials:2,defaults:{x:'y'}},'x'));
/*			trace("-----------------")
			
			trace("--------zzzzzzzzzzzzzzz---------")*/
		}

		
		//testing deleting stuff from a multitrial
		[Test]
		public function test4() : void 
		{
			//trace(MultiTrialCorrection.sortMultiSpecs(null,"x---y",{trialNum:0,itemNum:0,numItems:2,numTrials:1,defaults:{}}))
			Assert.assertTrue('y'==MultiTrialCorrection.sortMultiSpecs(null,"x---y",{trialNum:0,itemNum:0,numItems:2,numTrials:1,defaults:{}}));
			Assert.assertTrue('x'==MultiTrialCorrection.sortMultiSpecs(null,"x---y",{trialNum:0,itemNum:1,numItems:2,numTrials:1,defaults:{}}));
			Assert.assertTrue('z'==MultiTrialCorrection.sortMultiSpecs(null,"",{trialNum:0,itemNum:1,numItems:2,numTrials:1,defaults:{z:'z'}},'z'));
			//trace("--------");
			//trace(111,MultiTrialCorrection.sortMultiSpecs(null,"x---y",{trialNum:1,itemNum:1,numItems:2,numTrials:3,defaults:{z:'z'}},'z'))
			Assert.assertTrue('y;x---y;x---y'==MultiTrialCorrection.sortMultiSpecs(null,"x---y",{trialNum:0,itemNum:0,numItems:2,numTrials:3,defaults:{}}));
			Assert.assertTrue('x---y;x'==MultiTrialCorrection.sortMultiSpecs(null,"x---y",{trialNum:1,itemNum:1,numItems:2,numTrials:3,defaults:{}}));
			//trace("5555555555555555555");
			//trace(111,MultiTrialCorrection.sortMultiSpecs(null,"x---y---q",{trialNum:1,itemNum:1,numItems:2,numTrials:3,defaults:{}}));
			//trace("-a-------------------");
		}
		
		//testing where overTrials 
		[Test]
		public function test5() : void 
		{
			MultiTrialCorrection.overTrials = true;
			//trace(MultiTrialCorrection.sortMultiSpecs('x',"y---x;y",{trialNum:0,itemNum:0,numItems:2,numTrials:2,defaults:{}}))
			Assert.assertTrue('x---y'==MultiTrialCorrection.sortMultiSpecs('x',"x---y",{trialNum:0,itemNum:0,numItems:2,numTrials:1,defaults:{}}));
			Assert.assertTrue('x---y'==MultiTrialCorrection.sortMultiSpecs('x',"y---y;y",{trialNum:0,itemNum:0,numItems:2,numTrials:2,defaults:{}}));
			Assert.assertTrue('x;x---y'==MultiTrialCorrection.sortMultiSpecs('x',"y---x;y",{trialNum:0,itemNum:0,numItems:2,numTrials:2,defaults:{}}));
			Assert.assertTrue('x'==MultiTrialCorrection.sortMultiSpecs('x',"y---x;y---x",{trialNum:0,itemNum:0,numItems:2,numTrials:2,defaults:{}}));
			MultiTrialCorrection.overTrials = false;
		}
		
		//testing where overStims
		[Test]
		public function test6() : void 
		{
			MultiTrialCorrection.overStims = true;

			Assert.assertTrue('x'==MultiTrialCorrection.sortMultiSpecs('x',"x---y",{trialNum:0,itemNum:0,numItems:2,numTrials:1,defaults:{}}));
			Assert.assertTrue('x;b---c'==MultiTrialCorrection.sortMultiSpecs('x',"x---y;b---c",{trialNum:0,itemNum:0,numItems:2,numTrials:1,defaults:{}}));
			
			MultiTrialCorrection.overStims = false;

		}
		
		
	}
}