package unitTests
{
	import com.xperiment.BehavLogicAction.LogicActions;
	import com.xperiment.BehavLogicAction.PropValDict;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	public class test_EventPassPegToAction
	{
		[Test(async)]
		public function test1() : void
		{
			

			var propValDict:PropValDict = new PropValDict();
			
			var testL:LogicActions = new LogicActions(propValDict);
			testL.passLogicAction(["A.onCli?B.start()"]);
				
			var returnedPeg:String='';
			
			linkResultantActions("B.start()",propValDict.bind);
			
			var dummy:Sprite = new Sprite;
			
			dummy.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(returnedPeg=='A');
					}
					, 500	));
			
			
			var actionCount:int=0;
			function linkResultantActions(action:String, bindProperty:Function):void
			{
				bindProperty(action,function(peg:String):void{
					returnedPeg=peg;
					dummy.dispatchEvent(new Event(Event.COMPLETE));
				});
			}
			
			propValDict.incrementPerTrial("A.onCli",null);
		
		}
		
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