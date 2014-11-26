package unitTests
{
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.trialOrder.trialOrderFunctions;
	import com.xperiment.trialOrder.components.BlockOrder.BlockDepthOrdering;
	import com.xperiment.trialOrder.components.BlockOrder.OrderBlocksBoss;
	import com.xperiment.trialOrder.components.BlockOrder.SlotInForcePositions;
	import com.xperiment.trialOrder.components.BlockOrder.TrialBlock;
	import com.xperiment.trialOrder.components.DepthNode.DepthNode;
	import com.xperiment.trialOrder.components.DepthNode.DepthNodeBoss;
	
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	
	
	public class test_trialOrderFunctions
	{
		

		[Test]
		public function test6() : void
		{
			var level:OrderBlocksBoss = new OrderBlocksBoss;
			var sortF:Function = level.__sortF;
			
			
			function make(f:Function, blocks1:Array,blocks2:Array):int{
				var t1:TrialBlock = new TrialBlock;
				var t2:TrialBlock = new TrialBlock;
				
				for(var i:int=0;i<blocks1.length;i++){
					t1.blocksVect.push(blocks1[i]);
				}
				for(i=0;i<blocks2.length;i++){
					t2.blocksVect.push(blocks2[i]);
				}
				
				
				
			return f(t1,t2);;
			}
			
			Assert.assertTrue(make(sortF,[0],[1])==-1);
			Assert.assertTrue(make(sortF,[1],[0])==1);
			Assert.assertTrue(make(sortF,[0],[0])==0);
			
			Assert.assertTrue(make(sortF,[0,1],[0])==1);
			Assert.assertTrue(make(sortF,[0,1],[0,2])==-1);
			Assert.assertTrue(make(sortF,[0,2],[0,2])==0);
			Assert.assertTrue(make(sortF,[0,3],[0,2])==1);
			
			Assert.assertTrue(make(sortF,[0],[0,2])==-1);

			Assert.assertTrue(make(sortF,[20],[0])==1);
		}
	
		[Test]
		public function test7() : void
		{
		
			function test(result:Array, answer:Array):Boolean{
				
				
				if(result.length!=answer.length){
				
					return false;
				}
				
				for(var i:int=0;i<result.length;i++){
					
					
					if(result[i]!=answer[i]){
						return false;
					}
				}
				return true;
			}
			
			var result:Array;
			ExptWideSpecs.__init();
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
 
					<TRIAL block="20" order="fixed" trials="1"/>
					<TRIAL block="0" order="fixed" trials="1"/>
				</CBCondition1>)	,new Function);
			
			//boring linear test, reverse though
	
			Assert.assertTrue(test(result,[1,0]))
				
				
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
 
					<TRIAL block="20" order="fixed" trials="2"/>
					<TRIAL block="8" order="fixed" trials="3"/>
					<TRIAL block="6" order="fixed" trials="3"/>                    
					<TRIAL block="3" order="fixed" trials="2" />
					<TRIAL block="0" order="fixed" trials="1"/>
				</CBCondition1>)	,new Function);
			
			//boring linear test, reverse though


			Assert.assertTrue(test(result,[10,8,9,5,6,7,2,3,4,0,1]))
		
				
					
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL block="0,1" order="fixed" trials="2"/> 
					<TRIAL block="8" order="fixed" trials="3"/> 
				</CBCondition1>)	,new Function);
			
			Assert.assertTrue(test(result,[0,1,2,3,4]))
				
				
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
 
					<TRIAL block="0,1,2" order="fixed" trials="1"/>
					<TRIAL block="0,5,2" order="fixed" trials="1"/>
					<TRIAL block="0" order="fixed" trials="1"/>
				</CBCondition1>)	,new Function);
			
	

			Assert.assertTrue(test(result,[2,0,1]))
				
				
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
 
					<TRIAL block="0" order="fixed" trials="1"/>
					<TRIAL block="0" order="fixed" trials="1"/>
				</CBCondition1>)	,new Function);
			

			Assert.assertTrue(test(result,[0,1]))
				
				
				result = trialOrderFunctions.computeOrder(
				(<CBCondition1>

					<TRIAL block="0,1" order="fixed" trials="2"/>
					<TRIAL block="0,5" order="fixed" trials="3"/>
					<TRIAL block="0,2" order="fixed" trials="3"/>                    
					<TRIAL block="0,1" order="fixed" trials="2" />
				</CBCondition1>)	,new Function);
			
							

			Assert.assertTrue(test(result,[0,1,8,9,5,6,7,2,3,4]))
					
				
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>

					<TRIAL block="0,1" order="fixed" trials="2"/>
					<TRIAL block="0,1" order="reverse" trials="2"/>
				</CBCondition1>)	,new Function);
			
		
			Assert.assertTrue(test(result,[3,2,1,0]));
			
		
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>

					<TRIAL block="1" order="fixed" trials="1"/>
					<TRIAL block="0,1" order="fixed" trials="1"/>

				</CBCondition1>)	,new Function);
			

		Assert.assertTrue(test(result,[1,0]))
			
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
 
					<TRIAL block="0,1,2" order="reverse" trials="1"/>

					<TRIAL block="0" order="fixed" trials="1"/>
				</CBCondition1>)	,new Function);
			
			

			Assert.assertTrue(test(result,[1,0]))
				
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL  block='0' order="fixed" trials='1'/>
					<TRIAL  block='0' order="fixed" trials='1'/>           
					<TRIAL  block='0' order="fixed" trials='1'/>
					<TRIAL block='10'/>
				</CBCondition1>)	,new Function);		
			
			Assert.assertTrue(test(result,[0,1,2,3]))

			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
 
					<TRIAL block="0,1,2" order="reverse" trials="2"/>
					<TRIAL block="0,5,2" order="fixed" trials="3"/>
					<TRIAL block="0,2,3" order="fixed" trials="3"/>                    
					<TRIAL block="0,2,3" order="reverse" trials="2" />
					<TRIAL block="0" order="fixed" trials="1"/>
				</CBCondition1>)	,new Function);
			

			Assert.assertTrue(test(result,[10,1,0,9,8,7,6,5,2,3,4]))
		}
		
		
		

		[Test]
		public function test8_5() : void
		{
			var dn:DepthNode;
			
			var ord:String = TrialBlock.FIXED;
			
			try{
				dn = new DepthNode();
				dn.init([],'');
				assertTrue(false);
			}catch(e:Error){}
			try{
				dn = new DepthNode();
				dn.init([1],'');
				assertTrue(false);
			}catch(e:Error){}
			
			
			dn = new DepthNode();
			dn.init([10],ord);
			assertTrue(dn.__kinderCount()==1);
			assertTrue(dn.__combinedKinderCount()==1);
			assertTrue(dn.__retrieve([10])==ord);
			
			dn = new DepthNode();
			dn.init([10,9,8],ord);
			assertTrue(dn.__kinderCount()==1);
			assertTrue(dn.__combinedKinderCount()==3);
			assertTrue(dn.__retrieve([10,9,8])==ord);
			assertTrue(dn.__retrieve([10,9,8,7])==DepthNode.UNKNOWN);
			assertTrue(dn.__retrieve([10,9])==DepthNode.UNKNOWN);
			assertTrue(dn.__retrieve([10])==DepthNode.UNKNOWN);
			
			dn = new DepthNode();
			dn.init([10,9,"*"],ord);
			assertTrue(dn.__combinedKinderCount()==3);
			assertTrue(dn.__retrieve([10,9,8])==ord);
			assertTrue(dn.__retrieve([10,9,1])==ord);
			assertTrue(dn.__isWildCard([10,9,1])==true);
			assertTrue(dn.__isWildCard([10,9])==false);
			assertTrue(dn.__isWildCard([10,9,1,1])==false);
			
			dn = new DepthNode();
			dn.init([10,"*",8],ord);
			assertTrue(dn.__retrieve([10,9,8])==ord);
			assertTrue(dn.__retrieve([10,7,8])==ord);
			assertFalse(dn.__retrieve([10,7,2])==ord);
			assertFalse(dn.__retrieve([11,9,8])==ord);
			
			dn = new DepthNode();
			dn.init(["*",8,4],ord);
			assertTrue(dn.__retrieve([10,8,4])==ord);
			assertTrue(dn.__retrieve([1,8,4])==ord);
			assertFalse(dn.__retrieve([1,9,4])==ord);
			assertFalse(dn.__retrieve([1,8,3])==ord);
			
			dn = new DepthNode();
			dn.init(["*",8,"*"],ord);
			assertTrue(dn.__retrieve([10,8,4])==ord);
			assertTrue(dn.__retrieve([1,8,4])==ord);
			assertFalse(dn.__retrieve([1,9,4])==ord);
			assertFalse(dn.__retrieve([1,7,3])==ord);
			
			dn = new DepthNode();
			dn.init([9],TrialBlock.FIXED);
			dn.init([10],TrialBlock.RANDOM);
			dn.init([10,"*"],TrialBlock.FIXED);
			dn.init([10,"*","*"],TrialBlock.RANDOM);

			assertTrue(dn.__retrieve([9])==TrialBlock.FIXED);
			assertTrue(dn.__retrieve([10])==TrialBlock.RANDOM);
			assertTrue(dn.__retrieve([10,3])==TrialBlock.FIXED);
			assertTrue(dn.__retrieve([10,4,4])==TrialBlock.RANDOM);
			assertTrue(dn.__isWildCard([10,4,4])==true);
			assertTrue(dn.__isWildCard([10,4,4,4])==false);
			assertTrue(dn.__isWildCard([10])==false);
			
			dn = new DepthNode();
			dn.init([9,2],TrialBlock.FIXED);
			dn.init([10,2,1],TrialBlock.RANDOM);
			assertTrue(dn.__retrieve([9,2])==TrialBlock.FIXED);
			assertTrue(dn.__retrieve([10,2,1])==TrialBlock.RANDOM);
			
			dn = new DepthNode();
			dn.init([9],TrialBlock.FIXED);
			dn.init([1,2],TrialBlock.FIXED);
			dn.init([1,2,3],TrialBlock.FIXED);
			dn.init([1,2,4],TrialBlock.REVERSE);
			assertTrue(dn.__retrieve([9])==TrialBlock.FIXED);
			assertTrue(dn.__retrieve([1,2])==TrialBlock.FIXED);
			assertTrue(dn.__retrieve([1,2,3])==TrialBlock.FIXED);
			assertTrue(dn.__retrieve([1,2,4])==TrialBlock.REVERSE);
			dn.kill();
			
		}
		
		
		[Test]
		public function test8_6() : void
		{
			var dnb:DepthNodeBoss = new DepthNodeBoss("9=fixed 10=random 10,*=fixed 10,*,*=random");
			assertTrue(dnb.retrieve("9.1")== DepthNode.UNKNOWN);
			assertTrue(dnb.retrieve("9")== TrialBlock.FIXED);
			assertTrue(dnb.retrieve("10")== TrialBlock.RANDOM);
			assertTrue(dnb.retrieve("10 1")== TrialBlock.FIXED);
			assertTrue(dnb.retrieve("10 5 0")== TrialBlock.RANDOM);
		
			dnb = new DepthNodeBoss("9=fixed 1,2=fixed 1,2,3=fixed 1,2,4=reverse");
			assertTrue(dnb.retrieve("1 2")== TrialBlock.FIXED);
			assertTrue(dnb.retrieve("1 2 3")== TrialBlock.FIXED);
			assertTrue(dnb.retrieve("1 2 4")== TrialBlock.REVERSE);
			
			dnb.kill();
		}
		
		
		[Test]
		public function test8_7() : void
		{
			function makeTrialBlocks(params:Object):Boolean{
				
	
				var blocks:Array = params.blocks
				var numTrials:Array = params.numTrials
				
				var trialBlocks:Array = [];
				var block:TrialBlock;
				
				var count:int=0;
				var trials:Array;
				var i:int;
				var j:int;
				
				for (i=0;i<blocks.length;i++){
					
					block=new TrialBlock;
									
					trials=[];
					for(j=0;j<numTrials[i];j++){
						trials.push(count);
						count++
					}
					block.trials=trials;
					block.order=TrialBlock.FIXED;
					block.setBlock(blocks[i]);
					trialBlocks.push(block);
				}

				BlockDepthOrdering.DO(trialBlocks);
			
				var trialList:Array = [];
				var expectedTrialList:Array=params.trials;
				var tArr:Array; 
				
				for(i=0;i<trialBlocks.length;i++){
					
					
					if(trialBlocks[i].alive){
						tArr=trialBlocks[i].getTrials();
						
						for(j=0;j<tArr.length;j++){
							trialList.push(tArr[j]);
						}
					}
				}
			
				for(i=0;i<expectedTrialList.length;i++){
					if(expectedTrialList[i]!=trialList[i])return false;
				}
				
				
				return true; 
			}
			
			ExptWideSpecs.__init();
			ExptWideSpecs.__ExptWideSpecs.trials.blockDepthOrder="1,2=fixed 1,2,3=fixed 1,2,4=fixed";

			Assert.assertTrue(makeTrialBlocks({
				blocks:['1,2','1,2,3','1,2,4'],
				numTrials:[2,2,2],
				trials:[0,1,2,3,4,5]
			}));
		
			ExptWideSpecs.__ExptWideSpecs.trials.blockDepthOrder="1,2=fixed 1,2,*=reverse";
			Assert.assertTrue(makeTrialBlocks({
				depthOrdering:['fixed','fixed','reverse'],
				blocks:['1,2','1,2,3','1,2,4'],
				numTrials:[2,2,2],
				trials:[0,1,4,5,2,3]
			}));
			
			ExptWideSpecs.__ExptWideSpecs.trials.blockDepthOrder="1,2=fixed 1,2,*=reverse";
			Assert.assertTrue(makeTrialBlocks({
				depthOrdering:['fixed','fixed','reverse'],
				blocks:['1,2','1,2,3','1,2,4'],
				numTrials:[2,2,2],
				trials:[0,1,4,5,2,3]
			}));
			
			

		}
		
		
		[Test]
		public function test10() : void
		{
			
			Assert.assertTrue(SlotInForcePositions.getPosition("1",5)==1);
			Assert.assertTrue(SlotInForcePositions.getPosition("6",5)==6);
			
			Assert.assertTrue(SlotInForcePositions.getPosition("first",5)==0);
			Assert.assertTrue(SlotInForcePositions.getPosition("last",5)==5);
			
			Assert.assertTrue(SlotInForcePositions.getPosition("center",5)==2);
			Assert.assertTrue(SlotInForcePositions.getPosition("center+1",5)==3);
			
			Assert.assertTrue(SlotInForcePositions.getPosition("1/2",5)==3);
			Assert.assertTrue(SlotInForcePositions.getPosition("1/4",8)==2);
			
		}
		
		[Test]
		public function test11() : void
		{
			
			function f(arr,arr2):Boolean{
				if(arr.length!=arr2.length)return false;
				for (var i:int = 0;i<arr.length;i++){
					if(arr[i]!=arr2[i])return false;
				}
				return true;
			}
			
			Assert.assertTrue(f(SlotInForcePositions.__addTrials([0,1,2,3,4,5,6],2,['a','b','c']),[0,1,'a','b','c',2,3,4,5,6]));

		}
		

		
		[Test]
		public function test12() : void
		{
			ExptWideSpecs.__init();
			
			
			
			var result:Array;
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
 
					<TRIAL block="20" order="fixed" forcePositionInBlock = '0' trials="2"/>
					<TRIAL block="0" order="fixed" trials="1"/>
				</CBCondition1>)	,new Function);
			


			Assert.assertTrue(test(result,[2,0,1]));
			

			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
 
					<TRIAL block="20,2" order="fixed" forceBlockDepthPositions = '0' trials="2"/>
					<TRIAL block="20,1" order="fixed" trials="1"/>
				</CBCondition1>)	,new Function);

			Assert.assertTrue(test(result,[0,1,2]));
			
		
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
 
					<TRIAL block="20,2" order="fixed" forceBlockDepthPositions = '1' trials="2"/>
					<TRIAL block="20,1" order="fixed" trials="3"/>
				</CBCondition1>)	,new Function);
			
			Assert.assertTrue(test(result,[2,0,1,3,4]));
	

			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL block="20,6" order="fixed" forceBlockDepthPositions = '1/3' trials="1"/>
					<TRIAL block="20,6" order="fixed" forceBlockDepthPositions = '2/3' trials="1"/>
					<TRIAL block="20,3" order="fixed" trials="5"/>
					<TRIAL block="20,2" order="fixed" trials="5"/>
					<TRIAL block="20,1" order="fixed" trials="5"/>
				</CBCondition1>)	,new Function);

			Assert.assertTrue(test(result,[12,13,14,15,16,0,7,8,9,10,11,1,2,3,4,5,6]));
			
				
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL block="20,1" order="fixed" forceBlockDepthPositions = '1/3' trials="1"/>
					<TRIAL block="20,1" order="fixed" forceBlockDepthPositions = '2/3' trials="1"/>
					<TRIAL block="20,3" order="fixed" trials="5"/>
					<TRIAL block="20,2" order="fixed" trials="5"/>
					<TRIAL block="20,1" order="fixed" trials="5"/>
				</CBCondition1>)	,new Function);
		
			Assert.assertTrue(test(result,[12,13,14,15,16,0,7,8,9,10,11,1,2,3,4,5,6]));
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL block="20,3" order="fixed" trials="5"/>
					<TRIAL block="20,2" order="fixed" trials="5"/>
					<TRIAL block="20,2" order="fixed" forceBlockDepthPositions = '1/3' trials="1"/>
					<TRIAL block="20,2" order="fixed" forceBlockDepthPositions = '2/3' trials="1"/>
					<TRIAL block="20,1" order="fixed" trials="5"/>
				</CBCondition1>)	,new Function);
			Assert.assertTrue(test(result,[12,13,14,15,16,10,5,6,7,8,9,11,0,1,2,3,4]));
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL block="-20,6" order="fixed" forceBlockDepthPositions = '1/3' trials="1"/>
					<TRIAL block="-20,6" order="fixed" forceBlockDepthPositions = '2/3' trials="1"/>
					<TRIAL block="-20,3" order="random" trials="5"/>
					<TRIAL block="-20,2" order="random" trials="5"/>
					<TRIAL block="-20,1" order="random" trials="5"/>
				</CBCondition1>)	,new Function);
			
			Assert.assertTrue(result[5]==0,result[11]==1)
				
		}

		
		private function test(result:Array, answer:Array):Boolean{
			if(result.length!=answer.length){
				return false;
			}
			for(var i:int=0;i<result.length;i++){
				if(result[i]!=answer[i]){
					return false;
				}
			}
			return true;
		}
		
		[Test]
		public function test13() : void
		{
			ExptWideSpecs.__init();
			
			
			
			var result:Array;
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
				
					<TRIAL block="20,2" order="fixed" trials="6"/>
					<TRIAL block="20,2" order="fixed" forcePositionInBlock = '1/3' trials="1"/>
					<TRIAL block="20,2" order="fixed" forcePositionInBlock = '2/3' trials="1"/>
	
				</CBCondition1>)	,new Function);

			Assert.assertTrue(test(result,[0,1,6,2,3,7,4,5]));
			
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL block="20,3" order="fixed" trials="5"/>
					<TRIAL block="20,2" order="fixed" trials="5"/>
					<TRIAL block="20,2" order="fixed" forcePositionInBlock = '1/3' trials="1"/>
					<TRIAL block="20,2" order="fixed" forcePositionInBlock = '2/3' trials="1"/>
					<TRIAL block="20,1" order="fixed" trials="5"/>
				</CBCondition1>)	,new Function);

			Assert.assertTrue(test(result,[12,13,14,15,16,5,6,10,7,11,8,9,0,1,2,3,4]));
										   
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL block="20,3" order="fixed" trials="5"/>
					<TRIAL block="20,2" order="fixed" trials="5"/>
					<TRIAL block="20,2" order="fixed" forcePositionInBlock = '1/3' trials="1"/>
					<TRIAL block="20,2" order="fixed" forcePositionInBlock = '3/3' trials="1"/>
					<TRIAL block="20,1" order="fixed" trials="5"/>
				</CBCondition1>)	,new Function);
			Assert.assertTrue(test(result,[12,13,14,15,16,5,6,10,7,8,9,11,0,1,2,3,4]));
					
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL block="20" order="fixed" forcePositionInBlock = '1/4' trials="1"/>
					<TRIAL block="20" order="fixed" forcePositionInBlock = '1/2' trials="1"/>
					<TRIAL block="20" order="fixed" forcePositionInBlock = '3/4' trials="1"/>
					<TRIAL block="20" order="fixed" trials="8"/>
				</CBCondition1>)	,new Function);
			Assert.assertTrue(test(result,[3,4,0,5,6,1,7,8,2,9,10]));
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL block="1" order="fixed" trials="1"/>
					<TRIAL block="20" order="fixed" forcePositionInBlock = '1/4' trials="1"/>
					<TRIAL block="20" order="fixed" forcePositionInBlock = '1/2' trials="1"/>
					<TRIAL block="20" order="fixed" forcePositionInBlock = '3/4' trials="1"/>
					<TRIAL block="20" order="fixed" trials="8"/>
				</CBCondition1>)	,new Function);
			Assert.assertTrue(test(result,[0,4,5,1,6,7,2,8,9,3,10,11]));
			
			result = trialOrderFunctions.computeOrder(
				(<CBCondition1>
					<TRIAL block="1" order="fixed" trials="5"/>
					<TRIAL block="20" order="fixed" forcePositionInBlock = '1/4' trials="1"/>
					<TRIAL block="20" order="fixed" forcePositionInBlock = '1/2' trials="1"/>
					<TRIAL block="20" order="fixed" forcePositionInBlock = '3/4' trials="1"/>
					<TRIAL block="20" order="fixed" trials="8"/>
					<TRIAL block="22" order="fixed" trials="5"/>
				</CBCondition1>)	,new Function);
			Assert.assertTrue(test(result,[0,1,2,3,4,8,9,5,10,11,6,12,13,7,14,15,16,17,18,19,20]));
		}
		
	}
}