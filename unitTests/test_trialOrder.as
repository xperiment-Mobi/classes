package unitTests
{

	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.events.GotoTrialEvent;
	import com.xperiment.runner.runner;
	import com.xperiment.runner.ComputeNextTrial.NextTrialBoss;
	import com.xperiment.script.ProcessScript;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trialOrder.trialOrderFunctions;
	import org.flexunit.asserts.assertTrue;

	
	
	public class test_trialOrder
	{
		
		
		private function init(myScript:XML):runner{
			var run:runner = new runner(null);
			run.trialProtocolList=myScript;
			ExptWideSpecs.__init();
			var trialOrder:Array = trialOrderFunctions.computeOrder(myScript,run.__composeTrial);
			run.__nextTrialBoss = new NextTrialBoss(myScript,run.trialList,trialOrder);
			return run;
		} 

		[Test]
		public function test1() : void
		{
			
			function run(myScript:XML,labels:Array,ident:Array):Boolean{	
				var run:runner = init(myScript);
				
				for(var i:int=0;i<run.trialList.length;i++){
					if(run.trialList[i].trialLabel != labels[i])	return false;
				}
				
				run.runningTrial = run.__nextTrialBoss.firstTrial();
				
				for(    i    =0;i<run.trialList.length;i++){
					run.commenceWithTrial()
					if(run.runningTrial.trialLabel != labels[i]) return false;	
					if(run.runningTrial.OnScreenElements[0].getVar('test')!=ident[i])	return false;
						
					run.runningTrial=run.__nextTrialBoss.getTrial(GotoTrialEvent.NEXT_TRIAL,run.runningTrial);
				}
				
				return true;
			}			
			
			var script:XML = <test>
								<TRIAL block="20" trials="4" order="fixed" trialName="v"><behavNextTrial test="a;b;c;d"/></TRIAL>
							</test>
			assertTrue(	run(script,['v1','v2','v3','v4'],['a','b','c','d'])		);
			
			script = 		<test>
								<TRIAL block="20" trials="4" order="fixed" trialName="v"><behavNextTrial test="a;b;c;d"/></TRIAL>
								<TRIAL block="20" trials="4" order="fixed" trialName="w"><behavNextTrial test="e;f;g;h"/></TRIAL>
							</test>
			assertTrue(	run(script,['v1','v2','v3','v4','w1','w2','w3','w4'],['a','b','c','d','e','f','g','h'])		);
			
			script = 		<test>
								<TRIAL block="0" trials="2" order="fixed" trialName="u"><behavNextTrial test="l;m"/></TRIAL>
								<TRIAL block="20" trials="4" order="fixed" trialName="v"><behavNextTrial test="a;b;c;d"/></TRIAL>
								<TRIAL block="20" trials="4" order="fixed" trialName="w"><behavNextTrial test="e;f;g;h"/></TRIAL>
							</test>
			assertTrue(	run(script,['u1','u2','v1','v2','v3','v4','w1','w2','w3','w4'],['l','m','a','b','c','d','e','f','g','h'])		);
			
		}
		
		private function t(myScript:XML,labels:Array,ident:Array):Boolean{	
			var run:runner = init(myScript);
			
			
			var blockTrialCorrectNames:Array;
			var blockTrialNames:Array;
			var counter:int=0;
			var pos:int;
			
			for(var block_i:int=0;block_i<labels.length;block_i++){
				blockTrialCorrectNames=labels[block_i];
				
				blockTrialNames= [];
				for(var i:int=0;i<blockTrialCorrectNames.length;i++){
					blockTrialNames.push(run.trialList[counter].trialLabel);
					counter++;
				}
				
				if(blockTrialCorrectNames.length!=blockTrialNames.length)	return false;
				for(    i    =0;i<blockTrialCorrectNames.length;i++){
					
					pos=blockTrialNames.indexOf(blockTrialCorrectNames[i]);
					if(pos==-1)return false;
					blockTrialNames.splice(pos,1);
					
				}
				if(blockTrialNames.length!=0)return false;
				
			}
			
			
			var testArr:Array=[];
			var testTrialNamesArr:Array = [];
			run.runningTrial = run.__nextTrialBoss.firstTrial();
			
			for(    i    =0;i<run.trialList.length;i++){
				run.commenceWithTrial()
				testArr.push(run.runningTrial.OnScreenElements[0].getVar('test'));
				testTrialNamesArr.push(run.runningTrial.trialLabel);
				run.runningTrial=run.__nextTrialBoss.getTrial(GotoTrialEvent.NEXT_TRIAL,run.runningTrial);
			}
			
			
			blockTrialNames = [];
			var correctBlockTestAns:Array=[];
			var blockTestAns:Array;
			var testAns:String;
			var trialName:String;
			
			for(    block_i  =0;block_i<ident.length;block_i++){
				blockTestAns=[];
				blockTrialNames=[];
				correctBlockTestAns=ident[block_i];
				blockTrialCorrectNames=labels[block_i];
				
				for(    i    =0;i<correctBlockTestAns.length;i++){
					blockTestAns.push(testAns=testArr.shift());
					blockTrialNames.push(trialName=testTrialNamesArr.shift());
					
					if(correctBlockTestAns.indexOf(testAns)!=blockTrialCorrectNames.indexOf(trialName))return false;
				}
				
				
				
				for(    i	 =0;i<correctBlockTestAns.length;i++){
					pos = blockTestAns.indexOf(correctBlockTestAns[i]);
					if(pos==-1)return false;
					blockTestAns.splice(pos,1);
					
					pos = blockTrialNames.indexOf(blockTrialCorrectNames[i]);
					if(pos==-1)return false;
					blockTrialNames.splice(pos,1);
					
				}
				if(blockTestAns.length!=0)return false;
				if(blockTrialNames.length!=0)return false;
			}
			
			return true;
		}			
		
		[Test]
		public function test2():void{
			
			
			var script:XML = <test>
								<TRIAL block="0" trials="2" order="fixed" trialName="u"><behavNextTrial test="l;m"/></TRIAL>
								<TRIAL block="20" trials="4" order="fixed" trialName="v"><behavNextTrial test="a;b;c;d"/></TRIAL>
								<TRIAL block="20" trials="4" order="fixed" trialName="w"><behavNextTrial test="e;f;g;h"/></TRIAL>
							</test>
			assertTrue(	t(script,[['u1','u2'],['v1','v2','v3','v4','w1','w2','w3','w4']],[['l','m'],['a','b','c','d','e','f','g','h']])		);
			
			script         = <test>
								<TRIAL block="0" trials="2" order="random" trialName="u"><behavNextTrial test="l;m"/></TRIAL>
								<TRIAL block="20" trials="4" order="random" trialName="v"><behavNextTrial test="a;b;c;d"/></TRIAL>
								<TRIAL block="20" trials="4" order="random" trialName="w"><behavNextTrial test="e;f;g---b;h---a"/></TRIAL>
							</test>

			assertTrue(	t(script,[['u1','u2'],['v1','v2','v3','v4','w1','w2','w3','w4']],[['l','m'],['a','b','c','d','e','f','g','h']])		);

			
		}
		
		[Test]
		public function test3():void{
			function tt():Boolean{
				var script:XML = <Taste exptType="WEB">
									<SETUP><trials blockDepthOrder="20,*=random 20,*,*=random" /></SETUP>
									<TRIAL TYPE="Trial"  hideResults="true" block="0" order="fixed" trials="1"><behavNextTrial test="e;f;g;h"/></TRIAL>
									<TRIAL TYPE="Trial" block="3" order="fixed" trials="1"><behavNextTrial test="e;f;g;h"/></TRIAL>
									<TRIAL template="templatePause" TYPE="Trial" block="20,2" order="fixed" forceBlockDepthPositions="0"/>
									<TRIAL template="templatePause" TYPE="Trial" block="20,2" order="fixed" forceBlockDepthPositions="11"/>
									<TRIAL template="templatePause" TYPE="Trial" block="20,2" order="fixed" forceBlockDepthPositions="22"/>
									<TRIAL template="templatePause" TYPE="Trial" block="20,2" order="fixed" forceBlockDepthPositions="33"/>
									<TRIAL block="20,4,1" template="templateLineScale" trialName="A_sour;B_sour;C_sour;D_sour;E_sour;F_sour;G_sour;H_sour"><behavNextTrial copyOverID="taste" text1="991"/></TRIAL>
									<TRIAL block="20,4,2" template="templatePackage" trialName="Csour"><behavNextTrial copyOverID="taste" text1="991"/></TRIAL>
									<TRIAL block="20,4,3" template="templateJam" trialName="Jsour"><behavNextTrial copyOverID="taste" text1="991" /></TRIAL>
									<TRIAL block="20,4,4" template="templateLiking" trialName="Liking_sour"><behavNextTrial copyOverID="taste" text1="991" /></TRIAL>
									<TRIAL block="20,5,1" template="templateLineScale" trialName="A_sweet;B_sweet;C_sweet;D_sweet;E_sweet;F_sweet;G_sweet;H_sweet"><behavNextTrial copyOverID="taste" text1="523"/></TRIAL>
									<TRIAL block="20,5,2" template="templatePackage" trialName="Csweet"><behavNextTrial copyOverID="taste" text1="523"/></TRIAL>
									<TRIAL block="20,5,3" template="templateJam" trialName="Jsweet"><behavNextTrial copyOverID="taste" text1="523" /></TRIAL>
									<TRIAL block="20,5,4" template="templateLiking" trialName="Liking_sweet"><behavNextTrial copyOverID="taste" text1="523" /></TRIAL>
									<templatePause  order="fixed" trials="1"></templatePause>
									<templateLiking order="random" trials="1"><behavNextTrial copyOverID="taste" test="l1" /> </templateLiking>
									<templateLineScale order="random" trials="8"><behavNextTrial copyOverID="taste" test="a;b;c;d;e;f;g;h" /> </templateLineScale>  
									<templatePackage order="random" trials="1"><behavNextTrial copyOverID="taste" test="p1" /> </templatePackage>  
									<templateJam order="random" trials="1">	<behavNextTrial copyOverID="taste" test="j1" /> </templateJam>  	
									<TRIAL TYPE="Trial" hideResults="true" block="100" order="fixed" trials="1" test="l1"><behavNextTrial test="e;f;g;h"/></TRIAL>
								</Taste>
	
					var run:runner = new runner(null);
			
					ExptWideSpecs.setup(script);
					
					var processScript:ProcessScript = new ProcessScript();
					processScript.process(script);
					script=processScript.script;
					
					run.trialProtocolList=script;
		
					var trialOrder:Array = trialOrderFunctions.computeOrder(script,run.__composeTrial);
					
					run.__nextTrialBoss = new NextTrialBoss(script,run.trialList,trialOrder);
					
					var correct_trialNames:Array = [];
					for(var i:int=0;i<run.trialList.length;i++){
						correct_trialNames.push(run.trialList[i].trialLabel);
					}
					
					run.runningTrial = run.__nextTrialBoss.firstTrial();
					
					var check_trialNames:Array=[];
					var check_props:Array=[];
					var elements:Vector.<object_baseClass>;
					for(    i    =0;i<run.trialList.length;i++){
						run.commenceWithTrial()
						check_trialNames.push(run.runningTrial.trialLabel);
						elements = run.runningTrial.OnScreenElements;
						if(elements.length>0)	check_props.push(run.runningTrial.OnScreenElements[0].getVar('test'));
						else check_props.push("");
						
						run.runningTrial=run.__nextTrialBoss.getTrial(GotoTrialEvent.NEXT_TRIAL,run.runningTrial);
					}
	
					if(check_trialNames.length!=check_trialNames.length)	return false;
					for(i=0;i<check_trialNames.length;i++){
						if(check_trialNames[i].charAt(1)=="_"){
							if(check_trialNames[i].charAt(0).toLowerCase()!=check_props[i])	return false;
						}
					}
				return true;		
			}
			
				assertTrue(tt());
				
		}
	

	}
}