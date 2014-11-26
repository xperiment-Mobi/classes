package unitTests
{

	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.Bind.CrunchUp;
	import com.xperiment.make.xpt_interface.Cards.Cards;
	import com.xperiment.make.xpt_interface.Cards.Helpers.Cards_orderChange;
	
	import org.flexunit.Assert;

	
	public class test_trialOrderChange
	{
		
		
		[Test]
		public function test1() : void //testing no trial order changes, just block order
		{		
			Assert.assertTrue(	doTest([[["Bouba2_4_T0","Bouba2_4_T1"]],[["Bouba2_7_T0","Bouba2_7_T1","Bouba2_7_T2"]],["Bouba2_10_T0"]],[1,2,3])	);
			Assert.assertTrue(	doTest([[["Bouba2_4_T0","Bouba2_4_T1"]],["Bouba2_10_T0"],[["Bouba2_7_T0","Bouba2_7_T1","Bouba2_7_T2"]]],[1,3,2])	);
			Assert.assertTrue(	doTest([["Bouba2_10_T0"],[["Bouba2_7_T0","Bouba2_7_T1","Bouba2_7_T2"]],[["Bouba2_4_T0","Bouba2_4_T1"]]],[3,2,1])	);
		}
		
		[Test]
		public function test1_5() : void //test updateProp
		{		
			var stim:XML  = <stim abc="123" />
			//Bind_MultiStim_change.__updateStimulus(stim,[]);
			
			//stim:XML, propName:String, value:String, trialOrder:Arra	
			
			//Bind_MultiStim_change.__updateProp(stim,'abc',stim.@abc.toString(),[1,2,3],[2,1,3]);
			
			Assert.assertTrue(true);
		}
		
		[Test]
		public function test2() : void //testing no block order changes, just trial order
		{	
			
			//generate some changes
			Assert.assertTrue(	doTest([[["Bouba2_4_T1","Bouba2_4_T0"]],[["Bouba2_7_T0","Bouba2_7_T1","Bouba2_7_T2"]],["Bouba2_10_T0"]],[1,2,3])	);
			
			//verifying detects change
			Assert.assertTrue( Cards_orderChange.__newOrder.__stacks[0].trialOrderChanged==true );
			Assert.assertTrue( Cards_orderChange.__newOrder.__stacks[1].trialOrderChanged==false );
			Assert.assertTrue( Cards_orderChange.__newOrder.__stacks[2].trialOrderChanged==false );
			Assert.assertTrue(testAttrib("Bouba2_4","trialName","b,a"));
			
			
			Assert.assertTrue(testAttrib("TRIAL_5","x","50%---60%"));
			Assert.assertTrue(testAttrib("TRIAL_5","background","white---blue"));
			
			Assert.assertTrue(testAttrib("TRIAL_5","text","b;a"));
			
			//test that can reset
			Assert.assertTrue(	doTest([[["Bouba2_4_T0","Bouba2_4_T1"]],[["Bouba2_7_T0","Bouba2_7_T1","Bouba2_7_T2"]],["Bouba2_10_T0"]],[1,2,3])	);
			Assert.assertTrue(testAttrib("TRIAL_5","background","white---blue"));
			Assert.assertTrue(testAttrib("TRIAL_5","text","a;b"));
				
			//generate new changes
			Assert.assertTrue(	doTest([[["Bouba2_4_T0","Bouba2_4_T1"]],[["Bouba2_7_T1","Bouba2_7_T2","Bouba2_7_T0"]],["Bouba2_10_T0"]],[1,2,3])	);
			Assert.assertTrue(testAttrib("TRIAL_8","text","b;a;a")); 
			
			/*<TRIAL TYPE="Trial" trialName="DoExpt" hideResults="true" block="2" order="fixed" trials="3">	
							<addText  text="a;b" multiline="true" timeStart="0" howMany="2" peg="a---b" x="50%---60%" width="400" background="white---blue" fontSize="80"/>
							<addButton width="140" sstartID="next" height="40" text="I consent" resultFileName="continue" timeStart="0" timeEnd="forever" x="50%"  y="90%"/>
			</TRIAL>*/
		}

			[Test]
			public function test3() : void //testing no block order changes, just trial order
			{
			
				var chunks:Array = [];
				CrunchUp.__chunkify([1,2,3,4,5,6],chunks,2);
				Assert.assertTrue(	chunks.join("-").toString() == "1,2-3,4-5,6" );
				
				chunks=[];
				CrunchUp.__chunkify([1,2,3,4,5,6,7],chunks,2);
				Assert.assertTrue(	chunks.join("-").toString() == "1,2-3,4-5,6-7" );
					
				function test(arrOrig:Array,arrNew:Array):Boolean{
					var result:Array = CrunchUp.DO(arrOrig);
					return compareOrders(result,arrNew);
				}
				
				Assert.assertTrue(	test([1,2,3],[1,2,3])	);
				Assert.assertTrue(	test([1,1,1],[1])	);
				Assert.assertTrue(	test([1,2,1,2],[1,2])	);
				Assert.assertTrue(	test([1,2,3,1],[1,2,3])	);
			}
		
		private function testAttrib(bindID:String, attrib:String, val:String):Boolean
		{
			var xml:XML = BindScript.script..*.(@__BIND==bindID)[0];
			var actualVal:String = xml.@[attrib].toXMLString();
			return actualVal == val;
		}		
		
		
		private function doTest(change:Array, order:Array):Boolean{
			var script:XML = generateScript();
			script = BindScript.setup(script.copy(),null);
			Cards.setup(fakeComms);
			var origOrder:Array = getTrialOrder(script);			
			Cards.change(change,true);
			return compareOrders(order,getTrialOrder(BindScript.script));
		}
		
		private function compareOrders(origOrder:Array, newOrder:Array):Boolean
		{
			if(origOrder.length!=newOrder.length)throw new Error();
			for(var i:int=0;i<origOrder.length;i++){
				if(origOrder[i]!=newOrder[i])return false;
			}
			
			return true;
		}
		
		private function getTrialOrder(script:XML):Array
		{
			var trial:XML;
			var arr:Array = [];
			for(var i:int=0;i<script.children().length();i++){
				trial = script.children()[i];
				if(trial.name().toString()=="TRIAL"){
					//trace(5,trial.@block, trial.@['__BIND']);
					arr.push(trial.@block.toString())
				}
			}
			return arr;
		}			

		
		
		private function fakeComms(a:String,b:*):void{};
		
		
		
		private function generateScript():XML{
		return <Bouba2 exptType="WEB">
			<SETUP>                          
			   <screen BGcolour="black" />		  
			   <computer stimuliFolder="assets" />
			</SETUP>
			
			<TRIAL TYPE="Trial" trialName="a,b" hideResults="true" block="1" order="fixed" trials="2">	
				<addText  text="a;b" multiline="true" timeStart="0" howMany="2" peg="a---b" x="50%---60%" width="400" background="white---blue" fontSize="80"/>
				<addButton width="140" sstartID="next" height="40" text="I consent" resultFileName="continue" timeStart="0" timeEnd="forever" x="50%"  y="90%"/>
			</TRIAL>
			
			<TRIAL TYPE="Trial" trialName="a,b,c" hideResults="true" block="2" order="fixed" trials="3">	
				<addText  text="a;b" multiline="true" timeStart="0" howMany="2" peg="a---b" x="50%---60%" width="400" background="white---blue" fontSize="80"/>
				<addButton width="140" sstartID="next" height="40" text="I consent" resultFileName="continue" timeStart="0" timeEnd="forever" x="50%"  y="90%"/>
			</TRIAL>
		
			<TRIAL TYPE="Trial" trialName="a" hideResults="true" block="3" order="fixed" trials="1">	
				<addText  text="a;b" multiline="true" timeStart="0" howMany="2" peg="a---b" x="50%---60%" width="400" background="white---blue" fontSize="80"/>
				<addButton width="140" sstartID="next" height="40" text="I consent" resultFileName="continue" timeStart="0" timeEnd="forever" x="50%"  y="90%"/>
			</TRIAL>
		</Bouba2>	
		}
	}
}