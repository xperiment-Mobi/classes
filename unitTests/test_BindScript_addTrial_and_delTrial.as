package unitTests
{
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.Bind.Bind_addTrial;
	import com.xperiment.make.xpt_interface.Bind.Bind_delTrial;
	import com.xperiment.make.xpt_interface.Cards.CardLevel;
	import com.xperiment.make.xpt_interface.Cards.Cards;
	
	import org.flexunit.Assert;
	
	public class test_BindScript_addTrial_and_delTrial
	{
		
		[tTest]
		public function test():void
		{
			var script:XML = generateScript();
			script = BindScript.setup(script.copy(),null);
			Cards.setup(fakeComms);
	
			Bind_addTrial.DO({groupSelected:"",cardSelected:"Bouba2_10",command:'right',howMany:'2'});
			
			
			var xmlList:XMLList = BindScript.script..*.(name()=="TRIAL");
			Assert.assertTrue(xmlList.length()==5);
			Bind_addTrial.DO({groupSelected:"",cardSelected:"Bouba2_7",command:'down',howMany:'2'});

		}
		[tTest]
		public function test2():void
		{
			var script:XML = generateScript();
			script = BindScript.setup(script.copy(),null);
			Cards.setup(fakeComms);
			var trials:Array = BindScript.assembleType("TRIAL");	
			Assert.assertTrue(trials.length==3);
			
		}
		
		[Test]
		public function test1_5():void
		{
			var arr:Array = [];
			arr[0] = <xml block="3" />
			arr[1] = <xml block="4" banana="max" />
			arr[2] = <xml block="1" banana="min"/>
			arr[3] = <xml block="2" />
			
			Assert.assertTrue(Bind_addTrial.__getMaxBlock(arr).@banana.toXMLString()=="max");
			Assert.assertTrue(Bind_addTrial.__getMinBlock(arr).@banana.toXMLString()=="min");
		}
		
		[Test]//checking can insert trials into blank expt
		public function test3():void
		{
			var script:XML = <Bouba2>
				<SETUP>                          
				   <screen BGcolour="black" />		  
				   <computer stimuliFolder="assets" />
				</SETUP>
			</Bouba2>
			
			
			BindScript.setup(script,null);
			
			
			Cards.setup(fakeComms);
			var trials:Array = BindScript.assembleType("TRIAL");	
			Assert.assertTrue(trials.length==0);
			
			Cards.addTrials({groupSelected:"",cardSelected:"",command:'right',howMany:'2'});
			
			var xmlList:XMLList = BindScript.script..*.(name()=="TRIAL");
			Assert.assertTrue(xmlList.length()==2);
			for(var i:int=0;i<xmlList.length();i++){
				Assert.assertTrue(int(xmlList[i].@block)==i)
			}
			
			Cards.addTrials({groupSelected:"",cardSelected:"",command:'down',howMany:'1'});
			xmlList = BindScript.script..*.(name()=="TRIAL");
			Assert.assertTrue(xmlList.length()==3);
			for(i=0;i<xmlList.length();i++){
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==i)
			}
			
			Cards.addTrials({groupSelected:"",cardSelected:"",command:'up',howMany:'1'});
			xmlList = BindScript.script..*.(name()=="TRIAL");
			Assert.assertTrue(xmlList.length()==4);
			var binds:Array = ['TRIAL_7','TRIAL_4','TRIAL_5','TRIAL_6']
			for(i=0;i<xmlList.length();i++){
				//trace(22222,(xmlList[i] as XML).toXMLString());
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==i)
				Assert.assertTrue(xmlList[i].@__BIND.toXMLString()==binds[i])	
			}
			
			Cards.addTrials({groupSelected:"",cardSelected:"",command:'left',howMany:'2'});
			xmlList = BindScript.script..*.(name()=="TRIAL");
			Assert.assertTrue(xmlList.length()==6);
			
			binds = ['TRIAL_8','TRIAL_9','TRIAL_7','TRIAL_4','TRIAL_5','TRIAL_6'];
			var blocks:Array = [0,0,0,1,2,3];
			for(i=0;i<xmlList.length();i++){
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==blocks[i])
				Assert.assertTrue(xmlList[i].@__BIND.toXMLString()==binds[i])	
			}
			
			Cards.addTrials({groupSelected:"",cardSelected:"",command:'up',howMany:'2'});
			xmlList = BindScript.script..*.(name()=="TRIAL");
			binds = ['TRIAL_10','TRIAL_11','TRIAL_8','TRIAL_9','TRIAL_7','TRIAL_4','TRIAL_5','TRIAL_6'];
			blocks = [0,1,2,2,2,3,4,5];
			for(i=0;i<xmlList.length();i++){
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==blocks[i])
				Assert.assertTrue(xmlList[i].@__BIND.toXMLString()==binds[i])	
			}
			
			Cards.addTrials({groupSelected:"",cardSelected:"",command:'right',howMany:'2'});
			xmlList = BindScript.script..*.(name()=="TRIAL");
			binds = ['TRIAL_10','TRIAL_11','TRIAL_8','TRIAL_9','TRIAL_7','TRIAL_4','TRIAL_5','TRIAL_6','TRIAL_12','TRIAL_13'];
			blocks = [0,1,2,2,2,3,4,5,5,5];
			for(i=0;i<xmlList.length();i++){
			
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==blocks[i])
				Assert.assertTrue(xmlList[i].@__BIND.toXMLString()==binds[i])	
			}
			
			Cards.addTrials({groupSelected:"",cardSelected:"",command:'down',howMany:'2'});
			//trace("_____");	
			xmlList = BindScript.script..*.(name()=="TRIAL");
			binds = ['TRIAL_10','TRIAL_11','TRIAL_8','TRIAL_9','TRIAL_7','TRIAL_4','TRIAL_5','TRIAL_6','TRIAL_12','TRIAL_13','TRIAL_14','TRIAL_15'];
			blocks = [0,1,2,2,2,3,4,5,5,5,6,7];
			for(i=0;i<xmlList.length();i++){
				//trace(22222,(xmlList[i] as XML).toXMLString());
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==blocks[i])
				Assert.assertTrue(xmlList[i].@__BIND.toXMLString()==binds[i])	
			}
			
		}
		
		
		[Test]//checking can insert trials around a selected card.
		public function test4():void
		{
			var script:XML = generateScript();
			
			
			BindScript.setup(script,null);
			
			
			Cards.setup(fakeComms);
			//var trials:Array = BindScript.assembleType("TRIAL");	
			
			Cards.addTrials({groupSelected:"",cardSelected:"Bouba2_7",command:'right',howMany:'2'});
			
			var xmlList:XMLList = BindScript.script..*.(name()=="TRIAL");
			Assert.assertTrue(true);
			
			var binds:Array = ['Bouba2_4','Bouba2_7','TRIAL_13','TRIAL_14','Bouba2_10'];
			var blocks:Array = [1,2,2,2,3];
			for(var i:int=0;i<xmlList.length();i++){
				//trace(22222,(xmlList[i] as XML).toXMLString());
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==blocks[i])
				Assert.assertTrue(xmlList[i].@__BIND.toXMLString()==binds[i])	
			}
			
			
			Cards.addTrials({groupSelected:"",cardSelected:"TRIAL_14",command:'left',howMany:'2'});
			xmlList = BindScript.script..*.(name()=="TRIAL");
			
			binds = ['Bouba2_4','Bouba2_7','TRIAL_13','TRIAL_15','TRIAL_16','TRIAL_14','Bouba2_10'];
			blocks = [1,2,2,2,2,2,3];
			for(i=0;i<xmlList.length();i++){
				//trace(22222,(xmlList[i] as XML).toXMLString());
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==blocks[i])
				Assert.assertTrue(xmlList[i].@__BIND.toXMLString()==binds[i])	
			}
			
			
			Cards.addTrials({groupSelected:"",cardSelected:"TRIAL_15",command:'up',howMany:'2'});
			xmlList = BindScript.script..*.(name()=="TRIAL");
			
			binds = ['Bouba2_4','Bouba2_7','TRIAL_13','TRIAL_17','TRIAL_18','TRIAL_15','TRIAL_16','TRIAL_14','Bouba2_10'];
			blocks = [1,4,4,2,3,4,4,4,5];
			for(i=0;i<xmlList.length();i++){
				//trace(22222,(xmlList[i] as XML).toXMLString());
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==blocks[i])
				Assert.assertTrue(xmlList[i].@__BIND.toXMLString()==binds[i])	
			}
			
			
			Cards.addTrials({groupSelected:"",cardSelected:"TRIAL_14",command:'down',howMany:'2'});
			xmlList = BindScript.script..*.(name()=="TRIAL");
			
			binds = ['Bouba2_4','Bouba2_7','TRIAL_13','TRIAL_17','TRIAL_18','TRIAL_15','TRIAL_16','TRIAL_14','TRIAL_19','TRIAL_20','Bouba2_10'];
			blocks = [1,4,4,2,3,4,4,4,5,6,7];
			for(i=0;i<xmlList.length();i++){
				//trace(22222,(xmlList[i] as XML).toXMLString());
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==blocks[i])
				Assert.assertTrue(xmlList[i].@__BIND.toXMLString()==binds[i])	
			}
			
			
			Cards.addTrials({groupSelected:"",cardSelected:"TRIAL_16",command:'left',howMany:'2'});
			xmlList = BindScript.script..*.(name()=="TRIAL");
			
			binds = ['Bouba2_4','Bouba2_7','TRIAL_13','TRIAL_17','TRIAL_18','TRIAL_15','TRIAL_21','TRIAL_22','TRIAL_16','TRIAL_14','TRIAL_19','TRIAL_20','Bouba2_10'];
			blocks = [1,4,4,2,3,4,4,4,4,4,5,6,7];
			for(i=0;i<xmlList.length();i++){
				Assert.assertTrue(int(xmlList[i].@block.toXMLString())==blocks[i])
				Assert.assertTrue(xmlList[i].@__BIND.toXMLString()==binds[i])	
			}
		}
		
		[Test]//checking can insert trials around a selected card.
		public function test5():void
		{
			var script:XML = generateScript();
			
			
			BindScript.setup(script,null);
			
			
			Cards.setup(fakeComms);
			//var trials:Array = BindScript.assembleType("TRIAL");	
			
			Cards.addTrials({groupSelected:"Bouba2_7",cardSelected:"",command:'right',howMany:'2'});
			
			var xmllist:XMLList = BindScript.script..*.(name()=="TRIAL");
			for each(var xml:XML in xmllist){
				if(xml.@__BIND.toXMLString()=="Bouba2_7"){
					Assert.assertTrue(xml.@trials.toXMLString()=="3")
					break;
				}
			}
		}
		
		
		[Test]//checking can delete groups.
		public function test6():void
		{
			var script:XML = generateScript();
			
			BindScript.setup(script,null);
			Cards.setup(fakeComms);
			
			Assert.assertTrue(verifyPresent("Bouba2_7"));
			Cards.deleteTrials({groups:["Bouba2_7"],cards:[]});
			Assert.assertTrue(verifyAbsent("Bouba2_7"));
			
			Assert.assertTrue(verifyPresent("Bouba2_10"));
			Cards.deleteTrials({groups:["Bouba2_10"],cards:[]});
			Assert.assertTrue(verifyAbsent("Bouba2_10"));

			
			//checking can delete trials in and out of groups.
		
			script = generateScript();
			BindScript.setup(script,null);
			
			Assert.assertTrue(verifyPresent("Bouba2_4"));
			Cards.deleteTrials({groups:[],cards:["Bouba2_4"]});
			Assert.assertTrue(verifyTrials("Bouba2_10",1));
			trace("---");
			Cards.deleteTrials({groups:[],cards:["Bouba2_4"]});
			Assert.assertTrue(verifyAbsent("Bouba2_4"));
		}
		
		[Test]//checking tallyUnique
		public function test8():void
		{
			var link:String = CardLevel.TRIAL_SPLIT;
			var arr:Array,result:Object;
			
			arr = ['a'+link+'abc','a'+link+'abc'];
			result = Bind_delTrial.__tallyUniqueBinds(arr);
			
			Assert.assertTrue(objCount(result)==1 && result['a']==2);
			
			arr = ['a'+link+'abc','a'+link+'abc','a'+link+'abc','b'+link+'abc','c'+link+'abc'];
			result = Bind_delTrial.__tallyUniqueBinds(arr);
			
			Assert.assertTrue(objCount(result)==3 && result['a']==3 && result['b']==1 && result['c']==1);
		}
		
		private function objCount(obj:Object):int{
			var count:int=0;
			for(var key:String in obj){
				count++;
			}
			return count;
		}
		
		private function verifyPresent(bindId:String):Boolean
		{
			var arr:Array = getListTrialBinds();
			return arr.indexOf(bindId)!=-1;
		}
		
		private function verifyTrials(bindId:String,trials:int):Boolean
		{
			var xmllist:XMLList = BindScript.script..*.(name()=="TRIAL")
			
			for each(var xml:XML in xmllist){
				if(xml.@__BIND.toXMLString()==bindId){
					return xml.@trials.toXMLString() == trials.toString();
				}
			}
			
			//could not find bind
			return false;
		}
		
		private function verifyAbsent(bindId:String):Boolean
		{
			var arr:Array = getListTrialBinds();
			return arr.indexOf(bindId)==-1;
		}
		
		
						private function getListTrialBinds():Array{
							var arr:Array = [];
							var xmllist:XMLList = BindScript.script..*.(name()=="TRIAL");
							
							for each(var xml:XML in xmllist){
								arr.push(xml.@__BIND.toXMLString());
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
				
				<TRIAL TYPE="Trial" trialName="a,b,c" hideResults="true" block="2" order="fixed" trials="1">	
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