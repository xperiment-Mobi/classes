package unitTests
{
	
	import com.xperiment.uberSprite;
	import com.xperiment.onScreenBoss.OnScreenBoss;
	
	import flash.display.Sprite;
	
	import flexunit.framework.Assert;
	
	public class test_OnScreenBoss
	{
		
		
		private function spr(params:Object = null):uberSprite{
			
			var spr:uberSprite = new uberSprite();
			
			if(params!=null){
				for(var key:String in params){
					spr[key]=params[key];
				}
			}

			return spr;
		}
		
		private function getObj(objs:Array,peg:String):uberSprite{
			for each(var obj:Object in objs){
				if(obj.uSprite.peg==peg){
					return obj.uSprite;
				}
			}
			throw new Error();
			return null;
		}
		
		private function getSpr(objs:Array,peg:String):uberSprite{
			for each(var obj:Object in objs){
				if(obj.uSprite.peg==peg){
					return obj.uSprite;
				}
			}
			throw new Error();
			return null;
		}
		
		private function pegAtDepth(screen:Sprite, depth:int, peg:String):Boolean{
			var spr:uberSprite = screen.getChildAt(depth) as uberSprite;
			//trace(spr.peg,peg,depth,spr.peg == peg)
			return spr.peg == peg;
		}
		
		
		[Test('basic where there is no depth info')]
		public function test1() : void
		{
			
			var boss:OnScreenBoss = new OnScreenBoss();
			
			var screen:Sprite = boss;
			
			boss.addtoTimeLine(spr({peg:'a',startTime:0,endTime:100000}));
			boss.addtoTimeLine(spr({peg:'b',startTime:0,endTime:100000}));
			boss.addtoTimeLine(spr({peg:'c',startTime:0,endTime:100000}));
			
			boss.commenceDisplay(false);
			trace(screen,22)
			var objs:Array = boss._startTimeSorted;

			boss.__addToScreen(getObj(objs,'a'));
			
			
			Assert.assertTrue(screen.numChildren==1 && pegAtDepth(screen,0,'a'));
			
			/*boss.__addToScreen(getObj(objs,'b')); // as depth for for a and b are 0, b added at 0 pushing a to 1.			
			Assert.assertTrue(screen.numChildren==2 && pegAtDepth(screen,0,'b') && pegAtDepth(screen,1,'a'));
			
			
			boss.__addToScreen(getObj(objs,'c')); // as depth for for a and b are 0, b added at 0 pushing a to 1.
			Assert.assertTrue(screen.numChildren==3 && pegAtDepth(screen,0,'c') && pegAtDepth(screen,1,'b') && pegAtDepth(screen,2,'a'));
			
			boss.cleanUpScreen();*/
		}
		
		/*[Test('where there IS depth info')]
		public function test2() : void
		{
			
			var boss:OnScreenBoss = new OnScreenBoss();
			
			var screen:Sprite = boss;
			
			boss.addtoTimeLine(false, spr({peg:'a',depth:0}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'b',depth:1}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'c',depth:2}), 0,100000);
			
			boss.commenceDisplay(false);
			
			var objs:Array = boss._startTimeSorted;
			
			boss.__addToScreen(getObj(objs,'a'));
			Assert.assertTrue(screen.numChildren==1 && pegAtDepth(screen,0,'a'));
			
			boss.__addToScreen(getObj(objs,'b')); // as depth for for a and b are 0, b added at 0 pushing a to 1.
			Assert.assertTrue(screen.numChildren==2 && pegAtDepth(screen,1,'b') && pegAtDepth(screen,0,'a'));
			
			boss.__addToScreen(getObj(objs,'c')); // as depth for for a and b are 0, b added at 0 pushing a to 1.
			Assert.assertTrue(screen.numChildren==3 && pegAtDepth(screen,2,'c') && pegAtDepth(screen,1,'b') && pegAtDepth(screen,0,'a'));
			
			boss.cleanUpScreen();
		}
		
		
		[tTest('where there IS depth info, reverse order though')]
		public function test3() : void
		{
			
			var boss:OnScreenBoss = new OnScreenBoss();
			
			var screen:Sprite = boss;
			
			boss.addtoTimeLine(false, spr({peg:'a',depth:0}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'b',depth:1}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'c',depth:2}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'d',depth:3}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'e',depth:4}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'f',depth:5}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'g',depth:6}), 0,100000);
			
			boss.commenceDisplay(false);
			
			var objs:Array = boss._startTimeSorted;
			
			function add(yes:Boolean, peg:String, at:int=0):void{
				if(yes){
					boss.__objsOnScreen.push(getObj(objs,peg));
					boss.screen.addChildAt(getSpr(objs,peg),at);
				}
				else{
					boss.__objsOnScreen.splice(boss.__objsOnScreen.indexOf(getObj(objs,peg)),1);
					boss.screen.removeChild(getSpr(objs,peg));
				}
			}
			
			add(true,'b');//b
			Assert.assertTrue(boss.__getDepth(getSpr(objs,'a'))==0);
			Assert.assertTrue(boss.__getDepth(getSpr(objs,'c'))==1);
			add(false,'b');//
			
			//just verifies that these helper functions are doing what they are supposed to
			Assert.assertTrue(boss.screen.numChildren==0 && boss.__objsOnScreen.length==0)

		
			add(true,'c');//c
			add(true,'g',1);//cg
			

			Assert.assertTrue(boss.__getDepth(getSpr(objs,'b'))==0);
			Assert.assertTrue(boss.__getDepth(getSpr(objs,'d'))==1);
			add(true,'d',1);//cdg
			Assert.assertTrue(boss.__getDepth(getSpr(objs,'e'))==2);
			add(false,'d');//cg

			Assert.assertTrue(boss.__getDepth(getSpr(objs,'a'))==0)
			add(true,'b',0);//bcg
			Assert.assertTrue(boss.__getDepth(getSpr(objs,'b'))==1);
			
			Assert.assertTrue(boss.__getDepth(getSpr(objs,'e'))==2);
			
			boss.cleanUpScreen();
		}
		
		[tTest('where there IS depth info, reverse order, complex')]
		public function test4() : void
		{
			
			var boss:OnScreenBoss = new OnScreenBoss();
			var screen:Sprite = boss;
			
			boss.addtoTimeLine(false, spr({peg:'a',depth:0}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'b',depth:1}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'c',depth:2}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'d',depth:3}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'e',depth:4}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'f',depth:5}), 0,100000);
			boss.addtoTimeLine(false, spr({peg:'g',depth:6}), 0,100000);
			
			boss.commenceDisplay(false);
			
			var objs:Array = boss._startTimeSorted;
			
			function getPegDepth(peg:String):int{
				
				for(var i:int=0;i<screen.numChildren;i++){
					if((screen.getChildAt(i) as uberSprite).peg==peg){
						return i;
					}
				}
				throw new Error();
				return null;
			}
			
			boss.__addToScreen(getObj(objs,'c'));
			Assert.assertTrue(getPegDepth('c')==0)
			
			boss.__addToScreen(getObj(objs,'d'));
			Assert.assertTrue(getPegDepth('d')==1)
			
			
			boss.__addToScreen(getObj(objs,'f'));
			Assert.assertTrue(getPegDepth('f')==2)
			
			boss.__addToScreen(getObj(objs,'e'));
			Assert.assertTrue(getPegDepth('e')==2)
				
			boss.__addToScreen(getObj(objs,'b'));
			Assert.assertTrue(getPegDepth('b')==0)
			
			boss.__addToScreen(getObj(objs,'a'));
			boss.__addToScreen(getObj(objs,'g'));
			Assert.assertTrue(getPegDepth('b')==1)
			Assert.assertTrue(getPegDepth('d')==3)
			Assert.assertTrue(getPegDepth('e')==4)
				
			boss.__removeFromScreen(getObj(objs,'a'))
			Assert.assertTrue(getPegDepth('e')==3)
			Assert.assertTrue(getPegDepth('f')==4)
				
			boss.cleanUpScreen();
		}*/
	}
}