package unitTests
{
	import org.flexunit.Assert;
	import com.xperiment.BehavLogicAction.ActionDict;
	
	
	
	public class test_ActionDict
	{
	
		
		[Test( description="tests ActionDict" )]
		public function test3() : void
		{
			
			var pass:Boolean=true;
			//when passing a required action, ActionDict assigns missing function as Null (which is important later)
			var testSavesExpt:Function = function():Boolean{
				var ad:ActionDict = ActionDict.getInstance();
				ad.specifyRequirExptAction("exptA1");
				ad.specifyRequirExptAction("exptA2");
				ad.specifyRequirExptAction("exptA3");
				var count:uint=0;
				for (var act:String in ad.actionFuncts){
					pass = pass && ad.actionFuncts[act] == null && act !="";
					count++
				}
				ad.kill();
				ad=null;
				return pass && count==3;
			}
			
			//given expt and trial Actions.  Asked to delete trial Actions and does so (not deleting expt actions along the way)
			var testSavesTrialAndExptSpecific:Function = function():Boolean{
				var ad:ActionDict = ActionDict.getInstance();
				ad.specifyRequirExptAction("exptA1");
				ad.specifyRequirExptAction("exptA2");
				ad.specifyRequirExptAction("exptA3");
				ad.specifyRequirTrialAction("trialA1");
				ad.specifyRequirTrialAction("trialA2");
				ad.specifyRequirTrialAction("trialA3");
				
				var count:uint=0;
				for (var act:String in ad.actionFuncts){
					count++
				}
				ad.killPerTrialActions();
				for (act in ad.actionFuncts){
					count--
				}
				
				ad.kill();
				ad=null;
				return count==3;
			}				
			
			//given expt and trial Actions.  Asked to delete trial Actions and does so (not deleting expt actions along the way)
			var testCanPassRealFunctions:Function = function():Boolean{
				var test:Boolean=true;
				var ad:ActionDict = ActionDict.getInstance();
				ad.specifyRequirExptAction("exptA1");
				ad.specifyRequirExptAction("exptA2");
				ad.specifyRequirExptAction("exptA3");
				ad.specifyRequirTrialAction("trialA1");
				ad.specifyRequirTrialAction("trialA2");
				ad.specifyRequirTrialAction("trialA3");
				
				var f:Function = function():void{};
				ad.assignFunctToAction("trialA1",f);
				test = test && ad.giveActionF("trialA1")==f;
				
				try{
					ad.giveActionF("does not exist");
					test=false;
				}
				catch(e:Error){
					if(e.toString()!="Error: requested to run an action (does not exist) but no function has been assigned to it.") test=false;
				}
				try{
					ad.giveActionF("trialA2"); //exists, but no function set
					test=false;
				}
				catch(e:Error){
					if(e.toString()!="Error: requested to run an action (trialA2) but no function has been assigned to it.") test=false;
				}
				
				ad.kill();
				ad=null;
				
				return test;
			}

			Assert.assertTrue(testSavesExpt());//testing that variable replacement works for LHS	
			Assert.assertTrue(testSavesTrialAndExptSpecific());//testing that variable replacement works for RHS			
			Assert.assertTrue(testCanPassRealFunctions()); //testing that strings can be compoared
		}
		
	
	

	}
}