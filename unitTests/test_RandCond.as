package unitTests
{

	import com.xperiment.script.BetweenSJs;
	import com.xperiment.script.CollateSJsPerCond;
	import com.xperiment.script.MeldConditions;
	import com.xperiment.script.Test_BetweenSJs_SortOutMultiExperiment;
	
	import flash.events.Event;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	public class test_RandCond
	{
		public const DEFAULT_TIMEOUT:Number = 20000;
		public const LONG_TIMEOUT:Number = 10000;
		
		[Test( description="tests __randomCond" )]
		public function test1() : void
		{		
			Assert.assertTrue(String([1,4,0])==String(CollateSJsPerCond.give('a=1,b=4',['a','b','c'])));
			Assert.assertTrue(String([0.1,0.4,.5])==String(CollateSJsPerCond.give('a=.1,b=.4,c=.5',['a','b','c'])));
			Assert.assertTrue(String([1,4,0])==String(CollateSJsPerCond.give('a=1,b=4',['a','b','c'])));
			Assert.assertTrue(String([2,4,4])==String(CollateSJsPerCond.give('a=2,b=4,c=4',['a','b','c'])));
		}

		[Test]
		public function test2() : void
		{		
			var b:BetweenSJs = new BetweenSJs;
			
			var xml:XML;
		
			try{
				b.__singleMultiStep(null);
			}
			catch(e:Error){
				Assert.assertTrue(e.message=='attribs equals null!');
			}
			
			try{
				xml = <empty></empty>
				b.__singleMultiStep(xml.children());
			}
			catch(e:Error){
				Assert.assertTrue(e.message=="there are no children in attribs");
			}
			
			xml =
				<test>
						<unknown/>
				</test>
			
			try{
				b.__singleMultiStep(xml.children());
			}
			catch(e:Error){
				Assert.assertTrue(e.message=="you have entered an unknown parameter in a multistep: unknown = ''");
			}
			
			xml= <test>
					<howdeterminecondition/>
					<conditionsjs/>
			</test>

			try{
					b.__singleMultiStep(xml.children());
			}
			catch(e:Error){
					Assert.assertTrue(e.message=="howdeterminecondition and conditionsjs equal ''");
			}
			
			xml= <test>
					<howdeterminecondition></howdeterminecondition>
					<conditionsjs>a=2,b=4</conditionsjs>
			</test>
			
			try{
				b.__singleMultiStep(xml.children());
			}
			catch(e:Error){
				Assert.assertTrue(e.message=="have not set up other condition determine ways yet.  Only 'random'.");
			}
			
			xml= <test>
					<howdeterminecondition>random</howdeterminecondition>
					<conditionsjs>a=2,b=4</conditionsjs>
			</test>
			
			b.__conditions=['a','b','c','d'];
			Assert.assertTrue(b.__singleMultiStep(xml.children()).toString()=='2,4,0,0');
			
		}

		
		
		[Test( description="tests __conbobulate" )]
		public function test4() : void
		{		
			
			var xml:XML=<d betweenSJ="123"><k/><l peg='a'/></d>;
	
	
			MeldConditions.__conbobulate(<b betweenSJ='123'><addAttributes a='222'/></b>,xml);			
			Assert.assertTrue(xml==<d betweenSJ="123" a='222'><k/><l peg='a'/> </d>);
			
			MeldConditions.__conbobulate(<b betweenSJ='123'><addAttributes a='333'/></b>,xml);
			Assert.assertTrue(xml==<d betweenSJ="123" a='222'><k/><l peg='a'/> </d>); //NB no update
			
			MeldConditions.__conbobulate(<b betweenSJ='123'><removeAttributes>a</removeAttributes></b>,xml);
			Assert.assertTrue(xml==<d betweenSJ="123"><k/><l peg='a'/> </d>); 
			
			MeldConditions.__conbobulate(<b betweenSJ='123'><removeChild>a</removeChild></b>,xml);
			Assert.assertTrue(xml==<d betweenSJ="123"><k/></d>); 
			
			MeldConditions.__conbobulate(<b betweenSJ='123'><addChild><aaa r='r'><b/></aaa></addChild></b>,xml);
			Assert.assertTrue(xml==<d betweenSJ="123"><k/><aaa r='r'><b/></aaa></d>); 
			
			MeldConditions.__conbobulate(<b betweenSJ='123'><removeChildren/></b>,xml);
			Assert.assertTrue(xml==<d betweenSJ="123"/>); 
	
		}
		

		
		[Test(async, description="tests _sortOutMultiExperiment1" )]
		public function test6() : void
		{		
			var t:Test_BetweenSJs_SortOutMultiExperiment = new Test_BetweenSJs_SortOutMultiExperiment();
			t.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
					
						Assert.assertTrue(e.target.response=='__singleMultiStep');
					}
					, DEFAULT_TIMEOUT	));
			
			var xml:XML = <test></test>

			t.sortOutMultiExperiment(xml, null);	
		}
		
		
		
		
		[Test(async, description="tests _sortOutMultiExperiment3" )]
		public function test8() : void
		{		
			var forceCondition:String = 'forceBanana'
			var t:Test_BetweenSJs_SortOutMultiExperiment = new Test_BetweenSJs_SortOutMultiExperiment();
			t.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(e.target.response=='forceConditionF:'+forceCondition);
					}
					, DEFAULT_TIMEOUT	));
			
			var xml:XML =
				<test>
					<MULTISETUP forceCondition={forceCondition}>
					</MULTISETUP>
				</test>
	
				t.sortOutMultiExperiment(xml, '');	
		}	
		
		
		[Test(async, description="tests _sortOutMultiExperiment4" )]
		public function test9() : void
		{		

			var t:Test_BetweenSJs_SortOutMultiExperiment = new Test_BetweenSJs_SortOutMultiExperiment();
			t.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(e.target.response=='__needSJcountThenWhichStep');
					}
					, DEFAULT_TIMEOUT	));
			
			var xml:XML =
				<test>
					<MULTISETUP>
						<a conditionSJs='a=1'/>
					</MULTISETUP>
				</test>
	
				t.sortOutMultiExperiment(xml, '');	
		}	
		
		
		
		

		
		
		
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
	}
}