package com.xperiment.trial.Scroll
{
	
	import com.greensock.BlitMask;
	import com.greensock.TweenLite;
	import com.greensock.plugins.ScrollRectPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.xperiment.trial.helpers.SliderEvent;
	import com.xperiment.trial.helpers.TrialScrollBar;
	import flash.display.Sprite;
	import com.xperiment.trial.Trial;
	
	
	public class ScrollTrial implements IScroll
	{
		public var pic:Sprite;
		public var blitMask:BlitMask;
		private var scrollBar:TrialScrollBar;
		private var bar:Boolean;
		
		
		public function kill():void{
			if(bar){
				scrollBar.removeEventListener(SliderEvent.MOVED,movedL);
				scrollBar.kill();
			}
			pic=null;	
			if(blitMask)blitMask.dispose();
		}
		
		public function ScrollTrial(bar:Boolean)
		{
			this.bar = false;
		}
		
		
		
		public function init(pic:Sprite,maxHeight:int):void
		{
			this.pic=pic;
			
			this.blitMask = new BlitMask(pic,0,0,Trial.ACTUAL_STAGE_WIDTH,Trial.ACTUAL_STAGE_HEIGHT,false,true);
			TweenPlugin.activate([ScrollRectPlugin]);
			
			
			if(bar){
				this.scrollBar = new TrialScrollBar(pic,Trial.RETURN_STAGE_HEIGHT,maxHeight);
				scrollBar.addEventListener(SliderEvent.MOVED,movedL);
			}
			
			TweenLite.fromTo(blitMask, 1, {scrollY:.5},{scrollY:0, onComplete:blitMask.disableBitmapMode});
			if(bar)TweenLite.fromTo(scrollBar, 1, {y: scrollBar.range*.5},{y:0});
			//blitMask.scrollY=1;
		}
		
		protected function movedL(e:SliderEvent):void
		{
			
			blitMask.scrollY=e.pos;
			blitMask.update()
			
		}		
		
		
	}
}