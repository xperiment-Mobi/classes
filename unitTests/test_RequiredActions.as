package unitTests
{

	import com.xperiment.RequiredActions.RequiredActions;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	
	
	public class test_RequiredActions
	{
	
		private static var DEFAULT_TIMEOUT:int = 1000;
		
		[Test(async)]
		public function test1() : void
		{		
			var spr:Sprite = new Sprite;
			
			var successF:Function = function():void{
				spr.dispatchEvent(new Event("success"));
			}
			
			var failF:Function = function():void{
				spr.dispatchEvent(new Event("fail"));
			}
			
			var requiredActions:RequiredActions = new RequiredActions(20,{success:[successF],fail:[failF]})

			spr.addEventListener("success",
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(requiredActions.success);
					}
					, DEFAULT_TIMEOUT	));
			
			var f1:Function = requiredActions.add(10);
			var f2:Function = requiredActions.add(10);
			var f3:Function = requiredActions.add(10);
			requiredActions.start();

			
			f1(true);
			f2(true);
			f3(true);		
		}
			
		[Test(async)]
		public function test2() : void
		{		
			var spr:Sprite = new Sprite;
			
			var successF:Function = function():void{
				spr.dispatchEvent(new Event("success"));
			}
			
			var failF:Function = function():void{
				spr.dispatchEvent(new Event("fail"));
			}
			
			var requiredActions:RequiredActions = new RequiredActions(50,{success:[successF],fail:[failF]})
			
			spr.addEventListener("fail",
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(requiredActions.success == false);
					}
					, DEFAULT_TIMEOUT	));
			
			var f1:Function = requiredActions.add(20);
			var f2:Function = requiredActions.add(20);
			var f3:Function = requiredActions.add(20);
			requiredActions.start();
			
			f1(true);
			f2(true);
			f3(false);		
		}
		
		
		[Test(async)]
		public function test3() : void
		{		
			var spr:Sprite = new Sprite;
			
			var successF:Function = function():void{
				spr.dispatchEvent(new Event("success"));
			}
			
			var failF:Function = function():void{
				spr.dispatchEvent(new Event("fail"));
			}
			
			var requiredActions:RequiredActions = new RequiredActions(10,{success:[successF],fail:[failF]})
			
			spr.addEventListener("fail",
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(true);
					}
					, DEFAULT_TIMEOUT	));
			
			var f1:Function = requiredActions.add();
			var f2:Function = requiredActions.add();
			var f3:Function = requiredActions.add(5);
			requiredActions.start();
			
			f1(true);
			f2(true);		
		}
		
		
		[Test(async)]
		public function test4() : void
		{		
			var spr:Sprite = new Sprite;
			
			var successF:Function = function():void{
			}
			
			var failF:Function = function():void{
				spr.dispatchEvent(new Event("fail"));
			}
			
			var requiredActions:RequiredActions = new RequiredActions(10,{success:[successF],fail:[failF]})
			
			spr.addEventListener("success",
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(true);
					}
					, DEFAULT_TIMEOUT	));
			
			var f1Success:Function = function():void{
				spr.dispatchEvent(new Event("success"));
			}
			
			var f1:Function = requiredActions.add(5,{success:[f1Success]});
			var f2:Function = requiredActions.add(5);
			requiredActions.start();
			
			
			f1(true);
			f2(true);		
		}
		
		
		[Test(async)]
		public function test5() : void
		{		
			var spr:Sprite = new Sprite;
			
			var successF:Function = function():void{
			}
			
			var failF:Function = function():void{
				spr.dispatchEvent(new Event("fail"));
			}
			
			var requiredActions:RequiredActions = new RequiredActions(10,{success:[successF],fail:[failF]})
			
			spr.addEventListener("fail",
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(true);
					}
					, DEFAULT_TIMEOUT	));
			
			var f1Fail:Function = function():void{
				spr.dispatchEvent(new Event("fail"));
			}
			
			var f1:Function = requiredActions.add(5,{fail:[f1Fail]});
			var f2:Function = requiredActions.add();
			requiredActions.start();
			
			
			f1(false);
			f2(true);		
		}
		
		
		[Test(async)]
		public function test6() : void
		{		
			var spr:Sprite = new Sprite;
			
			var successF:Function = function():void{
			}
			
			var failF:Function = function():void{
				spr.dispatchEvent(new Event("fail"));
			}
			
			var requiredActions:RequiredActions = new RequiredActions(10,{success:[successF]})
			
			spr.addEventListener("fail",
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(true);
					}
					, DEFAULT_TIMEOUT	));
			
			var f1Fail:Function = function():void{
				spr.dispatchEvent(new Event("fail"));
			}
			
			var f1:Function = requiredActions.add(20,{fail:[f1Fail]});
			var f2:Function = requiredActions.add();
			var f3:Function = requiredActions.add();
			requiredActions.start();
			
			f2(true);
			f3(true);		
		}
			
		
		[Test(async)]
		public function test7() : void
		{					
			
			var requiredActions:RequiredActions = new RequiredActions(20);
			requiredActions.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(requiredActions.success == false);
					}
					, DEFAULT_TIMEOUT	));
			
	
			var f1:Function;
			
			var delayedF:Function = function():void{
				f1(false);
			}
				
			f1 = requiredActions.add(5,{action:delayedF, wait:true});
			
			var f2:Function = requiredActions.add(10,{success:[delayedF]});
			var f3:Function = requiredActions.add();
			requiredActions.start();
			
			
			f2(true);	
			f3(true);
		}
		
		
		[Test(async)]
		public function test8() : void
		{					
			var requiredActions:RequiredActions = new RequiredActions(20);
			
			requiredActions.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(requiredActions.success == true);
					}
					, DEFAULT_TIMEOUT	));
			
			
			var f1:Function;
			
			var delayedF:Function = function():void{
				f1(true);
			}
			
			f1 = requiredActions.add(10,{action:delayedF, wait:true});
			
			var f2:Function = requiredActions.add(5, {success:[delayedF]});
			var f3:Function = requiredActions.add();
			requiredActions.start();
			
			
			f2(true);	
			f3(true);
		}
		
		
		[Test(async)]
		public function test9() : void
		{					
			var requiredActions:RequiredActions = new RequiredActions(50);
			
			requiredActions.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(requiredActions.success == false);
					}
					, DEFAULT_TIMEOUT	));
			
			
			var f1:Function;
			
			var delayedF:Function = function():void{
				//f1(true); 
			}
			
			f1 = requiredActions.add(5,{action:delayedF, wait:true});
			
			var f2:Function = requiredActions.add(5,{success:[delayedF]});
			var f3:Function = requiredActions.add();
			requiredActions.start();
			
			
			f2(true);	
			f3(true);
		}
		
		[Test(async)]
		public function test10() : void
		{					
			var requiredActions:RequiredActions = new RequiredActions(50);
			
			requiredActions.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(requiredActions.success == true);
					}
					, DEFAULT_TIMEOUT	));
			
			
			var f1:Function;
			
			var retryCount:int=3;
			var delayedF:Function = function():void{
				retryCount--;
				if(retryCount==0){
					f1(true); 
				}
				else{
					f1(false);
				}
			}
			
			f1 = requiredActions.add(5,{action:delayedF, wait:true, retries:3});
			
			var f2:Function = requiredActions.add(5,{success:[delayedF]});
			var f3:Function = requiredActions.add();
			requiredActions.start();
			
			
			f2(true);	
			f3(true);
		}
		
		[Test(async)]
		public function test11() : void
		{					
			var requiredActions:RequiredActions = new RequiredActions(300);
			
			requiredActions.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(requiredActions.success == true);
					}
					, DEFAULT_TIMEOUT	));
			
			
			var f1:Function;
			
			var retryCount:int=3;
			var delayedF:Function = function():void{
				retryCount--;
				if(retryCount==0){
					f1(true); 
				}
			}
			
			f1 = requiredActions.add(5,{action:delayedF, wait:true, retries:3});
			
			var f2:Function = requiredActions.add(5,{success:[delayedF]});
			var f3:Function = requiredActions.add();
			requiredActions.start();
			
			
			f2(true);	
			f3(true);
		}
		
		[Test(async)]
		public function test12() : void
		{					
			var requiredActions:RequiredActions = new RequiredActions(300);
			
			requiredActions.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(requiredActions.success == false);
					}
					, DEFAULT_TIMEOUT	));
			
			
			var f1:Function;
			
			var retryCount:int=3;
			var delayedF:Function = function():void{
				retryCount--;
				if(retryCount==0){
					f1(false); 
				}
			}
				
			f1 = requiredActions.add(5,{name:'test',action:delayedF, wait:true, retries:3});
			
			var f2:Function = requiredActions.add(5,{success:[delayedF]});
			var f3:Function = requiredActions.add();
			requiredActions.start();
			
			
			f2(true);	
			f3(true);
		}
/*		
		[Test(async)]
		public function test13() : void
		{					
			var requiredActions:RequiredActions = new RequiredActions(300);
			
			requiredActions.addEventListener(Event.COMPLETE,
				Async.asyncHandler(this,
					function(e:Event, passThroughObj:Object):void{
						Assert.assertTrue(requiredActions.success == false);
					}
					, DEFAULT_TIMEOUT	));
			
			
			var f1:Function;
			
			
			var delayedF:Function = function():void{
				retryCount--;
				if(retryCount==0){
					f1(false); 
				}
			}
			
			f1 = requiredActions.add(5,{name:'test',action:delayedF, wait:true, retries:3});
			
			var f2:Function = requiredActions.add(5,{success:[delayedF]});
			var f3:Function = requiredActions.add();
			requiredActions.start();
			
			
			f2(true);	
			f3(true);
			
			var retryCount:int=3;
			var t:Timer = new Timer(10,3);
			t.addEventListener(Event.COMPLETE,function(e:Event):void{
				//////////////////////////////////////
				retryCount--;
				if(retryCount<=0){
					e.target.removeEventListener(e.type,arguments.callee);
				
				
				}
				//////////////////////////////////////
				//////////////////////////////////////
			});
		}*/
	
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