package unitTests
{
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trial.TrialHelper;
	
	import flexunit.framework.Assert;
	

	public class test_TrialHelper
	{
		
		[Test]
		public function test1():void{
			
			
			function giveStim(depth:int,peg:String):object_baseClass{
				var stim:object_baseClass = new object_baseClass;
				stim.depth=depth;
				stim.peg=peg;
				return stim;
			}
			
			function t(yesSet:Array,noSetNum:int,yesSetRes:Array,noSetRes:Array):Boolean{
				var depthSet:Vector.<object_baseClass> = new Vector.<object_baseClass>;
				var depthNotSet:Vector.<object_baseClass> = new Vector.<object_baseClass>;
				
				var i:int;
				for(i=0;i<yesSet.length;i++){
					depthSet.push(giveStim(yesSet[i],String("ns:"+yesSet[i])));
				}
				
				for(i=0;i<noSetNum;i++){
					depthNotSet.push(giveStim(i,"s:"+String(i)));
				}
				
				TrialHelper.__computeDepths(depthSet,depthNotSet);
				
				for(i=0;i<yesSetRes.length;i++){
					//trace(depthSet[i].peg, depthSet[i].depth,"=",yesSetRes[i]);
					if(depthSet[i].depth !=yesSetRes[i])return false;
				}
				
				for(i=0;i<noSetRes.length;i++){
					//trace(depthNotSet[i].peg, depthNotSet[i].depth,"=",noSetRes[i]);
					if(depthNotSet[i].depth !=noSetRes[i])return false;
				}
				return true;
			}
						
			
			Assert.assertTrue(t([],3,[],[0,1,2]));
			Assert.assertTrue(	t(	[1],	3,	[1],	[0,2,3])	);
			Assert.assertTrue(	t(	[1,2],	3,	[1,2],	[0,3,4])	);
			Assert.assertTrue(	t(	[0,5],	3,	[0,4],	[1,2,3])	);
		}
		
		/*[Test]
		public function test2():void{
			
			Assert.assertTrue(TrialHelper.__calcChange("^^") == 2)
			Assert.assertTrue(TrialHelper.__calcChange("") == 0)
			Assert.assertTrue(TrialHelper.__calcChange("vv") == -2)
			Assert.assertTrue(TrialHelper.__calcChange("vv^^^^") == 2)	
		}*/
		
		/*[Test]
		public function test3():void{
			
			
			function giveStim(depth:int, depthStr:String,peg:String):object_baseClass{
				var stim:object_baseClass = new object_baseClass;
				stim.OnScreenElements.depth=depthStr;
				stim.depth=depth;
				stim.peg=peg;
				return stim;
			}
			
			function t(yesSet_change:Array,yesSet_depth:Array,noSetNum:int,yesSetRes:Array,noSetRes:Array):Boolean{
				var depthSet:Vector.<object_baseClass> = new Vector.<object_baseClass>;
				var depthNotSet:Vector.<object_baseClass> = new Vector.<object_baseClass>;
				
				var i:int;
				for(i=0;i<yesSet_change.length;i++){
					depthSet.push(giveStim(yesSet_depth[i], yesSet_change[i],String("ns:"+yesSet_change[i])));
				}
				
				for(i=0;i<noSetNum;i++){
					depthNotSet.push(giveStim(i,String(i),"s:"+String(i)));
				}
				
				TrialHelper.__computeRelDepths(depthSet,depthNotSet);
				
				for(i=0;i<yesSetRes.length;i++){
					//trace(depthSet[i].peg, depthSet[i].depth,"=",yesSetRes[i]);
					if(depthSet[i].depth !=yesSetRes[i])return false;
				}
				
				for(i=0;i<noSetRes.length;i++){
					//trace(depthNotSet[i].peg, depthNotSet[i].depth,"=",noSetRes[i]);
					if(depthNotSet[i].depth !=noSetRes[i])return false;
				}
				return true;
			}
			
		
			Assert.assertTrue(	t(	[],		[],			3,	[],			[0,1,2])	);
			Assert.assertTrue(	t(	['^'],	[1],		3,	[2],		[0,1,3])	);
			Assert.assertTrue(	t(	['v'],	[1],		3,	[0],		[1,2,3])	);
			Assert.assertTrue(	t(	['^^^^'],	[1],		3,	[3],		[0,1,2])	);
			Assert.assertTrue(	t(	['vvvv'],	[1],		3,	[0],		[1,2,3])	);
			Assert.assertTrue(	t(	['vv','v'],	[3,1],		3,	[2,0],		[1,3,4])	);
		}
		*/
		
	}
}